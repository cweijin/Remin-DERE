import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/data/repositories/authentication_repository/authentication_repository.dart';
import 'package:remindere/features/development/models/notification/notification_model.dart';
import 'package:remindere/features/personalization/controllers/team_controller.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:remindere/utils/exceptions/firebase_exceptions.dart';
import 'package:remindere/utils/exceptions/format_exceptions.dart';
import 'package:remindere/utils/exceptions/platform_exceptions.dart';

class TeamRepository extends GetxController {
  static TeamRepository get instance => Get.find();
  final localStorage = GetStorage();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentReference<Map<String, dynamic>>> saveTeamDetails(
      TeamModel team) async {
    try {
      return await _db
          .collection('Users')
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .collection("Teams")
          .add(team.toJSON())
          .then(
        (value) async {
          //get a new team model with id updated
          team = team.setId(value.id);

          // update id field
          _db
              .collection("Users")
              .doc(AuthenticationRepository.instance.authUser!.uid)
              .collection("Teams")
              .doc(value.id)
              .update({"Id": value.id});

          await localStorage.write('CurrentTeam', value.id);
          await localStorage.write('CurrentTeamName', team.teamName);

          // Add to Teams collection
          await _db.collection("Teams").doc(value.id).set(team.toJSON());

          // Create a notification to update related users
          final notification = NotificationModel(
            title: team.teamName,
            where: '',
            timeCreated: DateTime.now(),
            createdBy: AuthenticationRepository.instance.authUser!.uid,
            type: NotificationType.teamCreation,
          );

          // upload team data to each team member
          for (String userId in team.teamMembers) {
            // No need to notify owner
            if (userId == UserController.instance.user.value.id) continue;

            await _db
                .collection('Users')
                .doc(userId)
                .collection('Teams')
                .doc(value.id)
                .set(team.toJSON());

            await _db
                .collection('Users')
                .doc(userId)
                .collection('Notifications')
                .add(notification.toJSON());

            await _db
                .collection('Users')
                .doc(userId)
                .update({'Unread': FieldValue.increment(1)});
          }

          await TeamController.instance.fetchCurrentTeam();
          NavigationController.instance.verifyOwnership();
          return value;
        },
      );
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

  Future<void> removeTeamDetails(TeamModel team) async {
    try {
      // Create a notification to update related users
      // final notification = NotificationModel(
      //   title: team.teamName,
      //   where: '',
      //   timeCreated: DateTime.now(),
      //   createdBy: AuthenticationRepository.instance.authUser!.uid,
      //   type: NotificationType.teamCreation,
      // );

      // remove team data from each team member
      for (String userId in team.teamMembers) {
        await _db
            .collection('Users')
            .doc(userId)
            .collection('Teams')
            .doc(team.id)
            .delete();

        // No need to notify owner
        // if (userId == UserController.instance.user.value.id) continue;

        // await _db
        //     .collection('Users')
        //     .doc(userId)
        //     .collection('Notifications')
        //     .add(notification.toJSON());

        // await _db
        //     .collection('Users')
        //     .doc(userId)
        //     .update({'Unread': FieldValue.increment(1)});
      }

      // Remove from Teams collection
      await _db.collection("Teams").doc(team.id).delete();
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

  Future<TeamModel> fetchTeamFromId(String id) async {
    try {
      return await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .collection("Teams")
          .doc(id)
          .get()
          .then((value) => TeamModel.fromSnapshot(value));
    } catch (e) {
      throw 'Something went wrong while fetching team data. Please try again later.';
    }
  }

  Future<List<UserModel>> fetchTeamMembers(String teamId) async {
    try {
      final membersId = await _db
          .collection("Teams")
          .doc(teamId)
          .get()
          .then((value) => List<String>.from(value.data()!['TeamMembers']));

      final userModelFutures = membersId
          .map((id) async => UserModel.fromSnapshot(
              await _db.collection("Users").doc(id).get()))
          .toList();

      return Future.wait(userModelFutures);
    } catch (e) {
      throw 'Something went wrong while fetching user data. Please try again later.';
    }
  }
}
