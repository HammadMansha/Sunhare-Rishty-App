class AdvertisementModel {
  final String? id;
  final String? title;
  final String? image;
  final int? months;
  final bool? status;
  final String? adType;

  final DateTime? dateCreated;

  AdvertisementModel(
      {this.dateCreated,
      this.id,
      this.image,
      this.months,
      this.adType,
      this.status,
      this.title});
}
