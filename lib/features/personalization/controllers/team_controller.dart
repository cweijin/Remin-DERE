import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/data/repositories/team/team_repository.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/utils/popups/loaders.dart';

class TeamController extends GetxController {
  static TeamController get instance => Get.find();

  final teamRepository = Get.put(TeamRepository());
  final localStorage = GetStorage();
  RxBool refreshData = true.obs;

  // Fetch all user specific teams
  Future<List<TeamModel>> getAllUserTeams() async {
    try {
      final localStorage = GetStorage();
      final teams = await teamRepository.fetchUserTeams();
      final selected = await teamRepository
          .fetchTeamFromId(localStorage.read('CurrentTeam'));
      if (teams.contains(selected)) {
        teams.insert(0, teams.removeAt(teams.indexOf(selected)));
      }
      return teams;
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Team not found', message: e.toString());
      return [];
    }
  }

  // Fetch team specific members from teamId
  Future<List<UserModel>> getTeamMembers(String teamId) async {
    try {
      return await teamRepository.fetchTeamMembers(teamId);
    } catch (e) {
      RLoaders.errorSnackBar(title: 'Team not found', message: e.toString());
      return [];
    }
  }

  // Change current selected team.
  void selectTeam(String teamId) {
    localStorage.write('CurrentTeam', teamId);
    refreshData.toggle();
  }
}
