class UserModel {
  final String name;
  final String email;
  final String? photoUrl;
  final String? avatarPath;
  UserModel({
    required this.name,
    required this.email,
    this.photoUrl,
    this.avatarPath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      avatarPath: json['avatarPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'avatarPath': avatarPath,
    };
  }
}
