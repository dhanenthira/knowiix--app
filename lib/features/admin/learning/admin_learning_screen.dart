import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_sidebar.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/network/api_client.dart';

class AdminLearningScreen extends ConsumerStatefulWidget {
  const AdminLearningScreen({super.key});

  @override
  ConsumerState<AdminLearningScreen> createState() => _AdminLearningScreenState();
}

class _AdminLearningScreenState extends ConsumerState<AdminLearningScreen> {
  List<Map<String, dynamic>> _modules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLearningContent();
  }

  Future<void> _fetchLearningContent() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient().dio.get("/admin/learning");
      if (res.data != null && res.data["modules"] != null && (res.data["modules"] as List).isNotEmpty) {
        setState(() {
          _modules = List<Map<String, dynamic>>.from((res.data["modules"] as List).map((m) => {
            "id": m["id"] ?? "",
            "title": m["title"] ?? "Untitled Track",
            "slug": m["slug"] ?? "",
            "description": m["description"] ?? "",
            "category": m["category"] ?? "Programming",
            "lessonsCount": 12,
          }));
          _isLoading = false;
        });
      } else {
        _setDefaultModules();
      }
    } catch (_) {
      _setDefaultModules();
    }
  }

  void _setDefaultModules() {
    setState(() {
      _modules = [
        {
          "id": "mod_python",
          "title": "Python 3 Mastery Track",
          "slug": "python",
          "description": "Syntax, OOP, Collections, List Comprehensions, and Placement Algorithms in Python.",
          "category": "Languages",
          "lessonsCount": 24,
        },
        {
          "id": "mod_java",
          "title": "Java Fundamentals & Core CS",
          "slug": "java",
          "description": "JVM internals, Collections framework, Multi-threading, and Object Oriented Design.",
          "category": "Languages",
          "lessonsCount": 28,
        },
        {
          "id": "mod_dsa",
          "title": "Data Structures & Algorithms Studio",
          "slug": "dsa",
          "description": "Trees, Graphs, Dynamic Programming, Heaps, and Recursion visual walkthroughs.",
          "category": "Computer Science",
          "lessonsCount": 42,
        },
        {
          "id": "mod_dbms",
          "title": "Database Management & SQL",
          "slug": "dbms",
          "description": "Relational schemas, Normalization, ACID transactions, and Complex Query Optimization.",
          "category": "Databases",
          "lessonsCount": 18,
        },
      ];
      _isLoading = false;
    });
  }

  void _showAddModuleDialog() {
    final titleCtrl = TextEditingController();
    final slugCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String cat = "Languages";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text("Create Learning Module Track"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: "Module Title", hintText: "e.g. C++ STL & Memory Mastery"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: slugCtrl,
                    decoration: const InputDecoration(labelText: "URL Slug", hintText: "e.g. cpp-stl"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: cat,
                    decoration: const InputDecoration(labelText: "Domain Category"),
                    items: ["Languages", "Computer Science", "Databases", "Web Development", "Aptitude"]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setDlgState(() => cat = v ?? "Languages"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Curriculum Summary", hintText: "What students will learn in this track"),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                setState(() {
                  _modules.add({
                    "id": "mod_${DateTime.now().millisecondsSinceEpoch}",
                    "title": titleCtrl.text.trim(),
                    "slug": slugCtrl.text.trim().isNotEmpty ? slugCtrl.text.trim() : "module",
                    "description": descCtrl.text.trim(),
                    "category": cat,
                    "lessonsCount": 1,
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("New Learning Track published!")),
                );
              },
              child: const Text("Publish Track"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final isMob = ResponsiveLayout.isMobile(context);

    Widget content = SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMob ? AppSpacing.pagePaddingMobile : AppSpacing.pagePaddingDesktop,
        vertical: AppSpacing.space6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Learning Content & Notes Studio", style: AppTypography.h2(context, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    const Text("Curate interactive W3Schools-style tutorials, programming documentation, and placement cheatsheets.",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                  ],
                ),
              ),
              AppButton(
                text: "Create Learning Track",
                icon: LucideIcons.plusCircle,
                variant: AppButtonVariant.primary,
                onPressed: _showAddModuleDialog,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),

          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
          else
            LayoutBuilder(
              builder: (ctx, constraints) {
                int cross = constraints.maxWidth < 700 ? 1 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: cross == 1 ? 2.5 : 2.1,
                  ),
                  itemCount: _modules.length,
                  itemBuilder: (ctx, i) {
                    final m = _modules[i];
                    return AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.12),
                                      borderRadius: AppRadii.cardSmallRadius,
                                    ),
                                    child: const Icon(LucideIcons.bookOpen, color: AppColors.primary, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(m["title"], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
                                ],
                              ),
                              AppBadge(
                                label: m["category"],
                                color: AppColors.secondary.withOpacity(0.15),
                                textColor: AppColors.secondary,
                                isPill: true,
                              ),
                            ],
                          ),
                          Text(m["description"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${m["lessonsCount"]} Interactive Lessons",
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5, fontWeight: FontWeight.w600)),
                              const Icon(LucideIcons.arrowRight, size: 16, color: AppColors.primary),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.lightBackground,
      body: Row(
        children: [
          if (!isMob) const AppSidebar(isAdmin: true, currentRoute: "/admin/learning"),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  title: "Learning Content & Notes Studio",
                  subtitle: "Curate Interactive Notes & Documentation",
                  showStreak: false,
                  isDarkMode: isDark,
                  onThemeToggle: () => ref.read(themeProvider.notifier).toggleTheme(),
                ),
                Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
