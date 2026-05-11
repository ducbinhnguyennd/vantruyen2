import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/CoinHistory_model.dart';
import 'package:loginapp/model/lichsuthanhtoan_model.dart';

import '../getapi/trangchuapi.dart';

class LichSuGiaoDich extends StatefulWidget {
  LichSuGiaoDich({super.key, required this.userId});
  static const routeName = 'lichsugiaodich';
  String userId;

  @override
  State<LichSuGiaoDich> createState() => _LichSuGiaoDichState();
}

class _LichSuGiaoDichState extends State<LichSuGiaoDich>
    with SingleTickerProviderStateMixin {
  final PaymentApi _paymentApi = PaymentApi();
  late Future<List<PaymentHistory>> _paymentHistory;
  late Future<List<CoinHistory>> _coinHistory;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _paymentHistory = _paymentApi.getPaymentHistory(widget.userId);
    _coinHistory = getCoinHistory(widget.userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử giao dịch'),
        backgroundColor: ColorConst.colorPrimary50,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Thanh toán'),
            Tab(text: 'Lịch sử xu'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPaymentTab(),
          _buildCoinTab(),
        ],
      ),
    );
  }

  Widget _buildPaymentTab() {
    return FutureBuilder<List<PaymentHistory>>(
      future: _paymentHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: ColorConst.colorPrimary50),
          );
        }
        if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('Chưa có lịch sử thanh toán'));
        }
        final list = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final history = list[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ColorConst.colorPrimary80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.success,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${history.totalAmount.toStringAsFixed(2)} USD',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: ColorConst.colorPrimary50),
                        ),
                        Text(history.date),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Xu bạn nhận được: '),
                        Text(
                          '${history.coin} xu',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: ColorConst.colorPrimary50),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCoinTab() {
    return FutureBuilder<List<CoinHistory>>(
      future: _coinHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: ColorConst.colorPrimary50),
          );
        }
        if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('Chưa có lịch sử xu'));
        }
        final list = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            final bool isAdd = item.method == 'add';
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ColorConst.colorPrimary80,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.content,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.date,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      '${isAdd ? '+' : '-'}${item.coin} xu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: isAdd ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}