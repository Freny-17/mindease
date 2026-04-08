import 'dart:convert';

import 'package:http/http.dart' as http;



class InnerGuideService {


// 🔑 Paste your GROQ API key here





  final String systemPrompt = """

You are a calm and supportive mental wellness assistant designed to help students and young adults think clearly during stressful situations.



Follow these rules strictly:



Keep responses short and easy to read.

Use simple bullet points using the symbol •

Do not use markdown formatting.

Do not use symbols like ** ### or any headings formatting.

Do not add extra headings beyond the structure below.



Always respond using this structure:



Logical Explanation:

• Give 1 or 2 short logical points.



Reality Check:

• Separate facts from assumptions in 1 or 2 points.



Calm Guidance:

• Give 2 or 3 short helpful suggestions.



Tone rules:

Stay calm, supportive, and non-judgmental.

Avoid sounding like a therapist.

Avoid long paragraphs.

""";



  Future<String> getResponse(String message) async {



    try {



      final response = await http.post(

        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),

        headers: {

          "Content-Type": "application/json",

          "Authorization": "Bearer "

        },

        body: jsonEncode({

          "model": "llama-3.1-8b-instant",

          "messages": [

            {

              "role": "system",

              "content": systemPrompt

            },

            {

              "role": "user",

              "content": message

            }

          ],

          "temperature": 0.7,

          "max_tokens": 500

        }),

      );



// Debug logs

      print("STATUS: ${response.statusCode}");

      print("BODY: ${response.body}");



      if (response.statusCode == 200) {



        final data = jsonDecode(response.body);



        return data["choices"][0]["message"]["content"];



      } else {



        return "AI service error.";



      }



    } catch (e) {



      print(e);



      return "Connection problem. Please check internet.";



    }

  }

}