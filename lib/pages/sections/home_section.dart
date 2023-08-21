import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../logic/constants.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height + 200,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/home_bg.jpg"),
        fit: BoxFit.cover,
      )),
      child: ClipRRect(
        child: Align(
          alignment: Alignment.centerLeft,
          child: LayoutBuilder(builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 1200;

            return Container(
              color: Colors.white.withOpacity(isMobile ? 0.6 : 0.2),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(left: 40, right: 40, bottom: 240),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PYRAMID TOKEN',
                    style: GoogleFonts.cinzelDecorative().copyWith(
                        fontSize: 60, color: Theme.of(context).backgroundColor),
                  ),
                  const Text(
                    "World's first legitimate Pyramid Scheme",
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      String url =
                          "https://app.uniswap.org/#/swap?inputCurrency=ETH&outputCurrency=$contractAddress";
                      if (!await launchUrl(Uri.parse(url))) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 40),
                        child: Text("BUY"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
