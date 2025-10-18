import 'dart:convert';
import 'dart:io';
import 'package:geeco/bax_end/env_bax_end.dart';
import 'package:http/http.dart' as http;

class AIEvaluation {
  int success_code = 0;
  int? human_score;
  String? human_eval;
  int? env_score;
  String? env_eval;
  int? anim_score;
  String? anim_eval;
  int? overall_score;
  String? overall_eval;
  List<String>? anim_list;
  List<String>? reco_list;
  
  AIEvaluation(String error, [int? human_score, String? human_eval, int? env_score, String? env_eval, int? anim_score, String? anim_eval, int? overall_score, String? overall_eval, List<String>? anim_list, List<String>? reco_list]) {
    success_code = int.parse(error);
    if(success_code == 0) {
      this.human_score = human_score;
      this.human_eval = human_eval;
      this.env_score = env_score;
      this.env_eval = env_eval;
      this.anim_score = anim_score;
      this.anim_eval = anim_eval;
      this.overall_score = overall_score;
      this.overall_eval = overall_eval;
      this.anim_list = anim_list;
      this.reco_list = reco_list;
    }
  }
}

Future<String> classifyImgs(List<String> imgPaths, bool isPhoto) async {
    final String claudeUrl = Env.url;
    final String APIkey = Env.apiKey;
    String prompt = "";
    if(isPhoto) { prompt = "Before proceeding to the questions below, answer this: #1 Are the pictures clear enough to assess the environmental aspects of the area? If no, stop reading, and type -1 with no explanation of any kind. If only one or two pictures are blurry then go answer the questions below this paragraph and NEVER mention the blurry images when you're gonna answer. If all pictures are all good and clear, ignore this question and proceed to the other questions below and just type those answers instead. If any of the pictures don't show outdoor nature and environmental aspects, type -2 with no explanation of any kind and stop reading this prompt. Before answering, NEVER say anything that doesn't align with any of the questions below. Based on the three pictures, Answer these questions with NO titles: #1 Pick a number from 1 to 10 that will serve as your \"human health\" score, with no explanation, just the number. #2 Explain why that's the \"human health\" score BRIEFLY but MEANINGFUL #3 Pick a number from 1 to 10 that will serve as your \"environmental health\" score, with no explanation, just the number. #4 Explain why that's the \"environmental health\" score BRIEFLY but MEANINGFUL #5 Pick a number from 1 to 10 that will serve as your \"animal health\" score, with no explanation, just the number. #6 Explain why that's the \"animal health\" score BRIEFLY but MEANINGFUL #7 Pick a number from 1 to 10 that will serve as your overall score, with no explanation, just the number. #8 Explain why that's your overall score BRIEFLY but MEANINGFUL #9 Give a list of animals that can inhabit the area with no explanation, and the max animals of the list is 10. #10 Give recommendations to improve the area but only include 3 meaningful and impactful recommendations"; }
    else { prompt = ""; } //! DONT FORGET ABOUT DIGITAL HABITAT EVALUATION PROMPT
    //API post request
    var images = [];
    for(var path in imgPaths) {
      images.add(base64Encode(File(path).readAsBytesSync()));
    }
    final response = await http.post(
      Uri.parse(claudeUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': APIkey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-opus-4-1-20250805',
        'max_tokens': 5000,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type':'image',
                'source': {
                  'type': 'base64',
                  'media_type': 'image/jpeg',
                  'data': images[0],
                },
              },
              {
                'type':'image',
                'source': {
                  'type': 'base64',
                  'media_type': 'image/jpeg',
                  'data': images[1],
                },
              },
              {
                'type':'image',
                'source': {
                  'type': 'base64',
                  'media_type': 'image/jpeg',
                  'data': images[2],
                },
              },
              {
                'type':'text',
                'text': prompt
              }
            ]
          }
        ]
      }),
    );

    if(response.statusCode == 200) {
      final answer = jsonDecode(response.body);
      return answer['content'][0]['text'];
    }

    //Error Status:
    return "-3\n\nError ${response.statusCode}. Failed to analyze the image taken (${response.body})";
  }

AIEvaluation parse_response(String answer) {
  print(answer.replaceAll("\n", r"\n"));
  final String main_split = "\n\n";
  //final String test = "-1";
  final List<String> ans_array = answer.split(main_split);
  switch(ans_array[0]) {
    case "-1":
      return new AIEvaluation(ans_array[0]);
    case "-2":
      return new AIEvaluation(ans_array[0]);
    default:
      return new AIEvaluation("0", int.parse(ans_array[0]), ans_array[1], int.parse(ans_array[2]), ans_array[3], int.parse(ans_array[4]), ans_array[5], int.parse(ans_array[6]), ans_array[7], ans_array[8].split(", "), ans_array.sublist(9, 11));
  }
}
