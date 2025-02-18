// Import Statements
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sampleas/core/app_export.dart';
import 'package:sampleas/theme/custom_button_style.dart';
import 'package:sampleas/widgets/custom_icon_button.dart';
import 'package:sampleas/widgets/custom_outlined_button.dart';
import 'package:sampleas/widgets/custom_text_form_field.dart';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
// End of Import Statements

// Statefull Fill Form Widget
class FillForm extends StatefulWidget {
  final String? languageCode;
  bool caricature;
  FillForm({super.key, required this.languageCode, this.caricature = false});

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  // Controllers to handle text input for bride and groom details
  final List<TextEditingController> brideControllers =
      List.generate(5, (index) => TextEditingController());
  final List<TextEditingController> groomControllers =
      List.generate(5, (index) => TextEditingController());

  // Keeps track of selected side (Bride or Groom)
  String side = 'Bride';

  // Toggles the display of instruction modal
  bool isInst = true;

  // Stores event data as a list of maps
  List<Map<String, String>> eventList = [];

  // File paths for selected bride and groom images
  String brideImage = '';
  String groomImage = '';

  String brideImageString = '';
  String groomImageString = '';

  // Manages expansion states for form sections
  List<bool> isExpandedList = [true, false, false, false];
  List<bool> isCompletedList = [false, false, false, false];

  int currentPage = 0; // Current form page being viewed
  int tempCurrentPage = 0; // Temporarily tracks current page

  final List<ExpansionTileController> expansionControllers =
      List.generate(4, (index) => ExpansionTileController());

  // Controllers for event form inputs
  final List<TextEditingController> eventControllers =
      List.generate(3, (index) => TextEditingController());

  final List<Map<String, String>> imageUrl = [
    {
      'Image1':
          'https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=300', // Wedding venue
      'Image2':
          'https://images.unsplash.com/photo-1464699908537-0954e50791ee?q=80&w=300', // Reception hall
      'Image3':
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=300', // Wedding ceremony
      'Image4':
          'https://images.unsplash.com/photo-1520854221256-17451cc331bf?q=80&w=300', // Wedding decoration
    }
  ];

  List<bool> selectedImages = [false, false, false, false];

  // Tracks whether in edit mode for events
  bool isEdit = false;
  bool isSelect = false;

  String selectImage = ''; // Stores the selected image path

  FocusNode dateFocusNode = FocusNode(); // Focus node for date input field

  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Audio player instance for playing music

  bool isPlaying = false; // Track whether audio is currently playing

  int? currentlyPlayingIndex;

  bool isDropdownVisible =
      false; // Controls visibility of dropdown for music selection

  List<MusicModel> musicList = [
    MusicModel(
        name: 'Aaj Sajeya',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FAaj-sajeya.mp3?alt=media&token=affe9265-89db-4160-931e-b5c00625c2fe',
        audioString: ''),
    MusicModel(
        name: 'Baaju Band',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FBaaju%20Band%20%20Aakanksha%20Sharma%20%20Nizam%20Khan%20%20Dhanraj%20Dadhich%20%20Rajasthani%20Folk%20Songs.mp3?alt=media&token=205c634d-141e-4056-b496-41a4d7d01e1d',
        audioString: ''),
    MusicModel(
        name: 'Chhap Tilak',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FChhap_tilak.mp3?alt=media&token=41d64aff-2fbe-40ee-a806-5ddf8965e6a0',
        audioString: ''),
    MusicModel(
        name: 'Din Shagna X Kabira Maan Ja',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FDin%20Shagna%20Da%20X%20Kabira%20Maan%20Ja.mp3?alt=media&token=c6a4b7ea-64f3-49e6-aa32-0e4bbf4ee275',
        audioString: ''),
    MusicModel(
        name: 'VakraTunda Mahakay',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FVakratunda%20Mahakaya%20%E0%A4%B5%E0%A4%95%E0%A4%B0%E0%A4%A4%E0%A4%A1%20%E0%A4%AE%E0%A4%B9%E0%A4%95%E0%A4%AF%20%20Ganesh%20Mantra%20%20Anup%20Jalota%20%20Hindi%20English%20Lyrics.mp3?alt=media&token=5ae7d78e-6f7d-4e8c-9cc0-0a70f9c6de5b',
        audioString: ''),
    MusicModel(
        name: 'Ek Dil Ek Jaan',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FEk%20Dil%20Ek%20Jaan%20(From%20_Padmaavat_).mp3?alt=media&token=abf60c2b-ac41-4ba8-a64c-85990ad00bf4',
        audioString: ''),
    MusicModel(
        name: 'Wedding Songs Mashup',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FHindi%20Wedding%20Songs%20Mashup%20%20Shaadi%20Songs%20%20Saajanji%20Ghar%20Aaye%20%20Bole%20Chudiyan%20%20Mashup.mp3?alt=media&token=53d7ad80-e89d-4a48-9a67-544178ff8f9c',
        audioString: ''),
    MusicModel(
        name: 'Kesariya',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FKesariya.mp3?alt=media&token=6321f490-c4a3-498e-995e-11eaae27b314',
        audioString: ''),
    MusicModel(
        name: 'Krrish Flute',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FKrrish%20Flute.mp3?alt=media&token=6434a60c-3b00-46a4-bdea-a2a3b69f80a3',
        audioString: ''),
    MusicModel(
        name: 'Ishq(slowed and reverb)',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FLAAL%20ISHQ%20%20(slowed%20%26%20reverb)%40Subratasamanta834.mp3?alt=media&token=5f7d6ee2-88b0-4179-86d4-1a5e0f9b8144',
        audioString: ''),
    MusicModel(
        name: 'Madhanya',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FMadhanya.mp3?alt=media&token=7f483529-5b06-45f6-b379-4e02493d860e',
        audioString: ''),
    MusicModel(
        name: 'Mast Magan',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FMast_Magan.mp3?alt=media&token=978b9d25-a279-4059-a0e8-c0e43b12b913',
        audioString: ''),
    MusicModel(
        name: 'Matthe Te Chamkaan',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FMatthe_te_chamkaan.mp3?alt=media&token=5a976cbd-2f95-49a0-8441-9fc06d9654c8',
        audioString: ''),
    MusicModel(
        name: 'Saajanji Ghar Aaye',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FSaajanji%20Ghar%20Aaye.mp3?alt=media&token=c2a05848-7c43-4be5-bf06-c87d232b57b4',
        audioString: ''),
    MusicModel(
        name: 'Tujh Me Rab Dikhta hai(Instrumental)',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FTujh_mein_rab_dikhta_hai-intrumental.mp3?alt=media&token=af9bfe05-d2c0-4a4e-8057-3b449432bb99',
        audioString: ''),
    MusicModel(
        name: 'Tujh Me Rab Dikhta Hai',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FTujh_mein_rab_dikhta_hai.mp3?alt=media&token=12a6bdbc-da0d-4969-8bee-708a489a1038',
        audioString: ''),
    MusicModel(
        name: 'Tum Mile',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FTum_mile.mp3?alt=media&token=18963aa1-d910-4c41-94cf-5ec04dcedd21',
        audioString: ''),
    MusicModel(
        name: 'Ullam Paadum',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FUllam%20Paadum%20-%20Wedding%20Song%20%202%20States.mp3?alt=media&token=49be6aac-41c1-4fc1-bb29-8d93bfc3b6fd',
        audioString: ''),
    MusicModel(
        name: 'Romantic JukeBox',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FWedding%20Mashup%20Songs%20Mega%20Mix%20Romantic%20%20Dance%20%20Jukebox%20%20Nonstop%20%20VDj%20Royal.mp3?alt=media&token=9608f494-0440-4f52-9e51-f150a2dbf615',
        audioString: ''),
    MusicModel(
        name: 'low Reverb Mashup',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FWedding%20Mashup%20%5BSlowed%20%20Reverb%5D%20Aadi%20Production.mp3?alt=media&token=60c970cd-0833-4763-93d6-78119cebe38c',
        audioString: ''),
    MusicModel(
        name: 'Kanha Soja Zara Flute',
        url:
            'https://firebasestorage.googleapis.com/v0/b/python-14626.appspot.com/o/compressedSongs%2FWedding%20Function%20-%20Flute%20!%20Bgm.mp3?alt=media&token=151a91d9-5448-4ff5-80ea-14891699c808',
        audioString: ''),
  ]; // List of MusicModel objects representing music options

