import 'dart:io';
import 'package:flutter/material.dart';
import '../models/certificate_settings.dart';
import '../models/participant.dart';
import '../utils/image_utils.dart';
import 'dart:ui' as ui;
import '../utils/zip_utils.dart';

class CertificateController extends ChangeNotifier {
  File? _templateFile;
  CertificateSettings? _settings;
  bool _isGenerating = false;
  double _generationProgress = 0.0;
  List<File> _generatedCertificates = [];
  File? _zipFile;
  
  // Getters
  File? get templateFile => _templateFile;
  CertificateSettings? get settings => _settings;
  bool get isGenerating => _isGenerating;
  double get generationProgress => _generationProgress;
  List<File> get generatedCertificates => _generatedCertificates;
  File? get zipFile => _zipFile;
  bool get hasTemplate => _templateFile != null;
  bool get hasSettings => _settings != null;
  
  // Set template file
  void setTemplateFile(File file) {
    _templateFile = file;
    notifyListeners();
  }
  
  // Set certificate settings
  void setSettings(CertificateSettings settings) {
    _settings = settings;
    notifyListeners();
  }
  
  // Generate certificates for all participants
  Future<bool> generateCertificates(List<Participant> participants) async {
    if (_templateFile == null || _settings == null) {
      return false;
    }
    
    try {
      _isGenerating = true;
      _generationProgress = 0.0;
      _generatedCertificates = [];
      _zipFile = null;
      notifyListeners();
      
      for (int i = 0; i < participants.length; i++) {
        final participant = participants[i];
        
        final certificateFile = await ImageUtils.generateCertificate(
          templateFile: _templateFile!,
          participant: participant,
          settings: _settings!,
        );
        
        if (certificateFile != null) {
          _generatedCertificates.add(certificateFile);
        }
        
        _generationProgress = (i + 1) / participants.length;
        notifyListeners();
      }
      
      // Create ZIP file if certificates were generated
      if (_generatedCertificates.isNotEmpty) {
        _zipFile = await ZipUtils.createZipFromFiles(
          _generatedCertificates,
          'certificates',
          onProgress: (progress) {
            // ZIP creation progress is shown after certificate generation
            _generationProgress = 0.9 + (progress * 0.1);
            notifyListeners();
          },
        );
      }
      
      _isGenerating = false;
      _generationProgress = 1.0;
      notifyListeners();
      
      return _generatedCertificates.isNotEmpty && _zipFile != null;
    } catch (e) {
      debugPrint('Error generating certificates: $e');
      _isGenerating = false;
      notifyListeners();
      return false;
    }
  }
  
  // Save the ZIP file to downloads
  Future<File?> saveZipToDownloads() async {
    if (_zipFile == null) return null;
    
    try {
      final savedFile = await ZipUtils.saveZipToDownloads(_zipFile!);
      return savedFile;
    } catch (e) {
      debugPrint('Error saving ZIP to downloads: $e');
      return null;
    }
  }
  
  // Clear generated certificates
  void clearGeneratedCertificates() {
    for (final file in _generatedCertificates) {
      try {
        file.deleteSync();
      } catch (e) {
        debugPrint('Error deleting certificate file: $e');
      }
    }
    
    if (_zipFile != null) {
      try {
        _zipFile!.deleteSync();
      } catch (e) {
        debugPrint('Error deleting ZIP file: $e');
      }
    }
    
    _generatedCertificates = [];
    _zipFile = null;
    notifyListeners();
  }
  
  // Reset controller
  void reset() {
    clearGeneratedCertificates();
    _templateFile = null;
    _settings = null;
    _isGenerating = false;
    _generationProgress = 0.0;
    notifyListeners();
  }
}
