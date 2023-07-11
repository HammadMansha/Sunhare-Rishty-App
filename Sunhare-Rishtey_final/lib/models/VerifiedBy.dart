class VerifiedBy {
  String? panCard = "";
  String? adharCard = "";
  String? passPort = "";
  String? driveinglicense = "";

  VerifiedBy(
      {required this.panCard, required this.adharCard, required this.passPort, required this.driveinglicense});

  VerifiedBy.fromJson(Map<Object, String> json) { //Object
    panCard = json['PAN Card'];
    adharCard = json['Aadhar Card'];
    passPort = json['Pass Port'];
    driveinglicense = json['Driving Licence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PAN Card'] = this.panCard;
    data['Aadhar Card'] = this.adharCard;
    data['Pass Port'] = this.passPort;
    data['Driving Licence'] = this.driveinglicense;
    return data;
  }
}
