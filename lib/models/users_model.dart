class UserModel {
  const UserModel({this.id, this.username});
  final String username;
  final String id;

  User toUser() {
    return new User(id: this.id, username: this.username);
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(id: data['ui'], username: data['u']);
  }
}

class User {
  const User({this.id, this.username});
  final String username;
  final String id;
}
