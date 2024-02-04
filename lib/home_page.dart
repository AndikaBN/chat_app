// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:chat_app/data/data_source/firebase_datasource.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class HomePage extends StatefulWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.logout_outlined),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 243, 251, 255),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: FirebaseDatasource.instance.allUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<UserModel> users = (snapshot.data ?? [])
              .where((element) => element.id != currentUser!.uid)
              .toList();
          if (users.isEmpty) {
            return const Center(
              child: Text("Tidak ada user"),
            );
          }
          return ListView.builder(
            itemCount: users.length,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatView(
                              partnerUser: users[index],
                            )),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 117, 117, 117),
                      child: Center(
                        child: Text(
                          users[index].userName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    title: Text(users[index].userName),
                    subtitle: const Text("Programmer"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
