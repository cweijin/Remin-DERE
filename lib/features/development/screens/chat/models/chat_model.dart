import "dart:developer";

class ChatModel {
  String receiverID;
  String? receiverUsername;
  DateTime? updatedAt;
  DateTime lastMessage;
  int unreadMessagesCount;
  
  // ValueNotifier<int> notifier = ValueNotifier(0);
  bool isOpen = false;

  ChatModel({
    required this.receiverID,
    required this.receiverUsername,
    required this.updatedAt,
    required this.lastMessage,
    required this.unreadMessagesCount
  });

  static ChatModel empty() => ChatModel(
        receiverID: '',
        receiverUsername: '',
        updatedAt: DateTime.now(),
        lastMessage: DateTime.now(),
        unreadMessagesCount: 0
      );
  

  // Whatever function needed.

  Map<String, dynamic> toJSON() {
    return {
      'receiverID': receiverID,  // not required since document id is receiver id
      'receiverUsername': receiverUsername,
      'updatedAt': (updatedAt != null) ? updatedAt!.toIso8601String() : DateTime.now().toIso8601String(),
      'lastMessage': lastMessage.toIso8601String(),
      'unreadMessagesCount': unreadMessagesCount
      };
  }

  // Factory method to create a ChatModel from JSON
  factory ChatModel.fromJSON(
      Map<String, dynamic> snapshot) {
    if (snapshot.isNotEmpty) {
      final data = snapshot['details'];
      // log("here Chatmodel from Json is called");
      // log(snapshot.toString());
      // log(data.toString());
      final chat = ChatModel(
          receiverID: data['receiverID'],
          receiverUsername: data['receiverUsername'],
          updatedAt: DateTime.parse(data['updatedAt']),  // temporary workaround
          lastMessage: DateTime.parse(data['lastMessage']),
          unreadMessagesCount: data['unreadMessagesCount']
          );
      // log(chat.toString());
      // log("here Chatmodel from Json is returned");
      return chat;
    } else {
      return ChatModel.empty();
    }
  }
  
  void updateLastMessage(DateTime message) {
    lastMessage = message;
    unreadMessagesCount++;
  }

  void readMessages() {
    unreadMessagesCount = 0;
  }

  void createChat() {
    isOpen = true;
  }
}