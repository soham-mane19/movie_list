import 'package:hive_flutter/hive_flutter.dart';
import 'package:mounarchtech_task/models/user_model.dart';


class LocalRepo {



  static void storeData({required String name,required String email,required String imageUrl})async{
          print("called ");
           var box  = Hive.box<UserModel>('userData');
    UserModel userModel = UserModel(email: email,imageUrl: imageUrl,name: name);

  await box.add(userModel);
  
         }

static List<UserModel> getData(){
  print("get data");
  var box = Hive.box<UserModel>('userData');
  
      return box.values.toList();
}
    
}