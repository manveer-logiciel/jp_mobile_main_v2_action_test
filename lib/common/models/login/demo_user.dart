class DemoUserModel {
  late String username;
  late String password;

  DemoUserModel({required this.username, required this.password});

  DemoUserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }
}