  Map<String, dynamic> data = {};
  // Default selected music
  late MusicModel selectedMusic;

  final _brideAndGroomKey =
      GlobalKey<FormState>(); // Key to validate bride and groom name form

  final ScrollController _scrollController = ScrollController();

  bool caricature = true;

  void preloadImages(BuildContext context) {
    for (var url in imageUrl[0].values) {
      precacheImage(NetworkImage(url), context);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedMusic = musicList[0];
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    preloadImages(context);
  }

//// Dispose Method
  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }
//// End of Dispose Method

//// Local storage function

// Save data to Hive
  Future<void> saveData(Map<String, dynamic> formData) async {
    // Open a Hive box
    final box = await Hive.openBox('formDataBox');

    // Save the formData as a string
    String jsonString = jsonEncode(formData);
    await box.put('formData', jsonString);

    // Close the box after saving
    await box.close();
  }

// Load data from Hive
  Future<void> loadData() async {
    // Open the Hive box
    final box = await Hive.openBox('formDataBox');
    String? jsonString = box.get('formData');

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        // Decode JSON string
        Map<String, dynamic> dataFiles = jsonDecode(jsonString);

        // Initialize variables with decoded data
        Map<String, String> groomData = {
          'groomName': dataFiles['groomName'] ?? '',
          'groomMother': dataFiles['groomMother'] ?? '',
          'groomFather': dataFiles['groomFather'] ?? '',
          'groomGrandmother': dataFiles['groomGrandmother'] ?? '',
          'groomGrandfather': dataFiles['groomGrandfather'] ?? '',
        };

        Map<String, String> brideData = {
          'brideName': dataFiles['brideName'] ?? '',
          'brideMother': dataFiles['brideMother'] ?? '',
          'brideFather': dataFiles['brideFather'] ?? '',
          'brideGrandmother': dataFiles['brideGrandmother'] ?? '',
          'brideGrandfather': dataFiles['brideGrandfather'] ?? '',
        };

        List<Map<String, String>> tempEventList =
            (jsonDecode(dataFiles['events'] ?? '[]') as List)
                .map((e) => Map<String, String>.from(e))
                .toList();

        List<MusicModel> tempMusicList =
            (jsonDecode(dataFiles['musicList'] ?? '[]') as List)
                .map((e) => MusicModel(
                      name: e['name'],
                      audioString: e['audioString'],
                      url: e['url'],
                    ))
                .toList();

        Map<String, dynamic> musicFile = jsonDecode(dataFiles['selectedAudio']);

        List<bool> tempSelectedImages = List.generate(4, (i) => false);
        tempEventList.forEach((event) {
          for (int i = 0; i < 4; i++) {
            if (imageUrl[0]['Image${i + 1}'] == event['image']) {
              tempSelectedImages[i] = true;
              break;
            }
          }
        });

        setState(() {
          isExpandedList[0] = false;
          expansionControllers[0].collapse();
          for (int i = 0; i < 4; i++) {
            isCompletedList[i] = true;
          }
          groomControllers[0].text = groomData['groomName']!;
          brideControllers[0].text = brideData['brideName']!;
          side = dataFiles['side'] ?? '';
          groomControllers[1].text = groomData['groomMother']!;
          groomControllers[2].text = groomData['groomFather']!;
          groomControllers[3].text = groomData['groomGrandmother']!;
          groomControllers[4].text = groomData['groomGrandfather']!;
          brideControllers[1].text = brideData['brideMother']!;
          brideControllers[2].text = brideData['brideFather']!;
          brideControllers[3].text = brideData['brideGrandmother']!;
          brideControllers[4].text = brideData['brideGrandfather']!;
          brideImage = dataFiles['brideImage'] ?? '';
          groomImage = dataFiles['groomImage'] ?? '';
          eventList = tempEventList;
          selectedImages = tempSelectedImages;
          musicList = tempMusicList;
          selectedMusic = MusicModel(
            name: musicFile['name'],
            audioString: musicFile['audioString'],
            url: musicFile['url'],
          );
          if (!widget.caricature) {
            isExpandedList[3] = true;
            expansionControllers[3].expand();
            widget.caricature = true;
            caricature = false;
          }
        });
      } catch (e) {
        print('Error loading data: $e');
      }
    } else {
      print('No saved data found');
    }

    // Close the box after loading
    await box.close();
  }
//// End of Load data function

