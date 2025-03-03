import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toss/screen/reservation_page.dart';

class PayFailed extends StatelessWidget {
  const PayFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, color: Colors.red, size: 100),
            Text(
              '결제실패',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
