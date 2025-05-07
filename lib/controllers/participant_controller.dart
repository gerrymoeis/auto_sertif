import 'package:flutter/material.dart';
import '../models/participant.dart';

class ParticipantController extends ChangeNotifier {
  List<Participant> _participants = [];
  
  List<Participant> get participants => _participants;
  
  // Add a single participant
  void addParticipant(Participant participant) {
    _participants.add(participant);
    notifyListeners();
  }
  
  // Add multiple participants from text input
  void addParticipantsFromText(String text, {bool hasRole = false, bool hasAdditionalInfo = false}) {
    // Split the text by new lines to get each participant entry
    final lines = text.split('\n');
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      // Split the line by comma or tab to get the different fields
      final parts = line.split(RegExp(r'[,\t]'));
      
      if (parts.isEmpty) continue;
      
      final name = parts[0].trim();
      String? role;
      String? additionalInfo;
      
      if (hasRole && parts.length > 1) {
        role = parts[1].trim();
      }
      
      if (hasAdditionalInfo && parts.length > 2) {
        additionalInfo = parts[2].trim();
      }
      
      if (name.isNotEmpty) {
        _participants.add(Participant(
          name: name,
          role: role,
          additionalInfo: additionalInfo,
        ));
      }
    }
    
    notifyListeners();
  }
  
  // Remove a participant
  void removeParticipant(int index) {
    if (index >= 0 && index < _participants.length) {
      _participants.removeAt(index);
      notifyListeners();
    }
  }
  
  // Update a participant
  void updateParticipant(int index, Participant participant) {
    if (index >= 0 && index < _participants.length) {
      _participants[index] = participant;
      notifyListeners();
    }
  }
  
  // Clear all participants
  void clearParticipants() {
    _participants.clear();
    notifyListeners();
  }
  
  // Get participant count
  int get participantCount => _participants.length;
  
  // Check if the list is empty
  bool get isEmpty => _participants.isEmpty;
}
