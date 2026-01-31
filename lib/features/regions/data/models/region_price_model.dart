class RegionPriceModel {
  final int regionId;
  final String? regionName;
  final num price;

  RegionPriceModel({
    required this.regionId,
    this.regionName,
    required this.price,
  });

  factory RegionPriceModel.fromJson(Map<String, dynamic> json) {
    return RegionPriceModel(
      regionId: json['regionId'] ?? 0,
      regionName: json['regionName'],
      price: json['price'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'regionId': regionId,
      'price': price,
    };
  }
}
