class Category{
  final int id;
  final String icon;
  final String name;

  Category(this.id, this.icon, this.name);

  Category.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        icon = json["icon"],
        name = json["name"];
}

