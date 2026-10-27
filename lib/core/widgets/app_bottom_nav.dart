import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_icons.dart';
import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final String currentRoute;

  const AppBottomNav({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.border : AppColors.lightBorder;
    final unselectedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    int getIndex() {
      if (currentRoute.startsWith("/student/dashboard")) return 0;
      if (currentRoute.startsWith("/student/learning")) return 1;
      if (currentRoute.startsWith("/student/practice")) return 2;
      if (currentRoute.startsWith("/student/aptitude")) return 3;
      if (currentRoute.startsWith("/student/coding")) return 4;
      return 0;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: getIndex(),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go("/student/dashboard");
              break;
            case 1:
              context.go("/student/learning");
              break;
            case 2:
              context.go("/student/practice");
              break;
            case 3:
              context.go("/student/aptitude");
              break;
            case 4:
              context.go("/student/coding");
              break;
          }
        },
        backgroundColor: bgColor,
        selectedItemColor: isDark ? AppColors.primary : AppColors.primaryDark,
        unselectedItemColor: unselectedColor,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.home, size: 22),
            activeIcon: Icon(AppIcons.home, size: 24),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.bookOpen, size: 22),
            activeIcon: Icon(AppIcons.bookOpen, size: 24),
            label: "Learning",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.zap, size: 22),
            activeIcon: Icon(AppIcons.zap, size: 24),
            label: "Practice",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.brain, size: 22),
            activeIcon: Icon(AppIcons.brain, size: 24),
            label: "Aptitude",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.code2, size: 22),
            activeIcon: Icon(AppIcons.code2, size: 24),
            label: "Technical",
          ),
        ],
      ),
    );
  }
}
