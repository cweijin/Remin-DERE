import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';

class TeamRepository extends GetxController {
  static TeamRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTeamDetails(TeamModel team) async {
    try {
      await _db.collection("Teams").add(team.toJSON());
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .collection("Teams")
          .add(team.toJSON());
    } on FirebaseAuthException catch (e) {
      throw RFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RFormatException();
    } on PlatformException catch (e) {
      throw RPlatformException(e.code).message;
    } catch (e) {
      throw 'Unknown error. Please try again.';
    }
  }

  Future<List<TeamModel>> fetchUserTeams() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) {
        throw 'Unable to find user information. Try again in few minutes.';
      }
      final result =
          await _db.collection("Users").doc(userId).collection("Teams").get();
      return result.docs
          .map((docSnapshot) => TeamModel.fromSnapshot(docSnapshot))
          .toList();
      // return [
      //   const TeamModel(teamName: 'ABC', teamMembers: ['123'])
      // ];
    } catch (e) {
      throw 'Something went wrong while fetching team data. Please try again later.';
    }
  }
}
