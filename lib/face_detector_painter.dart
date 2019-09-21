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

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    final Paint eyebrowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.green;
    final Paint eyePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.pink;
    final Paint upperMouthPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.orange;
    final Paint lowerMouthPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purple;
          final Paint nosePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.teal;
          final Paint facePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.yellow;
                final Paint noseBridgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.pink;
                final Paint noseBottomPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.black;

  drawfacialFeature(List<Offset> facialPoints, Paint paint) {

      for (int i = 0; i < facialPoints.length - 1; i++) {
        if (facialPoints[i] != null &&
            facialPoints[i + 1] != null) {
          Offset newOffset1 = Offset(facialPoints[i].dx * scaleX,
              facialPoints[i].dy * scaleY);
          Offset newOffset2 = Offset(facialPoints[i + 1].dx * scaleX,
              facialPoints[i + 1].dy * scaleY);
          canvas.drawLine(newOffset1, newOffset2, paint);
        } else if (facialPoints[i] != null &&
            facialPoints[i + 1] == null) {
          return;
        }
      }
  }

    for (Face face in faces) {
      //print('\n\n\n\n\n\n\n\n\nSMILE DETAILS:${face.smilingProbability}');
      //print('\n\n\n\n\n\n\n\n\nEYE DETAILS:${face.rightEyeOpenProbability}');
      FaceContourType rightEyebrowTop = FaceContourType.rightEyebrowTop;
      FaceContourType rightEyebrowBottom = FaceContourType.rightEyebrowBottom;
      FaceContourType leftEye = FaceContourType.leftEye;
      FaceContourType rightEye = FaceContourType.rightEye;
      FaceContourType upperLipTop = FaceContourType.upperLipTop;
      FaceContourType lowerLipBottom = FaceContourType.lowerLipBottom;
      FaceContourType noseBridge = FaceContourType.noseBridge;
      FaceContourType noseBottom = FaceContourType.noseBottom;

      FaceContourType entireFace = FaceContourType.face;

     // print('\n\n\n\n\n\n\n\n\nFACE DETAILS:${face.getContour(entireFace).positionsList}');
      //smileProbability = face.smilingProbability;

      List<Offset> rightEyebrowPointsList = face.getContour(rightEyebrowTop).positionsList;
      List<Offset> rightEyebrowBottomPoints = face.getContour(rightEyebrowBottom).positionsList;
      List<Offset> leftEyePoints = face.getContour(leftEye).positionsList;
      List<Offset> rightEyePoints = face.getContour(rightEye).positionsList;
      List<Offset> upperLipTopPoints = face.getContour(upperLipTop).positionsList;
      List<Offset> lowerLipBottomPoints = face.getContour(lowerLipBottom).positionsList;
      List<Offset> entireFacePoints = face.getContour(entireFace).positionsList;
      List<Offset> noseBridgePoints = face.getContour(noseBridge).positionsList;
      List<Offset> noseBottomPoints = face.getContour(noseBottom).positionsList;
      //face.getContour(faceContours);
      //canvas.drawLine(rightEyebrowPointsList., p2, paint)

      drawfacialFeature(rightEyebrowPointsList, eyebrowPaint);
      drawfacialFeature(rightEyebrowBottomPoints, eyebrowPaint);
      drawfacialFeature(leftEyePoints, eyePaint);
      drawfacialFeature(rightEyePoints, eyePaint);
      drawfacialFeature(upperLipTopPoints, upperMouthPaint);
      drawfacialFeature(lowerLipBottomPoints, lowerMouthPaint);
      drawfacialFeature(entireFacePoints, facePaint);
      drawfacialFeature(noseBridgePoints, noseBridgePaint);
      drawfacialFeature(noseBottomPoints, noseBottomPaint);

      // for (int i = 0; i < rightEyebrowPointsList.length - 1; i++) {
      //   if (rightEyebrowPointsList[i] != null &&
      //       rightEyebrowPointsList[i + 1] != null) {
      //     Offset newOffset1 = Offset(rightEyebrowPointsList[i].dx * scaleX,
      //         rightEyebrowPointsList[i].dy * scaleY);
      //     Offset newOffset2 = Offset(rightEyebrowPointsList[i + 1].dx * scaleX,
      //         rightEyebrowPointsList[i + 1].dy * scaleY);
      //     canvas.drawLine(newOffset1, newOffset2, eyebrowPaint);
      //   } else if (rightEyebrowPointsList[i] != null &&
      //       rightEyebrowPointsList[i + 1] == null) {
      //     return;
      //   }
      // }


      // canvas.drawPath(rightEyeLandmark, paint)

      canvas.drawRect(
        Rect.fromLTRB(
          face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        paint,
      );
    }
  }



  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}

class SmileDetectorPainter extends CustomPainter {
  SmileDetectorPainter(this.absoluteImageSize, this.faces);

  final Size absoluteImageSize;
  final List<Face> faces;
  double smileProbability;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.green;

    for (Face face in faces) {
      FaceContourType faceContours = FaceContourType.rightEyebrowTop;

      print('\n\n\n\n\n\n\n\n\nFACE DETAILS:${face.getContour(faceContours)}');
      smileProbability = face.smilingProbability;

      List<Offset> rightEyebrowPointsList =
          face.getContour(faceContours).positionsList;

      //face.getContour(faceContours);
      //canvas.drawLine(rightEyebrowPointsList., p2, paint)

      for (int i = 0; i < rightEyebrowPointsList.length - 1; i++) {
        if (rightEyebrowPointsList[i] != null &&
            rightEyebrowPointsList[i + 1] != null) {
          canvas.drawLine(
              rightEyebrowPointsList[i], rightEyebrowPointsList[i + 1], paint);
        } else if (rightEyebrowPointsList[i] != null &&
            rightEyebrowPointsList[i + 1] == null) {
          return;
        }
      }

      canvas.drawRect(
        Rect.fromLTRB(
          face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
