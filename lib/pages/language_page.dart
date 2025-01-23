import 'package:flutter/material.dart';
import 'package:sampleas/core/utils/size_utils.dart';
import 'package:sampleas/pages/fill_form.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String languageCode = 'en';

  ButtonStyle getButtonStyle(String code) {
    return TextButton.styleFrom(
      side: BorderSide(
        color: code == languageCode
            ? Color.fromRGBO(109, 81, 206, 1)
            : Colors.grey,
        width: 2,
      ),
      backgroundColor: code == languageCode
          ? Color.fromRGBO(109, 81, 206, 1)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  TextStyle getTextStyle(String code) {
    return TextStyle(
      color: code == languageCode ? Colors.white : Colors.grey,
      fontWeight: FontWeight.bold,
    );
  }

  void showLangDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Center(child: Text('Languages:')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildLanguageRow('English', 'हिंदी', 'en', 'hi', setState),
                    buildLanguageRow('தமிழ்', 'मराठी', 'ta', 'mr', setState),
                    buildLanguageRow('తెలుగు', 'ગુજરાતી', 'te', 'gu', setState),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(
                      color: Color.fromRGBO(109, 81, 206, 1),
                      width: 2,
                    ),
                    backgroundColor: Color.fromRGBO(109, 81, 206, 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            FillForm(languageCode: languageCode),
                      ),
                    );
                  },
                  child: Center(child: const Text('Set Language',style: TextStyle(
                    color: Colors.white
                  ),)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildLanguageRow(
    String text1,
    String text2,
    String code1,
    String code2,
    StateSetter setState,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: SizeUtils.width * 0.3,
            child: TextButton(
              onPressed: () {
                setState(() {
                  languageCode = code1;
                });
              },
              style: getButtonStyle(code1),
              child: Text(text1, style: getTextStyle(code1)),
            ),
          ),
          SizedBox(
            width: 12.h,
          ),
          SizedBox(
            width: SizeUtils.width * 0.3,
            child: TextButton(
              onPressed: () {
                setState(() {
                  languageCode = code2;
                });
              },
              style: getButtonStyle(code2),
              child: Text(text2, style: getTextStyle(code2)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: showLangDialog,
          child: const Text('Click Me'),
        ),
      ),
    );
  }
}
