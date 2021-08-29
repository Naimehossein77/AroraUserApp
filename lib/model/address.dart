class AddressModel {
  String name;
  String phoneNumber;
  String flatNumber;
  String city;
  String state;
  String pincode;
  String addressDocID;

  AddressModel({
    this.name,
    this.phoneNumber,
    this.flatNumber,
    this.city,
    this.state,
    this.pincode,
    this.addressDocID,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    flatNumber = json['flatNumber'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    addressDocID = json['addressDocID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['flatNumber'] = this.flatNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['addressDocID'] = this.addressDocID;
    return data;
  }
}
