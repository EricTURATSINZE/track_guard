class User {
  int id;
  String firstName;
  String lastName;
  String gender;
  String email;
  String phone;
  String password;
  bool recieveNotificationsEmail;
  String accountType;
  String status;
  String pictureUrl;
  String lastLogin;
  dynamic resetPasswordToken;
  dynamic resetPasswordExpires;
  int createdBy;
  String createdAt;
  String updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phone,
    required this.password,
    required this.recieveNotificationsEmail,
    required this.accountType,
    required this.status,
    required this.pictureUrl,
    required this.lastLogin,
    required this.resetPasswordToken,
    required this.resetPasswordExpires,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      recieveNotificationsEmail: json['recieveNotificationsEmail'],
      accountType: json['accountType'],
      status: json['status'],
      pictureUrl: json['pictureUrl'],
      lastLogin: json['lastLogin'],
      resetPasswordToken: json['resetPasswordToken'],
      resetPasswordExpires: json['resetPasswordExpires'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'email': email,
      'phone': phone,
      'password': password,
      'recieveNotificationsEmail': recieveNotificationsEmail,
      'accountType': accountType,
      'status': status,
      'pictureUrl': pictureUrl,
      'lastLogin': lastLogin,
      'resetPasswordToken': resetPasswordToken,
      'resetPasswordExpires': resetPasswordExpires,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return '''
      User {
      id: $id
      firstName: $firstName
      lastName: $lastName
      gender: $gender
      email: $email
      phone: $phone
      password: $password
      recieveNotificationsEmail: $recieveNotificationsEmail
      accountType: $accountType
      status: $status
      pictureUrl: $pictureUrl
      lastLogin: $lastLogin
      resetPasswordToken: $resetPasswordToken
      resetPasswordExpires: $resetPasswordExpires
      createdBy: $createdBy
      createdAt: $createdAt
      updatedAt: $updatedAt
      }
    ''';
  }
}
