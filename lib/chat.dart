// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:chat_app/data/data_source/firebase_datasource.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/data/models/user_model.dart';

import 'data/models/channel_model.dart';
import 'widgets/bubble_chat.dart';

class ChatView extends StatefulWidget {
  final UserModel partnerUser;
  const ChatView({
    Key? key,
    required this.partnerUser,
  }) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.partnerUser.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
                stream: FirebaseDatasource.instance.messageStream(
                    channelid(widget.partnerUser.id, currentUser!.uid)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final List<Message> messages = snapshot.data ?? [];
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text("Tidak ada pesan"),
                    );
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    reverse: true,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatBubble(
                        direction: message.senderId == currentUser!.uid
                            ? Direction.right
                            : Direction.left,
                        message: message.textMessage,
                        type: BubbleType.alone,
                      );
                    },
                  );
                }),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final channel = Channel(
      id: channelid(currentUser!.uid, widget.partnerUser.id),
      memberIds: [currentUser!.uid, widget.partnerUser.id],
      members: [UserModel.fromFirebaseUser(currentUser!), widget.partnerUser],
      lastMessage: _messageController.text.trim(),
      sendBy: currentUser!.uid,
      lastTime: Timestamp.now(),
      unRead: {
        currentUser!.uid: false,
        widget.partnerUser.id: true,
      },
    );

    await FirebaseDatasource.instance
        .updateChannel(channel.id, channel.toMap());

    var docRef = FirebaseFirestore.instance.collection('messages').doc();
    var message = Message(
      id: docRef.id,
      textMessage: _messageController.text.trim(),
      senderId: currentUser!.uid,
      sendAt: Timestamp.now(),
      channelId: channel.id,
    );
    FirebaseDatasource.instance.addMessage(message);

    var channelUpdateData = {
      'lastMessage': message.textMessage,
      'sendBy': currentUser!.uid,
      'lastTime': message.sendAt,
      'unRead': {
        currentUser!.uid: false,
        widget.partnerUser.id: true,
      },
    };
    FirebaseDatasource.instance.updateChannel(channel.id, channelUpdateData);

    _messageController.clear();
  }
}
