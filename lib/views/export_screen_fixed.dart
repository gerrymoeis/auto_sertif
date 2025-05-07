import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/certificate_controller.dart';
import '../models/certificate_settings.dart';
import '../models/participant.dart';
import '../widgets/custom_button.dart';
import '../widgets/preview_card.dart';
import '../widgets/progress_indicator.dart';

class ExportScreen extends StatefulWidget {
  final File templateFile;
  final CertificateSettings settings;
  final List<Participant> participants;

  const ExportScreen({
    Key? key,
    required this.templateFile,
    required this.settings,
    required this.participants,
  }) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final CertificateController _certificateController = CertificateController();
  bool _isGenerating = false;
  bool _isExporting = false;
  bool _isCompleted = false;
  String? _exportPath;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _certificateController.setTemplateFile(widget.templateFile);
    _certificateController.setSettings(widget.settings);
  }

  Future<void> _generateCertificates() async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final success = await _certificateController.generateCertificates(widget.participants);
      
      setState(() {
        _isGenerating = false;
        _isCompleted = success;
        if (!success) {
          _errorMessage = 'Gagal membuat sertifikat. Silakan coba lagi.';
        }
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _exportCertificates() async {
    setState(() {
      _isExporting = true;
      _errorMessage = null;
    });

    try {
      final savedFile = await _certificateController.saveZipToDownloads();
      
      setState(() {
        _isExporting = false;
        if (savedFile != null) {
          _exportPath = savedFile.path;
        } else {
          _errorMessage = 'Gagal menyimpan file. Silakan coba lagi.';
        }
      });
    } catch (e) {
      setState(() {
        _isExporting = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  void _showPreviewDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D44),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Preview Sertifikat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Simpan Sertifikat Ini'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E6AE8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {
                    // Implementasi untuk menyimpan sertifikat tunggal
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Generate & Export Sertifikat'),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D44).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
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
                        const Text(
                          'Ringkasan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildSummaryItem(
                          icon: Icons.image,
                          label: 'Template',
                          value: widget.templateFile.path.split('/').last,
                        ),
                        _buildSummaryItem(
                          icon: Icons.people,
                          label: 'Jumlah Peserta',
                          value: widget.participants.length.toString(),
                        ),
                        _buildSummaryItem(
                          icon: Icons.text_fields,
                          label: 'Font',
                          value: widget.settings.nameFontFamily,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Generate Button or Progress
                  if (_isGenerating) ...[
                    Center(
                      child: CustomProgressIndicator(
                        progress: _certificateController.generationProgress,
                        message: 'Membuat sertifikat (${(_certificateController.generationProgress * 100).toInt()}%)...',
                      ),
                    ),
                  ] else if (!_isCompleted) ...[
                    CustomButton(
                      text: 'Buat Sertifikat',
                      icon: Icons.auto_awesome,
                      isFullWidth: true,
                      backgroundColor: const Color(0xFF6E6AE8),
                      onPressed: _generateCertificates,
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                  
                  // Results Section
                  if (_isCompleted) ...[
                    const Text(
                      'Hasil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Preview of first certificate
                    if (_certificateController.generatedCertificates.isNotEmpty) ...[
                      PreviewCard(
                        imageFile: _certificateController.generatedCertificates.first,
                        title: 'Preview Sertifikat',
                        onTap: () => _showPreviewDialog(_certificateController.generatedCertificates.first),
                      ),
                      const SizedBox(height: 20),
                      
                      // Export Button
                      if (_exportPath == null) ...[
                        _isExporting
                            ? const Center(
                                child: CustomProgressIndicator(
                                  isIndeterminate: true,
                                  message: 'Menyimpan file ZIP...',
                                ),
                              )
                            : CustomButton(
                                text: 'Simpan Semua Sertifikat (ZIP)',
                                icon: Icons.download,
                                isFullWidth: true,
                                backgroundColor: const Color(0xFF6E6AE8),
                                onPressed: _exportCertificates,
                              ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16),
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
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Berhasil!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'File ZIP berhasil disimpan di:',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _exportPath!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 15),
                              CustomButton(
                                text: 'Kembali ke Home',
                                icon: Icons.home,
                                isFullWidth: true,
                                backgroundColor: const Color(0xFF6E6AE8),
                                onPressed: () {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                  
                  // Error Message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF6E6AE8),
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
