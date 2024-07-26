class SubmissionModel {
  final List<String> attachments;
  final String taskOwnerId;
  final String taskId;
  final String taskName;
  final DateTime submittedAt;
  SubmissionModel(
      {required this.attachments,
      required this.taskOwnerId,
      required this.taskId,
      required this.taskName,
      required this.submittedAt});

  static SubmissionModel empty() => SubmissionModel(
        attachments: [],
        taskOwnerId: '',
        taskId: '',
        taskName: '',
        submittedAt: DateTime(1000),
      );

  // Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJSON() {
    return {
      'Attachments': attachments,
      'TaskOwner': taskOwnerId,
      'TaskId': taskId,
      'TaskName': taskName,
      'SubmittedAt': submittedAt.toIso8601String(),
    };
  }

  // Factory method to create a CommentModel from a JSON
  factory SubmissionModel.fromJSON(Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      return SubmissionModel(
        attachments: List<String>.from(data['Attachments'] ?? []),
        taskOwnerId: data['TaskOwner'] ?? '',
        taskId: data['TaskId'] ?? '',
        taskName: data['TaskName'] ?? '',
        submittedAt: DateTime.parse(data['SubmittedAt']).toLocal(),
      );
    } else {
      return SubmissionModel.empty();
    }
  }
}
