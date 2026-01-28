import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceController extends GetxController {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  RxBool isListening = false.obs;
  RxBool isAlwaysListening = false.obs;
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
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
            if (isAlwaysListening.value) {
              startListening();
            }
          }
        },
        onError: (error) => print('Error: $error'),
      );
      if (!available) {
        print("Speech recognition not available.");
      }
    } catch (e) {
      print("Speech initialization error: $e");
    }
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> startListening() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      isListening.value = true;
      lastWords.value = "";
      await _speechToText.listen(
        onResult: (result) {
          lastWords.value = result.recognizedWords;
          if (result.finalResult) {
            _processCommand(result.recognizedWords);
          }
        },
      );
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    isListening.value = false;
  }

  void toggleAlwaysListening() {
    isAlwaysListening.value = !isAlwaysListening.value;
    if (isAlwaysListening.value && !isListening.value) {
      startListening();
    }
  }

  void _processCommand(String command) {
    commandHistory.insert(0, command);
    if (commandHistory.length > 20) commandHistory.removeLast();

    String cmd = command.toLowerCase();

    if (cmd.contains("open whatsapp")) {
      _respond("Opening WhatsApp for you.");
    } else if (cmd.contains("open telegram")) {
      _respond("Opening Telegram.");
    } else if (cmd.contains("open browser") || cmd.contains("open google")) {
      _respond("Opening your web browser.");
    } else if (cmd.contains("call")) {
      String contact = cmd.split("call").last.trim();
      _respond("Initiating a call to $contact.");
    } else if (cmd.contains("send message")) {
      String contact = cmd.contains("to")
          ? cmd.split("to").last.trim()
          : "someone";
      _respond("Opening message composer for $contact.");
    } else if (cmd.contains("balance") ||
        cmd.contains("transaction") ||
        cmd.contains("check my money")) {
      _respond(
        "Your current wallet balance is \$2,450.75 across all accounts.",
      );
    } else if (cmd.contains("alarm") || cmd.contains("reminder")) {
      _respond("I've added that to your reminders for today.");
    } else if (cmd.contains("time") || cmd.contains("what time")) {
      _respond(
        "The current time is ${DateTime.now().hour}:${DateTime.now().minute}.",
      );
    } else if (cmd.contains("date")) {
      _respond(
        "Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}.",
      );
    } else if (cmd.contains("thank you") || cmd.contains("thanks")) {
      _respond("You're very welcome! Is there anything else I can help with?");
    } else {
      _respond(
        "I heard you say: '$command'. I'm still learning how to handle that specific request.",
      );
    }
  }

  Future<void> _respond(String text) async {
    responseText.value = text;
    await _flutterTts.speak(text);
  }

  void speak(String text) async {
    await _flutterTts.speak(text);
  }
}
