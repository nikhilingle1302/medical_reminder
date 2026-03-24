import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

// User Model
@JsonSerializable()
class User {
  final int id;
  final String username;
  final String email;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
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
  final String email;
  final String password;
  final String role;

  RegisterRequest({
    required this.username,
    required this.email,
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
  @JsonKey(name: 'user')
  final User user;

  @JsonKey(name: 'tokens')
  final TokenData tokens;  // ✅ nested under 'tokens', not at root

  LoginResponse({
    required this.user,
    required this.tokens,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: 'user')
  final User user;

  @JsonKey(name: 'tokens')
  final TokenData tokens;

  RegisterResponse({
    required this.user,
    required this.tokens,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class TokenData {
  @JsonKey(name: 'access')
  final String access;

  @JsonKey(name: 'refresh')
  final String refresh;

  TokenData({
    required this.access,
    required this.refresh,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDataToJson(this);
}
