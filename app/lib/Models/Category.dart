class Category {
  String _id;
  String name;
  String description;

  get id => _id;

  Category.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    _id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'name': this.name,
      'description': this.description,
    };
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };

  Category.create() {
    _id = '';
    name = '';
    description = '';
  }

  Category({
    String id,
    this.name,
    this.description,
  }) : _id = id;
}
