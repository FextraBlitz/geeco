import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geeco/pages/evaluation.dart';
import 'package:scaled_size/scaled_size.dart';
import 'package:geeco/bax_end/camera_bax_end.dart';
import 'package:image_picker/image_picker.dart';

class ScansPage extends StatefulWidget {
  const ScansPage({super.key});

  @override
  State<ScansPage> createState() => _ScansPageState();
}

class _ScansPageState extends State<ScansPage> {
  List<File> images = [];
  int imageCount = -1;
  String btnText = "Take a Photo";
  Icon btnIcon = Icon(Icons.camera, color:Colors.white);

  void cameraMode(ImageSource source) async {
    File? photo = await pickImage(source);
    if(photo != null) {
      setState(() {
        images.add(photo);
        imageCount = imageCount + 1;
        if(imageCount == 2) { 
          btnText = "Evaluate"; 
          btnIcon = Icon(Icons.document_scanner_outlined, color: Colors.white); 
        }
      });
    }
  }

  void removalDialog(int index) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Are you sure you want to remove this picture?"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  images.remove(images[index]);
                  imageCount -= 1;
                },);
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        if(images.isEmpty) 
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.rem),
            child: Text(
              "Take 3 photos of your area's environment to proceed with evaluation!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 139, 139, 139),
                fontSize: 1.0.rem,
                fontFamily: "Gabarito",
              )
            ),
          )
        else 
          Builder(
            builder: (context) {
              return Scrollbar(
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: Container(
                  height:250,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: 
                      (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              Image.file(images[index],
                                height: 200,
                                width: 120,
                                fit: BoxFit.cover
                              ),
                              IconButton(
                                onPressed: () {
                                  removalDialog(index);
                                }, 
                                icon: Icon(Icons.cancel),
                                color: Colors.white60,
                                splashColor: Colors.black,
                                splashRadius: 17,
                                iconSize: 35,
                              )
                            ]
                          ),
                        );
                      }
                  )
                )
              );
            }
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            Expanded(
              child: Padding(
                padding:EdgeInsetsGeometry.symmetric(horizontal: 2.0.rem, vertical: 0.5.rem),
                child:ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(captureButton),
                  ),
                  icon: btnIcon,
                  label: Text(btnText, style: TextStyle(color: Colors.white, fontFamily: "Gabarito")),
                  onPressed: () async {
                    if(imageCount < 2) cameraMode(ImageSource.camera);
                    else {
                      List<String> imagePaths = [];
                      imagePaths.add(images[0].path);
                      imagePaths.add(images[1].path);
                      imagePaths.add(images[2].path);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (context) => Evaluation(images: imagePaths))
                      );
                      setState(() {
                        images.remove(images[0]);
                        images.remove(images[0]);
                        images.remove(images[0]);
                        imageCount = -1;
                        btnText = "Take a Photo"; 
                        btnIcon = Icon(Icons.camera, color: Colors.white); 
                      });
                    }
                  },
                ),
              ),
            ),]
          ),
          if(imageCount < 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            Expanded(
              child: Padding(
                padding:EdgeInsetsGeometry.symmetric(horizontal: 2.0.rem, vertical: 0),
                child:ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(captureButton),
                  ),
                  icon: Icon(Icons.image, color: Colors.white),
                  label: Text("Upload from Gallery", style: TextStyle(color: Colors.white, fontFamily: "Gabarito")),
                  onPressed: () async {
                    if(imageCount < 2) cameraMode(ImageSource.gallery);
                  },
                ),
              ),
            ),]
          ),
      ]
    );
  }
}

Color captureButton(Set<WidgetState> states) {
  if (states.contains(WidgetState.pressed)){
    return Color(0xFF3ACF72);
  }
  else {
    return Color(0xFF3ACF72);
  }
}

Widget tempCapturedContainer() {
  return Stack(
    children: [
      FractionallySizedBox(
        heightFactor: 0.35,
        widthFactor: 0.25,
        child: Placeholder()
      ),
    ],
  );
}

Widget capturedContainer() {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("")
          )
        ),
          
      )
    ],
  );
}