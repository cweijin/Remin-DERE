import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindere/data/repositories/team/team_repository.dart';
import 'package:remindere/features/personalization/controllers/user_controller.dart';
import 'package:remindere/features/personalization/models/user_model.dart';
import 'package:remindere/features/teaming/models/team_model.dart';
import 'package:remindere/navigation_menu.dart';
import 'package:remindere/utils/popups/loaders.dart';

class TeamController extends GetxController {
  static TeamController get instance => Get.find();

  final teamRepository = Get.put(TeamRepository());
  final user = UserController.instance;
  final localStorage = GetStorage();
  // late Future<List<UserModel>> teamMemberFuture =
  //     getTeamMembers(localStorage.read('CurrentTeam'));
  RxBool refreshData = true.obs;

  Rx<TeamModel> team = TeamModel.empty().obs;

  final deviceStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    if (localStorage.read('CurrentTeam') != null) fetchCurrentTeam();
  }

  Future<void> fetchCurrentTeam() async {
    try {
      team.value = await teamRepository
          .fetchTeamFromId(localStorage.read('CurrentTeam'));
    } catch (e) {
      RLoaders.errorSnackBar(
          title: 'Team Fetching Failed', message: e.toString());
    }
  }

  // Fetch all user specific teams
  Future<List<TeamModel>> getAllUserTeams() async {
    try {
      final teams = await teamRepository.fetchUserTeams();
      if (deviceStorage.read('CurrentTeam') != null) {
        final selected = await teamRepository
            .fetchTeamFromId(deviceStorage.read('CurrentTeam'));
        if (teams.contains(selected)) {
          teams.insert(0, teams.removeAt(teams.indexOf(selected)));
        }
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
    fetchCurrentTeam();
    NavigationController.instance.verifyOwnership();
    // teamMemberFuture = getTeamMembers(teamId);
    refreshData.toggle();
  }
}
