
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mounarchtech_task/models/user_model.dart';
import 'package:mounarchtech_task/screens/registration_screen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

 await Hive.openBox<UserModel>('userData');
  runApp(const Myapp());
}

class Myapp extends StatelessWidget{
const Myapp({super.key});

@override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: SignUpScreen(),
    );
  }




}