import 'package:flutter/material.dart';

import '../../bloc/homework_bloc/homework_bloc.dart';
import '../../utils/constants/colors.dart';

Future<void> showNewNoticeSheet(BuildContext context, HomeworkBloc bloc) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99000000),
    builder: (context) => _NewNoticeSheet(bloc: bloc),
  );
}

class _NewNoticeSheet extends StatefulWidget {
  const _NewNoticeSheet({required this.bloc});

  final HomeworkBloc bloc;

  @override
  State<_NewNoticeSheet> createState() => _NewNoticeSheetState();
}

class _NewNoticeSheetState extends State<_NewNoticeSheet> {
  final _title = TextEditingController();
  final _details = TextEditingController();
  String? _attachmentName;

  @override
  void dispose() {
    _title.dispose();
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Notice',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _title,
                  decoration: _decoration('Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _details,
                  maxLines: 4,
                  decoration: _decoration('Details'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Attachment',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => setState(
                    () => _attachmentName = 'notice_attachment.pdf',
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_file,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _attachmentName ?? 'Add attachment (PDF / image)',
                            style: TextStyle(
                              color: _attachmentName == null
                                  ? AppColors.grey
                                  : AppColors.textDark,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _publish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Publish Notice',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }

  void _publish() {
    if (_title.text.trim().isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    widget.bloc.publishNotice(
      title: _title.text.trim(),
      details: _details.text.trim(),
      attachmentName: _attachmentName,
    );
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.primary,
        content: Text('Notice published'),
      ),
    );
  }
}
