class Member {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final DateTime memberSince;
  final List<String> borrowedBookIds;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.memberSince,
    List<String>? borrowedBookIds,
  }) : borrowedBookIds = borrowedBookIds ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'memberSince': memberSince.toIso8601String(),
      'borrowedBookIds': borrowedBookIds,
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      memberSince: DateTime.parse(json['memberSince']),
      borrowedBookIds: List<String>.from(json['borrowedBookIds']),
    );
  }
}
