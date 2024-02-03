// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'widgets/bubble_chat.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              "data:image/jpeg;base64,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",
            ),
          ),
        ),
        title: const Text("Indira JKT48"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              reverse: true,
              padding: const EdgeInsets.all(10.0),
              children: [
                ChatBubble(
                  direction: Direction.right,
                  message: 'Pagi juga sayang....',
                  photoUrl: null,
                  type: BubbleType.alone,
                ),
                ChatBubble(
                  direction: Direction.left,
                  message: 'Pagi Sayang',
                  photoUrl: null,
                  type: BubbleType.alone,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Send message logic here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
