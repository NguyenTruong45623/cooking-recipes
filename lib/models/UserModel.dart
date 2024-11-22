import 'package:hive_flutter/hive_flutter.dart';
part 'UserModel.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  // constructor
  UserModel({
    required this.uid,
    required this.name,
    required this.image,
  });
}
