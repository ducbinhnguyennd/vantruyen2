import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/widgets/item_card_huongdan.dart';

class HuongDanScreen extends StatefulWidget {
  const HuongDanScreen({super.key});
  static const routeName = 'huongdan_screen';

  @override
  State<HuongDanScreen> createState() => _HuongDanScreenState();
}

class _HuongDanScreenState extends State<HuongDanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        centerTitle: true,
        title: Text('Hướng dẫn'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const ItemHuongdan(
                title: 'Tiên thạch là gì, làm sao để Thêm/Nạp tiên thạch?',
                titleSmall:
                    ' Tiên thạch được dùng để mua chap truyện để người đọc hưởng thụ những thước truyện hay nhất mà nhó dịch làm ra, ngoài ra còn để donate cho nhóm dịch có thêm động lực.'),
            ItemHuongdan(
                title: 'Giới thiệu Vip-Reader',
                titleSmall:
                    'Là người nạp nhiều tiên thạch nhất được nằm trên bảng xếp hạng'),
            ItemHuongdan(
                title: 'Điều khoản dịch vụ',
                titleSmall:
                    '1. Người dùng cam kết chỉ sử dụng ứng dụng để mục đích hợp pháp và không vi phạm bất kỳ quy định pháp luật nào.\n\n 2. Bạn đồng ý không sử dụng ứng dụng để thực hiện bất kỳ hành vi gian lận, xâm phạm quyền riêng tư, hoặc tạo ra bất kỳ rủi ro nào cho hệ thống hoặc dữ liệu.'),
            ItemHuongdan(
                title: 'Về Bản Quyền',
                titleSmall:
                    '1. Nội dung được cung cấp bởi ứng dụng là tài sản của chúng tôi và được bảo vệ bởi các quyền sở hữu trí tuệ.\n \n2. Bạn không được sao chép, sửa đổi, phân phối hoặc tái sử dụng bất kỳ phần nào của nội dung mà không có sự cho phép của chúng tôi.'),
            ItemHuongdan(
                title: 'Bảo Mật Riêng Tư',
                titleSmall:
                    'Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn và thực hiện các biện pháp bảo mật để ngăn chặn truy cập trái phép hoặc sử dụng không đúng.'),
            ItemHuongdan(
                title: 'Liên hệ',
                titleSmall:
                    'Để liên hệ với nhà phát triển hoặc bộ phận hỗ trợ của ứng dụng đọc truyện, bạn có thể liên hệ qua email: duantotnghiep2023@gmail.com')
          ],
        ),
      ),
    );
  }
}
