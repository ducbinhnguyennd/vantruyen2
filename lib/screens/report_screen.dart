import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/getapi/trangchuapi.dart';

class ReportScreen extends StatefulWidget {
  final String baivietID;
  final String userID;

  ReportScreen({required this.baivietID, required this.userID});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController _reportController = TextEditingController();
  ApiReportBaiDang _apiReportBaiDang = ApiReportBaiDang();
  String selectedReason = '';
  String additionalNote = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        title: Text('Gửi báo cáo bài viết'),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, false);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView(
        children: [
          RadioListTile(
            title: Text('Nội dung không phù hợp'),
            value: 'Nội dung không phù hợp',
            activeColor: ColorConst.colorPrimary50,
            groupValue: selectedReason,
            onChanged: (value) {
              setState(() {
                selectedReason = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Spam'),
            value: 'Spam',
            activeColor: ColorConst.colorPrimary50,
            groupValue: selectedReason,
            onChanged: (value) {
              setState(() {
                selectedReason = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Quấy rối'),
            value: 'Quấy rối',
            groupValue: selectedReason,
            activeColor: ColorConst.colorPrimary50,
            onChanged: (value) {
              setState(() {
                selectedReason = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Nội dung khiêu dâm'),
            value: 'Nội dung khiêu dâm',
            groupValue: selectedReason,
            activeColor: ColorConst.colorPrimary50,
            onChanged: (value) {
              setState(() {
                selectedReason = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Khác'),
            value: 'Khác',
            groupValue: selectedReason,
            activeColor: ColorConst.colorPrimary50,
            onChanged: (value) {
              setState(() {
                selectedReason = value.toString();
              });
            },
          ),
          if (selectedReason == 'Khác')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(15),
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ColorConst.colorPrimary80,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _reportController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Ghi chú thêm nếu có',
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          counterText: '',
                        ),
                        maxLength: 200,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${_reportController.text.length}/200',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
            child: InkWell(
              onTap: () {
                _postReport();
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ColorConst.colorPrimary50,
                ),
                child: Center(
                  child: Text(
                    'Gửi',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _postReport() {
    String baivietId = widget.baivietID;
    String userId = widget.userID;
    String reason = selectedReason.trim();

    if (reason.isNotEmpty) {
      if (selectedReason == 'Khác') {
        reason = _reportController.text.trim();
      }

      try {
        _apiReportBaiDang.postReport(baivietId, userId, reason);
        CommonService.showToast('Gửi báo cáo thành công', context);
      } catch (error) {
        print('Lỗi trong _sendReport: $error');
      }
    } else {
      CommonService.showToast(
          'Vui lòng chọn một lý do báo cáo trước khi gửi báo cáo.', context);
    }
  }
}
