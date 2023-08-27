import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staking_test/pages/components/uniswap_iframe.dart';
import '../components/helper_widgets.dart';

class HowToBuySection extends StatelessWidget {
  const HowToBuySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffD8CAB0).withOpacity(0.82),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "HOW TO BUY",
              style: GoogleFonts.cinzelDecorative()
                  .copyWith(color: Colors.white, fontSize: 36),
            ),
            const SizedBox(height: 14,),
            yellowCardWithDetails(
                "l1",
                "CREATE A WALLET",
                """Install metamask or any other crypto wallet that you prefer. You can find them for free on the app store or google play store if you are using a mobile device. If you are using a desktop, you can get the google chrome extension from metamask.io.""",
                context),
            yellowCardWithDetails(
              "l2",
              "GET SOME ETH",
              """You can get ETH in different ways: buy it directly on metamask, send it from another wallet, or purchase it on another exchange and transfer it to your wallet.""",
              context,
            ),
            yellowCardWithDetails(
                "l3",
                "SWITCH ETH FOR \$PYRA",
                """Open app.uniswap.org on google chrome or on your Metamask app browser. Connect your wallet to the site. Copy and paste the \$PYRA token address into Uniswap, choose PYRA, and confirm the swap. Don’t worry, we have zero taxes!""",
                context),
            const UniswapIFrame(),
          ],
        ),
      ),
    );
  }
}
