
import 'package:hive_flutter/adapters.dart';
   part 'user_model.g.dart';
@HiveType(typeId: 0)
class UserModel extends HiveObject{
  @HiveField(1)
String? name;
@HiveField(2)
String? email;
@HiveField(3)
String? imageUrl;

  UserModel({
    this.name,
     this.email,
      this.imageUrl,
  });
}
