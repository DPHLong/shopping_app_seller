class VendorUserModel {
  VendorUserModel({
    required this.approved,
    required this.businessName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.cityValue,
    required this.stateValue,
    required this.countryValue,
    required this.storeImage,
    required this.vendorId,
  });

  final bool approved;
  final String businessName;
  final String emailAddress;
  final String phoneNumber;
  final String cityValue;
  final String stateValue;
  final String countryValue;
  final String storeImage;
  final String vendorId;

  VendorUserModel.fromJson(Map<String, dynamic> json)
    : this(
        approved: json['approved']! as bool,
        businessName: json['businessName']! as String,
        emailAddress: json['emailAddress']! as String,
        phoneNumber: json['phoneNumber']! as String,
        cityValue: json['cityValue']! as String,
        stateValue: json['stateValue']! as String,
        countryValue: json['countryValue']! as String,
        storeImage: json['storeImage']! as String,
        vendorId: json['vendorId']! as String,
      );

  // factory VendorUserModel.fromJson(Map<String, dynamic> json) {
  //   return VendorUserModel(
  //     approved: json['approved'] ?? false,
  //     businessName: json['businessName'] ?? '',
  //     emailAddress: json['emailAddress'] ?? '',
  //     phoneNumber: json['phoneNumber'] ?? '',
  //     cityValue: json['cityValue'] ?? '',
  //     stateValue: json['stateValue'] ?? '',
  //     countryValue: json['countryValue'] ?? '',
  //     storeImage: json['storeImage'] ?? '',
  //     vendorId: json['vendorId'] ?? '',
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'approved': approved,
      'businessName': businessName,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'cityValue': cityValue,
      'stateValue': stateValue,
      'countryValue': countryValue,
      'storeImage': storeImage,
      'vendorId': vendorId,
    };
  }
}
