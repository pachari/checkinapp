/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:checkinapp/utility/app_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../utility/app_controller.dart';
import '../data.dart';
// import 'package:http/http.dart' show get;

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const sep = 120.0;

AppController controller = Get.put(AppController());

Future<Uint8List> generateResume(PdfPageFormat format, CustomData data) async {
  final doc = pw.Document(
      title: 'Check-in report',
      author: controller.alleventforpirntModels.last.name);
  final swirls = await rootBundle.loadString('assets/nopic.svg');
  final pageTheme = await _myPageTheme(format);
  
  String datatitle = '';
  DateTime datastartdate;
  DateTime dataenddate;
  String dataresulttodo = '';
  int pageindex = 1;
  int pagecount = 0;

  List<List<dynamic>> events = [];
  events.add([
    'Factory',
    'BeginDate',
    'EndDate',
    'Result',
    // "Remark",
    "Image"
  ]);

  for (var i = 0; i < controller.todoresultforprintModels.length; i++) {
    datatitle =
        '${controller.factoryAllModels[controller.todoresultforprintModels[i].checkinid].title} ${controller.factoryAllModels[controller.todoresultforprintModels[i].checkinid].subtitle}';
    datastartdate =
        (controller.todoresultforprintModels[i].timestampIn).toDate();
    dataenddate =
        (controller.todoresultforprintModels[i].timestampOut)!.toDate();
    //find finish todo
    for (var z = 0;
        z < controller.todoresultforprintModels[i].finishtodo.length;
        z++) {
      if (controller.todoresultforprintModels[i].finishtodo[z] == true) {
        dataresulttodo += "${controller.todoresultforprintModels[i].todo[z]}  ";
      }
    }

    //เช็คการ upload image
    if (controller.todoresultforprintModels[i].image.isNotEmpty) {
      await AppService().readFileUpload(
          controller.todoresultforprintModels[i].uidCheck,
          '${controller.todoresultforprintModels[i].checkinid}',
          controller.todoresultforprintModels[i].timestampIn.toDate(),
          controller.todoresultforprintModels[i].todoid,
          controller.todoresultforprintModels[i].image,
          );

      if (controller.fileuploadModels.isNotEmpty) {
        final netImage =
            await networkImage(controller.fileuploadModels.last.image);

        events.add([
          datatitle,
          DateFormat('yyyy-MM-dd HH:mm').format(datastartdate),
          DateFormat('yyyy-MM-dd HH:mm').format(dataenddate),
          dataresulttodo,
          pw.Image(netImage, height: 50, width: 100)
        ]);
      } else {
        events.add([
          datatitle,
          DateFormat('yyyy-MM-dd HH:mm').format(datastartdate),
          DateFormat('yyyy-MM-dd HH:mm').format(dataenddate),
          dataresulttodo,
          pw.Center(child: pw.SvgImage(svg: swirls, width: 120, height: 50)),
        ]);
      }
    } else {
      events.add([
        datatitle,
        DateFormat('yyyy-MM-dd HH:mm').format(datastartdate),
        DateFormat('yyyy-MM-dd HH:mm').format(dataenddate),
        dataresulttodo,
        pw.Center(child: pw.SvgImage(svg: swirls, width: 120, height: 50)),
      ]);
    }
    pagecount = ((controller.todoresultforprintModels.length) / 8).ceil();
    if (i % 7 == 0 && i > 0 ||
        i == controller.todoresultforprintModels.length - 1) {
      doc.addPage(
        pw.MultiPage(
          pageTheme: pageTheme,
          build: (pw.Context context) => [
            pw.Partitions(
              children: [
                pw.Partition(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Header(level: 1, text: 'Check-in report'),
                      pw.Container(
                        padding: const pw.EdgeInsets.only(left: 0, bottom: 5),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: <pw.Widget>[
                            pw.Text(
                              'Date: ${controller.alleventforpirntModels.last.beginDate} to ${controller.alleventforpirntModels.last.endDate}',
                              textScaleFactor: 0.8,
                              // style: pw.Theme.of(context)
                            ),
                            pw.Padding( padding: const pw.EdgeInsets.all(3)),
                            pw.Text(
                              'Username: ${controller.alleventforpirntModels.last.name}',
                              textScaleFactor: 0.8,
                              // style: pw.Theme.of(context)
                              //     .defaultTextStyle
                              //     .copyWith(fontWeight: pw.FontWeight.bold)
                            ),
                            // pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
                          ],
                        ),
                      ),
                      pw.TableHelper.fromTextArray(
                        context: context,
                        data: events,
                      ),
                      pw.Padding(padding: const pw.EdgeInsets.all(10)),
                      pw.Text('${pageindex++} / $pagecount'),
                    ],
                  ),
                ),
                // pw.Partition(
                //   width: sep,
                //   child: pw.Column(
                //     children: [
                //       pw.Container(
                //         height: pageTheme.pageFormat.availableHeight,
                //         child: pw.Column(
                //           crossAxisAlignment: pw.CrossAxisAlignment.center,
                //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                //           children: <pw.Widget>[
                //             pw.ClipOval(
                //               child: pw.Container(
                //                 width: 100,
                //                 height: 100,
                //                 color: lightGreen,
                //                 child: pw.Image(profileImage),
                //               ),
                //             ),
                //             pw.Column(children: <pw.Widget>[
                //               _Percent(size: 60, value: .7, title: pw.Text('Word')),
                //               _Percent(
                //                   size: 60, value: .4, title: pw.Text('Excel')),
                //             ]),
                //             pw.BarcodeWidget(
                //               data: 'Parnella Charlesbois',
                //               width: 60,
                //               height: 60,
                //               barcode: pw.Barcode.qrCode(),
                //               drawText: false,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ],
        ),
      );
      events = [];
      events.add([
        'Factory',
        'BeginDate',
        'EndDate',
        'Result',
        // "Remark",
        "Image"
      ]);
    }

    datatitle = '';
    datastartdate;
    dataenddate;
    dataresulttodo = '';
  }
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final bgShape = await rootBundle.loadString('assets/resume.svg');

  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 2.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 2.0 * PdfPageFormat.cm);
  return pw.PageTheme(
    pageFormat: format,
    theme: pw.ThemeData.withFont(
      base: await PdfGoogleFonts
          .kanitExtraLight(), //await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts
          .kanitLight(), //await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Positioned(
              child: pw.SvgImage(svg: bgShape),
              left: 0,
              top: 0,
            ),
            pw.Positioned(
              child: pw.Transform.rotate(
                  angle: pi, child: pw.SvgImage(svg: bgShape)),
              right: 0,
              bottom: 0,
            ),
          ],
        ),
      );
    },
  );
}

