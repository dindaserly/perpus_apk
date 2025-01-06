import 'package:flutter/foundation.dart';
import '../models/member.dart';

class MemberProvider with ChangeNotifier {
  final List<Member> _members = [];

  List<Member> get members {
    return [..._members];
  }

  Member? findById(String id) {
    try {
      return _members.firstWhere((member) => member.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Member> searchMembers(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _members.where((member) {
      return member.name.toLowerCase().contains(lowercaseQuery) ||
          member.email.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  void addMember(Member member) {
    _members.add(member);
    notifyListeners();
  }

  void updateMember(Member member) {
    final index = _members.indexWhere((m) => m.id == member.id);
    if (index >= 0) {
      _members[index] = member;
      notifyListeners();
    }
  }

  void deleteMember(String id) {
    _members.removeWhere((member) => member.id == id);
    notifyListeners();
  }
}
