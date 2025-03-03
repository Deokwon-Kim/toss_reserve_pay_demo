import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toss/model/reserve_model.dart';
import 'package:toss/screen/reservation_page.dart';

class PaySuccess extends StatelessWidget {
  final ReservationInfo reservationInfo;

  const PaySuccess({super.key, required this.reservationInfo});

  // Format amount with commas
  String formatAmount(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            Text(
              '예약 및 결제가 완료되었습니다!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 36),
            // 예약정보 표시
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('예약번호: ${reservationInfo.reservationId}'),
                  SizedBox(height: 8),
                  Text('서비스: ${reservationInfo.serviceName}'),
                  SizedBox(height: 8),
                  Text('예약자: ${reservationInfo.customerName}'),
                  SizedBox(height: 8),
                  Text(
                    '예약일: ${reservationInfo.reservationDate.toString().split(' ')[0]}',
                  ),
                  SizedBox(height: 8),
                  Text('결제금액: ${formatAmount(reservationInfo.amount)}원'),
                  SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(height: 36),

            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.off(() => ReservationPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.amber,
                ),
                child: Text('홈으로'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
