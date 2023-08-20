import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:staking_test/pages/components/helper_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class TxResultDialog extends StatefulWidget {
  final TransactionResponse tx;

  const TxResultDialog(this.tx, {Key? key}) : super(key: key);

  @override
  State<TxResultDialog> createState() => _TxResultDialogState();
}

class _TxResultDialogState extends State<TxResultDialog> {
  TransactionReceipt? _receipt;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 900;

      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 40 : 200),
        backgroundColor: const Color(0xffD8CAB0).withOpacity(0.92),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dialogHeading("Transaction Successful", context),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Transaction Hash",
                  style: TextStyle(color: Colors.black, fontSize: 21),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.8),
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                        child: SelectableText(
                      widget.tx.hash,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    IconButton(
                        tooltip: "View on Etherscan",
                        onPressed: () async {
                          String url =
                              "https://etherscan.io/tx/${widget.tx.hash}";
                          if (!await launchUrl(Uri.parse(url))) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        icon: const Icon(
                          Feather.external_link,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _receipt == null
                      ? "Waiting for the transaction to be complete..."
                      : "Transaction added to the blockchain successfully!",
                  style: const TextStyle(color: Colors.black, fontSize: 21),
                ),
              ),
              _receipt == null
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    _receipt = await widget.tx.wait();
    if (mounted) {
      setState(() {});
    }
  }
}
