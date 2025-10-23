import 'dart:math';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/basic/dynamic_widget_json_exportor.dart';
import 'package:dynamic_widget/dynamic_widget/basic/stack_positioned_widgets_parser.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';
import 'package:geeco/bax_end/evaluation_bax_end.dart';
// import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:geeco/modules/globalbottomnav.dart';
import 'package:geeco/pages/evaluation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:scaled_size/scaled_size.dart';

class EditorPage extends StatefulWidget {
  final List<String>? scannedImages;
  const EditorPage({
    super.key,
    this.scannedImages,
  });

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late String scannedBackgroundImagePath;
  late Iterable<MapEntry<String, String>> defaultBackdrops;
  late List<String> habitatObjectCategories;
  late Iterable<MapEntry<String, String>> habitatObjectPaths;
  late List<Tab> stickerCategoryTabs;
  late Map<String, List<MapEntry<String, String>>> habitatCategoryObjectPaths;

  MapEntry<String, String>? selectedBackdrop;
  List<Widget> placedStickers = [];

  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final GlobalKey stickerStack = GlobalKey();
  final GlobalKey stickerStackElement = GlobalKey();
  ui.Image? _capturedImage;

  FocusNode backgroundFocusNode = FocusNode();
  FocusNode stickerCurrentFocusNode = FocusNode();
  double stickerPickerHeightPercentage = 0.5;
  Function? currentStickerGetterCallback;
  Function? currentStickerSetterCallback;
  ImageProvider defaultBackdrop = AssetImage('assets/images/default_backdrops/backdrops/Clearing.jpg');

