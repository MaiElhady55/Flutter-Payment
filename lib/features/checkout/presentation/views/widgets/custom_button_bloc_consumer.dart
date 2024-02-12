import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:payment_app/core/utils/api_keys.dart';
import 'package:payment_app/core/widgets/custom_button.dart';
import 'package:payment_app/features/checkout/data/models/amount_model/amount_model.dart';
import 'package:payment_app/features/checkout/data/models/amount_model/details.dart';
import 'package:payment_app/features/checkout/data/models/item_list_model/item.dart';
import 'package:payment_app/features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:payment_app/features/checkout/data/models/payment_intent_input_model.dart';
import 'package:payment_app/features/checkout/presentation/view_models/cubit/stripe_payment_cubit.dart';
import 'package:payment_app/features/checkout/presentation/views/my_cart_view.dart';
import 'package:payment_app/features/checkout/presentation/views/thank_you_view.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({
    super.key,
    required this.isPaypal,
  });

  final bool isPaypal;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StripePaymentCubit, StripePaymentState>(
      listener: (context, state) {
        if (state is StripePaymentSuccess) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const ThankYouView();
          }));
        }

        if (state is StripePaymentFailure) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(content: Text(state.errMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return CustomButton(
            onTap: () {
              if (isPaypal) {
                var transactionsData = getTransactionsData();
                exceutePaypalPayment(context, transactionsData);
              } else {
                excuteStripePayment(context);
              }
            },
            isLoading: state is StripePaymentLoading ? true : false,
            text: 'Continue');
      },
    );
  }

  void excuteStripePayment(BuildContext context) {
    PaymentIntentInputModel paymentIntentInputModel = PaymentIntentInputModel(
      amount: '100',
      currency: 'USD',
      customerId: 'cus_PUSn1Sxb9o6EZf',
    );

    BlocProvider.of<StripePaymentCubit>(context)
        .makePayment(paymentIntentInputModel: paymentIntentInputModel);
  }

  void exceutePaypalPayment(BuildContext context,
      ({AmountModel amount, ItemListModel itemList}) transctionsData) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: ApiKeys.clientID,
        secretKey: ApiKeys.paypalSecretKey,
        transactions: [
          {
            "amount": transctionsData.amount.toJson(),
            "description": "The payment transaction description.",
            // "payment_options": {
            //   "allowed_payment_method":
            //       "INSTANT_FUNDING_SOURCE"
            // },
            "item_list": transctionsData.itemList.toJson(),
            // Optional
            //   "shipping_address": {
            //     "recipient_name": "Tharwat samy",
            //     "line1": "tharwat",
            //     "line2": "",
            //     "city": "tharwat",
            //     "country_code": "EG",
            //     "postal_code": "25025",
            //     "phone": "+00000000",
            //     "state": "ALex"
            //  },
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const ThankYouView();
            }),
            (route) {
              if (route.settings.name == '/') {
                return true;
              } else {
                return false;
              }
            },
          );
        },
        onError: (error) {
          SnackBar snackBar = SnackBar(content: Text(error.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const MyCartView();
            }),
            (route) {
              return false;
            },
          );
        },
        onCancel: () {
          print('cancelled:');
          Navigator.pop(context);
        },
      ),
    ));
  }

  ({AmountModel amount, ItemListModel itemList}) getTransactionsData() {
    var amount = AmountModel(
      currency: "USD",
      total: '100',
      details: Details(subtotal: '100', shipping: '0', shippingDiscount: 0),
    );
    List<OrderItemModel> orders = [
      OrderItemModel(currency: "USD", name: "Apple", price: '10', quantity: 4),
      OrderItemModel(
          currency: "USD", name: "Pineapple", price: '12', quantity: 5),
    ];
    var itemList = ItemListModel(items: orders);

    return (amount: amount, itemList: itemList);
  }
}
