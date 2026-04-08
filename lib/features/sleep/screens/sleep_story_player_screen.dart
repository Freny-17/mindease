import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart'; // Import Translator
import '../models/sleep_story.dart';

class SleepStoryPlayerScreen extends StatefulWidget {
  final SleepStory story;

  const SleepStoryPlayerScreen({super.key, required this.story});

  @override
  State<SleepStoryPlayerScreen> createState() => _SleepStoryPlayerScreenState();
}

class _SleepStoryPlayerScreenState extends State<SleepStoryPlayerScreen> {
  late PageController _pageController;
  late FlutterTts _flutterTts;
  final translator = GoogleTranslator(); // Initialize Translator

  List<String> pages = [];
  int currentPage = 0;

  String _selectedLanguage = 'en';
  String _storyText = "";
  bool _isPlaying = false;
  bool _isTranslating = false; // Keep track of loading state

  @override
  void initState() {
    super.initState();
    _storyText = widget.story.text;
    _preparePages();
    _loadBookmark();
    _initTts();
  }

  // --- TTS LOGIC ---
  void _initTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setPitch(0.9);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      await _flutterTts.speak(pages[currentPage]);
    }
  }

  // --- LANGUAGE & TRANSLATION LOGIC ---
  Future<void> _changeLanguage(String langCode) async {
    if (_isPlaying) {
      await _flutterTts.stop();
      _isPlaying = false;
    }

    setState(() {
      _selectedLanguage = langCode;
      _isTranslating = true; // Show loading spinner
      pages.clear();
    });

    // 1. Set Voice Language (Don't await, so it doesn't freeze!)
    if (langCode == 'hi') {
      _flutterTts.setLanguage("hi-IN");
    } else if (langCode == 'gu') {
      _flutterTts.setLanguage("gu-IN");
    } else {
      _flutterTts.setLanguage("en-US");
    }

    try {
      // 2. ALWAYS load the English file first
      String baseEnglishText = await rootBundle.loadString("assets/stories/${widget.story.id}.txt");

      // 3. Translate if necessary
      if (langCode == 'en') {
        _storyText = baseEnglishText;
      } else {
        // Send to Google Translate
        var translation = await translator.translate(baseEnglishText, from: 'en', to: langCode);
        _storyText = translation.text;
      }

      setState(() {
        _preparePages();
        _isTranslating = false; // Hide loading spinner
      });

    } catch (e) {
      debugPrint("Error loading or translating: $e");
      setState(() {
        _storyText = "Could not translate. Please check your internet connection.";
        _preparePages();
        _isTranslating = false;
      });
    }
  }

  // --- PAGINATION LOGIC ---
  void _preparePages() {
    pages.clear();
    const wordsPerPage = 140;
    final words = _storyText.split(RegExp(r'\s+'));

    for (int i = 0; i < words.length; i += wordsPerPage) {
      pages.add(words.skip(i).take(wordsPerPage).join(" "));
    }
  }

  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    int savedPage = prefs.getInt("bookmark_${widget.story.id}") ?? 0;

    if (savedPage >= pages.length) savedPage = 0;

    _pageController = PageController(initialPage: savedPage);
    setState(() {
      currentPage = savedPage;
    });
  }

  Future<void> _saveBookmark(int page) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("bookmark_${widget.story.id}", page);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            icon: const Icon(Icons.language, color: Colors.white),
            dropdownColor: theme.colorScheme.surface,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'en', child: Text(" English")),
              DropdownMenuItem(value: 'hi', child: Text(" हिन्दी")),
              DropdownMenuItem(value: 'gu', child: Text(" ગુજરાતી")),
            ],
            onChanged: (value) {
              if (value != null && value != _selectedLanguage) {
                _changeLanguage(value);
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),

      floatingActionButton: _isTranslating ? null : FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: _playPauseAudio,
        child: Icon(
          _isPlaying ? Icons.pause : Icons.volume_up,
          color: Colors.white,
        ),
      ),

      body: _isTranslating || pages.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Translating story..."),
          ],
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Page ${currentPage + 1} / ${pages.length}",
              style: theme.textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                if (_isPlaying) {
                  _flutterTts.stop();
                  setState(() => _isPlaying = false);
                }
                setState(() {
                  currentPage = page;
                });
                _saveBookmark(page);
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      pages[index],
                      textAlign: TextAlign.justify,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        height: 1.9,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}