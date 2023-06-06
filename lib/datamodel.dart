class UserData {
  int? uid;
  String? title;
  String? description;

  UserData({this.uid, this.title, this.description});

  UserData.fromMap(Map<String, dynamic> json) {
    uid = json['uid'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
