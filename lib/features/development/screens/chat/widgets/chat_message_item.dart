import 'package:flutter/material.dart';
import 'package:remindere/utils/constants/colors.dart';
import 'package:remindere/utils/constants/sizes.dart';
import 'package:remindere/features/development/screens/chat/models/chat_message_model.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessageModel message;

  const ChatMessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    double radius = 12.0;

    return Row(
      mainAxisAlignment: message.fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        message.fromMe
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                // if read, blue. if unread, grey.
                child: Icon(Icons.check_circle, size: 20, color: message.read == false ? Colors.grey : Colors.blue[400]),
              )
            : const SizedBox(),
        Card(
          color: message.fromMe ? Colors.blue[300] : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: message.fromMe ? Radius.circular(radius) : const Radius.circular(2.0),
              topRight: message.fromMe ? const Radius.circular(2.0) : Radius.circular(radius),
              bottomLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Container(
                      alignment: message.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(message.message),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    alignment: message.fromMe ? Alignment.centerLeft : Alignment.centerRight,
                    child: Text(message.time, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              )
            )
          )
        )
      ]
    );
  }
}