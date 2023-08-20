import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:staking_test/pages/components/helper_widgets.dart';
import 'package:staking_test/pages/sections/footer_section.dart';
import 'package:staking_test/pages/sections/roadmap_section.dart';
import 'package:staking_test/pages/sections/home_section.dart';
import 'package:staking_test/pages/sections/howtobuy_section.dart';
import 'package:staking_test/pages/sections/socials_section.dart';
import 'package:staking_test/pages/sections/faq_section.dart';
import 'package:staking_test/pages/staking_page.dart';

class HomePage extends StatefulWidget {
  final int index;

  const HomePage(this.index, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> sections = const [
    HomeSection(),
    RoadmapSection(),
    HowToBuySection(),
    FAQSection(),
    SocialsSection(),
    FooterSection(),
  ];

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.index != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          itemScrollController.scrollTo(
              index: widget.index,
              duration: const Duration(milliseconds: 400)));
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Scaffold(
          key: _scaffoldKey,
          drawer: isMobile ? _mobileDrawer() : null,
          body: Column(
            children: [
              _stickyNavbar(isMobile),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemCount: sections.length,
                  itemScrollController: itemScrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return sections[index];
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  _stickyNavbar(bool isMobile) => Container(
        color: Theme.of(context).backgroundColor,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                if (isMobile) {
                  _scaffoldKey.currentState!.openDrawer();
                } else {
                  itemScrollController.scrollTo(
                      index: 0, duration: const Duration(milliseconds: 400));
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
                      primaryButton(context, "Stake Now", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const StakingPage()));
                      }),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
          ],
        ),
      );

  headerActionText(String title, int index) {
    return InkWell(
      onTap: () {
        if (index != -1) {
          itemScrollController.scrollTo(
              index: index, duration: const Duration(milliseconds: 400));
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
            primaryButton(context, "Stake Now", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const StakingPage()));
            }, verticalPadding: 0),
          ],
        ),
      );
}
