import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQSection extends StatelessWidget {
  const FAQSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor.withOpacity(0.94),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "FAQ",
              style: GoogleFonts.cinzelDecorative()
                  .copyWith(color: Colors.white, fontSize: 36),
            ),
            const SizedBox(height: 10,),
            _questionTile(
                "Is this legitimate? How can PYRA make me rich? ",
                """Yes, this is a genuine pyramid scheme built to benefit the early investors. None of the pyramid schemes tell you this before hand, but we do, because we believe that everyone should have an equal chance to profit from PYRA.
All the early comers will profit exponentially with our token.""",
                context),
            _questionTile(
                "I have bought the token and staked. What now?",
                "Refer your friends and family! Remember, the more people join after you, the better for your investment (basic principle of a pyramid scheme). Also, the contract will award you a massive 10% of the first stake of the people you refer. Make sure to tell them to set you as a referrer before they stake. Eg. Someone you referred staked 10,000 PYRA for any duration. You will get 1000 PYRA basically for free!",
                context),
            _questionTile(
                "Is staking necessary? Why is staking involved if there is going to be a rug pull?",
                "You can choose not to stake. Staking has been implemented so that referrers can be rewarded, and token price stability can be maintained early on. The rug pull will be publicly announced after we reach the TVL target, so make sure to withdraw your tokens before that!",
                context),
            _questionTile(
                "How can I earn through PYRA?",
                """There are 3 roles you can take to earn through PYRA
1. Peasant: Just buy tokens and sell when the price is high. Low risk, low reward.
2. Farmer: Active performer - stake and refer as much as you can. Collect rewards. Sell before the rug pull. High effort, high reward.
3. Vizier: Liquidity provider - join the inner circle of the Pharaoh and hold till the rug pull. High risk, highest reward.
Whatever role you opt for, make sure you are early to the party!""",
                context),
            _questionTile(
                "How can I see if I’m early or late?",
                "You can visually track how many people have joined before or after you with the help of our staking pyramid.",
                context),
            _questionTile(
                "Does the contract owner have special rights?",
                "The contract ownership is renounced. The contract is also verified and publicly available. We strongly believe that everyone in the community must have a equal chance to profit from the PYRA token.",
                context),
          ],
        ),
      ),
    );
  }

  _questionTile(String question, String answer, context) => Card(
        color: Colors.transparent,
        child: ExpansionTile(
          title: Text(
            question,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          textColor: Colors.white,
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          expandedAlignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
              child: Text(
                answer,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      );
}
