class MembershipTypeEntity{

  String _periode;
  String _price;
  String _scNumber;

  MembershipTypeEntity({dynamic data}){
    if(data != null){
      Map<String, dynamic> map = data;
      _periode = map["Periode"];
      _price = map["Prix"].toString();
      _scNumber = map["NbSeance"].toString();
    }
  }

  String get scNumber => _scNumber;

  set scNumber(String value) {
    _scNumber = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get periode => _periode;

  set periode(String value) {
    _periode = value;
  }


}