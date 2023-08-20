import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staking_test/logic/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialsSection extends StatelessWidget {
  const SocialsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffD8CAB0).withOpacity(0.82),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "JOIN THE CULT",
              style: GoogleFonts.cinzelDecorative()
                  .copyWith(color: Colors.white, fontSize: 36),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("s1", "https://discord.gg/SgH7cTaz"),
                    _socialButton("s2", "https://t.me/+R1ogF8C4bvM1NTY1"),
                    _socialButton("s3", "https://twitter.com/PYRAToken"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(
                        "s4", "https://etherscan.io/token/$contractAddress"),
                    _socialButton("s5",
                        "https://app.uniswap.org/swap?outputCurrency=$contractAddress"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _socialButton(String img, String url) => InkWell(
        onTap: () async {
          if (!await launchUrl(Uri.parse(url))) {
            throw Exception('Could not launch $url');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset(
            "assets/images/$img.png",
            scale: 1.6,
          ),
        ),
      );
}
