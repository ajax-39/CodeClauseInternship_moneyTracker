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

  // Convenience constructor to create a Transaction object from a map
  Transaction.fromMap(Map<String, dynamic> map)
      : _id = map['id'].toString(),
        _title = map['title'],
        _amount = map['amount'].toDouble(), // Ensure amount is parsed as double
        _date = DateTime.parse(map['date']);

  // Method to create a Map from this Transaction object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': int.tryParse(_id), // Convert _id to int if possible
      'title': _title,
      'amount': _amount,
      'date': _date.toIso8601String(),
    };
    return map;
  }
}
