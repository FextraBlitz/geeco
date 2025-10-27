import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geeco/bax_end/evaluation_bax_end.dart';
import 'package:geeco/modules/globalbottomnav.dart';
// import 'package:geeco/pages/editor.dart';
import 'package:scaled_size/scaled_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> exportedImages = [];

class Evaluation extends StatefulWidget {
  final List<String> images;
  final dynamic habitat;
  final bool viewMode;
  final int index;

  const Evaluation({super.key, required this.images, this.habitat, this.viewMode = false, this.index = 0});

  @override
  State<Evaluation> createState() => _EvaluationState();
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

bool loading = true;
AIEvaluation evaluation = AIEvaluation(
  "-2",
  8,
  "Humans cool",
  9,
  "Env Cool",
  6,
  "anim Cool",
  8,
  "overall cool",
  ["Monk", "Monk", "Monk", ],
  ["1. Yes", "2. Yesser"]
);

late Color backgroundColor;

class _EvaluationState extends State<Evaluation> with SingleTickerProviderStateMixin{
  late AnimationController control;
  late Animation<double> slideUp;
  Color humanColor = Colors.white;
  Color envColor = Colors.white;
  Color animColor = Colors.white;
  Color overallColor = Colors.white;
  List<Color> scoreRanges = [Colors.red.shade900, Colors.red, Colors.deepOrange, Colors.orange.shade700, const Color.fromARGB(255, 218, 169, 5), const Color.fromARGB(255, 209, 202, 11), Colors.lime.shade700, Colors.lightGreen.shade600, Color(0xFF83BF4F), Color.fromARGB(255, 93, 195, 3)];

  Future<void> evaluationCall() async {
    if(loading == true) {
      // if(widget.habitat == null && widget.viewMode == false) {
      //   classifyImgs(widget.images, true).then((String response) {
      //     AIEvaluation eval = parse_response(response);
      //     saveEvaluation(response);
      //     setState(() {
      //       evaluation = eval;
      //       loading = false;
      //     });
      //   });
      // } else if(widget.viewMode == true) {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   List<String> data = prefs.get("History") as List<String>;
      //   String imageData = prefs.get("Images${widget.index}") as String;
      //   List<String> imageDataList = imageData.split("evalpic");
      //   setState(() {
      //     for(String imgData in imageDataList) widget.images.add(imgData);
      //     evaluation = parse_response(data[widget.index]);
      //     loading = false;
      //   });
      // } else if(widget.habitat != null && widget.viewMode == false) {
      //   classifyImgs(widget.images, false, widget.habitat).then((String response) {
      //     print(response);
      //     AIEvaluation eval = parse_response(response);
      //     saveEvaluation(response);
      //     setState(() {
      //       evaluation = eval;
      //       loading = false;
      //     });
      //   });
      // }
      // if(widget.viewMode == false) saveEvaluation("8\nyes\n9\nyes\n9\nyes\n10\nyes\nmonkey, animals, birds\n1.yes\n2.yes");
      // else {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   List<String> data = prefs.get("History") as List<String>;
      //   List<String> imageData = prefs.get("Images${widget.index}") as List<String>;
      //   setState(() {
      //     widget.images = imageData;
      //     evaluation = parse_response(data[widget.index]);
      //   });
      // }
    }
  }

  Future<void> saveEvaluation(String response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic data = prefs.get("History");
    List<String> images = [];
    for(String image in widget.images) {
      images.add(base64Encode(File(image).readAsBytesSync()));
    }
    print("bax this is ${images.length}");
    List<String> history = [];
    if(data != null) history = data as List<String>;
    history.add(response);
    int index = history.indexOf(response);
    setState(() {
      print("Eval History: $history");
      prefs.setStringList("History", history);
      prefs.setStringList("Images$index", images);
    });
  }

