import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactionForm extends StatefulWidget {
  final Function _addTransaction;

  const NewTransactionForm(this._addTransaction, {super.key});

  @override
  _NewTransactionFormState createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _titleFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _dateFocus = FocusNode();
  final _timeFocus = FocusNode();

  bool _autoValidateToggle = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _autoValidateToggle = false;
    _selectedTime = null;
    _dateController.text = DateFormat('d/M/y').format(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('d/M/y').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = DateFormat.jm().format(DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        ));
      });
    }
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final txnTitle = _titleController.text;
      final txnAmount = double.parse(_amountController.text);
      final txnDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      widget._addTransaction(
        txnTitle,
        txnAmount,
        txnDateTime,
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _autoValidateToggle = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2F4D), // Background color
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              height: 15.0,
            ),

            // Title TextField
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                prefixIcon:
                    Icon(Icons.title, color: Colors.white), // Icon color
                hintText: "Enter a title",
                hintStyle: TextStyle(color: Colors.white70), // Hint text color
                labelStyle: TextStyle(color: Colors.white), // Label text color
              ),
              style: const TextStyle(color: Colors.white), // Text color
              validator: (value) {
                if (value!.isEmpty) return "Title cannot be empty";
                return null;
              },
              autovalidateMode: _autoValidateToggle
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              focusNode: _titleFocus,
              onFieldSubmitted: (_) =>
                  _fieldFocusChange(context, _titleFocus, _amountFocus),
              controller: _titleController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20.0,
            ),

            // Amount TextField
            TextFormField(
              focusNode: _amountFocus,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                prefixIcon:
                    Icon(Icons.local_atm, color: Colors.white), // Icon color
                hintText: "Enter the amount",
                hintStyle: TextStyle(color: Colors.white70), // Hint text color
                labelStyle: TextStyle(color: Colors.white), // Label text color
              ),
              style: const TextStyle(color: Colors.white), // Text color
              autovalidateMode: _autoValidateToggle
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              validator: (value) {
                RegExp regex = RegExp(r'^[0-9]+(\.[0-9]+)?$');
                if (!regex.hasMatch(value!) || double.tryParse(value) == null) {
                  return "Please enter valid amount";
                }
                return null;
              },
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(
              height: 20.0,
            ),

            // Date and Time Textfield
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Date TextField
                Flexible(
                  fit: FlexFit.loose,
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        focusNode: _dateFocus,
                        keyboardType: TextInputType.datetime,
                        style: const TextStyle(
                            color: Colors.white), // Date text color
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          labelText: 'Date',
                          hintText: 'Date of Transaction',
                          prefixIcon: Icon(Icons.calendar_today,
                              color: Colors.white), // Icon color
                          suffixIcon: Icon(Icons.arrow_drop_down,
                              color: Colors.white), // Icon color
                          hintStyle: TextStyle(
                              color: Colors.white70), // Hint text color
                          labelStyle: TextStyle(
                              color: Colors.white), // Label text color
                        ),
                        autovalidateMode: _autoValidateToggle
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: (value) {
                          if (value!.isEmpty) return "Please select a date";
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10.0,
                ),
                // Time TextField
                Flexible(
                  fit: FlexFit.loose,
                  child: GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _timeController,
                        focusNode: _timeFocus,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          labelText: 'Time',
                          hintText: 'Time of Transaction',
                          prefixIcon: Icon(Icons.schedule,
                              color: Colors.white), // Icon color
                          suffixIcon: Icon(Icons.arrow_drop_down,
                              color: Colors.white), // Icon color
                          hintStyle: TextStyle(
                              color: Colors.white70), // Hint text color
                          labelStyle: TextStyle(
                              color: Colors.white), // Label text color
                        ),
                        autovalidateMode: _autoValidateToggle
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: (value) {
                          if (value!.isEmpty) return "Please select a time";
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20.0,
            ),

            // Add Transaction Button
            ElevatedButton.icon(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, // Text color
                backgroundColor: const Color(0xFF75E7FE), // Button color
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
              ),
              icon: const Icon(Icons.check),
              label: const Text(
                'ADD TRANSACTION',
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 16.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
