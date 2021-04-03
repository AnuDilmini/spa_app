class Company{
  final String id;
  final String country_id;
  final String city_id;
  final String image;
  final String phone;
  final String rating;
  final String status;
  final String name;
  final String description;
  final String business_name;
  final City city;

  Company(this.id, this.country_id, this.city_id, this.image, this.phone, this.rating, this.status, this.name, this.business_name,
      this.city, this.description);

  Company.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        country_id = json["country_id"],
        city_id = json["city_id"],
        phone = json["phone"],
        image = json["logo"],
        rating = json["rating"],
        status = json["status"],
        name = json["name"],
        description = json["description"],
        business_name = json["business_name"],
        city = (json["city"] != null) ? City.fromJson(json["city"]) : new City(id: 0, name: "");
}

class City {
  
  int id;
  String name;

  City({this.id, this.name});

   City.fromJson(Map<String, dynamic> json) 
    :id =  json["id"],
    name = json["name"];
   
}
