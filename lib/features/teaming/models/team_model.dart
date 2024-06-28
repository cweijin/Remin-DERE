import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String teamName;
  final List<String> teamMembers;

  const TeamModel({
    required this.teamName,
    required this.teamMembers,
  });

  Map<String, dynamic> toJSON() {
    return {
      "TeamName": teamName,
      "TeamMembers": teamMembers,
    };
  }

  static TeamModel empty() => const TeamModel(
        teamName: '',
        teamMembers: [],
      );

  // Factory method to create a UserModel from a Firebase document snapshot
  factory TeamModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return TeamModel(
        teamName: data["TeamName"] ?? ' ',
        teamMembers: List<String>.from(data[
            "TeamMembers"]), //**Firestore returns us List<dynamic> causing incompatible type, this is a workaround.
      );
    } else {
      return TeamModel.empty();
    }
  }
}
