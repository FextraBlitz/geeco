import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geeco/bax_end/evaluation_bax_end.dart';
import 'package:geeco/modules/globalbottomnav.dart';
import 'package:geeco/pages/editor.dart';

class Evaluation extends StatefulWidget {
  List<String> images;

  Evaluation({super.key, required this.images});

  @override
  State<Evaluation> createState() => _EvaluationState();
}

bool loading = true;
AIEvaluation evaluation = AIEvaluation(
  "0",
  8,
  "Humans cool",
  9,
  "Env Cool",
  6,
  "anim Cool",
  8,
  "overall cool",
  ["Monk", "Monk", "Monk"],
  ["1. Yes", "2. Yesser"]
);

class _EvaluationState extends State<Evaluation> with SingleTickerProviderStateMixin{
  late AnimationController control;
  late Animation<double> slideUp;
  Color human_color = Colors.white;
  Color env_color = Colors.white;
  Color anim_color = Colors.white;
  Color overall_color = Colors.white;
  List<Color> scoreRanges = [Colors.red.shade900, Colors.red, Colors.deepOrange, Colors.orange.shade700, const Color.fromARGB(255, 218, 169, 5), const Color.fromARGB(255, 209, 202, 11), Colors.lime.shade700, Colors.lightGreen.shade600, Color(0xFF83BF4F), Color.fromARGB(255, 93, 195, 3)];

