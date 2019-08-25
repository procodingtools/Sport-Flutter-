class MembershipEntity{

  int _id;
  String _label;
  DateTime _beginDate;
  DateTime _endDate;
  double _price;
  double _paid;

  MembershipEntity({dynamic data}){
    if(data != null){
      _id = data['Id'];
      _label = data['Libelle'];
      _beginDate = DateTime.parse(data['DateDebut']);
      _endDate = DateTime.parse(data['DateFin']);
      _price = data['Prix'];
      _paid = data['SommePaiement'];
    }
  }

  double get paid => _paid;

  set paid(double value) {
    _paid = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  DateTime get endDate => _endDate;

  set endDate(DateTime value) {
    _endDate = value;
  }

  DateTime get beginDate => _beginDate;

  set beginDate(DateTime value) {
    _beginDate = value;
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}