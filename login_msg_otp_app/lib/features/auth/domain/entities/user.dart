class User {
  final String id;
  final int numberPhone;
  final String fullName;
  final String email;
  final List<String> roles;
  final bool isPhoneActive;
  final bool isActive;
  final String token;

  User(
      {required this.id,
      required this.numberPhone,
      this.email = "",
      required this.isPhoneActive,
      required this.fullName,
      required this.roles,
      required this.isActive,
      required this.token});

  bool get isAdmin {
    return roles.contains('admin');
  }

  bool get isUserPhoneActived {
    return isPhoneActive;
  }

  bool get isUserActivated{
    return isActive;
  }
}
