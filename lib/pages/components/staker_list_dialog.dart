import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'helper_widgets.dart';

class StakerListDialog extends StatelessWidget {
  final List<String> addresses;
  final int yourIndex;
  const StakerListDialog(this.addresses, this.yourIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemScrollController itemScrollController = ItemScrollController();
    double width = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 40 : width / 6, vertical: 40),
          backgroundColor: const Color(0xffD8CAB0).withOpacity(0.92),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                dialogHeading("PYRAMID STAKING", context),
                InkWell(
                  onTap: () {
                    if (yourIndex == -1) return;
                    itemScrollController.scrollTo(
                        index: yourIndex,
                        duration: const Duration(milliseconds: 400));
                  },
                  child: Text(
                    "Position of your first stake: ${yourIndex == -1 ? "You have not staked yet" : yourIndex + 1}",
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ScrollablePositionedList.separated(
                    itemCount: addresses.length,
                    itemScrollController: itemScrollController,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        addresses[index],
                        style: TextStyle(
                          color: index == yourIndex ? Colors.green : Colors.black,
                        ),
                      ),
                      leading: Text(
                        "${index + 1}.",
                        style: TextStyle(
                          color: index == yourIndex ? Colors.green : Colors.black,
                        ),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
