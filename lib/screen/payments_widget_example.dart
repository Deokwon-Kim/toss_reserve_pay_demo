import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toss/screen/pay_failed.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

class PaymentWidgetExamplePage extends StatefulWidget {
  const PaymentWidgetExamplePage({super.key});
  @override
  State<PaymentWidgetExamplePage> createState() {
    return _PaymentWidgetExamplePageState();
  }
}

class _PaymentWidgetExamplePageState extends State<PaymentWidgetExamplePage> {
  late PaymentWidget _paymentWidget;
  PaymentMethodWidgetControl? _paymentMethodWidgetControl;
  AgreementWidgetControl? _agreementWidgetControl;

  // Format amount with commas
  String formatAmount(int amount) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount)}원';
  }

  @override
  void initState() {
    super.initState();
    _paymentWidget = PaymentWidget(
      clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
      customerKey: "CUSTOMER_KEY",
      // 결제위젯에 브랜드페이 추가하기
      // paymentWidgetOptions: PaymentWidgetOptions(brandPayOption: BrandPayOption("리다이렉트 URL")) // Access Token 발급에 사용되는 리다이렉트 URL
    );
    _paymentWidget
        .renderPaymentMethods(
          selector: 'methods',
          amount: Amount(value: 300, currency: Currency.KRW, country: "KR"),
          // The formatted value for display would be: formatAmount(300) -> "300원"
          options: RenderPaymentMethodsOptions(variantKey: "DEFAULT"),
        )
        .then((control) {
          _paymentMethodWidgetControl = control;
        });
    _paymentWidget.renderAgreement(selector: 'agreement').then((control) {
      _agreementWidgetControl = control;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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

            // 결제하기 버튼
            GestureDetector(
              onTap: () async {
                final paymentResult = await _paymentWidget.requestPayment(
                  paymentInfo: const PaymentInfo(
                    orderId: 's2hDZDhdC3x6QGmf47ZGT',
                    orderName: '토스 티셔츠 외 2건',
                    // If you want to display the amount in the order summary:
                    // orderName: '토스 티셔츠 외 2건 (${formatAmount(300)})',
                  ),
                );
                if (paymentResult.success != null) {
                  // 결제 성공 처리
                  // 결제성공시 결제완료 페이지 이동
                } else if (paymentResult.fail != null) {
                  // 결제 실패 처리
                  Get.to(() => PayFailed()); // 결제실패시 결제실패 페이지 이동
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
                  '결제하기 (${formatAmount(300)})', // Added formatted amount to button text
                  style: const TextStyle(
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