  late final DraggableScrollableController _sheetController;
  final GlobalKey _sheetKey = GlobalKey();
  bool _dataLoaded = false; // Flag to track data loading

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    // Initialize with fallback data
    habitatObjectCategories = [];
    habitatCategoryObjectPaths = {};
    stickerCategoryTabs = [];
    defaultBackdrops = [];
    // Load data asynchronously
    _loadInitialData().then((_) {
      if (mounted) {
        setState(() {
          _dataLoaded = true;
          if(exported_images.isEmpty == false) {
            Image image = Image.file(File(exported_images[0]));
            defaultBackdrop = image.image;
            var temp = defaultBackdrops.toList();
            for(int i = 0; i < exported_images.length; i++) {
              temp.add(MapEntry("Scanned Image #${i+1}", exported_images[i]));
            }
            defaultBackdrops = temp;
          }
        });
      }
    });
    print("addlistener");
    _sheetController.addListener(() {
      print("SheetController size: ${_sheetController.size}, Attached: ${_sheetController.isAttached}");
    });
    print("addedlistener");
  }

  Future<void> _loadInitialData() async {
    await _loadHabitatObjectData();
    _loadCategoryTabs();
    await _loadDefaultBackdrops();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    backgroundFocusNode.dispose();
    //stickerCurrentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("EditorPage built");
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: InteractiveViewer(
                child: RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child: Focus(
                    focusNode: backgroundFocusNode,
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        setState(() {
                          stickerCurrentFocusNode = backgroundFocusNode;
                          currentStickerGetterCallback = null;
                          currentStickerSetterCallback = null;
                        });
                        print("background was focused, no sticker focused");
                      } else {
                        print("background was pressed, a sticker now has focus");
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        backgroundFocusNode.requestFocus();
                        print("background was pressed");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: selectedBackdrop != null 
                            ? selectedBackdrop!.key.startsWith("Scanned") 
                            ? Image.file(File(selectedBackdrop!.value)).image
                            : AssetImage(selectedBackdrop!.value)
                            : defaultBackdrop,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: placedStickers,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible: !backgroundFocusNode.hasPrimaryFocus && currentStickerGetterCallback != null,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FractionallySizedBox(
                    heightFactor: 0.75,
                    child: IntrinsicWidth(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: Color(0xFF022000).withAlpha(181),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Icon(
                                Icons.zoom_in,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                  min: 0.5,
                                  max: 4.0,
                                  activeColor: Color(0xFF3ACF72),
                                  thumbColor: Color(0xFF3ACF72),
                                  value: currentStickerGetterCallback != null ? currentStickerGetterCallback!() : 0.5,
                                  onChanged: (newValue) =>
                                      currentStickerSetterCallback != null ? currentStickerSetterCallback!(newValue) : () {},
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Icon(
                                Icons.zoom_out,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00461A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              padding: EdgeInsets.only(left: 8.0, right: 15.0, top: 10.0, bottom: 10.0),
            ),
            icon: Icon(Icons.document_scanner_outlined, size: 32.0),
            label: Text(
              "Evaluate",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: "Gabarito"),
            ),
            onPressed: _dataLoaded
                ? () => evaluateCall()
                : null, // Disable until data is loaded
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "Save",
            backgroundColor: Color(0xFF00461A),
            foregroundColor: Colors.white,
            onPressed: _dataLoaded ? () => saveDialog() : null,
            child: Icon(Icons.download, size: 32.0),
          ),
          Spacer(),
          FloatingActionButton(
            heroTag: "Sticker",
            backgroundColor: Color(0xFF00461A),
            foregroundColor: Colors.white,
            onPressed: _dataLoaded
                ? () {
                    _openStickerPicker(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print("rogg after frame: ${_sheetController.isAttached}");
                    });
                  }
                : null,
            child: Icon(Icons.add, size: 32.0),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "Backdrop",
            backgroundColor: Color(0xFF00461A),
            foregroundColor: Colors.white,
            onPressed: _dataLoaded ? () => _openBackdropPicker(context) : null,
            child: Icon(Icons.image_outlined, size: 32.0),
          ),
        ],
      ),
    );
  }

  Future<void> _captureCanvas() async {
    RenderRepaintBoundary? boundary =
        _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary != null) {
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      setState(() {
        _capturedImage = image;
      });
    }
  }

  void evaluateCall() async {
    final List<String> images = [""];
    await _captureCanvas();
    final image_byte_data = await _capturedImage?.toByteData(format:ui.ImageByteFormat.png);
    final image_byte_list = image_byte_data?.buffer.asUint8List();
    print("Sending image bytes...");
    BottomNavigationBar navBar = navbarKey.currentWidget as BottomNavigationBar;
    navBar.onTap!(1);
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => Evaluation(images: images, habitat: image_byte_list))
    );
  }

  void saveDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Save this Habitat? (as image)"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                saveToPhone();
                Navigator.pop(context);
              },
              child: Text(
                "Save to Gallery",
                style: TextStyle(
                  color:Theme.of(context).colorScheme.secondary
                ),
              )
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary
                )  
              )
            )
          ],
        );
      }
    );
  }

  Future<void> saveToPhone() async {
    await _captureCanvas();
    final image_byte_data = await _capturedImage?.toByteData(format:ui.ImageByteFormat.png);
    final image_byte_list = image_byte_data?.buffer.asUint8List();
    await Gal.putImageBytes(image_byte_list!);
    Fluttertoast.showToast(
      msg: "Habitat Saved to Gallery",
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 0.8.rem,
      textColor: Theme.of(context).colorScheme.shadow,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Future<void> saveToHomePage() async {
    for(var sticker in placedStickers) {
     
    }
  }

  Future<void> chooseBackdropFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      setState(() {
        selectedBackdrop = MapEntry("Scanned", image.path);
      });
      Fluttertoast.showToast(
        msg: "Backdrop Changed",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 0.8.rem,
        textColor: Theme.of(context).colorScheme.shadow,
        backgroundColor: Theme.of(context).colorScheme.surface,
      );
    }
  }

  Future<Iterable<MapEntry<String, String>>> _getImageAssetPaths(String source) async {
    String subfolderPath = source;
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = json.decode(manifestContent);

    final List<String> assetPaths = manifest.keys
        .where((String key) => key.startsWith('$subfolderPath/') && !key.endsWith('/'))
        .toList();
    final List<String> assetNames = assetPaths.map((e) => e.replaceAll('$subfolderPath/', "").replaceAll(".png", "").replaceAll(".jpg", "")).toList();

    return Map.fromIterables(assetNames, assetPaths).entries;
  }

  Future<void> _loadDefaultBackdrops() async {
    String subfolderPath = "assets/images/default_backdrops/backdrops";
    defaultBackdrops = await _getImageAssetPaths(subfolderPath);
    print("defaultBackdrops loaded: ${defaultBackdrops.length}");
  }

  Future<void> _loadHabitatObjectData() async {
    print("Loading habitat object data");
    String subfolderPath = "assets/images/habitat_objects";

    Iterable<MapEntry<String, String>> habitatObjectAssetPaths = await _getImageAssetPaths(subfolderPath);
    Iterable<List<String>> habitatObjectCategoryObjects = habitatObjectAssetPaths.map((e) => e.key.split("/"));

    habitatObjectCategories = habitatObjectCategoryObjects.map((e) => e[0]).toSet().toList();
    habitatCategoryObjectPaths = {};
    for (MapEntry<String, String> entry in habitatObjectAssetPaths) {
      List<String> entryCategoryAndName = entry.key.split("/");
      habitatCategoryObjectPaths.update(
        entryCategoryAndName[0],
        (list) => list..add(MapEntry(entryCategoryAndName[1], entry.value)),
        ifAbsent: () => [MapEntry(entryCategoryAndName[1], entry.value)],
      );
    }
    habitatObjectPaths = habitatObjectAssetPaths;
    print("habitatObjectCategories: $habitatObjectCategories");
    print("habitatCategoryObjectPaths: $habitatCategoryObjectPaths");
  }

  void _loadCategoryTabs() {
    print("Loading category tabs");
    stickerCategoryTabs = habitatObjectCategories.map((category) => Tab(text: category)).toList();
  }

  void _openBackdropPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xCC022000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(0.0)
        )
      ),
      builder: (context) => LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
                child: Center(
                  child: Text(
                    "Select a backdrop",
                    style: TextStyle(
                      color: Colors.lightGreen.shade100,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gabarito",
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  cacheExtent: 1000000.0,
                  addAutomaticKeepAlives: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  itemExtent: constraints.maxWidth / 2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: backdropListBuilder,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: FractionallySizedBox(
                  heightFactor: .5,
                  widthFactor: 1.0,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.image_outlined, color: Colors.white, size: 25),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      backgroundColor: Color(0xFF3ACF72),
                    ),
                    onPressed: () {
                      chooseBackdropFromGallery();
                    },
                    label: Text(
                      "Choose from files...",
                      style: TextStyle(fontSize: 25, fontFamily: "Gabarito", color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openStickerPicker(BuildContext context) {
    print("StickerPicker opened");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Color(0xCC022000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(0.0)
        )
      ),
      builder: (context) {
        // Debug attachment after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("Post-frame: Controller attached: ${_sheetController.isAttached}");
        });

        void onDragSticker() {
          print("Dragging sticker (balls)");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("bogg after frame: ${_sheetController.isAttached}");
            if (_sheetController.isAttached) {
              print("Animating to 0.15");
              _sheetController.animateTo(
                0.15,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              print("Cannot animate: Controller not attached");
            }
          });
        }

        void onDropSticker() {
          print("Dropping sticker (tight)");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("fogg after frame: ${_sheetController.isAttached}");
            if (_sheetController.isAttached) {
              print("Animating to 0.50");
              _sheetController.animateTo(
                0.50,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              print("Cannot animate: Controller not attached");
            }
          });
        }

        return DraggableScrollableSheet(
          key: _sheetKey,
          controller: _sheetController,
          expand: false,
          snapAnimationDuration: const Duration(milliseconds: 200),
          initialChildSize: stickerPickerHeightPercentage,
          minChildSize: 0.05,
          maxChildSize: 1.0,
          snap: true,
          builder: (BuildContext context, ScrollController scrollController) {
            print("Building DraggableScrollableSheet");
            if (!_dataLoaded || habitatObjectCategories.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                print("bowow ${_sheetController.isAttached}");
                return DefaultTabController(
                  length: habitatObjectCategories.length,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 52.0,
                        child: Center(
                          child: Text(
                            "Select a natural feature",
                            style: TextStyle(
                              color: Colors.lightGreen.shade100,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Gabarito",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.075,
                        child: TabBar(
                          tabs: stickerCategoryTabs,
                          unselectedLabelColor: Colors.lightGreen.shade100,
                          unselectedLabelStyle: TextStyle(fontSize: 18.0),
                          labelColor: Color(0xFF3ACF72),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          indicatorColor: Color(0xFF3ACF72),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: stickerCategoryTabs.map((Tab tab) {
                            print("Building TabBarView for ${tab.text}");
                            return GridView.builder(
                              controller: scrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: habitatCategoryObjectPaths[tab.text]?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) => stickersBuilder(
                                context,
                                index,
                                tab.text!,
                                onDragSticker,
                                onDropSticker,
                              ),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 20.0,
                                childAspectRatio: 1.0,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget? backdropListBuilder(BuildContext context, int index) {
    if (index < defaultBackdrops.length) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: Ink.image(
                      image: defaultBackdrops.elementAt(index).key.startsWith("Scanned") 
                      ? Image.file(File(defaultBackdrops.elementAt(index).value)).image
                      : AssetImage(defaultBackdrops.elementAt(index).value),
                      fit: BoxFit.cover,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {
                          setState(() {
                            selectedBackdrop = defaultBackdrops.elementAt(index);
                          });
                          print("Selected backdrop: ${defaultBackdrops.elementAt(index).key}");
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * .10,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        defaultBackdrops.elementAt(index).key,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.lightGreen.shade100),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
    return null;
  }

  Widget? categoriesBuilder(BuildContext context, int index) {
    if (index < habitatObjectCategories.length) {
      return null;
    }
    return null;
  }

  Widget createNewSticker(String droppedStickerAssetPath, Offset offset, {double initialScale = 1.0}) {
    print("created sticker");
    bool isActive = false;
    double scale = initialScale;
    double getScaleCallback() {
      print("Sticker scale: $scale");
      return scale;
    }
    FocusNode stickerFocusNode = FocusNode();
    Key stickerKey = UniqueKey();
    return StatefulBuilder(
        key: stickerKey,
        builder: (BuildContext context, StateSetter moveSetState) {
          Widget body = SizedBox(
            width: 50.0 * scale,
            height: 50.0 * scale,
            child: Stack(
              children: [
                Image.asset(droppedStickerAssetPath),
                Visibility(
                  visible: isActive,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(color: Colors.green),
                      color: Colors.lightGreen.withAlpha(88),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              color: Colors.redAccent.shade400.withAlpha(40),
                            ),
                            child: SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: IconButton(
                                iconSize: 24.0,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                color: Colors.red,
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  print("hibax");
                                  setState(() {
                                    placedStickers.removeWhere((item) => item.key == stickerKey);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              color: Colors.blue.withAlpha(40),
                            ),
                            child: SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: IconButton(
                                iconSize: 18.0,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                color: Colors.white,
                                icon: Icon(Icons.copy_outlined),
                                onPressed: () {
                                  setState(() {
                                    placedStickers.add(createNewSticker(droppedStickerAssetPath, offset + Offset(10.0, 10.0), initialScale: scale));
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
      
          void setScaleCallback(double newScale) {
            setState(() {
              moveSetState(() {
                scale = newScale;
              });
            });
          }
      
          return Positioned(
            top: offset.dy - kToolbarHeight,
            left: offset.dx,
            child: Focus(
              focusNode: stickerFocusNode,
              onFocusChange: (hasFocus) {
                print("focus change observed");
                if (hasFocus) {
                  print("focused");
                  setState(() {
                    stickerCurrentFocusNode = stickerFocusNode;
                    currentStickerGetterCallback = getScaleCallback;
                    currentStickerSetterCallback = setScaleCallback;
                  });
                  moveSetState(() {
                    isActive = true;
                  });
                } else {
                  moveSetState(() {
                    isActive = false;
                  });
                  print("unfocused");
                }
              },
              child: GestureDetector(
                onTap: () {
                  stickerFocusNode.requestFocus();
                  print("sticker tapped, requesting focus");
                },
                child: Draggable(
                  onDragEnd: (details) {
                    moveSetState(() {
                      offset = details.offset;
                    });
                    print("moved");
                  },
                  feedback: body,
                  childWhenDragging: Container(),
                  child: body,
                ),
              ),
            ),
          );
        },
      );
  }

  Widget? stickersBuilder(BuildContext context, int index, String category, Function dragCallback, Function dropCallback) {
    if (index < habitatCategoryObjectPaths[category]!.length) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
        child: Container(
          color: Colors.transparent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Draggable(
                    onDragStarted: () {
                      dragCallback();
                      print('Drag started');
                    },
                    onDragEnd: (details) {
                      dropCallback();
                      print('Drag ended ${details.offset} ${details.offset.runtimeType}');
                      setState(() {
                        placedStickers.add(createNewSticker(habitatCategoryObjectPaths[category]![index].value, details.offset));
                        backgroundFocusNode.requestFocus();
                        // print('bawawawawa $placedStickers');
                      });
                    },
                    feedback: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: constraints.maxWidth * .8,
                        height: constraints.maxWidth * .8,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(habitatCategoryObjectPaths[category]![index].value)),
                          ),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: constraints.maxWidth * .8,
                      height: constraints.maxWidth * .8,
                      child: Material(
                        color: Colors.grey.withAlpha(64),
                        borderRadius: BorderRadius.circular(8.0),
                        clipBehavior: Clip.antiAlias,
                        child: Ink.image(
                          image: AssetImage(habitatCategoryObjectPaths[category]![index].value),
                          fit: BoxFit.contain,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            onTap: () {
                              print('${habitatCategoryObjectPaths[category]![index].key} $index ${habitatCategoryObjectPaths[category]!.length}');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * .20,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          habitatCategoryObjectPaths[category]![index].key,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
    return null;
  }
}