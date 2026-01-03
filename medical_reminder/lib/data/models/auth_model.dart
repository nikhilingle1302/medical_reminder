import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

// User Model
@JsonSerializable()
class User {
  @JsonKey(name: 'user_id')
  final int? id;
  @JsonKey(name: 'username')
  final String username;
  final String? password;
  @JsonKey(name: 'role')
  final String? role;
  @JsonKey(name: 'token')
  final String? token;

  User({
    this.id,
    required this.username,
    this.password,
    this.role,
    this.token
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

}

// Login Request Model
@JsonSerializable()
class LoginRequest {
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'password')
  final String password;
  

  LoginRequest({
    required this.username,
    required this.password,
    
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// Register Request Model
@JsonSerializable()
class RegisterRequest {
  final String username;
  final String password;
  final String role;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.role,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// Login Response Model
@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'role')
  final String role;

  LoginResponse({
    required this.token,
    required this.message,
    required this.userId,
    required this.username,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}