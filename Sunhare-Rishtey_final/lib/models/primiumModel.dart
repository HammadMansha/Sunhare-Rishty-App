import 'package:matrimonial_app/models/UserModel.dart';

class PremiumModel {
  final DateTime? dateOfPerchase;
  final DateTime? validTill;
  final String? name;
  final String? packageId;
  final String? packageName;
  final bool? isActive ;
  final int? contact;

  PremiumModel(
      {this.dateOfPerchase,
      this.name,
      this.packageId,
      this.packageName,
      this.isActive= false,
      this.contact,
      this.validTill});
}

class PremiumNewModel {
  String? endDate;
  String? planName;
   String? startDate;
   int? totalContact;
   bool? activeStatus;
   List<String>? contactViewed;
   List<UserInformation>? userInfoData;

  PremiumNewModel(
      {this.endDate,
        this.planName,
        this.startDate,
        this.totalContact,
        this.activeStatus,
        this.contactViewed,
        this.userInfoData,
       });
}

