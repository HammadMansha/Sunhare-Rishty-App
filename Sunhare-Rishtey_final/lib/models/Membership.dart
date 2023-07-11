class Membership {
  final String? id;
  final int? contacts;
  final double? discount;
  final DateTime? discountValidTill;
  final DateTime? startTime;
  final String? name;
  final num? price;
  final int? months;
  final bool? isHide;

  Membership(
      {this.contacts,
      this.discount,
      this.discountValidTill,
      this.startTime,
      this.months,
      this.name,
      this.id,
      this.price,
      this.isHide});
}
