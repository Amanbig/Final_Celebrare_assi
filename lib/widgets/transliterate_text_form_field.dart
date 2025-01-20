import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TransliterateFormField extends StatefulWidget {
  final String languageCode;
  final InputDecoration decoration;
  final String? initialText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function()? onError;
  final void Function() onTapOutside;
  final bool autofocus;
  final TextStyle? style;
  final bool obscureText;
  final bool readOnly;
  final Function()? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLines;
  final FormFieldValidator<String>? validator;
  final EdgeInsets scrollPadding;

  const TransliterateFormField(
      {super.key,
      required this.controller,
      required this.languageCode,
      required this.focusNode,
      this.onError,
      this.initialText,
      required this.onTapOutside,
      this.autofocus = false,
      required this.style,
      this.obscureText = false,
      this.readOnly = false,
      this.onTap,
      this.textInputAction,
      this.keyboardType,
      this.maxLines,
      this.validator,
      required this.scrollPadding,
      this.decoration = const InputDecoration()});

  @override
  State<TransliterateFormField> createState() => _TransliterateFormField();
}

class _TransliterateFormField extends State<TransliterateFormField> {
  // Stores list of transliteration recevied from the API
  List<String> _suggestions = [];
  // Tracks if API call is waiting for response
  bool _isLoading = false;
  // Keep track of start and end of the word on which the cursor is placed.
  int? currentSelectionStart;
  int? currentSelectionEnd;
  OverlayEntry? _overlayEntry;

  // Replace the current selected text with newWord
  // isAutoUpdate is set TRUE if replaceCurrentSelection is called
  // due to new line or whitespace and is set FALSE
  // if its called when user selects suggestion to replace
  // current selected word
  void replaceCurrentSelection(String newWord, bool isAutoUpdate) {
    if (currentSelectionStart == null || currentSelectionEnd == null) {
      // Returns if the selection is empty
      return;
    }

    // Set suggestions to [] to prevent triggering
    // replaceCurrentSelection again due to whitespace
    _suggestions = [];
    final text = widget.controller.text;
    int start = currentSelectionStart!;
    int end = currentSelectionEnd!;

    // Get text before current selection
    String textBeforeWord = text.substring(0, start);
    // Get text after current selection
    String textAfterWord = text.substring(end);
    // Create newText with current selection replaced by newWord
    // If text is being updated due to whitespace or newline,
    // omit whitespace between newWord and textAfterWord
    String newText = isAutoUpdate
        ? '$textBeforeWord$newWord$textAfterWord'
        : '$textBeforeWord$newWord $textAfterWord';

    // Update the textEditingController with new text
    // and whitespace. Whitespace is added to avoid
    // getting outOfBoundException if the currentSelection is
    // at the end
    widget.controller.text = '${newText.trim()} ';

    // Move cursor to the whitespace after newWord
    int newCursorPosition = textBeforeWord.length + newWord.length + 1;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: newCursorPosition),
    );
  }

  Future<void> _getTransliterations() async {
    if (currentSelectionStart == null ||
        currentSelectionEnd == null ||
        currentSelectionEnd == currentSelectionStart ||
        widget.languageCode == "en") {
      // Return if current selection is empty
      return;
    }

    final text = widget.controller.text
        .substring(currentSelectionStart!, currentSelectionEnd);

    // Clear previous suggestions to prevent wrong selection and set loading to true
    setState(() {
      _removeOverlay();
      _suggestions = [];
      _isLoading = true;
    });
    // Try to call API to get transliterations
    try {
      final response = await http.post(
        Uri.parse(
          'https://inputtools.google.com/request?text=$text&itc=${widget.languageCode}-t-i0-und&num=5&cp=0&cs=1&ie=utf-8&oe=utf-8&app=demopage',
        ),
      );

      if (response.statusCode == 200) {
        handleSuccessfulResponse(text, response);
      } else {
        // If response code != 200 execute onError
        widget.onError?.call();
      }
    } catch (e) {
      // Execute onError function on exception
      widget.onError?.call();
    }
  }

  // Handles if API results with code 200
  void handleSuccessfulResponse(String text, http.Response response) {
    final data = json.decode(response.body);
    if (data[0] == 'SUCCESS') {
      // On success, update suggestions if
      // current selected text == text transliterated by previous request.
      // Current selection might differ from currently transliterated text
      // due to delay caused by API call
      setState(() {
        _isLoading = false;
        if (text == getCurrentSelection()) {
          _suggestions = List<String>.from(data[1][0][1]);
          _showOverlay();
        }
      });
    }
  }

  // Return current selected text
  String getCurrentSelection() => widget.controller.text
      .substring(currentSelectionStart!, currentSelectionEnd);

  // Function updates currentSelectedStart and currentSelectedEnd when
  // textEditController detects changes
  void _updateCurrentSelection() {
    final text = widget.controller.text;
    int cursorPosition = widget.controller.selection.baseOffset;
    if (cursorPosition == -1) {
      return;
    }

    int start = cursorPosition;
    while (start > 0 &&
        text[start - 1] != ' ' &&
        text[start - 1] != '\n' &&
        text[start - 1] != '\r') {
      start--;
    }

    int end = cursorPosition;
    while (end < text.length &&
        text[end] != ' ' &&
        text[end] != '\n' &&
        text[end] != '\r') {
      end++;
    }

    // If current selection have no word
    if (start == end) {
      // If cursor is on whitespace after last selected word
      // and suggestions are available, replace last word to
      // its transliteration.
      if (_suggestions.isNotEmpty && currentSelectionEnd! + 1 == end) {
        replaceCurrentSelection(_suggestions[0], true);
      }

      // Clear suggestions and set selection to empty
      setState(() {
        _suggestions = [];
        currentSelectionStart = null;
        currentSelectionEnd = null;
      });
    }

    //Update current selection
    currentSelectionStart = start;
    currentSelectionEnd = end;

    //If selection is not empty get suggestions
    if (start != end) {
      _getTransliterations();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    var screenHeight = MediaQuery.of(context).size.height;
    var spaceBelow = screenHeight - offset.dy - size.height;
    var spaceAbove = offset.dy;

    bool showAbove = spaceBelow < 200 && spaceAbove > spaceBelow;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: showAbove
            ? offset.dy - _suggestions.length * 48.0 - size.height
            : offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_suggestions[index]),
                onTap: () {
                  replaceCurrentSelection(_suggestions[index], true);
                  setState(() {
                    _removeOverlay();
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // Adds listener to update current selection if cursor position changes
    widget.controller.addListener(
      () {
        _updateCurrentSelection();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialText,
      focusNode: widget.focusNode,
      controller: widget.controller,
      decoration: widget.decoration.copyWith(
          suffix: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null),
      scrollPadding: widget.scrollPadding,
      onTapOutside: (event) {
        widget.onTapOutside.call();
      },
      autofocus: widget.autofocus,
      style: widget.style,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      validator: widget.validator,
    );
  }
}