  Future<void> evaluationCall() async {
    if(loading == true) {
      classifyImgs(widget.images, true).then((String response) {
        AIEvaluation eval = parse_response(response);
        setState(() {
          evaluation = eval;
          loading = false;
        });
      });
    }
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

  @override
  Widget build(BuildContext context) {
    if(evaluation.success_code == 0) {
      human_color = scoreRanges[evaluation.human_score!-1];
      env_color = scoreRanges[evaluation.env_score!-1];
      anim_color = scoreRanges[evaluation.anim_score!-1];
      overall_color = scoreRanges[evaluation.overall_score!-1];
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/evaluation_bg.png"),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color(0xFF022000),
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(
        //       Icons.keyboard_backspace_outlined,
        //       color: Colors.white
        //     )
        //   )
        // ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(loading == true) const CircularProgressIndicator(
                  color: Color(0xFF83BF4F),
                  strokeWidth: 9,
                ) 
                else Column(
                  children: [
                  if(evaluation.success_code == -1)
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            offset:Offset(3, 3),
                            blurRadius: 3,
                            spreadRadius: 3
                          ),
                        ]
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text("ERROR: PICTURES TOO BLURRY")
                      )
                    )
                  else if(evaluation.success_code == -2)
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            offset:Offset(3, 3),
                            blurRadius: 3,
                            spreadRadius: 3
                          ),
                        ]
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text("ERROR: PICTURES DONT SHOW ENVIRONMENTAL ASPECTS")
                      )
                    )
                  else if(evaluation.success_code == -3)
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            offset:Offset(3, 3),
                            blurRadius: 3,
                            spreadRadius: 3
                          ),
                        ]
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text("ERROR: ANALYZE FAILED")
                      )
                    )
                  else
                    Column(
                      children: [
                        Scrollbar(
                          scrollbarOrientation: ScrollbarOrientation.bottom,
                          child: Container(
                            height:240,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.images.length,
                              itemBuilder: 
                                (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Stack(
                                      children: [
                                        Image.file(File(widget.images[index]),
                                          height: 200,
                                          width: 120,
                                          fit: BoxFit.cover
                                        ),
                                      ]
                                    ),
                                  );
                                }
                            )
                          )
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          height: 400,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadiusGeometry.directional(
                              topStart: Radius.circular(30),
                              topEnd: Radius.circular(30)
                            ),
                            border:BoxBorder.all(
                              color: Theme.of(context).colorScheme.shadow,
                              width: 1.0
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:Theme.of(context).colorScheme.shadow,
                                blurRadius: 4,
                                spreadRadius: 4,
                                offset: Offset.zero,
                                blurStyle: BlurStyle.normal
                              )
                            ]
                          ),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 20, 0),
                            child: Scrollbar(
                              scrollbarOrientation: ScrollbarOrientation.right,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 27,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      spacing: 11,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: human_color,
                                                offset: Offset.zero,
                                                blurRadius: 4,
                                                spreadRadius: 5
                                              )
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage("assets/images/human_health_icon.png"),
                                              
                                            )
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "HUMAN HEALTH SCORE",
                                              style: TextStyle(
                                                color: human_color,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic
                                              ),
                                            ),
                                            SizedBox(
                                              width: 240,
                                              child: LinearProgressIndicator(
                                                minHeight: 17,
                                                value: (evaluation.human_score!/10).toDouble(),
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                                color: human_color
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${evaluation.human_score}",
                                          style: TextStyle(
                                            color: human_color,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            height: 0.8
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: 11,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: env_color,
                                                offset: Offset.zero,
                                                blurRadius: 4,
                                                spreadRadius: 5
                                              )
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage("assets/images/env_health_icon.png"),
                                              
                                            )
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "ENVIRONMENTAL HEALTH SCORE",
                                              style: TextStyle(
                                                color: env_color,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 240,
                                              child: LinearProgressIndicator(
                                                minHeight: 17,
                                                value: (evaluation.env_score!/10).toDouble(),
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                                color: env_color
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${evaluation.env_score}",
                                          style: TextStyle(
                                            color: human_color,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            height: 0.8
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: 11,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: anim_color,
                                                offset: Offset.zero,
                                                blurRadius: 4,
                                                spreadRadius: 5
                                              )
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage("assets/images/animal_health_icon.png"),
                                            )
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "ANIMAL HEALTH SCORE",
                                              style: TextStyle(
                                                color: anim_color,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic
                                              ),
                                            ),
                                            SizedBox(
                                              width: 240,
                                              child: LinearProgressIndicator(
                                                minHeight: 17,
                                                value: (evaluation.anim_score!/10).toDouble(),
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                                color: anim_color
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${evaluation.anim_score}",
                                          style: TextStyle(
                                            color: human_color,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            height: 0.8
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(11),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.shadow,
                                            offset:Offset(3, 3),
                                            blurRadius: 3,
                                            spreadRadius: 3
                                          ),
                                        ]
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          "${evaluation.human_eval}",
                                          style: TextStyle(
                                            fontSize: 10
                                          )
                                        ),
                                      )
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(11),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.shadow,
                                            offset:Offset(3, 3),
                                            blurRadius: 3,
                                            spreadRadius: 3
                                          ),
                                        ]
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          "${evaluation.env_eval}",
                                          style: TextStyle(
                                            fontSize: 10
                                          )
                                        ),
                                      )
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(11),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.shadow,
                                            offset:Offset(3, 3),
                                            blurRadius: 3,
                                            spreadRadius: 3
                                          ),
                                        ]
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          "${evaluation.anim_eval}",
                                          style: TextStyle(
                                            fontSize: 10
                                          )
                                        ),
                                      )
                                    ),
                                    Text(
                                      "${evaluation.overall_score}",
                                      style: TextStyle(
                                        color: overall_color,
                                        fontSize: 70,
                                        fontWeight: FontWeight.bold,
                                        height: 0.7,
                                      ),
                                    ),
                                    Text(
                                      "OVERALL SCORE",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        height: 0.7,
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/images/one_health_icon.png"),
                                        )
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(11),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.shadow,
                                            offset:Offset(3, 3),
                                            blurRadius: 3,
                                            spreadRadius: 3
                                          ),
                                        ]
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          "${evaluation.overall_eval}",
                                          style: TextStyle(
                                            fontSize: 10
                                          )
                                        ),
                                      )
                                    ),
                                    Text(
                                      "ANIMALS THAT CAN INHABIT THE AREA",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        height: 0.7,
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(11),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.shadow,
                                            offset:Offset(3, 3),
                                            blurRadius: 3,
                                            spreadRadius: 3
                                          ),
                                        ]
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for(String animal in evaluation.anim_list!) Text(animal)
                                          ],
                                        )
                                      )
                                    ),
                                    Text(
                                      "RECOMMENDATIONS",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        height: 0.7,
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(11),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.shadow,
                                            offset:Offset(3, 3),
                                            blurRadius: 3,
                                            spreadRadius: 3
                                          ),
                                        ]
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for(String reco in evaluation.reco_list!)
                                              Text(
                                                reco,
                                                style: TextStyle(
                                                  fontSize: 12
                                                ),
                                              )
                                          ],
                                        )
                                      )
                                    ),
                                    Text(
                                      "IMPROVE YOUR AREA WITH THE DIGITAL HABITAT BUILDER",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        height: 0.7,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.grass),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        BottomNavigationBar navBar = navbarKey.currentWidget as BottomNavigationBar;
                                        navBar.onTap!(2);
                                      }, 
                                      label: Text("Proceed")
                                    ),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.camera),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }, 
                                      label: Text("Try Again")
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ),
                      ]
                    )
                  ],
                ),
              ],
            ),
          )
        )
      ),
    );
  }
}