  final int maxScore = 10;
  Color getScoreColor(int score) {
    print("color1 ${Colors.red.shade900} ${Color.fromARGB(255, 93, 195, 3)}");
    HSVColor color1 = HSVColor.fromAHSV(1.0, 0, .85, 0.72);// (120/maxScore)*score;
    HSVColor color2 = HSVColor.fromAHSV(1.0, 92, 1.0, 0.765);
    HSVColor lerpColor = HSVColor.lerp(color1, color2, score/maxScore)!;
    print("color $score $lerpColor");
    return lerpColor.toColor();
  }
  late Map<String, int?> categoryScore;
  late Map<String, String?> categoryEvaluation;
  Widget buildFeatureScoreSlider(String category) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage("assets/images/score_icons/$category.png"),
              )
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${category.toUpperCase()} HEALTH SCORE",
                style: TextStyle(
                  color: getScoreColor(categoryScore[category]!),
                  fontSize: 0.7.rem,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  minHeight: 17,
                  value: (categoryScore[category]!/10).toDouble(),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: getScoreColor(categoryScore[category]!),
                  backgroundColor: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
          Text(
            categoryScore[category].toString(),
            style: TextStyle(
              color: getScoreColor(categoryScore[category]!),
              fontSize: 1.5.rem,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              height: 0.8
            ),
          ),
          SizedBox(
            width: 0,
          ),
        ],
      ),
    );
  }

  

  Widget buildReviewContainer(String category, int index) {
    Widget icon = Flexible(
      flex: 35,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, .0, 8.0, 0.0),
        child: Image.asset("assets/images/score_icons/$category.png"),
      )
    );

    Widget textArea = Flexible(
      flex: 65,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*.05,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: RichText(
                  text:TextSpan(
                    children: [
                      TextSpan(
                        text: "${category.capitalize()} Factor: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: "Gabarito",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${categoryScore[category]}",
                        style: TextStyle(
                          color: getScoreColor(categoryScore[category]!),
                          fontSize: 24,
                          fontFamily: "Gabarito",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    ]
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "       ${categoryEvaluation[category]} Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Gabarito",
                color: Colors.white
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );

    List<Widget> layout = [
      icon,
      // VerticalDivider(indent: 32.0, endIndent: 32.0, width: 24, thickness: 2.0, color: Colors.grey.withAlpha(32), ),
      textArea,
    ];

    if (index % 2 == 1) {
      layout = layout.reversed.toList();
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: layout
        )
      ]
    );
  }

  Widget buildErrorScreen() {
    late String errorMessage;
    late String subMessage;
    if (evaluation.success_code == -1) {
      errorMessage = "ERROR: PICTURES TOO BLURRY";
      subMessage = "Please focus your camera when taking a picture";
    }

    if (evaluation.success_code == -2) {
      errorMessage = "ERROR: PICTURES DONT SHOW ENVIRONMENTAL ASPECTS";
      subMessage = "Take pictures of a natural environment";
    }

    if (evaluation.success_code == -3) {
      errorMessage = "ERROR: ANALYZE FAILED";
      subMessage = "Sorry, please try again...";
    }

    else {
      errorMessage = "UNDEFINED ERROR";
      subMessage = "Oh no... ¯\\_(ツ)_/¯";
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        Icon(Icons.warning_amber_rounded, size: 128.0,),
        FittedBox(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
              child: Text(errorMessage, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0, fontFamily: "Gabarito", color: Color(0xFF440000)),),
          )
        ),
        FittedBox(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
              child: Text(subMessage, style: TextStyle(fontSize: 16.0, fontFamily: "Gabarito", color: Color.fromARGB(255, 84, 72, 72)),),
          )
        ),
        
      ]
    );
  }
  Widget buildEvaluationResultsContent() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Center(
            child: FractionallySizedBox(
              heightFactor: 0.7,
              widthFactor: 1.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container (
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                          )
                        ]
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: () {
                        if(widget.habitat == null && widget.viewMode == false) {
                          return Image.file(
                            File(widget.images[index]),
                            height: 220,
                            width: 140,
                            fit: BoxFit.cover
                          );
                        }

                        if(widget.habitat != null) {
                          return Image.memory(
                            widget.habitat
                          );
                        }

                        if(widget.habitat == null && widget.viewMode == true && widget.images.length == 3) {
                          return Image.memory(
                            base64Decode(widget.images[index])
                          );
                        }
                      } ()
                    )
                  );
                }
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xCC022000),
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  color: Color(0xCC022000),
                    child: Center(
                      child: FittedBox(
                        child: Text("Evaluation", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: "Gabarito", letterSpacing: 1.6),)
                      ),
                    ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  spacing: 16,
                                  children: [
                                    buildFeatureScoreSlider("human"),
                                    buildFeatureScoreSlider("environmental"),
                                    buildFeatureScoreSlider("animal"),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/score_icons/shield.png"),
                                        colorFilter: ColorFilter.mode(getScoreColor(evaluation.overall_score!), BlendMode.srcATop),
                                      )
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        "${evaluation.overall_score}",
                                        style: TextStyle(
                                          fontSize: 128,
                                          fontWeight: FontWeight.bold,
                                          color: getScoreColor(evaluation.overall_score!)
                                        )
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "OVERALL SCORE",
                                    style: TextStyle(
                                      color: getScoreColor(evaluation.overall_score!),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        buildReviewContainer("human", 0),
                        buildReviewContainer("environmental", 1),
                        buildReviewContainer("animal", 2),
                        Divider(height: 4.0, indent: 4.0, endIndent: 4.0, color: Colors.grey.withAlpha(127),),
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height*.05,
                              child: Center(
                                child: Text(
                                  "OVERALL",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 201, 236, 178),
                                    fontFamily: "Gabarito",
                                    letterSpacing: 4.0,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color.fromARGB(255, 201, 236, 178),
                                    decorationThickness: 0.50
                                  ),
                                ),
                              )
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: SizedBox(width: 32,)
                                  ),
                                  TextSpan(
                                    text: "${evaluation.overall_eval} Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                  )
                                ]
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Gabarito",
                                color: Colors.white
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ]
                        ),
                        Divider(height: 4.0, indent: 4.0, endIndent: 4.0, color: Colors.grey.withAlpha(127),),
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height*.05,
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    "ANIMALS THAT CAN INHABIT THE AREA",
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 201, 236, 178),
                                      fontFamily: "Gabarito",
                                      letterSpacing: 1.0,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color.fromARGB(255, 201, 236, 178),
                                      decorationThickness: 0.50
                                    ),
                                  ),
                                ),
                              )
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "•${evaluation.anim_list!.join("  •")}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]
                        ),
                        Divider(height: 4.0, indent: 4.0, endIndent: 4.0, color: Colors.grey.withAlpha(127),),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height*.05,
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    "RECOMMENDATIONS",
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 201, 236, 178),
                                      fontFamily: "Gabarito",
                                      letterSpacing: 2.0,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color.fromARGB(255, 201, 236, 178),
                                      decorationThickness: 0.50
                                    ),
                                  ),
                                ),
                              )
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                evaluation.reco_list!.join("\n"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ]
                        ),
                        Divider(height: 4.0, indent: 4.0, endIndent: 4.0, color: Colors.grey.withAlpha(127),),
                        FittedBox(
                          child: Text(
                            widget.habitat != null
                            ? "TRY WITH ACTUAL PICTURES"
                            : "IMPROVE YOUR AREA WITH THE DIGITAL HABITAT BUILDER",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (widget.habitat == null) ElevatedButton.icon(
                          icon: Icon(Icons.grass),
                          onPressed: () {
                            Navigator.pop(context);
                            BottomNavigationBar navBar = navbarKey.currentWidget as BottomNavigationBar;
                            navBar.onTap!(2);
                            exportedImages = widget.images;
                          }, 
                          label: Text("Proceed"),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Color(0xFF83BF4F)),
                            foregroundColor: WidgetStateProperty.all(Colors.white)
                          )
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.camera),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: Text("Proceed to the Eco-Lens"),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Color(0xFF83BF4F)),
                            foregroundColor: WidgetStateProperty.all(Colors.white)
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    evaluationCall();
    // control = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this
    // );
    // slideUp = Tween<double>(begin: 400, end: 0).animate(control)..addListener(
    //   () {
    //     setState(() {
    //       if(y>0) y -= 10;
    //     });
    //   });
    // control.forward();
  }

  void initializeVariablesOnBuild() {
    // if(evaluation.success_code == 0) {
    //   humanColor = scoreRanges[evaluation.human_score!-1];
    //   envColor = scoreRanges[evaluation.env_score!-1];
    //   animColor = scoreRanges[evaluation.anim_score!-1];
    //   overallColor = scoreRanges[evaluation.overall_score!-1];
    // }

    categoryScore = {
      "human": evaluation.human_score,
      "environmental": evaluation.env_score,
      "animal": evaluation.anim_score,
    };

    categoryEvaluation = {
      "human": evaluation.human_eval,
      "environmental": evaluation.env_eval,
      "animal": evaluation.anim_eval,
    };

    evaluation.anim_list = ["Monkey", "Donkey", "Whake", "Zebra", "Octopus", "Ant", "Beaver", "Ostrich", "Stegosaurus", "Newts", "Lizards", ];
  
    evaluation.success_code = 0;
    evaluation.human_score = 1;
    evaluation.overall_score = 9;
    evaluation.success_code = 0;
  }

  @override
  Widget build(BuildContext context) {
    initializeVariablesOnBuild();
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "RESULTS",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Gabarito",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/homepage_bg.png"),
            fit: BoxFit.contain,
            opacity: 0.25
          ),
          color: backgroundColor,
        ),
        width: double.infinity,
        child: (() {
          if (loading == false) {
            return const CircularProgressIndicator(
              color: Color(0xFF83BF4F),
              strokeWidth: 9,
            );
          }

          else if (evaluation.success_code != 0) {
            backgroundColor = Color.fromARGB(255, 255, 226, 226);
            return buildErrorScreen();
          }
          else { 
            backgroundColor = Color(0x6683BF4F);
            return buildEvaluationResultsContent();
          }
        }) (),
      )
    );
  }
}