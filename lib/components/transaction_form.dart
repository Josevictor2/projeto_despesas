import 'package:flutter/material.dart';
import 'package:projeto2_despesas/components/adaptative_date_picker.dart';
import 'package:projeto2_despesas/components/adapttive_textfield.dart';

import 'adaptativebutton.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  const TransactionForm(this.onSubmit, {Key? key}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleC = TextEditingController();

  final _valueC = TextEditingController();

  DateTime? _selectedDate;

  _submitForm() {
    final title = _titleC.text;
    final value = double.tryParse(_valueC.text) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      return;
    }
    widget.onSubmit(title, value, _selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              AdaptativeTextField(
                submitForm: _submitForm,
                label: 'Título',
                controller: _titleC,
              ),
              AdaptativeTextField(
                submitForm: _submitForm,
                label: 'Valor (R\$)',
                controller: _valueC,
                keyBoardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              AdaptativeDate(
                selectedDate: _selectedDate,
                onChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              Container(
                alignment: Alignment.centerRight,
                child: AdaptativeButton(
                  label: 'Nova transação',
                  onPressed: _submitForm,
                ),
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(shadowColor: Colors.green),
                //   child: const Text(
                //     'Nova Transação',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 14,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   onPressed: () {
                //     _submitForm();
                //   },
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