// class _Block extends pw.StatelessWidget {
//   _Block({
//     required this.title,
//     this.icon,
//   });
//   final String title;
//   final pw.IconData? icon;
//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: <pw.Widget>[
//           pw.Row(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: <pw.Widget>[
//                 pw.Container(
//                   width: 6,
//                   height: 6,
//                   margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
//                   decoration: const pw.BoxDecoration(
//                     color: green,
//                     shape: pw.BoxShape.circle,
//                   ),
//                 ),
//                 pw.Text(title,
//                     style: pw.Theme.of(context)
//                         .defaultTextStyle
//                         .copyWith(fontWeight: pw.FontWeight.bold)),
//                 pw.Spacer(),
//                 if (icon != null) pw.Icon(icon!, color: lightGreen, size: 18),
//               ]),
//           pw.Container(
//             decoration: const pw.BoxDecoration(
//                 border: pw.Border(left: pw.BorderSide(color: green, width: 2))),
//             padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
//             margin: const pw.EdgeInsets.only(left: 5),
//             child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: <pw.Widget>[
//                   pw.Lorem(length: 20),
//                 ]),
//           ),
//         ]);
//   }
// }
// class _Category extends pw.StatelessWidget {
//   _Category({required this.title});
//   final String title;
//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.Container(
//       decoration: const pw.BoxDecoration(
//         color: lightGreen,
//         borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
//       ),
//       margin: const pw.EdgeInsets.only(bottom: 10, top: 20),
//       padding: const pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
//       child: pw.Text(
//         title,
//         textScaleFactor: 1.5,
//       ),
//     );
//   }
// }
// class _Percent extends pw.StatelessWidget {
//   _Percent({
//     required this.size,
//     required this.value,
//     required this.title,
//   });

//   final double size;

//   final double value;

//   final pw.Widget title;

//   static const fontSize = 1.2;

//   PdfColor get color => green;

//   static const backgroundColor = PdfColors.grey300;

//   static const strokeWidth = 5.0;

//   @override
//   pw.Widget build(pw.Context context) {
//     final widgets = <pw.Widget>[
//       pw.Container(
//         width: size,
//         height: size,
//         child: pw.Stack(
//           alignment: pw.Alignment.center,
//           fit: pw.StackFit.expand,
//           children: <pw.Widget>[
//             pw.Center(
//               child: pw.Text(
//                 '${(value * 100).round().toInt()}%',
//                 textScaleFactor: fontSize,
//               ),
//             ),
//             pw.CircularProgressIndicator(
//               value: value,
//               backgroundColor: backgroundColor,
//               color: color,
//               strokeWidth: strokeWidth,
//             ),
//           ],
//         ),
//       )
//     ];

//     widgets.add(title);

//     return pw.Column(children: widgets);
//   }
// }

// class _UrlText extends pw.StatelessWidget {
//   _UrlText(this.text, this.url);

//   final String text;
//   final String url;

//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.UrlLink(
//       destination: url,
//       child: pw.Text(text,
//           style: const pw.TextStyle(
//             decoration: pw.TextDecoration.underline,
//             color: PdfColors.blue,
//           )),
//     );
//   }
// }
