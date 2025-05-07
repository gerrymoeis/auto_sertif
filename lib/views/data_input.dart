import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/participant_controller.dart';
import '../models/certificate_settings.dart';
import '../models/participant.dart';
import '../widgets/custom_button.dart';
import 'export_screen.dart';

class DataInputScreen extends StatefulWidget {
  final File templateFile;
  final CertificateSettings settings;

  const DataInputScreen({
    Key? key,
    required this.templateFile,
    required this.settings,
  }) : super(key: key);

  @override
  State<DataInputScreen> createState() => _DataInputScreenState();
}

class _DataInputScreenState extends State<DataInputScreen> {
  final ParticipantController _participantController = ParticipantController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  
  bool _hasRole = false;
  bool _isAddingParticipant = false;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _toggleAddParticipant() {
    setState(() {
      _isAddingParticipant = !_isAddingParticipant;
      if (!_isAddingParticipant) {
        _nameController.clear();
        _roleController.clear();
      }
    });
  }

  void _addParticipant() {
    if (_nameController.text.isNotEmpty) {
      _participantController.addParticipant(
        Participant(
          name: _nameController.text.trim(),
          role: _hasRole ? _roleController.text.trim() : null,
          additionalInfo: null, // Removed additionalInfo
        ),
      );
      
      _nameController.clear();
      _roleController.clear();
      
      setState(() {});
    }
  }

  // Removed bulk input processing method

  void _removeParticipant(int index) {
    _participantController.removeParticipant(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Input Data Peserta'),
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
              // Instructions
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D44).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF6E6AE8).withOpacity(0.2),
                    width: 1,
                  ),
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
                      'Tambahkan peserta satu per satu dengan mengisi form di bawah ini.',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Field Options
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D44).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _hasRole,
                      onChanged: (value) {
                        setState(() {
                          _hasRole = value ?? false;
                        });
                      },
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFF6E6AE8);
                          }
                          return Colors.grey;
                        },
                      ),
                    ),
                    const Text(
                      'Jabatan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              // Input Form
              Expanded(
                child: _buildSingleInputForm(),
              ),
              
              // Participant Count and Next Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D44),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jumlah Peserta: ${_participantController.participantCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: _participantController.isEmpty
                              ? null
                              : () {
                                  _participantController.clearParticipants();
                                  setState(() {});
                                },
                          child: const Text(
                            'Hapus Semua',
                            style: TextStyle(
                              color: Color(0xFFE57373),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Buat Sertifikat',
                      icon: Icons.check_circle_outline,
                      isFullWidth: true,
                      backgroundColor: const Color(0xFF6E6AE8),
                      onPressed: _participantController.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExportScreen(
                                    templateFile: widget.templateFile,
                                    settings: widget.settings,
                                    participants: _participantController.participants,
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

  Widget _buildBulkInputForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
                const Text(
                  'Format:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _hasRole
                      ? 'Nama, Jabatan'
                      : 'Nama',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Contoh:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _hasRole
                      ? 'John Doe, Manager\nJane Smith, Designer'
                      : 'John Doe\nJane Smith',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          if (_participantController.participantCount > 0) ...[
            const SizedBox(height: 15),
            const Text(
              'Daftar Peserta:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
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
              child: ListView.builder(
                itemCount: _participantController.participantCount,
                itemBuilder: (context, index) {
                  final participant = _participantController.participants[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      participant.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: participant.role != null || participant.additionalInfo != null
                        ? Text(
                            [
                              if (participant.role != null) participant.role,
                              if (participant.additionalInfo != null) participant.additionalInfo,
                            ].join(' - '),
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _removeParticipant(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSingleInputForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isAddingParticipant) ...[
            // Name Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nama Peserta',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Role Field (if enabled)
            if (_hasRole) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                child: TextField(
                  controller: _roleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Jabatan',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            
            // Additional Info Field removed
            
            // Add Button
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Tambahkan',
                    icon: Icons.add,
                    isFullWidth: true,
                    backgroundColor: const Color(0xFF6E6AE8),
                    onPressed: _addParticipant,
                  ),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  text: 'Batal',
                  icon: Icons.close,
                  backgroundColor: const Color(0xFF94A3B8),
                  onPressed: _toggleAddParticipant,
                ),
              ],
            ),
          ] else ...[
            CustomButton(
              text: 'Tambah Peserta',
              icon: Icons.add,
              isFullWidth: true,
              backgroundColor: const Color(0xFF6E6AE8),
              onPressed: _toggleAddParticipant,
            ),
          ],
          
          const SizedBox(height: 15),
          
          // Participant List
          if (_participantController.participantCount > 0) ...[
            const Text(
              'Daftar Peserta:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
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
                child: ListView.builder(
                  itemCount: _participantController.participantCount,
                  itemBuilder: (context, index) {
                    final participant = _participantController.participants[index];
                    return ListTile(
                      title: Text(
                        participant.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: participant.role != null || participant.additionalInfo != null
                          ? Text(
                              [
                                if (participant.role != null) participant.role,
                                if (participant.additionalInfo != null) participant.additionalInfo,
                              ].join(' - '),
                              style: TextStyle(color: Colors.grey[400]),
                            )
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Color(0xFFE57373)),
                        onPressed: () => _removeParticipant(index),
                        tooltip: 'Hapus peserta',
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else if (!_isAddingParticipant) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 60,
                      color: const Color(0xFF6E6AE8).withOpacity(0.5),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Belum ada peserta',
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
          ],
        ],
      ),
    );
  }
}
