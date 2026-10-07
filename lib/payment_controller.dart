import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  RxBool isloading = false.obs;

  Future<void> makePayment({required String paymentId}) async {
    isloading.value = true;
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/payments/create-payment-intent'),
        body: {"product_id": paymentId},
        headers: {"Accept": "application/json"},
      );
      final result = jsonDecode(response.body);
      log("response body : $result");
      if (response.statusCode == 200) {
        final String clientSecret = result['client_secret'];

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'My Flutter Store',
          ),
        );

        await Stripe.instance.presentPaymentSheet();
      } else {
        final String errorMessage = result['message'];
        log(" backend error: $errorMessage");
      }
    } catch (e) {
      log('error: $e');
    } finally {
      isloading.value = false;
    }
  }

  Future<void> saveCardForFuture({required int userId}) async {
    isloading.value = true;
    try {
      // 🌐 1. Backend se SetupIntent & Customer details lena
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/payments/create-setup-intent'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode != 200) {
        Get.snackbar("Backend error", response.body, borderColor: Colors.red);
      }

      final data = jsonDecode(response.body);

      final setupIntentSecret = data['setup_intent_client_secret'];
      final customerId = data['customer_id'];
      final ephemeralKeySecret = data['ephemeral_key_secret'];

      // ⚙️ 2. Payment Sheet Initialize karna (SetupIntent ke sath)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: setupIntentSecret,
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKeySecret,
          merchantDisplayName: 'My Flutter Store',
        ),
      );

      // 📱 3. Sheet open karna
      await Stripe.instance.presentPaymentSheet();

      log('Card Saved Successfully! 💳');
    } on StripeException catch (e) {
      log('Stripe Error: ${e.error.localizedMessage}');
    } catch (e) {
      log('General Error: $e');
    } finally {
      isloading.value = false;
    }
  }

   
   Future<void> getSavedCards({required int userId}) async {
    isloading.value = true  ; 
  try {
    final response = await http.get(
      Uri.parse(
        'http://127.0.0.1:8000/api/payments/payment-methods/$userId',
      ),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      log('Saved cards: $data');
    } else {
      log('Failed to get cards: ${response.body}');
    }
  } catch (e) {
    log('Error: $e');
  }
  finally {
    isloading.value = false  ; 
  }
}
   
    

}
