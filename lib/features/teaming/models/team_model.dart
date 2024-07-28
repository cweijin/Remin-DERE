import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String teamName;
  final List<String> teamMembers;
  final String id;
  final String owner;

  const TeamModel({
    required this.teamName,
    required this.teamMembers,
    required this.id,
    required this.owner,
  });

  Map<String, dynamic> toJSON() {
    return {
      'TeamName': teamName,
      'TeamMembers': teamMembers,
      'Id': id,
      'Owner': owner,
    };
  }

  static TeamModel empty() => const TeamModel(
        teamName: '',
        teamMembers: [],
        id: '',
        owner: '',
      );

  // Factory method to create a UserModel from a Firebase document snapshot
  factory TeamModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return TeamModel(
        teamName: data["TeamName"] ?? '',
        teamMembers: List<String>.from(data["TeamMembers"] ?? []),
        //**Firestore returns us List<dynamic> causing incompatible type, this is a workaround.
        id: document.id,
        owner: data['Owner'] ?? '',
      );
    } else {
      return TeamModel.empty();
    }
  }

  TeamModel setId(String id) {
    return TeamModel(
        teamName: teamName, teamMembers: teamMembers, id: id, owner: owner);
  }

  @override
  String toString() {
    return 'Team Model: $teamName';
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