//// Play Pause Function

  Future<void> _togglePlayPause(int index) async {
    if (currentlyPlayingIndex == index && isPlaying) {
      // Pause if the current track is playing
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
        currentlyPlayingIndex = null;
      });
    } else {
      // Play the selected track
      final selectedTrack = index == 0 ? null : musicList[index - 1];
      if (selectedTrack != null) {
        if (selectedTrack.audioString == '') {
          await _audioPlayer.play(UrlSource(selectedTrack.url));
        } else {
          await _audioPlayer.play(DeviceFileSource(selectedTrack.url));
        }
      }
      setState(() {
        isPlaying = true;
        currentlyPlayingIndex = index;
      });
    }
  }

//// End of Play and Pause Function

//// Get Random File Name Function
  String _generateRandomFileName() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return 'audio_${List.generate(10, (_) => chars[random.nextInt(chars.length)]).join()}';
  }
//// Random FIle Name

//// Pick File Function
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final path = result.files.single.path!;
      debugPrint("Picked file path: $path");

      final appDocDir = await getApplicationDocumentsDirectory();
      final extension = path.split('.').last;
      final uniqueFileName = _generateRandomFileName();
      final newPath = '${appDocDir.path}/$uniqueFileName.$extension';

      final newFile = await File(path).copy(newPath);
      if (!newFile.existsSync()) throw Exception('Failed to copy file');

      final bytes = await newFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final newMusic = MusicModel(
          name: result.files.single.name.split('.').first,
          audioString: base64String,
          url: newPath);
      setState(() {
        musicList.insert(0, newMusic);
        selectedMusic = newMusic;
        isDropdownVisible = false;
      });
    } catch (e) {
      debugPrint('Error picking or copying file: $e');
    }
  }
////End of Pick File Function

//// Pick Image function
  Future<void> _pickImage(bool isBride) async {
    try {
      if (isInst) {
        await showModalBottomSheet(
          context: context,
          isDismissible: true,
          builder: (context) => buildInstructionsSheet(context),
        );
        setState(() {
          isInst = false;
        });
      }

      final picker = ImagePicker();
      final XFile? result = await picker.pickImage(source: ImageSource.gallery);

      if (result == null) {
        debugPrint('No image selected.');
        return;
      }

      final path = result.path;
      final appDocDir = await getApplicationDocumentsDirectory();
      final uniqueFileName = _generateRandomFileName();
      final extension = path.split('.').last;
      final newPath = '${appDocDir.path}/$uniqueFileName.$extension';

      final newFile = await File(path).copy(newPath);

      final bytes = await newFile.readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        if (isBride) {
          brideImage = newFile.path;
          brideImageString = base64String;
        } else {
          groomImage = newFile.path;
          groomImageString = base64String;
        }
      });
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }
//// End of Pick Image function

//// Get Date With suffix function
  String getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return "${day}th";
    }
    switch (day % 10) {
      case 1:
        return "${day}st";
      case 2:
        return "${day}nd";
      case 3:
        return "${day}rd";
      default:
        return "${day}th";
    }
  }
//// End of Get Date Function

  String truncateText(String text, int limit) {
    return text.length > limit ? '${text.substring(0, limit)}...' : text;
  }

//// Format Date Time Function
  String formatDateTime(DateTime date, {TimeOfDay? time}) {
    String dayWithSuffix = getDayWithSuffix(date.day);
    String month = DateFormat('MMMM').format(date); // Full month name
    String year = date.year.toString();

    if (time != null) {
      String formattedTime =
          time.format(context).toLowerCase(); // Time in am/pm
      return "$dayWithSuffix $month $year | $formattedTime Onwards";
    } else {
      return "$dayWithSuffix $month $year";
    }
  }
//// End of Format Date and Time function

//// Pick Date and Time Function
  void pickDateTime(BuildContext context) async {
    // Unfocus the date field to prevent keyboard appearance
    dateFocusNode.unfocus();

    // Pick the date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Disable past dates
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary:
                  Color.fromRGBO(109, 81, 206, 1), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Pick the time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary:
                    Color.fromRGBO(109, 81, 206, 1), // Header background color
                onPrimary: Colors.white, // Header text color
                onSurface: Colors.black, // Body text color
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final formattedDateTime = formatDateTime(pickedDate, time: pickedTime);
        setState(() {
          eventControllers[1].text = formattedDateTime;
        });
      }
    }
  }
//// End of Date and Time picker function

//// Event Format function
  String eventFormat() {
    String a = '';
    for (int i = 0; i < eventList.length; i++) {
      a += eventList[i]['name']!;
      if (i != eventList.length - 1) {
        a += ' | ';
      }
    }
    return a;
  }
