class CreditCard {
  String cardNumber;
  String name;
  String validate;

  CreditCard({this.cardNumber, this.name, this.validate});

  CreditCard.fromJson(Map<String, dynamic> json) {
    cardNumber = json["cardNumber"];
    name = json["name"];
    validate = json["validate"];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "cardNumber": cardNumber,
        "name": name,
        "validate": validate
      };

  @override
  String toString() {
    return "cardNumber=$cardNumber, name=$name, validate=$validate";
  }
}
