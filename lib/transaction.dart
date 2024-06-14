class Transaction {
  final String _id;
  final String _title;
  final double _amount;
  final DateTime _date;

  String get txnId => _id;
  String get txnTitle => _title;
  double get txnAmount => _amount;
  DateTime get txnDateTime => _date;

  Transaction(
    this._id,
    this._title,
    this._amount,
    this._date,
  );

  
  Transaction.fromMap(Map<String, dynamic> map)
      : _id = map['id'].toString(),
        _title = map['title'],
        _amount = map['amount'].toDouble(), 
        _date = DateTime.parse(map['date']);


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': int.tryParse(_id), 
      'title': _title,
      'amount': _amount,
      'date': _date.toIso8601String(),
    };
    return map;
  }
}
