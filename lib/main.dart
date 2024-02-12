import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_app/core/utils/api_keys.dart';
import 'package:payment_app/features/checkout/presentation/views/my_cart_view.dart';

void main() {
  Stripe.publishableKey = ApiKeys.stripePublishableKey;
  runApp(const CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Payment App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyCartView());
  }
}

//PaymentIntentModel==>Create Payment Intent (amount , currency, customerId)
//KeySecret ==> Create Ephemeral Key (customerId)   //Stripe-Version is Header
//init Payment Sheet (merchantDisplayName , paymentIntentClientSecret ,ephemeralKey )
//PresentPaymentSheet()
