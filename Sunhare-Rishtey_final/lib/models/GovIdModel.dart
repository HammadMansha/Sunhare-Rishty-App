class GovIdModel {
  String? imageUrl;
  bool? isVerificationRequired;
  bool? isVerified;
  String? name;
  String? srId;
  String? userId;
  String? varificationBy;
  String? verifiedBy;
  Map<Object, Object>? verified = {};

  GovIdModel(
      {this.imageUrl,
      this.isVerificationRequired,
      this.isVerified,
      this.name,
      this.srId,
      this.userId,
      this.varificationBy,
      this.verifiedBy,
      this.verified});

  GovIdModel.fromJson(Map<dynamic, dynamic> json) {
    imageUrl = (json['imageUrl']??"").toString();
    isVerificationRequired = json['isVerificationRequired'] as bool;
    isVerified = json['isVerified'] as bool;
    name = json['name'].toString();
    srId = json['srId'].toString();
    userId = json['userId'].toString();
    varificationBy = json['varificationBy'].toString();
    verifiedBy = json['verifiedBy'].toString();
    verified = json['verified'] as Map<Object, Object>?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['isVerificationRequired'] = this.isVerificationRequired;
    data['isVerified'] = this.isVerified;
    data['name'] = this.name;
    data['srId'] = this.srId;
    data['userId'] = this.userId;
    data['varificationBy'] = this.varificationBy;
    data['verifiedBy'] = this.verifiedBy;
    data['verified'] = this.verified;
    return data;
  }
}
