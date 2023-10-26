// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controllers/playerController.dart';
import '../textFields/common_textfield.dart';
import '../text_highlight/text_highlight.dart';

class TranscriptionUrduContainer extends StatelessWidget {
  final String source;
  final List transcriptionlistdir;
  final TextEditingController? searchText;
  final VideoController videoController;

  const TranscriptionUrduContainer({
    Key? key,
    this.source = '',
    required this.transcriptionlistdir,
    this.searchText,
    required this.videoController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonTextField4(
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
          ],
          hintText: 'لفظ تلاش کریں',
          prefixIcon: Icons.search,
          controller: searchText,
          fillcolor: const Color(0xff62636d),
        ).marginOnly(left: 5, right: 5, bottom: 14),
        InteractiveViewer(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              children: [
                for (int i = 0; i < transcriptionlistdir.length; i++)




                  GestureDetector(
                    onDoubleTap: () {
                      String splittext = transcriptionlistdir[i]['duration'].split('-').first;
                      String splittext2 = transcriptionlistdir[i]['duration'].split('-').last;
                      double starttime = double.parse(splittext);
                      double endtime = double.parse(splittext2);
                      videoController
                          .betterPlayerController.videoPlayerController!
                          .seekTo(Duration(seconds: starttime.toInt()));
                      videoController.update();
                    },
                    child:
                    TextHighlighting(
                      textScaleFactor: 1.0,
                      text: '${transcriptionlistdir[i]['line']}',
                      highlights: [
                        searchText!.text.isEmpty
                            ? "ssadsauadnasjjwjeiweuywdsjandsakjdsad"
                            : searchText!.text
                      ],
                      style: GoogleFonts.notoNastaliqUrdu(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        backgroundColor: source.toLowerCase() == 'website' ||
                                source.toLowerCase() == 'print' ||
                                source.toLowerCase() == 'blog'
                            ? Colors.transparent
                            : videoController.playerTime == null
                                ? Colors.transparent
                                : videoController.check(
                                    transcriptionlistdir[i]['duration'],
                                    videoController.playerTime!,
                                  ),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TranscriptionEnglishContainer extends StatelessWidget {
  final String source;
  final List transcriptionlistdir;
  final TextEditingController? searchText;
  final Color? textbackgroundColr;
  final VideoController videoController;

  const TranscriptionEnglishContainer({
    Key? key,
    this.source = '',
    required this.transcriptionlistdir,
    this.textbackgroundColr,
    this.searchText,
    required this.videoController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CommonTextField3(
        //   inputFormatters: [
        //     FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
        //   ],
        //   hintText: 'Search Transcription',
        //   prefixIcon: Icons.search,
        //   controller: searchText,
        //   fillcolor: const Color(0xffEAEAEA),
        // ).marginOnly(left: 50, right: 50, bottom: 14),
        InteractiveViewer(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Wrap(
              alignment: WrapAlignment.start,
              clipBehavior: Clip.none,
              children: [
                for (int i = 0; i < transcriptionlistdir.length; i++)
                  GestureDetector(
                    onDoubleTap: () {
                      String splittext =
                          transcriptionlistdir[i]['duration'].split('-').first;
                      String splittext2 =
                          transcriptionlistdir[i]['duration'].split('-').last;
                      double starttime = double.parse(splittext);
                      double endtime = double.parse(splittext2);
                      videoController
                          .betterPlayerController.videoPlayerController!
                          .seekTo(Duration(seconds: starttime.toInt()));
                      videoController.update();
                    },
                    child: TextHighlighting(
                      caseSensitive: false,
                      textScaleFactor: 1.0,
                      text: '${transcriptionlistdir[i]['line']}',
                      highlights: [
                        searchText!.text.isEmpty
                            ? "ssadsauadnasjjwjeiweuywdsjandsakjdsadsdfdscdcfdsfcasfc"
                            : searchText!.text,
                      ],
                      style: TextStyle(
                        fontSize: 14.0,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        backgroundColor: source.toLowerCase() == 'website' ||
                                source.toLowerCase() == 'print' ||
                                source.toLowerCase() == 'blog'
                            ? Colors.transparent
                            : videoController.check(
                                transcriptionlistdir[i]['duration'],
                                videoController.playerTime!,
                              ),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}
