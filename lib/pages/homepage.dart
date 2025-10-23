import 'package:flutter/material.dart';
import 'package:geeco/pages/evaluation.dart';
import 'package:scaled_size/scaled_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> history = [];

  Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic data = prefs.get("History");
    if(data == null) {
      prefs.setStringList("History", []);
    } else {
      setState(() {
        history = prefs.get("History") as List<String>;
      });
    }
    print("History: ${history}");
  }

  Future <void> deleteEvaluation(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic data = prefs.get("History");
    if(data != null) {
      setState(() {
        history.removeAt(index);
        prefs.setStringList("History", history);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return ScaledSize(
      size: Size(ScaledSizeUtil.screenWidth, ScaledSizeUtil.screenHeight),
      builder: () {
        return Container(
          constraints: BoxConstraints.expand(),
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     opacity: 0.2,
          //     image: AssetImage('assets/images/homepage_bg.png'),
          //     fit: BoxFit.contain
          //   )
          // ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: ScaledSizeUtil.screenHeight * 0.20,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.2,
                  child: Center(
                    child: Image.asset(
                      'assets/images/homepage_bg.png',
                      width: ScaledSizeUtil.screenWidth * 0.8,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: ScaledSizeUtil.screenWidth * 0.8,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: history.isEmpty
                    ? Text(
                        "No evaluations to show. Scan or Edit to get started!",
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 1.25.rem,
                          fontFamily: "Gabarito",
                        ),
                      )
                    : Container(
                      width: 350,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(139, 139, 139, 139),
                        borderRadius: BorderRadius.circular(11)
                      ),
                      child: 
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(11),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 15,
                              children: [
                                for(int i = 0; i < history.length; i++)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (context) =>
                                                Evaluation(images: [""], habitat: null, viewMode: true, index: i)
                                            )
                                          ),
                                          child: Container(
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(210, 210, 210, 210),
                                              borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsGeometry.symmetric(vertical: 10.0, horizontal: 15.0),
                                              child: Row(
                                                spacing: 15,
                                                children: [
                                                  Container(
                                                    width: 65,
                                                    height: 65,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(65)
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        history[i].substring(0, 1),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Gabarito",
                                                          fontSize: 2.8.rem
                                                        ),
                                                      ),
                                                    )
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Evaluation#${i+1}",
                                                        style: TextStyle(
                                                          fontFamily: "Gabarito",
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 1.7.rem
                                                        ),
                                                      ),
                                                      Text(
                                                        "${history[i].substring(2, 5)}...",
                                                        style: TextStyle(
                                                          fontFamily: "Gabarito",
                                                          fontSize: 1.1.rem,
                                                          fontStyle: FontStyle.italic
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context, 
                                            builder: (BuildContext context) {
                                              return SimpleDialog(
                                                title: Text("Are you sure you want to remove Evaluation#${i+1}?"),
                                                children: [
                                                  SimpleDialogOption(
                                                    onPressed: () {
                                                      deleteEvaluation(i);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                        color:Colors.red
                                                      ),
                                                    )
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel")
                                                  )
                                                ],
                                              );
                                            }
                                          );
                                        }, 
                                        iconSize: 1.5.rem,
                                        icon: Icon(Icons.close)
                                      )
                                    ],
                                  )
                              ],
                            ),
                          )
                        ),
                    
                    )
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
