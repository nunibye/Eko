import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String name;
  final String description;
  final String lastActivity;
  final String owner;
  final List<String> members;
  final List<String> invitees;

  Group(
      {required this.name,
      required this.lastActivity,
      required this.owner,
      required this.invitees,
      required this.members,
      required this.description});
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["name"] = name;
    map["lastActivity"] = lastActivity;
    map["owner"] = owner;
    map["invitees"] = invitees;
    map["members"] = members;
    map["description"] = description;
    return map;
  }
}

class GroupHandler {
  void createGroup(Group group) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('groups').add(group.toMap());
  }
}
