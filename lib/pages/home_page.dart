import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/core/theme/app_palette.dart';
import 'package:voice_assistant/services/open_ai_service.dart';
import 'package:voice_assistant/widgets/feature_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  bool speechEnabled = false;
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: BounceInDown(
          child: const Text(
            'Lexa',
            style: TextStyle(fontFamily: 'Cera Pro', fontSize: 24),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                        color: AppPallete.assistantCircleColor,
                        shape: BoxShape.circle),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/virtualAssistant.png'))),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FadeInRight(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: AppPallete.borderColor),
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topLeft: const Radius.circular(0))),
                child: Text(
                  generatedContent == null
                      ? 'Good morning, what can I do for you ?'
                      : generatedContent!,
                  style: const TextStyle(
                      fontSize: 24,
                      color: AppPallete.mainFontColor,
                      fontFamily: 'Cera Pro'),
                ),
              ),
            ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Here are few features',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Cera Pro',
                        color: AppPallete.mainFontColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null,
                child: const Column(
                  children: [
                    FeatureBox(
                        headerText: 'ChatGPT',
                        descriptionText:
                            'A smarter way to stay organized and informed with ChatGPT. ',
                        color: AppPallete.firstSuggestionBoxColor),
                    FeatureBox(
                        headerText: 'Dall-E',
                        descriptionText:
                            'Get inspired and stay creative with your personal assistant powered by Dall-E.',
                        color: AppPallete.secondSuggestionBoxColor),
                    FeatureBox(
                        headerText: 'Smart Voice Assistant',
                        descriptionText:
                            'Get the best of  both worlds with a voice assistant powered by Dall-E and ChatGPT. ',
                        color: AppPallete.thirdSuggestionBoxColor),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            startListening();
          } else if (speechToText.isListening) {
            log(lastWords);
            final speech = await openAIService.chatGPTAPI(lastWords);
            log(speech);
            generatedContent = speech;
            setState(() {});
            await systemSpeak(speech);
            stopListening();
          } else {
            initSpeechToText();
          }
        },
        backgroundColor: AppPallete.firstSuggestionBoxColor,
        child: speechToText.isListening
            ? const Icon(Icons.stop)
            : const Icon(Icons.mic),
      ),
    );
  }
}
