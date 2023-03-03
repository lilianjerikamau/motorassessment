import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../models/imagesmodels.dart';
import '../main.dart';
import 'dart:io' as Io;
import 'package:progress_dialog/progress_dialog.dart';
import 'create_instruction.dart';
import 'home.dart';
import 'package:motorassesmentapp/utils/config.dart' as Config;
import 'package:http/http.dart' as http;

class AddPhotos extends StatefulWidget {
  final userid;
  final instructionid;
  const AddPhotos({Key? key, required this.userid, required this.instructionid})
      : super(key: key);

  @override
  State<AddPhotos> createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  final _itemDescController = TextEditingController();
  List<XFile>? imageslist = [];
  List<String>? filenames = [];
  bool? iscameraopen;
  XFile? image;
  Images? images;
  List<Map<String, dynamic>>? newImagesList;
  List<Images>? newList = [];
  List<Images>? newimages = [];
  int? customerid;
  void _addImage(XFile image) {
    setState(() {
      imageslist!.add(image);
    });
  }

  void _addImages(Images images) {
    setState(() {
      newList!.add(images);
      print(newList);
      uploadmultipleimage();
    });
  }

  void _addDescription(String description) {
    setState(() {
      filenames!.add(description);
    });
  }

  CameraController? controller; //controller for camera
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  StreamSubscription? connection;
  // bool _isRearCameraSelected = true;
  bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;
  // late SharedPreferences prefs;
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.max;

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      print('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras[0]);
    } else {
      print('Camera Permission: DENIED');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    iscameraopen = false;
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras[0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    connection!.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  Future uploadmultipleimage() async {
    for (int i = 0; i < newList!.length; i++) {
      print(newList![i].filename);
      newImagesList = newList!.map((e) {
        return {"filename": e.filename, "attachment": e.attachment};
      }).toList();
      print(newImagesList);
    }
    // _submit();
  }

  _submit() async {
    showDialog(
        context: this.context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Submit?'),
            content: Text('Are you sure you want to submit'),
            actions: <Widget>[
              MaterialButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  }),
              MaterialButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    ProgressDialog dial = new ProgressDialog(context,
                        type: ProgressDialogType.Normal);

                    dial.show();
                    dial.style(
                      message: 'Sending Assessment',
                    );
                    String demoUrl = await Config.getBaseUrl();
                    Uri url = Uri.parse(demoUrl + 'valuation/assessmentphoto/');
                    print(url);
                    int timeout = 5;

                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        final response = await http.post(url,
                            headers: <String, String>{
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode(<String, dynamic>{
                              "userid": widget.userid,
                              "assessmentid": widget.instructionid,
                              "photolist": newImagesList,
                            }));

                        if (response != null) {
                          dial.hide();
                          // prefs.clear();
                          int statusCode = response.statusCode;
                          if (statusCode == 200) {
                            return _showDialog(this.context);
                          } else {
                            print("Submit Status code::" +
                                response.body.toString());
                            showAlertDialog(this.context, response.body);
                          }
                        } else {
                          dial.hide();
                          Fluttertoast.showToast(
                              msg: 'There was no response from the server');
                        }
                      }
                    } on SocketException catch (e) {
                    } on Error catch (e) {}
                  },
                  child: Text('Yes'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return iscameraopen == false
        ? Scaffold(
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      label: Text('Add Photos'),
                      onPressed: () {
                        setState(() {
                          iscameraopen = true;
                          image = null;
                          _itemDescController.clear();
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      label: Text('Submit'),
                      onPressed: () {
                        _submit();
                      },
                    ),
                  ),
                ]),
            appBar: AppBar(
              title: Text(
                'Add Photos',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              leading: Builder(
                builder: (BuildContext context) {
                  return RotatedBox(
                    quarterTurns: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                imageslist != null
                    ? Container(
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: imageslist!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  InteractiveViewer(
                                    panEnabled: true,
                                    boundaryMargin: EdgeInsets.all(80),
                                    minScale: 0.5,
                                    maxScale: 3,
                                    child: FadeInImage(
                                      image: FileImage(
                                        File(imageslist![index].path),
                                      ),
                                      placeholder:
                                          MemoryImage(kTransparentImage),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.1),
                                    height: 30,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        filenames![index],
                                        maxLines: 8,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Regular'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
              ]),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: _isCameraPermissionGranted
                ? _isCameraInitialized
                    ? Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Column(children: [
                                AspectRatio(
                                  aspectRatio:
                                      MediaQuery.of(context).size.width /
                                          MediaQuery.of(context).size.height,
                                  child: Stack(
                                    children: [
                                      CameraPreview(
                                        controller!,
                                        // child: LayoutBuilder(builder:
                                        //     (BuildContext context,
                                        //         BoxConstraints constraints) {
                                        //   return GestureDetector(
                                        //     behavior: HitTestBehavior.translucent,
                                        //     onTapDown: (details) => onViewFinderTap(
                                        //         details, constraints),
                                        //   );
                                        // }),
                                      ),
                                      // TODO: Uncomment to preview the overlay
                                      // Center(
                                      //   child: Image.asset(
                                      //     'assets/camera_aim.png',
                                      //     color: Colors.greenAccent,
                                      //     width: 150,
                                      //     height: 150,
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          16.0,
                                          8.0,
                                          16.0,
                                          8.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                  ),
                                                  child: DropdownButton<
                                                      ResolutionPreset>(
                                                    dropdownColor:
                                                        Colors.black87,
                                                    underline: Container(),
                                                    value:
                                                        currentResolutionPreset,
                                                    items: [
                                                      for (ResolutionPreset preset
                                                          in resolutionPresets)
                                                        DropdownMenuItem(
                                                          child: Text(
                                                            preset
                                                                .toString()
                                                                .split('.')[1]
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          value: preset,
                                                        )
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        currentResolutionPreset =
                                                            value!;
                                                        _isCameraInitialized =
                                                            false;
                                                      });
                                                      onNewCameraSelected(
                                                          controller!
                                                              .description);
                                                    },
                                                    hint: Text("Select item"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0, top: 16.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    _currentExposureOffset
                                                            .toStringAsFixed(
                                                                1) +
                                                        'x',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: RotatedBox(
                                                quarterTurns: 3,
                                                child: Container(
                                                  height: 30,
                                                  child: Slider(
                                                    value:
                                                        _currentExposureOffset,
                                                    min:
                                                        _minAvailableExposureOffset,
                                                    max:
                                                        _maxAvailableExposureOffset,
                                                    activeColor: Colors.white,
                                                    inactiveColor:
                                                        Colors.white30,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        _currentExposureOffset =
                                                            value;
                                                      });
                                                      await controller!
                                                          .setExposureOffset(
                                                              value);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Slider(
                                                    value: _currentZoomLevel,
                                                    min: _minAvailableZoom,
                                                    max: _maxAvailableZoom,
                                                    activeColor: Colors.white,
                                                    inactiveColor:
                                                        Colors.white30,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        _currentZoomLevel =
                                                            value;
                                                      });
                                                      await controller!
                                                          .setZoomLevel(value);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black87,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        _currentZoomLevel
                                                                .toStringAsFixed(
                                                                    1) +
                                                            'x',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        _currentFlashMode =
                                                            FlashMode.off;
                                                      });
                                                      await controller!
                                                          .setFlashMode(
                                                        FlashMode.off,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.flash_off,
                                                      color:
                                                          _currentFlashMode ==
                                                                  FlashMode.off
                                                              ? Colors.amber
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        _currentFlashMode =
                                                            FlashMode.auto;
                                                      });
                                                      await controller!
                                                          .setFlashMode(
                                                        FlashMode.auto,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.flash_auto,
                                                      color:
                                                          _currentFlashMode ==
                                                                  FlashMode.auto
                                                              ? Colors.amber
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        _currentFlashMode =
                                                            FlashMode.always;
                                                      });
                                                      await controller!
                                                          .setFlashMode(
                                                        FlashMode.always,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.flash_on,
                                                      color:
                                                          _currentFlashMode ==
                                                                  FlashMode
                                                                      .always
                                                              ? Colors.amber
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        _currentFlashMode =
                                                            FlashMode.torch;
                                                      });
                                                      await controller!
                                                          .setFlashMode(
                                                        FlashMode.torch,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.highlight,
                                                      color:
                                                          _currentFlashMode ==
                                                                  FlashMode
                                                                      .torch
                                                              ? Colors.amber
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    image = await takePicture();
                                                    File image1 =
                                                        File(image!.path);

                                                    int currentUnix = DateTime
                                                            .now()
                                                        .millisecondsSinceEpoch;

                                                    String fileFormat = image1
                                                        .path
                                                        .split('.')
                                                        .last;
                                                    setState(() {
                                                      iscameraopen = false;
                                                    });
                                                    iscameraopen = false;
                                                    // GallerySaver.saveImage(
                                                    //         image!.path)
                                                    //     .then((path) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return _SystemPadding(
                                                          child: AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            content: Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _itemDescController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    autofocus:
                                                                        true,
                                                                    decoration: const InputDecoration(
                                                                        labelText:
                                                                            'Enter Description',
                                                                        hintText:
                                                                            'Description'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  child: const Text(
                                                                      'CANCEL'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                              TextButton(
                                                                  child:
                                                                      const Text(
                                                                          'OKAY'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {
                                                                      String?
                                                                          description =
                                                                          _itemDescController
                                                                              .text
                                                                              .trim();
                                                                      print(
                                                                          description);
                                                                      final bytes =
                                                                          Io.File(image!.path)
                                                                              .readAsBytesSync();

                                                                      String
                                                                          imageFile =
                                                                          base64Encode(
                                                                              bytes);
                                                                      images = Images(
                                                                          filename:
                                                                              description,
                                                                          attachment:
                                                                              imageFile);
                                                                      _addImage(
                                                                          image!);
                                                                      _addImages(
                                                                          images!);
                                                                      _addDescription(
                                                                          description);
                                                                    });
                                                                  })
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    // });
                                                    print(fileFormat);
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        color:
                                                            _isVideoCameraSelected
                                                                ? Colors.white
                                                                : Colors
                                                                    .white38,
                                                        size: 95,
                                                      ),
                                                      Icon(
                                                        Icons.circle,
                                                        color:
                                                            _isVideoCameraSelected
                                                                ? Colors.white
                                                                : Colors.blue,
                                                        size: 80,
                                                      ),
                                                      _isVideoCameraSelected &&
                                                              _isRecordingInProgress
                                                          ? Icon(
                                                              Icons
                                                                  .stop_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 32,
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          'LOADING',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(),
                      Text(
                        'Permission denied',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          getPermissionStatus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Give permission',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.padding,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

void _showDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home()));
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      "Success!",
      style: TextStyle(color: Colors.green),
    ),
    content: Text("Successful!"),
    actions: [
      okButton,
    ],
  );
  //   context: context,
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
