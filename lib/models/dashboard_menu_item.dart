import 'package:flutter/material.dart';

class DashboardMenuItem {
  const DashboardMenuItem({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

const dashboardMenuItems = [
  DashboardMenuItem(id: 'subjects', label: 'My Subjects', icon: Icons.menu_book_outlined),
  DashboardMenuItem(id: 'form_attendance', label: 'Form Attendance', icon: Icons.how_to_reg_outlined),
  DashboardMenuItem(id: 'form_students', label: 'Form Students', icon: Icons.groups_outlined),
  DashboardMenuItem(id: 'result', label: 'Result', icon: Icons.star_outline_rounded),
  DashboardMenuItem(id: 'class_routine', label: 'Class Routine', icon: Icons.calendar_month_outlined),
  DashboardMenuItem(id: 'homework', label: 'Homework', icon: Icons.assignment_outlined),
  DashboardMenuItem(id: 'notices', label: 'Notices', icon: Icons.campaign_outlined),
  DashboardMenuItem(id: 'messages', label: 'Messages', icon: Icons.chat_bubble_outline_rounded),
  DashboardMenuItem(id: 'study_material', label: 'Study Material', icon: Icons.folder_outlined),
  DashboardMenuItem(id: 'lesson_plan', label: 'Lesson Plan', icon: Icons.edit_calendar_outlined),
  DashboardMenuItem(id: 'assessment', label: 'Assessment', icon: Icons.fact_check_outlined),
  DashboardMenuItem(id: 'leave', label: 'Leave Application', icon: Icons.beach_access_outlined),
];
