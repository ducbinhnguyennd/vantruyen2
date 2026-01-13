import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/user_Service.dart';

class ThemTienThach extends StatefulWidget {
  static const routeName = 'themtienthach';

  @override
  _ThemTienThachState createState() => _ThemTienThachState();
}

class _ThemTienThachState extends State<ThemTienThach> {
  Data? currentUser;
  _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
        });
      } else {
        setState(() {
          currentUser = null;
        });
      }
    }, onError: (error) {}).then((value) async {
      // _sendPaymentData()
    });
  }

  Future<void> _sendPaymentData(
      String userId, double amount, String currency) async {
    print('day id khac ${userId}');
    try {
      await ApiThanhToan.sendPaymentData(userId, amount, currency);
    } catch (error) {
      print('loi cmnr $error');
    }
  }

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  final List<PaymentItem> paymentItems = [
    PaymentItem(
        amount: 2.0, currency: 'USD', quy: '2.00 USD quy đổi ra được 20 xu'),
    PaymentItem(
        amount: 10.0, currency: 'USD', quy: '10.00 USD quy đổi ra được 100 xu'),
    PaymentItem(
        amount: 20.0, currency: 'USD', quy: '20.00 USD quy đổi ra được 200 xu'),
    PaymentItem(
        amount: 30.0, currency: 'USD', quy: '30.00 USD quy đổi ra được 300 xu'),
  ];

  @override
  Widget build(BuildContext context) {
    print('day ${currentUser?.user[0].id}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        title: Text('Nạp tiền'),
        leading: InkWell(
          onTap: (() {
            Navigator.of(context).pop(true);
          }),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView.builder(
        itemCount: paymentItems.length,
        itemBuilder: (context, index) {
          final item = paymentItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 11,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: ColorConst.colorPrimary120),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Số tiền: ${item.amount.toStringAsFixed(2)} ${item.currency}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(item.quy.toString())
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: (() {
                        _sendPaymentData(currentUser?.user[0].id ?? '',
                            item.amount, item.currency);
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: ColorConst.colorPrimary50,
                          ),
                          child: Center(
                              child: Text(
                            'Nạp tiền',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaymentItem {
  final double amount;
  final String currency;
  final String quy;

  PaymentItem(
      {required this.amount, required this.currency, required this.quy});
}
