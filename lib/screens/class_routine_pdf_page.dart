import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../models/class_routine.dart';
import '../utils/common_methods.dart';
import '../utils/constants/colors.dart';
import '../utils/routine_pdf.dart';

class ClassRoutinePdfPage extends StatelessWidget {
  const ClassRoutinePdfPage({
    super.key,
    required this.routine,
    this.teacherName,
  });

  final ClassRoutine routine;
  final String? teacherName;

  static const _filesChannel = MethodChannel('com.bmhm.bmhm_teacher/files');

  Future<void> _download(BuildContext context) async {
    try {
      final bytes = await buildClassRoutinePdf(
        routine: routine,
        teacherName: teacherName,
      );
      final location = await _savePdf(bytes);
      if (!context.mounted) return;
      showSnackBarMessage(location, context, AppColors.primary);
    } catch (e) {
      debugPrint('routine pdf download $e');
      if (!context.mounted) return;
      showSnackBarMessage(
        'Unable to download class routine.',
        context,
        AppColors.red,
      );
    }
  }

  Future<String> _savePdf(Uint8List bytes) async {
    const fileName = 'class_routine.pdf';
    if (Platform.isAndroid) {
      await _filesChannel.invokeMethod<String>(
        'saveToDownloads',
        {'fileName': fileName, 'bytes': bytes},
      );
      return 'Saved to Downloads';
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return 'Saved to Files';
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.sizeOf(context).width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            'Full Class Routine',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Download',
              onPressed: () => _download(context),
              icon: const Icon(Icons.download_rounded),
            ),
          ],
        ),
        body: PdfPreview(
          build: (_) => buildClassRoutinePdf(
            routine: routine,
            teacherName: teacherName,
          ),
          pdfFileName: 'class_routine.pdf',
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
          allowPrinting: false,
          allowSharing: false,
          useActions: false,
          maxPageWidth: pageWidth,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          previewPageMargin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          scrollViewDecoration: const BoxDecoration(color: AppColors.bg),
        ),
      ),
    );
  }
}
