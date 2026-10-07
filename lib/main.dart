import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_integration/payment_screen.dart';
import 'package:payment_integration/student-Management/std_screen.dart';

void main() {

  Stripe.publishableKey =
      'pk_test_51T2v5k84q2RKJ6Nn2pbvNu2o4T7B5OMU9Mf9VCUkUaamm6dy3fC1pXqR1ynZ4LUfweTKoMvc0FUtfKPkZe5Kkfj5008m8VyUKR';


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PaymentScreen(),
    );
  }
}
 