import 'dart:ui';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces);

  final Size absoluteImageSize;
  final List<Face> faces;



  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    paint(Color color) {
      return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = color;
    }

  

    final Paint faceBoxPaint = paint(Colors.red);
    final Paint rightEyebrowPaint = paint(Colors.lightBlue);
    final Paint leftEyebrowPaint = paint(Colors.lightGreen);
    final Paint rightEyePaint = paint(Colors.purple);
    final Paint leftEyePaint = paint(Colors.orange);
    final Paint upperMouthPaint = paint(Colors.red);
    final Paint lowerMouthPaint = paint(Colors.deepOrange);
    final Paint nosePaint = paint(Colors.indigo);
    final Paint noseBridgePaint = paint(Colors.lime);
    final Paint noseBottomPaint = paint(Colors.teal);
    final Paint faceShapePaint = paint(Colors.blueGrey);
    
    



    drawfacialFeature(List<Offset> facialPoints, Paint paint) {
      for (int i = 0; i < facialPoints.length - 1; i++) {
        if (facialPoints[i] != null && facialPoints[i + 1] != null) {
          Offset newOffset1 =
              Offset(facialPoints[i].dx * scaleX, facialPoints[i].dy * scaleY);
          Offset newOffset2 = Offset(
              facialPoints[i + 1].dx * scaleX, facialPoints[i + 1].dy * scaleY);
          canvas.drawLine(newOffset1, newOffset2, paint);
        } else if (facialPoints[i] != null && facialPoints[i + 1] == null) {
          return;
        }
      }
    }

    for (Face face in faces) {

      FaceContourType rightEyebrowTop = FaceContourType.rightEyebrowTop;
      FaceContourType rightEyebrowBottom = FaceContourType.rightEyebrowBottom;
      FaceContourType leftEye = FaceContourType.leftEye;
      FaceContourType rightEye = FaceContourType.rightEye;
      FaceContourType upperLipTop = FaceContourType.upperLipTop;
      FaceContourType lowerLipBottom = FaceContourType.lowerLipBottom;
      FaceContourType noseBridge = FaceContourType.noseBridge;
      FaceContourType noseBottom = FaceContourType.noseBottom;
      FaceContourType leftEyebrowTop = FaceContourType.leftEyebrowTop;
      FaceContourType leftEyebrowBottom = FaceContourType.leftEyebrowBottom;

      FaceContourType entireFace = FaceContourType.face;


      List<Offset> rightEyebrowTopPoints =
          face.getContour(rightEyebrowTop).positionsList;
      List<Offset> rightEyebrowBottomPoints =
          face.getContour(rightEyebrowBottom).positionsList;
      List<Offset> leftEyePoints = face.getContour(leftEye).positionsList;
      List<Offset> rightEyePoints = face.getContour(rightEye).positionsList;
      List<Offset> upperLipTopPoints =
          face.getContour(upperLipTop).positionsList;
      List<Offset> lowerLipBottomPoints =
          face.getContour(lowerLipBottom).positionsList;
      List<Offset> entireFacePoints = face.getContour(entireFace).positionsList;
      List<Offset> noseBridgePoints = face.getContour(noseBridge).positionsList;
      List<Offset> noseBottomPoints = face.getContour(noseBottom).positionsList;
      List<Offset> leftEyebrowTopPoints = face.getContour(leftEyebrowTop).positionsList;
      List<Offset> leftEyebrowBottomPoints = face.getContour(leftEyebrowBottom).positionsList;



      drawfacialFeature(rightEyebrowTopPoints, rightEyebrowPaint);
      drawfacialFeature(rightEyebrowBottomPoints, rightEyebrowPaint);
      drawfacialFeature(leftEyePoints, leftEyePaint);
      drawfacialFeature(rightEyePoints, rightEyePaint);
      drawfacialFeature(upperLipTopPoints, upperMouthPaint);
      drawfacialFeature(lowerLipBottomPoints, lowerMouthPaint);
      drawfacialFeature(entireFacePoints, faceShapePaint);
      drawfacialFeature(noseBridgePoints, noseBridgePaint);
      drawfacialFeature(noseBottomPoints, noseBottomPaint);
      drawfacialFeature(leftEyebrowTopPoints, leftEyebrowPaint);
      drawfacialFeature(leftEyebrowBottomPoints, leftEyebrowPaint);


      canvas.drawRect(
        Rect.fromLTRB(
          face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        faceBoxPaint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
