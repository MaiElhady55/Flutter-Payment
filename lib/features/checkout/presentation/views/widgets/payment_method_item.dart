import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    super.key,
    required this.isActive,
    required this.image,
  });

  final bool isActive;
  final String image;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 103,
      height: 62,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isActive
                  ? const Color(0XFF34A853)
                  : Colors.grey, //const Color.fromRGBO(0, 0, 0, 0.5),
              width: 1.5),
          boxShadow: [
            BoxShadow(
                color: isActive ? const Color(0XFF34A853) : Colors.white,
                offset: const Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0)
          ]),
      child: Center(
        child: SvgPicture.asset(
          image,
          height: 24,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
