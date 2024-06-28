import 'package:get/get.dart';
import 'package:remindere/data/repositories/team/team_repository.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/utils/popups/loaders.dart';

class TeamController extends GetxController {
  static TeamController get instance => Get.find();

  final teamRepository = Get.put(TeamRepository());

  // Fetch all user specific teams.
  Future<List<TeamModel>> getAllUserTeams() async {
    try {
      final teams = await teamRepository.fetchUserTeams();
      return teams;
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Team not found', message: e.toString());
      return [];
    }
  }
}
