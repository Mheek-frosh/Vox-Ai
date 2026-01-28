import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

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

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
  }

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
