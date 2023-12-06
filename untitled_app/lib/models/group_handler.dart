class Group {
  final String name;
  final String lastActivity;
  final String owner;
  final List<String> members;
  final List<String> invitees;
  Group(
      {required this.name,
      required this.lastActivity,
      required this.owner,
      required this.invitees,
      required this.members});
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["name"] = name;
    map["lastActivity"] = lastActivity;
    map["owner"] = owner;
    map["invitees"] = invitees;
    map["members"] = members;
    return map;
  }
}

class GroupHandler {}
