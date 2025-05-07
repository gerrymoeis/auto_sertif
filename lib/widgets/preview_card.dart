import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PreviewCard extends StatelessWidget {
  final File? imageFile;
  final ui.Image? previewImage;
  final String title;
  final VoidCallback? onTap;

  const PreviewCard({
    Key? key,
    this.imageFile,
    this.previewImage,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: _buildPreviewImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tap to view or edit',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage() {
    if (previewImage != null) {
      return CustomPaint(
        size: Size(
          previewImage!.width.toDouble(),
          previewImage!.height.toDouble(),
        ),
        painter: ImagePainter(previewImage!),
      );
    } else if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    } else {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey[800],
        child: const Center(
          child: Icon(
            Icons.image,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImage(image, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
