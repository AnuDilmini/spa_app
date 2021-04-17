class CompanyDetails{
  final String id;
  final String country_id;
  final String city_id;
  final String image;
  final String logo;
  final String phone;
  final String rating;
  final String status;
  final String name;
  final String description;
  final String business_name;
  final String address;
  final City city;

  CompanyDetails({this.id, this.country_id, this.city_id, this.image, this.logo,  this.phone, this.rating, this.status, this.name, this.business_name,
      this.city, this.description, this.address});


  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
        id : json["id"],
        country_id : json["country_id"],
        city_id : json["city_id"],
        phone : json["phone"],
        image : json["image"],
        logo : json["logo"],
        rating : json["rating"],
        status : json["status"],
        name : json["name"],
        address : json["address"],
        description : json["description"],
        business_name : json["business_name"],
        city : (json["city"] != null) ? City.fromJson(json["city"]) : new City(id: 0, name: ""),
    );
  }

}

class City {

  int id;
  String name;

  City({this.id, this.name,});

  City.fromJson(Map<String, dynamic> json)
      :id =  json["id"],
        name = json["name"];

}


