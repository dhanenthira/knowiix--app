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

class AdminTestsScreen extends ConsumerStatefulWidget {
  const AdminTestsScreen({super.key});

  @override
  ConsumerState<AdminTestsScreen> createState() => _AdminTestsScreenState();
}

class _AdminTestsScreenState extends ConsumerState<AdminTestsScreen> {
  String _search = "";
  List<Map<String, dynamic>> _tests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTests();
  }

  Future<void> _fetchTests() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient().dio.get("/tests/available");
      if (res.data != null && res.data is List) {
        setState(() {
          _tests = List<Map<String, dynamic>>.from((res.data as List).map((t) => {
            "id": t["id"] ?? "",
            "title": t["title"] ?? "Untitled Assessment",
            "category": (t["category"] ?? "general").toString().toUpperCase(),
            "difficulty": t["difficulty"] ?? "Medium",
            "duration": "${t["duration_minutes"] ?? 60} mins",
            "marks": "${t["total_marks"] ?? 100} Marks",
            "questions": "${t["total_questions"] ?? 20} Questions",
            "status": t["status"] ?? "active",
          }));
          _isLoading = false;
        });
      } else {
        setState(() {
          _tests = _getDefaultTests();
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        _tests = _getDefaultTests();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getDefaultTests() {
    return [
      {
        "id": "test_tcs_nqt",
        "title": "TCS NQT Full Placement Mock Test",
        "category": "APTITUDE & CODING",
        "difficulty": "Medium",
        "duration": "90 mins",
        "marks": "100 Marks",
        "questions": "30 Questions",
        "status": "active",
      },
      {
        "id": "test_dsa_grand",
        "title": "Data Structures & Algorithms Grand Sprint",
        "category": "TECHNICAL",
        "difficulty": "Hard",
        "duration": "60 mins",
        "marks": "50 Marks",
        "questions": "15 Questions",
        "status": "active",
      },
      {
        "id": "test_core_cs",
        "title": "Core CS Fundamentals (OS, DBMS, Networks)",
        "category": "CORE CS",
        "difficulty": "Medium",
        "duration": "45 mins",
        "marks": "50 Marks",
        "questions": "25 Questions",
        "status": "completed",
      },
    ];
  }

  Future<void> _createTest(Map<String, dynamic> data) async {
    try {
      await ApiClient().dio.post("/admin/tests", data: data);
      _fetchTests();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Assessment created successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error creating test: $e")),
        );
      }
    }
  }

  Future<void> _deleteTest(String id) async {
    try {
      await ApiClient().dio.delete("/admin/tests/$id");
      setState(() => _tests.removeWhere((t) => t["id"] == id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Assessment deleted")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delete error: $e")),
        );
      }
    }
  }

  void _showAddTestDialog() {
    final titleCtrl = TextEditingController();
    final durationCtrl = TextEditingController(text: "60");
    final marksCtrl = TextEditingController(text: "100");
    final questionsCtrl = TextEditingController(text: "20");
    String cat = "aptitude";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text("Schedule Grand Assessment"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: "Assessment Title", hintText: "e.g. Infosys Specific Mock Test"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: cat,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: [
                      DropdownMenuItem(value: "aptitude", child: Text("Aptitude & Reasoning")),
                      DropdownMenuItem(value: "technical", child: Text("Technical & Core CS")),
                      DropdownMenuItem(value: "coding", child: Text("Coding Challenge")),
                    ],
                    onChanged: (v) => setDlgState(() => cat = v ?? "aptitude"),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: durationCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Duration (mins)"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: questionsCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Questions Count"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: marksCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Total Marks"),
                        ),
                      ),
                    ],
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
                _createTest({
                  "title": titleCtrl.text.trim(),
                  "category": cat,
                  "difficulty": "medium",
                  "duration_minutes": int.tryParse(durationCtrl.text) ?? 60,
                  "total_marks": int.tryParse(marksCtrl.text) ?? 100,
                  "total_questions": int.tryParse(questionsCtrl.text) ?? 20,
                  "status": "active",
                });
              },
              child: const Text("Create Test"),
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

    final filtered = _tests.where((t) {
      return t["title"].toString().toLowerCase().contains(_search.toLowerCase()) ||
          t["category"].toString().toLowerCase().contains(_search.toLowerCase());
    }).toList();

    Widget content = SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMob ? AppSpacing.pagePaddingMobile : AppSpacing.pagePaddingDesktop,
        vertical: AppSpacing.space6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Assessment Tests Management", style: AppTypography.h2(context, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    const Text("Schedule company mock placement exams, set test timers, and monitor student rankings.",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                  ],
                ),
              ),
              AppButton(
                text: "Schedule Assessment",
                icon: LucideIcons.calendar,
                variant: AppButtonVariant.primary,
                onPressed: _showAddTestDialog,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),

          // Search Card
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(
                hintText: "Search assessments by title or category...",
                prefixIcon: Icon(LucideIcons.search, size: 18),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space4),

          // Tests List
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
          else if (filtered.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No assessments scheduled.")))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final t = filtered[i];
                final isActive = t["status"] == "active";

                return AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.12),
                          borderRadius: AppRadii.cardSmallRadius,
                        ),
                        child: const Icon(LucideIcons.clipboardCheck, color: AppColors.secondary, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(t["title"], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
                                const SizedBox(width: 10),
                                AppBadge(
                                  label: isActive ? "LIVE" : "COMPLETED",
                                  color: (isActive ? AppColors.success : AppColors.textMuted).withOpacity(0.15),
                                  textColor: isActive ? AppColors.success : AppColors.textMuted,
                                  isPill: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text("${t["category"]}  •  ${t["duration"]}  •  ${t["questions"]}  •  ${t["marks"]}",
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash2, color: AppColors.error, size: 18),
                        tooltip: "Delete assessment",
                        onPressed: () => _deleteTest(t["id"]),
                      ),
                    ],
                  ),
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
          if (!isMob) const AppSidebar(isAdmin: true, currentRoute: "/admin/tests"),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  title: "Assessment Test Management",
                  subtitle: "Schedule & Curate Grand Placement Tests",
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