//// End of Format Function

  /// Build Widget
  @override
  Widget build(BuildContext context) {
    return Theme(
      data:theme,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Same as the AppBar background color
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey, // Color of the border
                  width: 1.0, // Thickness of the border
                ),
              ),
            ),
            child: AppBar(
              backgroundColor:
                  Colors.transparent, // Make the AppBar background transparent
              elevation: 0,
              leading: Icon(Icons.arrow_back_ios_new,
                  color: Colors.black), // Remove default AppBar shadow
              title: Center(
                child: Image.asset(
                  ImageConstant.wowInviteImage,
                  width: 144,
                  height: 39,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Need Help ?',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(153, 153, 153, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: !isExpandedList[index]
                    ? const EdgeInsets.only(top: 24)
                    : EdgeInsets.zero,
                child: buildCustomExpansionTile(
                  isExpandedList[index] ? 'Create Event' : 'Event Created',
                  '${brideControllers[0].text} weds ${groomControllers[0].text}',
                  index,
                  [buildCreateEvent()],
                  Key(index.toString()),
                ),
              );
            } else if (index == 1) {
              return buildCustomExpansionTile(
                'Bride & Groom Details',
                'Bride & Groom family details added',
                index,
                [buildBrideAndGroom()],
                Key(index.toString()),
              );
            } else if (index == 2) {
              return buildCustomExpansionTile(
                isCompletedList[index] && !isExpandedList[index]
                    ? '${eventList.length} Events Added'
                    : 'Event Details',
                eventFormat(),
                index,
                [buildAddEvents()],
                Key(index.toString()),
              );
            } else if (index == 3) {
              return buildCustomExpansionTile(
                'Songs & Caricature',
                '',
                index,
                [buildSongAndCaricature()],
                Key(index.toString()),
              );
            }
          },
        )),
        bottomNavigationBar: _buildNavigationButtonsRow(),
      ),
    );
  }

  /// End of Widget build Function

  /// Widget Build Drop Down Button
  Widget _buildDropdownButton() {
    return GestureDetector(
      onTap: () async {
        await _audioPlayer.stop();
        setState(() {
          isDropdownVisible = !isDropdownVisible;
          if (!isDropdownVisible) {
            isPlaying = false;
          }
        });
      },
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedMusic.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(118, 118, 118, 1)),
              ),
            ),
            Icon(isDropdownVisible
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  /// End of Build Drop Down widget

  /// Widget DropDown List
  Widget _buildDropdownList() {
    final listHeight = (musicList.length + 1) * 70.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox(
        height: listHeight > 270 ? 270 : listHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RawScrollbar(
            controller: _scrollController,
            thumbVisibility: true, // Makes the scrollbar always visible
            thumbColor: const Color.fromRGBO(109, 81, 206, 1), // Custom color
            thickness: 6, // Thickness of the scrollbar
            radius: const Radius.circular(
                5), // Rounded edges for the scrollbar thumb
            child: ListView.builder(
              controller: _scrollController,
              itemCount: musicList.length + 1,
              itemBuilder: (context, index) {
                final item = index == 0 ? null : musicList[index - 1];
                final isSelected = item == selectedMusic && index != 0;
                final isCurrentlyPlaying =
                    currentlyPlayingIndex == index && isPlaying;

                return TextButton(
                  onPressed: () {
                    if (index == 0) {
                      _pickFile();
                    } else {
                      setState(() {
                        selectedMusic = item!;
                        isDropdownVisible = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        isSelected ? Colors.grey[200] : Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.zero, // Set border radius to zero
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: index == 0
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _togglePlayPause(index);
                        },
                        child: Icon(
                          index == 0
                              ? Icons.file_upload_outlined
                              : isCurrentlyPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outlined,
                          color: const Color.fromRGBO(109, 81, 206, 1),
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        truncateText(item?.name ?? 'Upload your own music', 24),
                        style: TextStyle(
                          color: index == 0
                              ? const Color.fromRGBO(109, 81, 206, 1)
                              : Colors.grey[800],
                          fontSize: 16,
                          decoration: index == 0
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                        overflow: TextOverflow.ellipsis, // Handles overflow
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// End of Widget build dropdown List

  /// Widget build Instructions Sheet
  Widget buildInstructionsSheet(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 40.h,
        vertical: 56.h,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Follow these points for the best results",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.titleLargePrimary.copyWith(
              height: 1.31,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            "1.Images should be front facing \n2.Avoid glasses \n3.No darkeness in the background \n4.only one face in the image",
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge!.copyWith(
              height: 1.78,
            ),
          ),
          SizedBox(height: 52.h),
          CustomOutlinedButton(
            width: 158.h,
            text: "Got it",
            buttonStyle: OutlinedButton.styleFrom(
              backgroundColor: Color.fromRGBO(109, 81, 206, 1),
              side: BorderSide(
                color: appTheme.blueGray10003,
                width: 1.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.h),
              ),
              visualDensity: const VisualDensity(
                vertical: -4,
                horizontal: -4,
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              setState(() {
                isInst = false;
              });
              Navigator.pop(context);
            },
            buttonTextStyle: CustomTextStyles.bodyLargePoppinsOnPrimary,
          )
        ],
      ),
    );
  }

  /// End of Widget build Instructions Sheet

  /// Expansion Tile
  Widget buildCustomExpansionTile(
    String title,
    String description,
    int index,
    List<Widget> children,
    Key key,
  ) {
    bool isCurrentStep = index == currentPage;
    bool isPreviousStep = index < currentPage;
    bool isCompleted = isCompletedList[index];

    return Padding(
      padding: !isExpandedList[index]
          ? EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)
          : EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isExpandedList[index] ? Colors.white : Colors.grey[50],
                border: Border.all(
                  color:
                      isExpandedList[index] ? Colors.white : Colors.grey[300]!,
                )),
            child: ExpansionTile(
              key: key,
              controller: expansionControllers[index],
              tilePadding: EdgeInsets.zero,
              initiallyExpanded: isExpandedList[index],
              maintainState: true,
              enabled:
                  isCurrentStep || isPreviousStep || isCompletedList[index],
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(right: 16.0, left: 12),
                        child: !isCompleted
                            ? !isExpandedList[index]
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isExpandedList[index]
                                            ? Colors.white
                                            : Colors.grey[300]!, // Border color
                                        width: 2.0, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Text(
                                          "${index + 1}.",
                                          style:
                                              CustomTextStyles.bodyLargePrimary,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(
                                padding: isExpandedList[index]
                                    ? EdgeInsets.only(right: 16.0, left: 12)
                                    : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(109, 81, 206, 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    PhosphorIcons.check(),
                                    size: 22.h,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            !isCompleted
                                ? isExpandedList[index]
                                    ? '${index + 1}. $title'
                                    : title
                                : title,
                            style: isExpandedList[index]
                                ? CustomTextStyles.bodyLargePrimary
                                : TextStyle(
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                  ),
                          ),
                          if (!isExpandedList[index] && isCompleted)
                            Text(
                              description,
                              style:
                                  TextStyle(fontSize: 11.0, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(16.0),
                child: !isCompletedList[index]
                    ? null
                    : Icon(
                        isExpandedList[index]
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: isExpandedList[index]
                            ? theme.colorScheme.primary
                            : Colors.grey,
                      ),
              ),
              onExpansionChanged: (expanded) {
                // if (!isCurrentStep && !isPreviousStep) return;

                setState(() {
                  // First, handle the clicked tile's state
                  isExpandedList[index] = expanded;

                  // Then, if we're expanding this tile, collapse all others
                  if (expanded) {
                    for (int i = 0; i < isExpandedList.length; i++) {
                      if (i != index && isExpandedList[i]) {
                        isExpandedList[i] = false;
                        expansionControllers[i].collapse();
                      }
                    }

                    currentPage = index;
                  }
                });
              },
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  /// End of Expansion Tile

// Song and Caricature

  /// Song and Caricature widget
  Widget buildSongAndCaricature() {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 4.h,
            top: 10.h,
            right: 14.h,
          ),
          child: Column(
            children: [
              _buildMusicSelection(),
              SizedBox(height: 52.h),
            ],
          ),
        ),
      ),
    );
  }

  /// End of Song and Caricature widget

  /// Music Selection widget
  Widget _buildMusicSelection() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected music :",
            style: CustomTextStyles.bodyLargeGray60001,
          ),
          SizedBox(
            height: 12.h,
          ),
          _buildDropdownButton(),
          Stack(
            children: [
              // Base layer - Photo upload section
              Column(
                spacing: 40,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  SizedBox(
                    width: 220,
                    child: const Divider(
                      thickness: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.caricature
                          ? caricature? "Upload the photos of bride & Groom":"Please Upload Bride & Groom Images\nBefore Proceeding"
                          :"",
                      style: CustomTextStyles.bodyLargeGray60001,
                    ),
                  ),
                  !widget.caricature
                      ? SizedBox(
                          width: 180.h,
                          height: 180.h,
                        )
                      : Container(
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickImage(true),
                                  child: Column(
                                    spacing: 22,
                                    children: [
                                      Container(
                                        height: 82.h,
                                        width: 82.h,
                                        margin: EdgeInsets.only(right: 2.h),
                                        decoration: AppDecoration
                                            .outlineBluegray10004
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.circleBorder42,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            brideImage.isEmpty
                                                ? Icon(
                                                    Icons.file_upload_outlined,
                                                    color: Color.fromRGBO(
                                                        109, 81, 206, 1),
                                                    size: 36,
                                                  )
                                                : ClipOval(
                                                    child: Image.file(
                                                      File(brideImage),
                                                      height: 82.h,
                                                      width: 82.h,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Upload Bride\nImage",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyles.bodyLargeGray700
                                            .copyWith(height: 1.31),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickImage(false),
                                  child: Column(
                                    spacing: 24,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 82.h,
                                        width: 82.h,
                                        margin: EdgeInsets.only(right: 8.h),
                                        decoration: AppDecoration
                                            .outlineBluegray10004
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.circleBorder42,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            groomImage.isEmpty
                                                ? Icon(
                                                    Icons.file_upload_outlined,
                                                    color: Color.fromRGBO(
                                                        109, 81, 206, 1),
                                                    size: 36,
                                                  )
                                                : ClipOval(
                                                    child: Image.file(
                                                      File(groomImage),
                                                      height: 82.h,
                                                      width: 82.h,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Upload Groom\nImage",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyles.bodyLargeGray700
                                            .copyWith(height: 1.31),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              // Overlay layer - Dropdown list
              if (isDropdownVisible)
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Container(
                    color:
                        Colors.white, // Add background color to make it visible
                    child: _buildDropdownList(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// End of Music Section Widget

// End of Song and Caricature

// Add Events

  /// Build Add Events Widget
  Widget buildAddEvents() {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 14.h,
            right: 14.h,
          ),
          child: Column(
            children: [
              eventList.isNotEmpty
                  ? Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(
                        left: 18.h,
                        right: 24.h,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 2.h,
                            child: Column(
                              spacing: 44,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: VerticalDivider(
                                    width: 2.h,
                                    thickness: 2.h,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: VerticalDivider(
                                    width: 2.h,
                                    thickness: 2.h,
                                    color: theme.colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: eventList.map((event) {
                                // Extract data from the map
                                String eventName =
                                    event['name'] ?? 'Event Name';
                                String eventDate =
                                    event['date'] ?? 'Event Date';
                                String eventVenue =
                                    event['details'] ?? 'Event Venue';

                                String eventImage = event['image'] ??
                                    imageUrl[0]['Image1'] ??
                                    '';

                                return Container(
                                  margin: EdgeInsets.only(bottom: 28),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: Color.fromRGBO(
                                                  109, 81, 206, 1),
                                              width: 2))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 19.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventName,
                                          style: CustomTextStyles.bodyLarge18,
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          eventDate,
                                          style: CustomTextStyles
                                              .bodyMediumRobotoBluegray400,
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          eventVenue,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles
                                              .bodyMediumRobotoBluegray400
                                              .copyWith(
                                            height: 1.31,
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: Row(
                                            children: [
                                              CustomIconButton(
                                                  height: 40.h,
                                                  width: 40.h,
                                                  onTap: () {
                                                    setState(() {
                                                      // Remove event
                                                      for (int i = 0;
                                                          i < 4;
                                                          i++) {
                                                        if (imageUrl[0][
                                                                'Image${i + 1}'] ==
                                                            event['image']) {
                                                          selectedImages[i] =
                                                              false;
                                                          break;
                                                        }
                                                      }
                                                      eventList.remove(event);
                                                    });
                                                  },
                                                  padding: EdgeInsets.all(10.h),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          255, 0, 0, 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Icon(
                                                      PhosphorIcons.trash(),
                                                      size: 20.h,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 200, 4, 4))),
                                              SizedBox(
                                                width: 34.h,
                                              ),
                                              CustomIconButton(
                                                  height: 40.h,
                                                  width: 40.h,
                                                  onTap: () {
                                                    setState(() {
                                                      isEdit = true;
                                                      isSelect = false;
                                                      eventControllers[0].text =
                                                          event['name'] ??
                                                              'Event Name';
                                                      eventControllers[1].text =
                                                          event['date'] ??
                                                              'Event Date';
                                                      // Remove 'Venue: ' prefix from the details when setting the controller
                                                      eventControllers[2].text =
                                                          (event['details']!)
                                                              .replaceAll(
                                                                  'Venue - ',
                                                                  '');
                                                      selectImage =
                                                          event['image']!;
                                                    });
                                                    // Open the bottom sheet with the event data for editing
                                                    showEventBottomSheet(
                                                        context, event);
                                                  },
                                                  padding: EdgeInsets.all(8.h),
                                                  decoration:
                                                      IconButtonStyleHelper
                                                          .fillPrimary,
                                                  child: Icon(
                                                    PhosphorIcons
                                                        .pencilSimpleLine(),
                                                    size: 21.h,
                                                    color: Color.fromRGBO(
                                                        109, 81, 206, 1),
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 10.h,
                                                  right: 136.h,
                                                ),
                                                child: Text(
                                                  "Edit",
                                                  style: CustomTextStyles
                                                      .bodyMediumRobotoPrimary,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              eventList.isNotEmpty ? SizedBox(height: 24.h) : Container(),
              CustomOutlinedButton(
                width: 136.h,
                text: "Add event",
                onPressed: () {
                  if (eventList.length < 4) {
                    setState(() {
                      isEdit = false;
                      isSelect = true;
                      eventControllers[0].clear();
                      eventControllers[1].clear();
                      eventControllers[2].clear();
                      selectImage = '';
                    });
                    showEventBottomSheet(context, {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please Update or delete Events!'),
                      ),
                    );
                  }
                },
                leftIcon: Container(
                    margin: EdgeInsets.only(right: 6.h),
                    child: Icon(
                      PhosphorIcons.plusCircle(),
                      size: 22.h,
                      color: Color.fromRGBO(114, 114, 114, 0.72),
                    )),
                buttonStyle: CustomButtonStyles.outlineGray,
                buttonTextStyle: CustomTextStyles.bodyMediumGray600,
              ),
              SizedBox(height: 18.h)
            ],
          ),
        ),
      ),
    );
  }

  /// Build Add Events Widget

  /// Function to show bottom sheet with floating close button
  void showEventBottomSheet(BuildContext context, Map<String, String> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom Sheet Content
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 20.h), // Add margin for close button
              child: buildEventsBottomSheet(event),
            ),
          ),
          // Floating Close Button
          Positioned(
            top: -40.h,
            right: 20.h,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  size: 20.h,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Function to show bottom sheet with floating close button

  /// Original bottom sheet widget without the close button
  Widget buildEventsBottomSheet(Map<String, String> events) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setSheetState) {
        return Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 44.h,
            right: 44.h,
            top: 26.h,
          ),
          decoration: AppDecoration.fillOnPrimary.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder12,
          ),
          child: isSelect
              ? _buildImageSelectionView(setSheetState)
              : _buildEventFormView(context, events),
        );
      },
    );
  }

  ///End of Original bottom sheet widget without the close button

  /// Original Image Selection View without the close button
  Widget _buildImageSelectionView(StateSetter setSheetState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Click to select event',
              style: theme.textTheme.titleLarge,
            ),
          ),
        ),
        _buildImageGrid(setSheetState),
      ],
    );
  }

  /// Original Image Selection View without the close button

  /// Widget build Image Grid
  Widget _buildImageGrid(StateSetter setSheetState) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageRow(setSheetState, 0),
            _buildImageRow(setSheetState, 2),
          ],
        ),
      ),
    );
  }

  ///End of Widget build Image Grid

  /// Widget build Image Row
  Widget _buildImageRow(StateSetter setSheetState, int start) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(2, (index) {
          final imageNumber = start + index + 1;
          final selectedIndex = start + index;
          final imageKey = 'Image$imageNumber';

          return GestureDetector(
            onTap: () {
              if (!selectedImages[selectedIndex]) {
                setSheetState(() {
                  isSelect = false;
                  selectImage = imageUrl[0][imageKey] ?? '';
                });
                setState(() {
                  isSelect = false;
                  selectImage = imageUrl[0][imageKey] ?? '';
                });
              }
            },
            child: ColorFiltered(
              colorFilter: selectedImages[selectedIndex]
                  ? const ColorFilter.matrix(<double>[
                      0.15, 0.15, 0.15, 0, 0, // Red channel
                      0.15, 0.15, 0.15, 0, 0, // Green channel
                      0.15, 0.15, 0.15, 0, 0, // Blue channel
                      0, 0, 0, 1, 0, // Alpha channel
                    ])
                  : const ColorFilter.mode(
                      Colors.transparent, BlendMode.multiply),
              child: CachedNetworkImage(
                imageUrl: imageUrl[0][imageKey] ?? '',
                fit: BoxFit.cover,
                width: 136.h,
                height: 258.h,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(109, 81, 206, 1),
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  ///End of Widget build Image Row

  /// Widget build Event Form View
  Widget _buildEventFormView(BuildContext context, Map<String, String> events) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 6.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEdit ? "Edit Event Details" : "Add Event Details",
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 26.h),
                  Container(
                    width: 136.h,
                    height: 258.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.h),
                      image: DecorationImage(
                        image: NetworkImage(selectImage),
                        fit: BoxFit.cover,
                        // Add color filter to make image look disabled
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),
                  _buildFormFields(context),
                  SizedBox(height: 36.h),
                  _buildSubmitButton(context, events),
                  SizedBox(height: 46.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///End of Widget build Event Form View

  /// Widget build Form Fields View
  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: eventControllers[0],
          languageCode: widget.languageCode,
          hintText: "Event name",
          maxLines: 1,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 22.h,
            vertical: 14.h,
          ),
          borderDecoration: TextFormFieldStyleHelper.outlineBlueGrayTL10,
          fillColor: appTheme.gray5001,
        ),
        SizedBox(height: 26.h),
        CustomTextFormField(
          controller: eventControllers[1],
          hintText: "Event Date & Time",
          languageCode: 'en',
          contentPadding: EdgeInsets.symmetric(
            horizontal: 22.h,
            vertical: 14.h,
          ),
          readOnly: true,
          focusNode: dateFocusNode,
          onTap: () => pickDateTime(context),
          borderDecoration: TextFormFieldStyleHelper.outlineBlueGrayTL10,
          fillColor: appTheme.gray5001,
        ),
        SizedBox(height: 26.h),
        CustomTextFormField(
          controller: eventControllers[2],
          languageCode: widget.languageCode,
          hintText: "Event Venue",
          textInputAction: TextInputAction.newline,
          textInputType: TextInputType.multiline,
          maxLines: null, // This allows the field to grow with the content
          contentPadding: EdgeInsets.symmetric(
            horizontal: 22.h,
            vertical: 14.h,
          ),
          borderDecoration: TextFormFieldStyleHelper.outlineBlueGrayTL10,
          fillColor: appTheme.gray5001,
        ),
      ],
    );
  }

  /// Widget build Form Fields View

  /// Widget build Submit Button View
  Widget _buildSubmitButton(BuildContext context, Map<String, String> events) {
    return CustomOutlinedButton(
      text: isEdit ? "Update Event" : "Add Event",
      onPressed: () => _handleSubmit(context, events),
      margin: EdgeInsets.symmetric(horizontal: 74.h),
      buttonStyle: OutlinedButton.styleFrom(
          backgroundColor: Color.fromRGBO(109, 81, 206, 1),
          side: BorderSide(
            color: appTheme.blueGray10003,
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      rightIcon: Container(
          margin: EdgeInsets.only(left: 8.h),
          child: Icon(
            PhosphorIcons.arrowCircleRight(),
            size: 24.0,
            color: Colors.white,
          )),
    );
  }

  /// Widget build Submit Button View

  /// Function to handle Submit of events bottom sheet
  void _handleSubmit(BuildContext context, Map<String, String> events) {
    if (eventControllers[0].text.isNotEmpty &&
        eventControllers[1].text.isNotEmpty &&
        eventControllers[2].text.isNotEmpty &&
        eventList.length < 4) {
      setState(() {
        final event = {
          'name': eventControllers[0].text,
          'date': eventControllers[1].text,
          'details': 'Venue - ${eventControllers[2].text}',
          'image': selectImage
        };

        if (isEdit) {
          int index = eventList.indexWhere((element) => element == events);
          if (index != -1) {
            eventList[index] = event;
          }
        } else {
          eventList.add(event);
          for (int i = 0; i < 4; i++) {
            if (imageUrl[0]['Image${i + 1}'] == event['image']) {
              selectedImages[i] = true;
              break;
            }
          }
        }

        // Clear the controllers after adding/updating
        eventControllers[0].clear();
        eventControllers[1].clear();
        eventControllers[2].clear();
        selectImage = '';
      });

      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('All fields are required!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  ///End of Function to handle Submit of events bottom sheet

// End of Add Events

// Bride and Groom

  /// Birde and Groom Widget
  Widget buildBrideAndGroom() {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 42.h),
                child: Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.brideImage,
                      height: 40.h,
                      width: 40.h,
                      radius: BorderRadius.circular(
                        20.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14.h),
                      child: Text(
                        "Bride’s Details",
                        style: CustomTextStyles.bodyLargeGray50003,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              _buildBrideParentsRow(),
              SizedBox(height: 16.h),
              _buildBrideGrandparentsRow(),
              SizedBox(height: 52.h),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 42.h),
                child: Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.groomImage,
                      height: 40.h,
                      width: 40.h,
                      radius: BorderRadius.circular(
                        20.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14.h),
                      child: Text(
                        "Groom’s Details",
                        style: CustomTextStyles.bodyLargeGray50003,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              _buildGroomParentsRow(context),
              SizedBox(height: 16.h),
              _buildGroomGrandparentsRow(context),
              SizedBox(height: 48.h),
              // _buildEventDetailsRow(context)
            ],
          ),
        ),
      ),
    );
  }

  ///End of Bride and Groom Widget

  /// WIdget for Name Input
  Widget _buildNameInput(String hint, TextEditingController controller) {
    return Expanded(
      child: CustomTextFormField(
        controller: controller,
        languageCode: widget.languageCode,
        hintText: hint,
        maxLines: 1,
        contentPadding: EdgeInsets.all(12.h),
        borderDecoration: TextFormFieldStyleHelper.outlineBlueGrayTL10,
        fillColor: appTheme.gray5001,
      ),
    );
  }

  ///End of WIdget for Name Input

  /// Widget for Birde and Parents Row
  Widget _buildBrideParentsRow() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        children: [
          _buildNameInput("Mother's Name", brideControllers[1]),
          SizedBox(
            width: 12,
          ),
          _buildNameInput("Father's Name", brideControllers[2]),
        ],
      ),
    );
  }

  ///End of Widget for Birde and Parents Row

  /// Build Bride GrandParents Row
  Widget _buildBrideGrandparentsRow() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 20.h,
        right: 18.h,
      ),
      child: Row(
        children: [
          _buildNameInput("Grandmother's Name", brideControllers[3]),
          SizedBox(
            width: 12,
          ),
          _buildNameInput("Grandfather's Name", brideControllers[4]),
        ],
      ),
    );
  }

  /// End of bride Grand parents row

  /// Build Groom Parents Row
  Widget _buildGroomParentsRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        children: [
          _buildNameInput("Mother's Name", groomControllers[1]),
          SizedBox(
            width: 12,
          ),
          _buildNameInput("Father's Name", groomControllers[2]),
        ],
      ),
    );
  }

  /// Build Groom Parents Row

  /// build Groom Grand parents Row
  Widget _buildGroomGrandparentsRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 20.h,
        right: 18.h,
      ),
      child: Row(
        children: [
          _buildNameInput("Grandmother's Name", groomControllers[3]),
          SizedBox(
            width: 12,
          ),
          _buildNameInput("Grandfather's Name", groomControllers[4]),
        ],
      ),
    );
  }

  /// build Groom Grand parents Row

