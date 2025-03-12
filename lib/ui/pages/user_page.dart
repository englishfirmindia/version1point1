import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final String apiKey =
      "AIzaSyAUXQQU3pYLkq7X5x5qSC0VlFIIRvxMYV0"; // Replace with your Gemini API key

  // Speech to Text variables
  late stt.SpeechToText _speech;
  bool _isListening = false;

  // Language selection
  String _selectedLanguage = 'en-US'; // Default to English
  final Map<String, String> _languageLocales = {
    'English': 'en-US',
    'Hindi': 'hi-IN',
    'Punjabi': 'pa-IN',
    'Arabic': 'ar-SA',
    'Nepali': 'ne-NP',
    'Malayalam': 'ml-IN',
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final timestamp = DateTime.now();

      final messageData = {
        "text": message,
        "isUser": true,
        "userId": user?.uid,
        "userEmail": user?.email,
        "timestamp": timestamp,
        "language": _selectedLanguage, // Store the language for reference
      };

      try {
        await FirebaseFirestore.instance
            .collection('chat_messages')
            .add(messageData);
        setState(() {
          _messages.add(messageData);
        });

        _messageController.clear();

        String botResponse = await _getAIResponse(message);
        final botMessageData = {
          "text": botResponse,
          "isUser": false,
          "userId": user?.uid,
          "userEmail": user?.email,
          "timestamp": DateTime.now(),
          "language": _selectedLanguage,
        };

        await FirebaseFirestore.instance
            .collection('chat_messages')
            .add(botMessageData);
        setState(() {
          _messages.add(botMessageData);
        });
      } catch (e) {
        Fluttertoast.showToast(msg: "Failed to save message: $e");
      }
    }
  }

  Future<String> _getAIResponse(String userInput) async {
    final String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

    // Adjust the prompt to include the language context
    String languageName = _languageLocales.keys.firstWhere(
      (k) => _languageLocales[k] == _selectedLanguage,
      orElse: () => 'English',
    );

    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "You are an AI assistant created by the Englishfirm AI team to help students prepare for the PTE exam. "
                  "Your responses should be clear, concise, and relevant to PTE-related topics. "
                  "The student's query is in $languageName (locale: $_selectedLanguage). "
                  "If a question is unrelated to the PTE exam, respond with: 'I am designed to answer PTE-related questions only.' "
                  "\n\nStudent's query:\n\n$userInput",
            },
          ],
        },
      ],
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse =
            data["candidates"][0]["content"]["parts"][0]["text"];
        return aiResponse;
      } else {
        return "Sorry, I couldn't process your request.";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: "Logged out successfully!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Logout failed: ${e.toString()}");
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: _selectedLanguage, // Use the selected language locale
          onResult:
              (val) => setState(() {
                _messageController.text = val.recognizedWords;
                if (val.finalResult) {
                  _isListening = false;
                  _sendMessage();
                }
              }),
        );
      } else {
        Fluttertoast.showToast(msg: "Speech recognition not available");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Englishfirm AI Assistant',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 218, 213, 227),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            icon: Icon(Icons.language, color: Colors.white),
            dropdownColor: Colors.deepPurple,
            style: TextStyle(color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
            },
            items:
                _languageLocales.entries.map<DropdownMenuItem<String>>((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(
                      entry.key,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment:
                      message["isUser"]
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color:
                          message["isUser"]
                              ? Colors.deepPurpleAccent
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      message["text"],
                      style: TextStyle(
                        color: message["isUser"] ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _getHintText(_selectedLanguage),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.send, color: Colors.white),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _listen,
                  backgroundColor:
                      _isListening ? Colors.red : Colors.deepPurple,
                  child: Icon(
                    _isListening ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  // Localized hint text for the TextField
  String _getHintText(String locale) {
    switch (locale) {
      case 'hi-IN':
        return 'संदेश टाइप करें...';
      case 'pa-IN':
        return 'ਸੁਨੇਹਾ ਟਾਈਪ ਕਰੋ...';
      case 'ar-SA':
        return 'اكتب رسالة...';
      case 'ne-NP':
        return 'सन्देश टाइप गर्नुहोस्...';
      case 'ml-IN':
        return 'സന്ദേശം ടൈപ്പ് ചെയ്യുക...';
      case 'en-US':
      default:
        return 'Type a message...';
    }
  }
}
