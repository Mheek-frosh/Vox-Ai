import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

/// Controller responsible for managing voice interactions.
///
/// It handles Speech-to-Text for listening to user commands,
/// and Text-to-Speech for responding back to the user.
class VoiceController extends GetxController {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  RxBool isListening = false.obs;
  RxString lastWords = "".obs;
  RxString responseText = "How can I help you today?".obs;
  RxList<String> commandHistory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    _initTts();
  }

  /// Initializes the Speech-to-Text service and sets up status listeners.
  void _initSpeech() async {
    try {
      await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening')
            isListening.value = false;
        },
      );
    } catch (e) {
      print("Speech init error: $e");
    }
  }

  /// Initializes the Text-to-Speech service with an English voice.
  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
  }

  /// Requests microphone permissions and starts listening for voice input.
  /// Resulting text is passed to [_processCommand].
  Future<void> startListening() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      isListening.value = true;
      lastWords.value = "";
      await _speechToText.listen(
        onResult: (result) {
          lastWords.value = result.recognizedWords;
          if (result.finalResult) _processCommand(result.recognizedWords);
        },
      );
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    isListening.value = false;
  }

  /// Processes the interpreted text command and generates a response.
  /// 
  /// The command is stored in [commandHistory]. Based on simple keyword matching,
  /// it decides how to respond using Text-to-Speech.
  void _processCommand(String command) {
    commandHistory.insert(0, command);
    String cmd = command.toLowerCase();
    if (cmd.contains("open whatsapp")) {
      _respond("Opening WhatsApp.");
    } else if (cmd.contains("call")) {
      _respond("Calling...");
    } else {
      _respond("I heard: $command");
    }
  }

  Future<void> _respond(String text) async {
    responseText.value = text;
    await _flutterTts.speak(text);
  }
}
