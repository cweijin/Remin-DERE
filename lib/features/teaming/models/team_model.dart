import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class TeamModel {
  final String teamName;
  final List<String> teamMembers;
  final String id;

  const TeamModel({
    required this.teamName,
    required this.teamMembers,
    required this.id,
  });

  Map<String, dynamic> toJSON() {
    return {
      "TeamName": teamName,
      "TeamMembers": teamMembers,
      "Id": id,
    };
  }

  static TeamModel empty() => const TeamModel(
        teamName: '',
        teamMembers: [],
        id: '',
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
        id: data["Id"] ?? '',
      );
    } else {
      return TeamModel.empty();
    }
  }

  TeamModel setId(String id) {
    return TeamModel(teamName: teamName, teamMembers: teamMembers, id: id);
  }

  @override
  String toString() {
    return "Team Model: $teamName";
  }

  @override
  bool operator ==(other) {
    if (other is TeamModel) {
      return other.id.toString() == id.toString();
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(id, teamName, teamMembers);
}
