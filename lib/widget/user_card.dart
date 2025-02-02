import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mounarchtech_task/models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        margin:const  EdgeInsets.all(20),
        child: Padding(
          padding:const  EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: user.imageUrl!.startsWith("http")
                    ? NetworkImage(user.imageUrl!)
                    : FileImage(File(user.imageUrl!)) as ImageProvider,
              ),
             const  SizedBox(height: 10),
              Text(user.name!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(user.email!, style:  const TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
