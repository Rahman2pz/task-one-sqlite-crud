class User {
  final int? id;
  final String? name;
  final String? phNumber;
  final String? imageUrl;

  const User({ this.id,  this.name,this.phNumber,  this.imageUrl});

  factory User.fromMap(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"],
          phNumber: json['phNumber'],
          imageUrl: json["imageUrl"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phNumber': phNumber,
      'imageUrl': imageUrl,
    };
  }
}