import 'package:checkinapp/componants/constants.dart';
import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 1,
              child: Image.asset(
                "assets/icons/icon.png",
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: kDefaultPedding * 20),
        // const Text(
        //   "CHECK-IN",
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
        const SizedBox(height: kDefaultPedding * 50),
        Center(
            child: Image.asset("assets/images/97111-loading-spinner-dots.gif",
                width: 100)),
      ],
    );
  }
}