// End of Groom and Bride

// Create Event

  /// Widget Build Create Events
  Widget buildCreateEvent() {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 18.h),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 46.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Groom Name",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 56.h),
                      child: Text(
                        "Bride Name",
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              _buildNameInputRow(context),
              SizedBox(height: 28.h),
              _buildChooseSideColumn(context),
              SizedBox(height: 54.h),
            ],
          ),
        ),
      ),
    );
  }

  ///End of Widget Build Create Events

  ///Widget build Name Input Row
  Widget _buildNameInputRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(
        horizontal: 36.h,
      ),
      child: Form(
        key: _brideAndGroomKey,
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items from the top
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: groomControllers[0],
                    hintText: "Groom Name",
                    languageCode: widget.languageCode,
                    maxLines: 1,
                    hintStyle: CustomTextStyles.bodySmallGray50002,
                    contentPadding: EdgeInsets.all(12.h),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h), // Consistent spacing using .h
                ],
              ),
            ),
            SizedBox(width: 12.h), // Consistent spacing
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: brideControllers[0],
                    hintText: "Bride Name",
                    languageCode: widget.languageCode,
                    maxLines: 1,
                    hintStyle: CustomTextStyles.bodySmallGray50002,
                    textInputAction: TextInputAction.done,
                    contentPadding: EdgeInsets.all(12.h),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h), // Consistent spacing using .h
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Widget build Name Input Row

  /// Widget Build Choose Side Column
  Widget _buildChooseSideColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 38.h,
        right: 30.h,
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              "Choose Your Side",
              style: theme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      side = 'Groom';
                    });
                  },
                  child: Container(
                    width: 134.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.h,
                      vertical: 6.h,
                    ),
                    decoration: side == 'Bride'
                        ? AppDecoration.outlineBlueGray.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder12,
                          )
                        : AppDecoration.outlinePrimary.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder12,
                          ),
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.groomImage,
                          height: 36.h,
                          width: 36.h,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Ladke \nWale",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: side == 'Bride'
                              ? theme.textTheme.bodyMedium!.copyWith(
                                  height: 1.36,
                                )
                              : CustomTextStyles.bodyMediumPrimary.copyWith(
                                  height: 1.36,
                                ),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  "or",
                  style: CustomTextStyles.bodyLargePoppinsGray50001,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      side = 'Bride';
                    });
                  },
                  child: Container(
                    width: 134.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.h,
                      vertical: 6.h,
                    ),
                    decoration: side == 'Groom'
                        ? AppDecoration.outlineBlueGray.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder12,
                          )
                        : AppDecoration.outlinePrimary.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder12,
                          ),
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.brideImage,
                          height: 36.h,
                          width: 36.h,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Ladki\nWale",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: side == 'Groom'
                              ? theme.textTheme.bodyMedium!.copyWith(
                                  height: 1.36,
                                )
                              : CustomTextStyles.bodyMediumPrimary.copyWith(
                                  height: 1.36,
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///End of Widget Build Choose Side Column

// End of Create Event

// Bottom Navigation

  /// Widget build Navigation Buttons Row
  Widget _buildNavigationButtonsRow() {
    return Container(
      height: 100.h,
      decoration: AppDecoration.outlineGray400,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildSkipButton(context), _buildNextButton(context)],
          ),
        ],
      ),
    );
  }

  /// Widget build Navigation Buttons Row

  /// Widget build Skip Button
  Widget _buildSkipButton(BuildContext context) {
    return currentPage != 0
        ? CustomOutlinedButton(
            width: 116.h,
            text: "Skip",
            onPressed: () {
              if (currentPage <= 3) {
                setState(() {
                  // Mark current step as completed
                  isCompletedList[currentPage] = true;
                  // Collapse current step
                  isExpandedList[currentPage] = false;
                  expansionControllers[currentPage].collapse();
                  if (currentPage == 1) {
                    groomControllers[1].text = 'Groom Mother';
                    groomControllers[2].text = 'Groom Father';
                    groomControllers[3].text = 'Groom GrandMother';
                    groomControllers[4].text = 'Groom GrandFather';
                    brideControllers[1].text = 'Bride Mother';
                    brideControllers[2].text = 'Bride Father';
                    brideControllers[3].text = 'Bride GrandMother';
                    brideControllers[4].text = 'Bride GrandFather';
                  }

                  // Move to next step
                  currentPage++;
                  // Expand next step
                  if (currentPage <= 3) {
                    isExpandedList[currentPage] = true;
                    expansionControllers[currentPage].expand();
                  }
                });
              }
            },
            margin: EdgeInsets.only(left: 4.h),
            buttonStyle: CustomButtonStyles.outlineGray,
            buttonTextStyle: CustomTextStyles.bodyMediumGray600,
          )
        : Container(
            width: 116.h,
          );
  }

  ///End of Widget build Skip Button

  /// Widget Build Next Button
  Widget _buildNextButton(BuildContext context) {
    return CustomOutlinedButton(
      width: 116.h,
      buttonStyle:  OutlinedButton.styleFrom(
          backgroundColor: Color.fromRGBO(109, 81, 206, 1),
          side: BorderSide(
            color: appTheme.blueGray10003,
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      text: "Next",
      onPressed: () {
        if ((currentPage == 0 && _brideAndGroomKey.currentState!.validate()) ||
            (currentPage == 1 &&
                ((brideControllers[1].text.isNotEmpty &&
                        brideControllers[2].text.isNotEmpty &&
                        groomControllers[1].text.isNotEmpty &&
                        groomControllers[2].text.isNotEmpty) ||
                    isCompletedList[currentPage])) ||
            (currentPage == 2 &&
                (eventList.isNotEmpty || isCompletedList[currentPage])) ||
            (currentPage == 3)) {
          setState(() {
            // Mark current step as completed
            isCompletedList[currentPage] = true;
            // Collapse current step
            isExpandedList[currentPage] = false;
            expansionControllers[currentPage].collapse();

            if (currentPage == 3) {
              String encodedEventList = jsonEncode(eventList);
              Map<String, dynamic> formData = {
                'groomName': groomControllers[0].text,
                'brideName': brideControllers[0].text,
                'side': side,
                'groomMother': groomControllers[1].text,
                'groomFather': groomControllers[2].text,
                'groomGrandmother': groomControllers[3].text,
                'groomGrandfather': groomControllers[4].text,
                'brideMother': brideControllers[1].text,
                'brideFather': brideControllers[2].text,
                'brideGrandmother': brideControllers[3].text,
                'brideGrandfather': brideControllers[4].text,
                'brideImage': brideImageString,
                'groomImage': groomImageString,
                'events': encodedEventList, // Store encoded string for `events`
                'selectedAudio': selectedMusic.audioString,
              };

              List<Map<String, dynamic>> musicListJson =
                  musicList.map((music) => music.toJson()).toList();

              data = formData;
              formData['brideImage'] = brideImage;
              formData['groomImage'] = groomImage;
              formData['selectedAudio'] = jsonEncode(selectedMusic);
              formData['musicList'] = jsonEncode(musicListJson);

              saveData(formData);
            }
            // Move to next step
            currentPage++;
            // Expand next step
            if (currentPage <= 3) {
              isExpandedList[currentPage] = true;
              expansionControllers[currentPage].expand();
            }
          });
        } else if (currentPage == 4) {
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(currentPage == 0
                    ? 'Both Bride And Groom name required'
                    : (currentPage == 1 && !isCompletedList[currentPage])
                        ? 'Both Bride and Groom Father and Mother name required'
                        : (currentPage == 2 && !isCompletedList[currentPage]
                            ? 'Event List Cannot be empty'
                            : ''))),
          );
        }
      },
      rightIcon: Container(
          margin: EdgeInsets.only(left: 6.h),
          child: Icon(
            PhosphorIcons.arrowCircleRight(),
            size: 22.h,
            color: Colors.white,
          )),
    );
  }

  /// Widget Build Next Button

// End of Bottom Navigation
}

// End of Statefull Widget Fill Form

// Music Model Class
class MusicModel {
  final String name;
  final String url;
  final String audioString;

  MusicModel({
    required this.name,
    required this.url,
    required this.audioString,
  });

  // Convert MusicModel to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'audioString': audioString,
    };
  }

  // Convert from Map to MusicModel (optional, for decoding)
  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      name: json['name'],
      url: json['url'],
      audioString: json['audioString'],
    );
  }
}

//End of Music Model Class
