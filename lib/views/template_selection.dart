import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/custom_button.dart';
import 'text_customization.dart';

class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Request permission if needed
      if (source == ImageSource.camera) {
        // Request camera permission
        final cameraStatus = await Permission.camera.status;
        if (!cameraStatus.isGranted) {
          final result = await Permission.camera.request();
          if (!result.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Izin kamera dibutuhkan untuk mengambil foto'),
                duration: Duration(seconds: 3),
              ),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }
      } else {
        // Request storage permissions for gallery access
        // For Android 13+ (SDK 33+), we need READ_MEDIA_IMAGES
        // For older versions, we need READ_EXTERNAL_STORAGE
        Permission permission;
        
        if (Platform.isAndroid) {
          if (await Permission.mediaLibrary.status.isGranted) {
            // Already granted
          } else {
            // Try requesting the appropriate permission based on Android version
            try {
              permission = Permission.mediaLibrary;
              final result = await permission.request();
              if (!result.isGranted) {
                // Try the older permission as fallback
                permission = Permission.storage;
                final storageResult = await permission.request();
                if (!storageResult.isGranted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Izin akses galeri dibutuhkan untuk memilih gambar'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                }
              }
            } catch (e) {
              // Fallback to storage permission if there's an error
              permission = Permission.storage;
              final result = await permission.request();
              if (!result.isGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Izin akses penyimpanan dibutuhkan untuk memilih gambar'),
                    duration: Duration(seconds: 3),
                  ),
                );
                setState(() {
                  _isLoading = false;
                });
                return;
              }
            }
          }
        } else if (Platform.isIOS) {
          // iOS uses photos permission
          final photosStatus = await Permission.photos.status;
          if (!photosStatus.isGranted) {
            final result = await Permission.photos.request();
            if (!result.isGranted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Izin akses galeri dibutuhkan untuk memilih gambar'),
                  duration: Duration(seconds: 3),
                ),
              );
              setState(() {
                _isLoading = false;
              });
              return;
            }
          }
        }
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D44),
        title: const Text(
          'Pilih Sumber Gambar',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF6E6AE8),
              ),
              title: const Text(
                'Galeri',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: Color(0xFF94A3B8),
              ),
              title: const Text(
                'Kamera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Pilih Template Sertifikat'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E1E2E),
              const Color(0xFF2D2D44),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D44).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF6E6AE8).withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6E6AE8).withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF6E6AE8),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Petunjuk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '1. Pilih gambar template sertifikat dari galeri atau kamera\n'
                        '2. Pastikan template memiliki ruang kosong untuk nama peserta\n'
                        '3. Gambar dengan resolusi tinggi akan menghasilkan sertifikat yang lebih baik',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Template Preview
                Expanded(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _showImageSourceDialog,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D44).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF6E6AE8).withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6E6AE8).withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 80,
                                      color: const Color(0xFF6E6AE8).withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Tap untuk memilih template',
                                      style: const TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Next Button
                CustomButton(
                  text: 'Lanjutkan',
                  icon: Icons.arrow_forward,
                  isFullWidth: true,
                  backgroundColor: const Color(0xFF6E6AE8),
                  onPressed: _selectedImage == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TextCustomizationScreen(
                                templateFile: _selectedImage!,
                              ),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
