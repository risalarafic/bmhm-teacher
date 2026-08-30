import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/media_url.dart';

class TeacherAvatar extends StatefulWidget {
  const TeacherAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 28,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  @override
  State<TeacherAvatar> createState() => _TeacherAvatarState();
}

class _TeacherAvatarState extends State<TeacherAvatar> {
  late List<String> _urls;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _urls = MediaUrl.candidates(widget.imageUrl);
  }

  @override
  void didUpdateWidget(TeacherAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _urls = MediaUrl.candidates(widget.imageUrl);
      _index = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    const titles = {'mr', 'mr.', 'mrs', 'mrs.', 'ms', 'ms.', 'dr', 'dr.'};
    final initials = widget.name
        .split(' ')
        .where((part) => part.isNotEmpty && !titles.contains(part.toLowerCase()))
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    final size = widget.radius * 2;
    final url = _index < _urls.length ? _urls[_index] : null;

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      child: ClipOval(
        child: url == null
            ? _Initials(initials: initials, fontSize: widget.radius * 0.55)
            : Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                headers: const {'Accept': 'image/*'},
                errorBuilder: (_, _, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    if (_index < _urls.length - 1) {
                      setState(() => _index++);
                    }
                  });
                  if (_index >= _urls.length - 1) {
                    return _Initials(
                      initials: initials,
                      fontSize: widget.radius * 0.55,
                    );
                  }
                  return SizedBox(
                    width: size,
                    height: size,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.initials, required this.fontSize});

  final String initials;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      initials,
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
      ),
    );
  }
}
