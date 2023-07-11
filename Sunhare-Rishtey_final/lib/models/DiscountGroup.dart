class DiscountGroup {
  final String? id;
  final String? name;
  final double? discount_percentage;
  final DateTime? expire_date;
  final DateTime? user_ac_old_date;
  final DateTime? start_date;
  final double? user_ac_old_days;

  DiscountGroup(
      {this.id,
        this.name,
        this.discount_percentage,
      this.expire_date,
      this.user_ac_old_date,
      this.start_date,
      this.user_ac_old_days,
      });


}
