import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'scanner_utils.dart';
import 'face_detector_painter.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CameraController camera;
  bool isDetecting = false;
  CameraLensDirection direction = CameraLensDirection.front;
  dynamic scanResults;
  String smileEmoji = "";
  double smileProbability;

  static FaceDetectorOptions options = new FaceDetectorOptions(
    mode: FaceDetectorMode.accurate,
    enableContours: true,
    enableClassification: true,
    enableLandmarks: true,
    enableTracking: true
  );

   FaceDetector faceDetector = FirebaseVision.instance.faceDetector(options);



  FaceDetectorMode accurateMode = FaceDetectorMode.accurate;

  final List<Face> faces;

  _HomePageState({this.faces});

  @override
  void initState() {
    super.initState();

    
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description = await ScannerUtils.getCamera(direction);

    camera = CameraController(
      description, 
      defaultTargetPlatform == TargetPlatform.iOS
        ? ResolutionPreset.low
        : ResolutionPreset.medium
    );
    await camera.initialize();

    camera.startImageStream((CameraImage image) {
      if (isDetecting) return;

      isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: faceDetector.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          setState(() {
          //print('\n\n\n\n\n\n\n\n\nRESULTS: $results');
          scanResults = results;           
          });
        }
      ).whenComplete(() => isDetecting = false);
    });
  }

  Widget _buildResults() {
    const Text noResultsText = Text("No Results!");

    if (scanResults == null || camera == null || !camera.value.isInitialized) {
      return noResultsText;
    }



  CustomPainter painter;

  final Size imageSize = Size(camera.value.previewSize.height, camera.value.previewSize.width);

  painter = FaceDetectorPainter(imageSize, scanResults);

  for (Face face in scanResults) {
    smileProbability = face.smilingProbability;

 //   FaceContourType faceContours = FaceContourType.rightEyebrowTop;

//  print('\n\n\n\n\n\n\n\n\nFACE DETAILS:${face.getContour(faceContours).positionsList}');
     
     if (smileProbability > 0.99) {
       smileEmoji = "😁";
     } else if (smileProbability < 0.989 && smileProbability > 0.5) {
       smileEmoji = "🙂";
     } else if (smileProbability < 0.5 && smileProbability > 0.05) {
       smileEmoji = "😐";
     } else {
       smileEmoji = "🙁";
     }
 // print('\n\n\n\n\n\n\n\n\nSMILE PROBABILITY: ${smileProbability}');
  }


    return CustomPaint(
    painter: painter,
    );
  }

  //   Widget _buildSmileResults() {
  //   const Text noResultsText = Text("No Results!");

  //   if (scanResults == null || camera == null || !camera.value.isInitialized) {
  //     return noResultsText;
  //   }

  // print('\n\n\n\n\n\n\n\n\nSMILE PROBABILITY: ${smileProbability}');

  // CustomPainter painter;

  // final Size imageSize = Size(camera.value.previewSize.height, camera.value.previewSize.width);

  // painter = FaceDetectorPainter(imageSize, scanResults);


  //   return CustomPaint(
  //   painter: painter,
  //   );
  // }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: camera == null
        ? const Center(
          child: Text(
            "Initializing Camera...",
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
            ),
          ),
        )
      : Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(camera),
          _buildResults(),
          Positioned(
            left: (MediaQuery.of(context).size.width / 2) - 50,
            bottom: 20,
            width: 100,
            height: 120,
            child: Text(
              smileEmoji,
              style: TextStyle(
                fontSize: 100
              ),
              ),
          ),
        ],
      ),
    );
  }

  void _toggleCameraDirection() async {
    if (direction == CameraLensDirection.back) {
      direction = CameraLensDirection.front;
    } else {
      direction = CameraLensDirection.back;
    }

    await camera.stopImageStream();
    await camera.dispose();

    setState(() {
      camera = null;
    });

    _initializeCamera();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildImage(),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCameraDirection,
        child: direction == CameraLensDirection.back
            ? const Icon(Icons.camera_front)
            : const Icon(Icons.camera_rear),
      ),
    );
  }

    @override
  void dispose() {
    camera.dispose().then((_) {

      faceDetector.close();

    });

    super.dispose();
  }

}
