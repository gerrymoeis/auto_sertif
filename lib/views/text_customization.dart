import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/certificate_settings.dart';
import '../widgets/custom_button.dart';
import 'data_input.dart';

class TextCustomizationScreen extends StatefulWidget {
  final File templateFile;

  const TextCustomizationScreen({
    Key? key,
    required this.templateFile,
  }) : super(key: key);

  @override
  State<TextCustomizationScreen> createState() => _TextCustomizationScreenState();
}

class _TextCustomizationScreenState extends State<TextCustomizationScreen> {
  // Event name
  String _eventName = 'Acara Sertifikat';
  
  // Text position
  double _nameX = 0.5;
  double _nameY = 0.5;
  
  // Text styling
  double _nameFontSize = 36;
  Color _nameColor = Colors.black;
  String _nameFontFamily = 'Inter';
  
  // Sample text
  String _sampleName = 'Nama Peserta';
  
  // Available fonts
  final List<String> _availableFonts = [
    'Inter',
    'Roboto',
    'Montserrat',
    'Poppins',
    'Open Sans',
    'Lato',
  ];
  
  // Preview key for capturing the preview as an image
  final GlobalKey _previewKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Kustomisasi Teks'),
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
          child: Column(
            children: [
              // Template Preview with Draggable Text
              Expanded(
                child: RepaintBoundary(
                  key: _previewKey,
                  child: Stack(
                    children: [
                      // Template Image
                      Center(
                        child: Image.file(
                          widget.templateFile,
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      // Draggable Sample Text
                      Positioned(
                        left: _nameX * MediaQuery.of(context).size.width,
                        top: _nameY * MediaQuery.of(context).size.height * 0.7,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              _nameX += details.delta.dx / MediaQuery.of(context).size.width;
                              _nameY += details.delta.dy / (MediaQuery.of(context).size.height * 0.7);
                              
                              // Clamp values to stay within bounds
                              _nameX = _nameX.clamp(0.0, 1.0);
                              _nameY = _nameY.clamp(0.0, 1.0);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(
                                color: const Color(0xFF4F46E5),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _sampleName,
                              style: GoogleFonts.getFont(
                                _nameFontFamily,
                                fontSize: _nameFontSize,
                                color: _nameColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Text Customization Controls
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D44).withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kustomisasi Teks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Event Name Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF232336),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF6E6AE8).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Acara',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Masukkan nama acara',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              filled: true,
                              fillColor: const Color(0xFF2D2D44),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            controller: TextEditingController(text: _eventName),
                            onChanged: (value) {
                              setState(() {
                                _eventName = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Font Size Slider
                    Row(
                      children: [
                        const Icon(
                          Icons.format_size,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Ukuran Font:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _nameFontSize,
                            min: 12,
                            max: 72,
                            divisions: 60,
                            activeColor: const Color(0xFF6E6AE8),
                            inactiveColor: const Color(0xFF94A3B8).withOpacity(0.3),
                            label: _nameFontSize.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                _nameFontSize = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          _nameFontSize.round().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    // Font Family Dropdown
                    Row(
                      children: [
                        const Icon(
                          Icons.font_download,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Font:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D2D44).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF6E6AE8).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _nameFontFamily,
                                dropdownColor: const Color(0xFF2D2D44),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                isExpanded: true,
                                onChanged: (String? value) {
                                  if (value != null) {
                                    setState(() {
                                      _nameFontFamily = value;
                                    });
                                  }
                                },
                                items: _availableFonts.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: GoogleFonts.getFont(value),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Text Color Picker
                    Row(
                      children: [
                        const Icon(
                          Icons.color_lens,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Warna Teks:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            _showColorPicker();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _nameColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.7),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _nameColor.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        
                        // Sample Text Input
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2D44).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF6E6AE8).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Contoh teks',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _sampleName = value.isEmpty ? 'Nama Peserta' : value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Next Button
                    CustomButton(
                      text: 'Lanjutkan',
                      icon: Icons.arrow_forward,
                      isFullWidth: true,
                      backgroundColor: const Color(0xFF6E6AE8),
                      onPressed: () {
                        // Create certificate settings
                        final settings = CertificateSettings(
                          eventName: _eventName,
                          nameX: _nameX,
                          nameY: _nameY,
                          nameFontSize: _nameFontSize,
                          nameColor: _nameColor,
                          nameFontFamily: _nameFontFamily,
                        );
                        
                        // Navigate to data input screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DataInputScreen(
                              templateFile: widget.templateFile,
                              settings: settings,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Warna Teks'),
        backgroundColor: const Color(0xFF2D2D44),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _nameColor,
            onColorChanged: (color) {
              setState(() {
                _nameColor = color;
              });
            },
            pickerAreaHeightPercent: 0.8,
            displayThumbColor: true,
            paletteType: PaletteType.hsl,
            pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6E6AE8),
            ),
            child: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
