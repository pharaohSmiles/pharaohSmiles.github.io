import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

void showToast(BuildContext context, String msg) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    webBgColor: "linear-gradient(to right, #CD962C, #00B9F3)",
    backgroundColor: Theme.of(context).primaryColor,
    textColor: Colors.white,
    fontSize: 16.0);

primaryButton(context, String title, fn, {verticalPadding = 20}) => Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: InkWell(
        onTap: () {
          fn();
        },
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(title),
          ),
        ),
      ),
    );

yellowCardWithDetails(String img, String title, String description, context,
        {Widget? bar}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.94),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/$img.png",
                scale: 1.8,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 24),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    bar ?? Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

dialogHeading(title, context) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.cinzelDecorative()
                  .copyWith(color: Colors.black, fontSize: 36),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Feather.x))
        ],
      ),
    );

openWhitePaper() => html.window.open("/assets/PYRAWhitepaper.pdf", "text");
