import 'dart:math';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto2_despesas/components/transaction_form.dart';
import 'package:projeto2_despesas/components/transaction_list.dart';
import 'package:projeto2_despesas/models/transaction.dart';

import 'components/chart.dart';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      home: const MyHome(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 20 * MediaQuery.textScaleFactorOf(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHome> {
  final _transaction = [];
  bool _showChart = false;

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      date: date,
      value: value,
    );

    setState(() {
      _transaction.add(newTransaction);
    });

    Navigator.of(context)
        .pop(); //fechando o modal depois de coloca os valores e confirma
  }

  _removeTransaction(String id) {
    setState(() {
      _transaction.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  List get _recentTransaction {
    return _transaction
        .where((tr) => tr.date.isAfter(DateTime.now().subtract(
              const Duration(days: 7),
            )))
        .toList();
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return UniversalPlatform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(onPressed: fn, icon: Icon(icon));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final iconList =
        UniversalPlatform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList = UniversalPlatform.isIOS
        ? CupertinoIcons.refresh
        : Icons.show_chart_sharp;
    final actions = [
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : chartList,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        UniversalPlatform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModel(context),
      ),
    ];
    final appBar = AppBar(
      title: const Text(
        "Despesas Pessoais",
      ),
      actions: actions,
    );
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandscape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text('Exibir Gráfico'),
            //       Switch.adaptive( Switch criar um marcador que é utilizado em formularios é bom guarda esse widget
            //         activeColor = Theme.of(context).accentColor,
            //         value: _showChart,
            //         onChanged: (value) {
            //           setState(() {
            //             _showChart = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 0.6 : 0.4),
                child: Chart(recentTransaction: _recentTransaction),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 0.9 : 0.6),
                child: TransactionList(_transaction, _removeTransaction),
              )
          ],
        ),
      ),
    );

    return UniversalPlatform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            //SingleChildScrollView
            body: bodyPage,
            floatingActionButton: UniversalPlatform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModel(context),
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.purple,
                    hoverColor: Colors.blue,
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
