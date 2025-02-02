import 'package:flutter/material.dart';
import 'package:mounarchtech_task/screens/HomeScreen.dart';
import 'package:mounarchtech_task/services/local_repo.dart';
import 'package:mounarchtech_task/models/user_model.dart';
import 'package:mounarchtech_task/widget/user_card.dart';

class UserSliderScreen extends StatefulWidget {
  @override
  _UserSliderScreenState createState() => _UserSliderScreenState();
}

class _UserSliderScreenState extends State<UserSliderScreen> {
  List<UserModel> users = [];
  bool slidemessage = true;
  @override
  void initState() {
    super.initState();
    users = LocalRepo.getData(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const  Text("User Data Slider")),
      body: 

      Stack(
        children: [
users.isEmpty  ?const  Center(child: Text("No registered users found."))
          : PageView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserCard(user: users[index]);
              },
              onPageChanged: (value) {
                setState(() {
                  slidemessage = false;
                });
              },
            ),

             if (slidemessage)
                 const  Positioned(
                    bottom:50,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Swipe right to view more →",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Icon(Icons.swipe_right, size: 30, color: Colors.grey),
                      ],
                    ),
                  )
        ],
      ),
         
    floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
         return  const HomeScreen();
      },));
    },child:const  Icon(Icons.arrow_forward_ios),),
    
    );
    
  }
}

