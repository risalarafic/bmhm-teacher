import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/class_routine.dart';

Future<Uint8List> buildClassRoutinePdf({
  required ClassRoutine routine,
  String? teacherName,
}) async {
  final document = pw.Document();
  final green = PdfColor.fromInt(0xFF1B823E);
  final headerBg = PdfColor.fromInt(0xFF1B823E);
  final altRow = PdfColor.fromInt(0xFFF4F7FB);
  final border = PdfColor.fromInt(0xFFD0D5DD);
  final periodIds = routine.periodIds;

  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 32, 28, 32),
      build: (context) {
        if (periodIds.isEmpty) {
          return [
            _title(green),
            if (teacherName != null && teacherName.trim().isNotEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4, bottom: 16),
                child: pw.Text(
                  teacherName.trim(),
                  style: const pw.TextStyle(
                    fontSize: 13,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            pw.Text(
              'No class routine available.',
              style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
            ),
          ];
        }

        return [
          _title(green),
          if (teacherName != null && teacherName.trim().isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.Text(
                teacherName.trim(),
                style: const pw.TextStyle(
                  fontSize: 13,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          pw.SizedBox(height: 18),
          ...ClassRoutine.schoolWeekdays.expand((day) {
            return [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: pw.BoxDecoration(
                  color: headerBg,
                  borderRadius: const pw.BorderRadius.vertical(
                    top: pw.Radius.circular(6),
                  ),
                ),
                child: pw.Text(
                  ClassRoutine.weekdayLabelFor(day),
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              pw.Table(
                border: pw.TableBorder.all(color: border, width: 0.6),
                columnWidths: const {
                  0: pw.FlexColumnWidth(0.7),
                  1: pw.FlexColumnWidth(1.6),
                  2: pw.FlexColumnWidth(2.4),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      _cell('P', bold: true),
                      _cell('Time', bold: true),
                      _cell('Subject', bold: true),
                    ],
                  ),
                  ...periodIds.asMap().entries.map((entry) {
                    final periodId = entry.value;
                    final subject = routine.subjectAt(
                      weekday: day,
                      periodId: periodId,
                    );
                    final classLabel = routine.classLabelAt(
                      weekday: day,
                      periodId: periodId,
                    );
                    final subjectText = subject.isEmpty
                        ? '—'
                        : (classLabel.isEmpty
                            ? subject
                            : '$subject\n$classLabel');
                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: entry.key.isOdd ? altRow : PdfColors.white,
                      ),
                      children: [
                        _cell('$periodId', bold: true),
                        _cell(routine.timeRangeFor(periodId)),
                        _cell(subjectText),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 16),
            ];
          }),
        ];
      },
    ),
  );

  return document.save();
}

pw.Widget _title(PdfColor green) {
  return pw.Text(
    'Class Routine',
    style: pw.TextStyle(
      fontSize: 22,
      fontWeight: pw.FontWeight.bold,
      color: green,
    ),
  );
}

pw.Widget _cell(String text, {bool bold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 11,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: PdfColors.grey800,
      ),
    ),
  );
}
