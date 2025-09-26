import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'base_model.dart';

/// User: مثال على تغليف (Encapsulation) بوجود حقول خاصّة مع getters.
/// يرث من BaseModel (Inheritance) ويطبّق toMap (Polymorphism عبر نفس الواجهة).
class User extends BaseModel {
  final String _email;
  final String _name;
  final String _passwordHash;

  User({
    int? id,
    required String email,
    required String name,
    required String passwordHash,
  })  : _email = email,
        _name = name,
        _passwordHash = passwordHash,
        super(id: id);

  String get email => _email;
  String get name => _name;
  String get passwordHash => _passwordHash;

  /// دالة مساعدة لتوليد الهاش من كلمة المرور
  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// التحقق من كلمة المرور
  bool verifyPassword(String plain) => _passwordHash == hashPassword(plain);

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'email': _email,
    'name': _name,
    'password_hash': _passwordHash,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as int?,
    email: map['email'] as String,
    name: map['name'] as String,
    passwordHash: map['password_hash'] as String,
  );

  User copyWith({
    int? id,
    String? email,
    String? name,
    String? passwordHash,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? _email,
      name: name ?? _name,
      passwordHash: passwordHash ?? _passwordHash,
    );
  }
}
