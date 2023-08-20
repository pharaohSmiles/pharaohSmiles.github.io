import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;

import '../../logic/constants.dart';
import '../components/helper_widgets.dart';

class RoadmapSection extends StatefulWidget {
  const RoadmapSection({Key? key}) : super(key: key);

  @override
  State<RoadmapSection> createState() => _RoadmapSectionState();
}

class _RoadmapSectionState extends State<RoadmapSection> {
  double percentDone = 0;

  @override
  void initState() {
    fetchTVL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor.withOpacity(0.94),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "ROADMAP",
              style: GoogleFonts.cinzelDecorative()
                  .copyWith(color: Colors.white, fontSize: 36),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "Most crypto projects crash one day or the other. We are a token which is designed to crash. However, we’ll make you rich before we go down in our blaze of glory!",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontSize: 22,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            yellowCardWithDetails(
                "p1",
                "Phase 1: The Launch",
                """• Token and website launch with providing initial liquidity
• Staking(100% APR): We have designed a visual pyramid showing your position in the pyramid scheme – now you can finally see how early you are and how many people come after you!
• Referral rewards: You will get 10% of the first staking amount of the people you refer. Remember, the more people join the Pyramid, the better for your investment!""",
                context),
            yellowCardWithDetails(
              "p2",
              "Phase 2: Liquidity Target",
              """• Our target is to reach at least \$40M TVL(total value locked) on Uniswap
• LP tokens will be locked till a particular date decided by the community. You can also provide liquidity and enjoy rewards! Join the discord server to learn more
• You can track the target progress here. The values are updated daily.""",
              context,
              bar: progressBar(percentDone, context),
            ),
            yellowCardWithDetails(
                "p3",
                "Phase 3: The Rug Pull",
                """• The rug pull will be publicly announced on our social media handles after we have reached our liquidity target.
• LP tokens will be unlocked and the liquidity will be pulled out. The Viziers will earn exponential profits.
• You may choose to sell your tokens before the rug pull. This is not for the light hearted!""",
                context),
          ],
        ),
      ),
    );
  }

  progressBar(double percentDone, BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 4),
        child: LinearPercentIndicator(
          lineHeight: 30,
          percent: percentDone,
          animation: true,
          animationDuration: 2000,
          leading: Text('\$0'),
          trailing: Text('\$40M'),
          center: Text(
            "${percentDone * 100}% = \$${(percentDone * 40).toStringAsFixed(2)}M locked",
          ),
          backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.7),
          progressColor: Theme.of(context).primaryColor,
        ),
      );

  fetchTVL() async {
    try {
      var response = await http.get(Uri.parse(tvlEndpoint));
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        int tvl = jsonDecode(response.body)["TVL"];
        String percent = (tvl / 40000000).toStringAsFixed(4);
        percentDone = double.parse(percent);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }
}
