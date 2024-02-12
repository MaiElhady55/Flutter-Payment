class PaymentIntentInputModel {
  final String amount;
  final String currency;
  final String customerId;

  PaymentIntentInputModel({
    required this.amount,
    required this.currency,
    required this.customerId,
  });

  toJson() {
    return {
      'amount': '${amount}00',
      'currency': currency,
      'customer': customerId
    };
  }

  // Note the payment sub amount in 100 so you need to multiply amount in 100 first
}
