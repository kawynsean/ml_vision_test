import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ml_vision_test/camera_utilities.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:ml_vision_test/face_detector_painter.dart';



 class EmojiDetectionPage extends StatefulWidget {

  @override
  _EmojiDetectionPageState createState() => _EmojiDetectionPageState();
}

class _EmojiDetectionPageState extends State<EmojiDetectionPage> {

  CameraController _camera;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;
  dynamic _scanResults;
  String _smileEmoji = "😐";
  double _smileProbability;
  double _rightEyeOpenProbability;
  double _leftEyeOpenProbability;
  Icon _cameraIcon = Icon(Icons.camera_front);
  CustomPainter _painter;
  bool _showContourLines = false;


  static FaceDetectorOptions _options = FaceDetectorOptions(
      mode: FaceDetectorMode.accurate,
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true);

    FaceDetector _faceDetector = FirebaseVision.instance.faceDetector(_options);


  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description =
        await CameraUtils.getCamera(_direction);

    _camera = CameraController(
        description,
        defaultTargetPlatform == TargetPlatform.iOS
            ? ResolutionPreset.high
            : ResolutionPreset.high);
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      CameraUtils.detect(
        image: image,
        detectInImage: _faceDetector.processImage,
        imageRotation: description.sensorOrientation,
      ).then((dynamic results) {
        setState(() {
          _scanResults = results;
        });
      }).whenComplete(() => _isDetecting = false);
    });
  }

  // ⬇️ OPTIONAL? DO WE WANT THE DEMO USER TO TOGGLE BETWEEN FRONT AND BACK CAMERAS.

  void _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _camera.stopImageStream();
    await _camera.dispose();

    setState(() {
      _camera = null;
    });

    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.face),
          onPressed: () {
            setState(() {
            _showContourLines = !_showContourLines;       
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: _cameraIcon,
            onPressed: _toggleCameraDirection,
          ),
        ],
      ),
      body: _buildCameraImage(context),
    );
  }

  Widget _buildEmoji() {
    for (Face face in _scanResults) {
      _smileProbability = face.smilingProbability;
      _leftEyeOpenProbability = face.leftEyeOpenProbability;
      _rightEyeOpenProbability = face.rightEyeOpenProbability;

      if (_smileProbability == null &&
          _leftEyeOpenProbability == null &&
          _rightEyeOpenProbability == null) {
        _smileEmoji = "😐";
      } else {
        if (_leftEyeOpenProbability < 0.5 || _rightEyeOpenProbability < 0.5) {
          _smileEmoji = "😉";
        } else  {
          if (_smileProbability > 0.75) {
            _smileEmoji = "😁";
          } else  {
            _smileEmoji = "😐";
          }
        }
      }
    }
    return _positionedEmoji();
  }

  Widget _positionedEmoji() {
    return Positioned(
      left: (MediaQuery.of(context).size.width / 2) - 60,
      bottom: MediaQuery.of(context).size.width / 12,
      width: 120,
      height: 120,
      child: Text(
        _smileEmoji,
        style: TextStyle(fontSize: 100),
      ),
    );
  }

  Widget _loadingScreen() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "Initializing Face Detection...",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget _buildCameraImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _camera == null
          ? _loadingScreen()
          : Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                CameraPreview(_camera),
                _buildEmoji(),
                _buildContourPainter(),
                ],
            ),
    );
  }

  Widget _buildContourPainter() {
    
    final Size imageSize =
    Size(_camera.value.previewSize.height, _camera.value.previewSize.width);
    _painter = FaceDetectorPainter(imageSize, _scanResults);

    if (_showContourLines) {
      print("SHOW CONTOURS LINES: $_painter");
      
      return CustomPaint(
        painter: _painter,
      );
    } else {
      return Container();
    }
  }



  @override
  void dispose() {
    _camera.dispose().then((_) {
      _faceDetector.close();
    });

    super.dispose();
  }

 }
 
 
 
 
 
