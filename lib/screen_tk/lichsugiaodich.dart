import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/lichsuthanhtoan_model.dart';

// ignore: must_be_immutable
class LichSuGiaoDich extends StatefulWidget {
  LichSuGiaoDich({super.key, required this.userId});
  static const routeName = 'lichsugiaodich';
  String userId;
  @override
  State<LichSuGiaoDich> createState() => _LichSuGiaoDichState();
}

class _LichSuGiaoDichState extends State<LichSuGiaoDich> {
  final PaymentApi _paymentApi = PaymentApi();
  late Future<List<PaymentHistory>> _paymentHistory;

  @override
  void initState() {
    super.initState();
    _paymentHistory = _paymentApi.getPaymentHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử thanh toán'),
        backgroundColor: ColorConst.colorPrimary50,
      ),
      body: FutureBuilder<List<PaymentHistory>>(
        future: _paymentHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: ColorConst.colorPrimary50,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Chưa có lịch sử thanh toán'));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('Chưa có lịch sử thanh toán'));
          } else {
            final paymentHistory = snapshot.data;
            return ListView.builder(
              itemCount: paymentHistory?.length,
              itemBuilder: (context, index) {
                final history = paymentHistory?[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ColorConst.colorPrimary80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          history?.success ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${history?.totalAmount.toStringAsFixed(2)} USD',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: ColorConst.colorPrimary50)),
                            Text('${history?.date}')
                          ],
                        ),
                        Row(
                          children: [
                            Text('Xu bạn nhận được: '),
                            Text('${history?.coin} xu',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: ColorConst.colorPrimary50)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
