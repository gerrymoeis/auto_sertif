import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// Removed image_gallery_saver import due to compatibility issues
import 'package:permission_handler/permission_handler.dart';

import '../models/certificate_settings.dart';
import '../models/participant.dart';

class ImageUtils {
  // Convert a File to a ui.Image
  static Future<ui.Image> fileToImage(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  // Generate a certificate for a participant
  static Future<File?> generateCertificate({
    required File templateFile,
    required Participant participant,
    required CertificateSettings settings,
  }) async {
    try {
      // Create a temporary directory to store the certificate
      final tempDir = await getTemporaryDirectory();
      // Format nama file: Nama Acara_Nama Peserta
      final safeEventName = settings.eventName.replaceAll(' ', '_').replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
      final safeParticipantName = participant.name.replaceAll(' ', '_').replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
      final certificatePath = '${tempDir.path}/${safeEventName}_${safeParticipantName}.png';
      
      // Load the template image
      final templateImage = await fileToImage(templateFile);
      
      // Create a picture recorder to draw on
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Draw the template image
      canvas.drawImage(templateImage, Offset.zero, Paint());
      
      // Draw the participant's name
      _drawTextOnCanvas(
        canvas,
        participant.name,
        settings.nameX * templateImage.width,
        settings.nameY * templateImage.height,
        settings.nameFontSize,
        settings.nameColor,
        settings.nameFontFamily,
      );
      
      // Draw role if included
      if (settings.includeRole && participant.role != null) {
        _drawTextOnCanvas(
          canvas,
          participant.role!,
          settings.roleX! * templateImage.width,
          settings.roleY! * templateImage.height,
          settings.roleFontSize!,
          settings.roleColor!,
          settings.roleFontFamily!,
        );
      }
      
      // Draw additional info if included
      if (settings.includeAdditionalInfo && participant.additionalInfo != null) {
        _drawTextOnCanvas(
          canvas,
          participant.additionalInfo!,
          settings.additionalInfoX! * templateImage.width,
          settings.additionalInfoY! * templateImage.height,
          settings.additionalInfoFontSize!,
          settings.additionalInfoColor!,
          settings.additionalInfoFontFamily!,
        );
      }
      
      // End recording and create an image
      final picture = recorder.endRecording();
      final img = await picture.toImage(
        templateImage.width.toInt(),
        templateImage.height.toInt(),
      );
      
      // Convert the image to bytes
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();
      
      // Write to a file
      final file = File(certificatePath);
      await file.writeAsBytes(buffer);
      
      return file;
    } catch (e) {
      debugPrint('Error generating certificate: $e');
      return null;
    }
  }

  // Draw text on a canvas
  static void _drawTextOnCanvas(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
    Color color,
    String fontFamily,
  ) {
    final textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    );
    
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    // Pastikan layout diatur dengan benar
    textPainter.layout(maxWidth: double.infinity);
    
    // Posisikan teks dengan tepat di tengah koordinat yang ditentukan
    // Gunakan nilai yang tepat tanpa pembulatan untuk posisi yang akurat
    final double xPos = x - (textPainter.width / 2);
    final double yPos = y - (textPainter.height / 2);
    final offset = Offset(xPos, yPos);
    
    // Tambahkan outline untuk membantu keterbacaan pada background berwarna
    if (color.computeLuminance() > 0.6) { // Jika warna teks terang
      // Gambar outline teks gelap untuk kontras
      final outlinePaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      
      final outlineTextPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: textStyle.copyWith(
            foreground: outlinePaint,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      
      outlineTextPainter.layout(maxWidth: double.infinity);
      outlineTextPainter.paint(canvas, offset);
    }
    
    // Gambar teks utama
    textPainter.paint(canvas, offset);
  }

  // Save an image to the downloads directory
  static Future<File?> saveImageToDownloads(File imageFile) async {
    try {
      // Request appropriate storage permissions based on platform and Android version
      bool permissionGranted = false;
      
      if (Platform.isAndroid) {
        // For Android, we need to request the appropriate storage permission
        // Try storage permission first (for older Android versions)
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) {
          permissionGranted = true;
        } else {
          // Request storage permission
          final storageResult = await Permission.storage.request();
          permissionGranted = storageResult.isGranted;
          
          // If storage permission is not granted, try media permission as fallback
          if (!permissionGranted) {
            try {
              final mediaStatus = await Permission.mediaLibrary.status;
              if (mediaStatus.isGranted) {
                permissionGranted = true;
              } else {
                final mediaResult = await Permission.mediaLibrary.request();
                permissionGranted = mediaResult.isGranted;
              }
            } catch (e) {
              debugPrint('Error requesting media permission: $e');
            }
          }
        }
      } else {
        // For iOS and other platforms
        permissionGranted = true; // Assume granted for non-Android platforms
      }
      
      if (!permissionGranted) {
        debugPrint('Storage permission not granted');
        return null;
      }

      // Gunakan nama file asli dari path
      final originalFileName = imageFile.path.split('/').last;
      
      // Untuk Android, simpan ke folder Download di penyimpanan eksternal
      if (Platform.isAndroid) {
        try {
          // Coba dapatkan direktori Downloads di penyimpanan eksternal
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            final savedFile = File('${directory.path}/$originalFileName');
            await imageFile.copy(savedFile.path);
            return savedFile;
          }
        } catch (e) {
          debugPrint('Error saving to external storage: $e');
          // Lanjutkan ke fallback jika gagal
        }
      }
      
      // Fallback ke getApplicationDocumentsDirectory()
      final docsDir = await getApplicationDocumentsDirectory();
      final savedFile = File('${docsDir.path}/$originalFileName');
      await imageFile.copy(savedFile.path);
      return savedFile;
    } catch (e) {
      debugPrint('Error saving image to downloads: $e');
      return null;
    }
  }

  // Create a preview of the certificate
  static Future<ui.Image> createPreview({
    required ui.Image templateImage,
    required String sampleName,
    required CertificateSettings settings,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Draw the template
    canvas.drawImage(templateImage, Offset.zero, Paint());
    
    // Draw sample name
    _drawTextOnCanvas(
      canvas,
      sampleName,
      settings.nameX * templateImage.width,
      settings.nameY * templateImage.height,
      settings.nameFontSize,
      settings.nameColor,
      settings.nameFontFamily,
    );
    
    // End recording and create an image
    final picture = recorder.endRecording();
    return await picture.toImage(
      templateImage.width.toInt(),
      templateImage.height.toInt(),
    );
  }
}
