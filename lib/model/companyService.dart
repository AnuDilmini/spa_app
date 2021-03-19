class CompanyServices {
  final String id;
  final String company_id;
  final String category_id;
  final String image;
  final String name;
  final String description;
  final String duration_min;
  final String price;

  CompanyServices(this.id, this.company_id, this.category_id, this.image, this.price, this.description, this.duration_min, this.name);

  CompanyServices.fromJson(Map<String, dynamic> json)
      : id =  json["id"],
        company_id = json["company_id"],
        category_id = json["category_id"],
        image = json["image"],
        price = json["price"],
        duration_min = json["duration_min"],
        name = json["name"],
        description = json["description"];

}
