import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ZipUtils {
  // Create a ZIP file from a list of files
  static Future<File?> createZipFromFiles(
    List<File> files, 
    String zipName,
    {Function(double)? onProgress}
  ) async {
    try {
      // Create an Archive object
      final archive = Archive();
      
      // Add each file to the archive
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final bytes = await file.readAsBytes();
        
        // Create an ArchiveFile and add it to the archive
        final archiveFile = ArchiveFile(
          file.path.split('/').last,
          bytes.length,
          bytes,
        );
        archive.addFile(archiveFile);
        
        // Report progress
        if (onProgress != null) {
          onProgress((i + 1) / files.length);
        }
      }
      
      // Encode the archive as a ZIP
      final zipData = ZipEncoder().encode(archive);
      if (zipData == null) return null;
      
      // Save the ZIP to a file
      final tempDir = await getTemporaryDirectory();
      final zipFile = File('${tempDir.path}/$zipName.zip');
      await zipFile.writeAsBytes(zipData);
      
      return zipFile;
    } catch (e) {
      debugPrint('Error creating ZIP file: $e');
      return null;
    }
  }
  
  // Save a ZIP file to the Downloads directory
  static Future<File?> saveZipToDownloads(File zipFile) async {
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
      
      // Untuk Android, simpan ke folder Download di penyimpanan eksternal
      if (Platform.isAndroid) {
        try {
          // Coba dapatkan direktori Downloads di penyimpanan eksternal
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            final fileName = 'certificates_${DateTime.now().millisecondsSinceEpoch}.zip';
            final savedFile = File('${directory.path}/$fileName');
            await zipFile.copy(savedFile.path);
            return savedFile;
          }
        } catch (e) {
          debugPrint('Error saving to external storage: $e');
          // Lanjutkan ke fallback jika gagal
        }
      }
      
      // Fallback ke getDownloadsDirectory()
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        debugPrint('Downloads directory not found');
        return null;
      }
      
      final fileName = 'certificates_${DateTime.now().millisecondsSinceEpoch}.zip';
      final savedFile = File('${downloadsDir.path}/$fileName');
      await zipFile.copy(savedFile.path);
      return savedFile;
    } catch (e) {
      debugPrint('Error saving ZIP to downloads: $e');
      return null;
    }
  }
  
  // Get the downloads directory
  static Future<Directory> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory;
      }
      // Fall back to app documents directory if Download doesn't exist
      return await getApplicationDocumentsDirectory();
    } else {
      // For other platforms, use the application documents directory
      return await getApplicationDocumentsDirectory();
    }
  }
}
