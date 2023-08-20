import 'package:flutter/material.dart';
import 'helper_widgets.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 1150;

      return isMobile
          ? _mobileInfoDialog(context)
          : _desktopInfoDialog(context);
    });
  }

  _desktopInfoDialog(context) => Dialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 6, vertical: 40),
        backgroundColor: const Color(0xffD8CAB0).withOpacity(0.92),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              dialogHeading("PYRAMID STAKING", context),
              Row(
                children: [
                  Image.asset(
                    "assets/images/pyramidlevels.png",
                    scale: 2,
                  ),
                  const Expanded(
                    child: Text(
                      "There are 5 levels in the staking pyramid. Each level denotes the stakeholders in chronological order, i.e. Level 1 people are the earliest to join. "
                      "The color of the pyramid gradually changes as more and more people join in. Remember, the earlier you join, the more profits you get! "
                      "You can view your position and the complete list of stakers by tapping on the Pyramid.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _levelInfo("Level 1: 0 to 100 stakeholders", 1),
                  _levelInfo("Level 2: 101 to 1000 stakeholders", 2),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _levelInfo("Level 3: 1001 to 5000 stakeholders", 3),
                  _levelInfo("Level 4: 5001 to 10000 stakeholders", 4),
                ],
              ),
              _levelInfo("Level 5: 10001 and above", 5),
            ],
          ),
        ),
      );

  _mobileInfoDialog(context) => Dialog(
        insetPadding: const EdgeInsets.all(40),
        backgroundColor: const Color(0xffD8CAB0).withOpacity(0.92),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              dialogHeading("PYRAMID STAKING", context),
              Image.asset(
                "assets/images/pyramidlevels.png",
                scale: 2.4,
              ),
              const Text(
                "There are 5 levels in the staking pyramid. Each level denotes the stakeholders in chronological order, i.e. Level 1 people are the earliest to join. "
                "The color of the pyramid gradually changes as more and more people join in. Remember, the earlier you join, the more profits you get! "
                "You can view your position and the complete list of stakers by tapping on the Pyramid.",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              _levelInfo("Level 1: 0 to 100 stakeholders", 1, scale: 2.4),
              _levelInfo("Level 2: 101 to 1000 stakeholders", 2, scale: 2.4),
              _levelInfo("Level 3: 1001 to 5000 stakeholders", 3, scale: 2.4),
              _levelInfo("Level 4: 5001 to 10000 stakeholders", 4, scale: 2.4),
              _levelInfo("Level 5: 10001 and above", 5, scale: 2.4),
            ],
          ),
        ),
      );

  _levelInfo(String txt, int level, {double scale = 2.0}) => Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Text(
              txt,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 12,
            ),
            Image.asset(
              "assets/images/pyramid$level.png",
              scale: scale,
            ),
          ],
        ),
      );
}
