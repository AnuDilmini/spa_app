import 'dart:convert';

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

  static Map<String, dynamic> toMap(CompanyServices companyServices) => {
    'id': companyServices.id,
    'company_id': companyServices.company_id,
    'category_id': companyServices.category_id,
    'image': companyServices.image,
    'price': companyServices.price,
    'duration_min': companyServices.duration_min,
    'name': companyServices.name,
    'description': companyServices.description,
  };

  static String encode(List<CompanyServices> companyServices) => json.encode(
    companyServices
        .map<Map<String, dynamic>>((companyServices) => CompanyServices.toMap(companyServices))
        .toList(),
  );

  static List<CompanyServices> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<CompanyServices>((item) => CompanyServices.fromJson(item))
          .toList();

}
