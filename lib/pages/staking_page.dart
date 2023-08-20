import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_web3/ethereum.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staking_test/models/staker.dart';
import 'package:staking_test/logic/staking_functions.dart';
import 'package:staking_test/pages/components/tx_dialog.dart';
import 'package:staking_test/pages/home_page.dart';
import 'components/helper_widgets.dart';
import 'components/info_dialog.dart';
import 'components/staker_list_dialog.dart';

class StakingPage extends StatefulWidget {
  const StakingPage({super.key});

  @override
  State<StakingPage> createState() => _StakingPageState();
}

class _StakingPageState extends State<StakingPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StakingFunctions stakingFunctions = StakingFunctions();
  num bal = 0;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  double daysToStake = 30;
  String selectedAddress = "";
  Staker? staker;
  List<String> stakerAddresses = [];

  @override
  void initState() {
    getAllStakers();
    super.initState();
  }

  getAllStakers() async {
    stakerAddresses = await stakingFunctions.getStakerAddresses();
    print('All stakers $stakerAddresses');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xffD8CAB0).withOpacity(0.82),
          drawer: isMobile ? _mobileDrawer() : null,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _navBar(isMobile),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      isMobile
                          ? Column(
                              children: _mainContent(isMobile),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _mainContent(isMobile)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "© 2023 by PYRA. All rights reserved",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _mobileDrawer() => Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    scale: 1.7,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "PYRA",
                    style: GoogleFonts.cinzelDecorative()
                        .copyWith(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
            headerActionText("Home", 0),
            headerActionText("Roadmap", 1),
            headerActionText("How To Buy", 2),
            headerActionText("Whitepaper", -1),
            headerActionText("FAQs", 3),
          ],
        ),
      );

  // fetches address, balance, staking info and updates the UI
  connectWallet() async {
    if (ethereum != null) {
      try {
        // Prompt user to connect to the provider, i.e. confirm the connection modal
        final accs = await ethereum!.requestAccount();
        print(accs);
        stakingFunctions.subscribeToEvents(connectWallet);
        selectedAddress = ethereum!.selectedAddress!.toLowerCase();
        bal = await stakingFunctions.fetchBalance();
        staker = await stakingFunctions.getStakerInfo(selectedAddress);
        print(staker.toString());
        if (staker == null) {
          showToast(
              context, "Make sure you are connected to the correct network!");
        }
        setState(() {});
      } catch (e) {
        print(e);
        showToast(context, 'Please accept the request on your wallet');
      }
    } else {
      showToast(context, "Cannot detect any web3 wallet. Install Metamask!");
    }
  }

  _pyramid(double width, bool isMobile) => GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (c) => StakerListDialog(stakerAddresses,
                  stakerAddresses.indexOf(selectedAddress)));
        },
        child: SizedBox(
          width: width,
          child: Image.asset(
            "assets/images/pyramid${calcLevel(stakerAddresses.length)}.png",
            scale: 1,
            fit: BoxFit.contain,
          ),
        ),
      );

  _stakeBox(double width) => Container(
        color: Theme.of(context).primaryColor.withOpacity(0.32),
        width: width,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "STAKE",
              style: GoogleFonts.cinzelDecorative()
                  .copyWith(color: Colors.white, fontSize: 36),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 40,
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      """You are not on the Pyramid yet.
Stake your tokens to get a spot on the Pyramid!
Get 100% APR on your tokens!""",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Feather.help_circle,
                    size: 18,
                  ),
                  tooltip:
                      "Whenever you stake, you take a spot on the pyramid. Visually track how many stakeholders are coming before or after you.",
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Balance : ${bal.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.black),
                    )),
                InkWell(
                  onTap: () {
                    _amountController.text = bal.toStringAsFixed(2);
                  },
                  child: const Text(
                    "MAX",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            _amountTextField(
                _amountController, true, "Enter the amount you want to stake"),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Selected Time Period: $daysToStake days",
              style: const TextStyle(color: Colors.black),
            ),
            Slider(
              value: daysToStake,
              onChanged: (newVal) => setState(() {
                daysToStake = newVal.truncate() as double;
              }),
              min: 30,
              max: 90,
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Theme.of(context).primaryColor.withOpacity(0.4),
            ),
            primaryButton(context, "Stake", () async {
              final tx = await stakingFunctions.stake(
                  _amountController.text, daysToStake, bal, context);
              if (tx == null) return;

              showDialog(context: context, builder: (c) => TxResultDialog(tx));

              print(tx.hash);
              showToast(context, "Transaction Sent: ${tx.hash}");

              final receipt =
                  await tx.wait(); // Wait until transaction complete
              print(receipt.from);
              print(receipt.to);

              await getAllStakers();
              connectWallet();
            }),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: _amountTextField(_addressController, false,
                      "Enter the address of your referrer"),
                ),
                const SizedBox(
                  width: 10,
                ),
                primaryButton(context, "Set Referrer", () async {
                  final tx = await stakingFunctions.setReferrer(
                      _addressController.text.trim(), context);
                  if (tx == null) return;

                  showDialog(
                      context: context, builder: (c) => TxResultDialog(tx));

                  print(tx.hash);
                  showToast(context, "Referrer set successfully: ${tx.hash}");

                  final receipt =
                      await tx.wait(); // Wait until transaction complete
                  print(receipt.from);
                  print(receipt.to);
                  _addressController.clear();
                }),
              ],
            ),
            const Text(
              "You can only set your referrer once. Make sure to set the referrer BEFORE you stake for the first time. The contract will award your referrer 10% of the amount of your first stake.",
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );

  headerActionText(String title, int index) {
    return InkWell(
      onTap: () {
        if (index != -1) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => HomePage(index)));
        } else {
          openWhitePaper();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  _amountTextField(
          TextEditingController controller, bool isDigitOnly, String hint) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          inputFormatters: isDigitOnly
              ? [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ]
              : null,
          keyboardType: isDigitOnly
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
          controller: controller,
          decoration: InputDecoration(
            fillColor: Theme.of(context).primaryColor.withOpacity(0.5),
            filled: true,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.0),
            ),
            hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
            border: const OutlineInputBorder(),
            hintText: hint,
          ),
        ),
      );

  _addressWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
                "${selectedAddress.substring(0, 6)}...${selectedAddress.substring(selectedAddress.length - 4, selectedAddress.length)}"),
          ),
        ),
      );

  _alreadyStakedBox(double width) {
    num daysSpent =
        ((DateTime.now().millisecondsSinceEpoch / 1000) - staker!.stakingTime) /
            86400;
    num duration = staker!.customStakeDuration / 86400;
    String daysLeft = (max(0, duration - daysSpent)).toStringAsFixed(2);

    num reward = staker!.amount * (duration / 365);
    String rewards = reward.toStringAsFixed(2);

    int index = stakerAddresses.indexOf(selectedAddress);
    int above = index;
    int below = stakerAddresses.length - index - 1;
    int level = calcLevel(index);

    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.32),
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "STAKE",
            style: GoogleFonts.cinzelDecorative()
                .copyWith(color: Colors.white, fontSize: 36),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                width: 40,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    """You are currently on level $level on the Pyramid.
There are $above holders before you and $below holders after you
Congrats! You’re early!""",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Feather.help_circle,
                  size: 18,
                ),
                tooltip: "Based on the info of your first stake",
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              """Time to withdraw: $daysLeft days left
Total Rewards: $rewards PYRA""",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          primaryButton(context, "Withdraw", () async {
            final tx = await stakingFunctions.withdraw(daysLeft, context);
            if (tx == null) return;

            showDialog(context: context, builder: (c) => TxResultDialog(tx));

            print(tx.hash);
            showToast(context, "Transaction Sent: ${tx.hash}");

            final receipt = await tx.wait(); // Wait until transaction complete
            print(receipt.from);
            print(receipt.to);
            connectWallet();
          }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  int calcLevel(int index) {
    int level = 1;
    if (index <= 100) {
      level = 1;
    } else if (index <= 1000) {
      level = 2;
    } else if (index <= 5000) {
      level = 3;
    } else if (index <= 10000) {
      level = 4;
    } else {
      level = 5;
    }

    return level;
  }

  _navBar(bool isMobile) => Container(
        color: Theme.of(context).backgroundColor,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                if (isMobile) {
                  _scaffoldKey.currentState!.openDrawer();
                } else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomePage(0)));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      scale: 1.7,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "PYRA",
                      style: GoogleFonts.cinzelDecorative()
                          .copyWith(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            isMobile
                ? Container()
                : Row(
                    children: [
                      headerActionText("Home", 0),
                      headerActionText("Roadmap", 1),
                      headerActionText("How To Buy", 2),
                      headerActionText("Whitepaper", -1),
                      headerActionText("FAQs", 3),
                    ],
                  ),
            selectedAddress == ""
                ? primaryButton(context, "Connect Wallet", connectWallet)
                : _addressWidget(),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      );

  List<Widget> _mainContent(bool isMobile) {
    double width = MediaQuery.of(context).size.width / (isMobile ? 1 : 2) - 20;
    return [
      _pyramid(width, isMobile),
      const SizedBox(
        height: 20,
      ),
      Column(
        children: [
          staker == null || staker!.amount == 0
              ? _stakeBox(width)
              : _alreadyStakedBox(width),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context, builder: (c) => const InfoDialog());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Feather.info,
                    color: Colors.black,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Learn more about the pyramid staking model",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    ];
  }
}
