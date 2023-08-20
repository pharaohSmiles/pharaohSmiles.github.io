import 'package:flutter/material.dart';
import 'package:staking_test/pages/components/helper_widgets.dart';

class ConfirmationDialog extends StatelessWidget {
  final BigInt amount;
  final double daysToStake;

  const ConfirmationDialog(this.amount, this.daysToStake, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 40 : 200),
          backgroundColor: const Color(0xffD8CAB0).withOpacity(0.92),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                dialogHeading("Confirm Transaction", context),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Confirm your staking details:",
                    style: TextStyle(color: Colors.black, fontSize: 21),
                  ),
                ),
                RichText(
                    text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.black, fontSize: 21),
                        children: <TextSpan>[
                          const TextSpan(text: "Amount to stake:"),
                          TextSpan(
                            text: " $amount PYRA",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Colors.black,
                                fontSize: 21,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                RichText(
                    text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.black, fontSize: 21),
                        children: <TextSpan>[
                          const TextSpan(text: "Time to stake:"),
                          TextSpan(
                            text: " $daysToStake Days",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Colors.black,
                                fontSize: 21,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        primaryButton(context, "Accept", () {
                          Navigator.pop(context, true);
                          showToast(context, "Sending your transaction...");
                        }),
                        const SizedBox(
                          width: 100,
                        ),
                        primaryButton(context, "Reject", () {
                          Navigator.pop(context, false);
                        }),
                      ],
                    )),
              ],
            ),
          ),
        );
      }
    );
  }
}
