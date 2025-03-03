// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toss/model/reserve_model.dart';
import 'package:toss/screen/pay_failed.dart';
import 'package:toss/screen/pay_success.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

class PaymentPage extends StatefulWidget {
  final ReservationInfo reservationInfo;

  const PaymentPage({super.key, required this.reservationInfo});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late PaymentWidget _paymentWidget;
  PaymentMethodWidgetControl? _paymentMethodWidgetControl;
  AgreementWidgetControl? _agreementWidgetControl;

  // Format amount with commas
  String formatAmount(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  void initState() {
    super.initState();

    // 토스페이먼트 위젯 초기화
    _paymentWidget = PaymentWidget(
      clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
      customerKey:
          widget.reservationInfo.reservationId, // 예약 ID를 cutomerKey로 사용
    );

    // 결제 수단 위젯 렌더링 (예약 정보의 금액 사용)
    _paymentWidget
        .renderPaymentMethods(
          selector: 'methods',
          amount: Amount(
            value: widget.reservationInfo.amount,
            currency: Currency.KRW,
            country: 'KR',
          ),
          options: RenderPaymentMethodsOptions(variantKey: 'DEFAULT'),
        )
        .then((control) {
          _paymentMethodWidgetControl = control;
        });

    // 약관 동의 위젯 렌더링
    _paymentWidget.renderAgreement(selector: 'agreement').then((control) {
      _agreementWidgetControl = control;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('결제하기')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 예약 정보 요약 표시
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '서비스: ${widget.reservationInfo.serviceName}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('예약자: ${widget.reservationInfo.customerName}'),
                  SizedBox(height: 8),
                  Text(
                    '예약일: ${widget.reservationInfo.reservationDate.toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '금액: ${formatAmount(widget.reservationInfo.amount)}원',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // 결제 위젯들
            Expanded(
              child: ListView(
                children: [
                  PaymentMethodWidget(
                    paymentWidget: _paymentWidget,
                    selector: 'methods',
                  ),
                  AgreementWidget(
                    paymentWidget: _paymentWidget,
                    selector: 'agreement',
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // 결제 버튼
            GestureDetector(
              onTap: () async {
                // 결제 요청
                final paymentResult = await _paymentWidget.requestPayment(
                  paymentInfo: PaymentInfo(
                    // 예약정보로부터 orderId와 orderName 설정
                    orderId: widget.reservationInfo.reservationId,
                    orderName: '${widget.reservationInfo.serviceName} 예약',
                    // 추가 정보 설정
                    customerName: widget.reservationInfo.customerName,
                    customerEmail: widget.reservationInfo.customerEmail,
                    // 필요시 추가 메타데이터
                    metadata: {
                      'reservation_date':
                          widget.reservationInfo.reservationDate.toString(),
                    },
                  ),
                );
                // 결제 결과 처리
                if (paymentResult.success != null) {
                  // Success 객체를 PaymentSuccessResult로 변환
                  // 결제 성공 - 예약 정보와 결제 정보 함께 전달
                  Get.to(
                    () => PaySuccess(reservationInfo: widget.reservationInfo),
                  );
                } else if (paymentResult.fail != null) {
                  // 결제 실패
                  Get.to(() => PayFailed());
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 40),
                width: double.infinity,
                height: 65,
                child: Text(
                  '${formatAmount(widget.reservationInfo.amount)}원 결제하기',
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
