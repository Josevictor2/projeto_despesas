import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List transactions;
  final void Function(String) removeTransactions;

  // ignore: use_key_in_widget_constructors
  const TransactionList(this.transactions, this.removeTransactions);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                    child: Text(
                      'Nenhuma transação Cadastrada!',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 20 * MediaQuery.textScaleFactorOf(context),
                      ),
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Image.asset(
                      'assets/imagens/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : Scrollbar(
            isAlwaysShown: false,
            showTrackOnHover: true,
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, i) {
                final tr = transactions[i];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('R\$ ${tr.value}'),
                        ),
                      ),
                    ),
                    title: Text(
                      tr.title,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          fontFamily: 'Quicksand'),
                    ),
                    subtitle: Text(
                      DateFormat('d MMM y').format(tr.date),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? TextButton.icon(
                            onPressed: () => removeTransactions(tr.id),
                            icon: const Icon(Icons.delete),
                            label: Text(
                              'Excluir',
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => removeTransactions(tr.id),
                          ),
                  ),
                );
              },
            ),
          );
  }
}
