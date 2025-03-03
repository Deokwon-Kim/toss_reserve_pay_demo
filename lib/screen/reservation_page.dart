import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toss/model/reserve_model.dart';
import 'package:toss/screen/payment_page.dart';

// Utility function to format number with commas
String formatAmount(int amount) {
  final formatter = NumberFormat('#,###');
  return '${formatter.format(amount)}원';
}

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  int _selectedAmount = 30000; // 기본가격
  String _selectedService = '기본 서비스';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('예약하기')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 서비스 선택
            DropdownButton<String>(
              value: _selectedService,
              items:
                  ['기본 서비스', '프리미엄 서비스', 'VIP 서비스', 'VVVVIP 서비스']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedService = value!;
                  // 서비스에 따라 가격 변경
                  if (value == '기본 서비스')
                    _selectedAmount = 30000;
                  else if (value == '프리미엄 서비스')
                    _selectedAmount = 50000;
                  else if (value == 'VIP 서비스')
                    _selectedAmount = 100000;
                  else if (value == 'VVVVIP 서비스')
                    _selectedAmount = 10000000;
                });
              },
            ),
            SizedBox(height: 16),

            // 날짜 선택
            ListTile(
              title: Text('예약일: ${_selectedDate.toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 90)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 16),

            // 이름, 이메일 입력
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: '이름',
              ),
            ),
            SizedBox(height: 8),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: '이메일',
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 24),

            // 가격 표시
            Text(
              '결제 금액: ${formatAmount(_selectedAmount)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 24),

            // 결제 페이지로 이동 버튼
            GestureDetector(
              onTap: () {
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('이름을 입력해주세요')));
                  return;
                }

                // 예약 정보 객체 생성
                final reservationInfo = ReservationInfo(
                  reservationId: 'rsv_${DateTime.now().millisecondsSinceEpoch}',
                  serviceName: _selectedService,
                  amount: _selectedAmount,
                  customerName: _nameController.text,
                  customerEmail: _emailController.text,
                  reservationDate: _selectedDate,
                );
                Get.to(() => PaymentPage(reservationInfo: reservationInfo));
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 40),
                width: double.infinity,
                height: 58,
                child: const Text(
                  '결제하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
