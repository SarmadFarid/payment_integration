import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:payment_integration/payment_controller.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stripe Payment integraion")),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Center(
              child: Obx(
                () => OutlinedButton(
                  onPressed: () => controller.isloading.value
                      ? null
                      : controller.makePayment(paymentId: "1"),
                  child: controller.isloading.value
                      ? CircularProgressIndicator()
                      : Text("Buy"),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Obx(
                () => OutlinedButton(
                  onPressed: () => controller.isloading.value
                      ? null
                      : controller.saveCardForFuture(userId: 1),
                  child: controller.isloading.value
                      ? CircularProgressIndicator()
                      : Text("Save Card"),
                ),
              ),
            ),
            SizedBox(height: 10),

            Center(
              child: Obx(
                () => OutlinedButton(
                  onPressed: () => controller.isloading.value
                      ? null
                      : controller.getSavedCards(userId: 1),
                  child: controller.isloading.value
                      ? CircularProgressIndicator()
                      : Text("Get Card"),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
