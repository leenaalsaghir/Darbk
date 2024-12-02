class AppUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String companion;
  final String budget;

  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.companion,
    required this.budget,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? 'Riyadh',
      companion: json['companion'] ?? 'Alone',
      budget: json['budget'] ?? 'Economy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'city': city,
      'companion': companion,
      'budget': budget,
    };
  }
}
