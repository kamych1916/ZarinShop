class Address {
  String city;
  String street;
  String houseNumber;
  String apartmentNumber;
  String code;

  Address(this.city, this.street, this.houseNumber, this.apartmentNumber,
      this.code);

  Address.fromJson(Map<String, dynamic> json) {
    city = json["city"];
    street = json["street"];
    houseNumber = json["houseNumber"];
    apartmentNumber = json["apartmentNumber"];
    code = json["code"];
  }

  Address.copy(Address other)
      : this(other.city, other.street, other.houseNumber, other.apartmentNumber,
            other.code);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "city": city,
        "street": street,
        "houseNumber": houseNumber,
        "apartmentNumber": apartmentNumber,
        "code": code
      };

  @override
  String toString() {
    return "city=$city, street=$street, houseNumber=$houseNumber, apartmentNumber=$apartmentNumber, code=$code";
  }
}
