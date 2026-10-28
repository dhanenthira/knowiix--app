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

class AdminCodingScreen extends ConsumerStatefulWidget {
  const AdminCodingScreen({super.key});

  @override
  ConsumerState<AdminCodingScreen> createState() => _AdminCodingScreenState();
}

class _AdminCodingScreenState extends ConsumerState<AdminCodingScreen> {
  String _search = "";
  String _selectedDifficulty = "All";
  List<Map<String, dynamic>> _problems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCodingProblems();
  }

  Future<void> _fetchCodingProblems() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiClient().dio.get("/coding/problems");
      if (res.data != null && res.data["items"] != null) {
        setState(() {
          _problems = List<Map<String, dynamic>>.from((res.data["items"] as List).map((p) => {
            "id": p["id"] ?? "",
            "title": p["title"] ?? "Untitled Problem",
            "slug": p["slug"] ?? "",
            "difficulty": p["difficulty"] ?? "Medium",
            "topic": p["topic"] ?? "Algorithms",
            "description": p["description"] ?? "",
            "solvedCount": p["solved_count"] ?? 0,
            "acceptanceRate": "${(p["acceptance_rate"] ?? 75.0).toStringAsFixed(1)}%",
          }));
          _isLoading = false;
        });
      } else {
        setState(() {
          _problems = _getDefaultProblems();
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        _problems = _getDefaultProblems();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getDefaultProblems() {
    return [
      {
        "id": "cp_two_sum",
        "title": "Two Sum Problem",
        "slug": "two-sum",
        "difficulty": "Easy",
        "topic": "Arrays & Hashing",
        "description": "Find indices of two numbers that add up to target.",
        "solvedCount": 420,
        "acceptanceRate": "88.4%",
      },
      {
        "id": "cp_reverse_ll",
        "title": "Reverse Linked List",
        "slug": "reverse-linked-list",
        "difficulty": "Easy",
        "topic": "Linked List",
        "description": "Reverse a singly linked list in-place.",
        "solvedCount": 350,
        "acceptanceRate": "82.1%",
      },
      {
        "id": "cp_lps",
        "title": "Longest Palindromic Substring",
        "slug": "longest-palindromic-substring",
        "difficulty": "Medium",
        "topic": "Dynamic Programming",
        "description": "Return the longest palindromic substring in s.",
        "solvedCount": 190,
        "acceptanceRate": "64.5%",
      },
      {
        "id": "cp_merge_k",
        "title": "Merge K Sorted Lists",
        "slug": "merge-k-sorted-lists",
        "difficulty": "Hard",
        "topic": "Heaps & Divide and Conquer",
        "description": "Merge k sorted linked lists into one sorted linked list.",
        "solvedCount": 85,
        "acceptanceRate": "48.2%",
      },
    ];
  }

  Future<void> _createProblem(Map<String, dynamic> data) async {
    try {
      await ApiClient().dio.post("/admin/coding", data: data);
      _fetchCodingProblems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Coding challenge added successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create problem: $e")),
        );
      }
    }
  }

  Future<void> _deleteProblem(String id) async {
    try {
      await ApiClient().dio.delete("/admin/coding/$id");
      setState(() {
        _problems.removeWhere((p) => p["id"] == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Problem removed successfully")),
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

  void _showAddProblemDialog() {
    final titleCtrl = TextEditingController();
    final topicCtrl = TextEditingController(text: "Algorithms");
    final descCtrl = TextEditingController();
    String diff = "Medium";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text("Create Coding Challenge"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: "Problem Title", hintText: "e.g. Valid Parentheses"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: topicCtrl,
                    decoration: const InputDecoration(labelText: "Topic / Tag", hintText: "e.g. Stacks, Trees"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: diff,
                    decoration: const InputDecoration(labelText: "Difficulty"),
                    items: ["Easy", "Medium", "Hard"].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (v) => setDlgState(() => diff = v ?? "Medium"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: "Problem Description", hintText: "Explain the problem requirements and constraints"),
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
                _createProblem({
                  "title": titleCtrl.text.trim(),
                  "topic": topicCtrl.text.trim(),
                  "difficulty": diff,
                  "description": descCtrl.text.trim(),
                  "time_limit_seconds": 1.0,
                  "memory_limit_mb": 256,
                });
              },
              child: const Text("Save & Publish"),
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

    final filtered = _problems.where((p) {
      final matchesSearch = p["title"].toString().toLowerCase().contains(_search.toLowerCase()) ||
          p["topic"].toString().toLowerCase().contains(_search.toLowerCase());
      final matchesDiff = _selectedDifficulty == "All" || p["difficulty"] == _selectedDifficulty;
      return matchesSearch && matchesDiff;
    }).toList();

    Widget content = SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMob ? AppSpacing.pagePaddingMobile : AppSpacing.pagePaddingDesktop,
        vertical: AppSpacing.space6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Add Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Technical Coding Management", style: AppTypography.h2(context, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    const Text("Curate multi-language coding problems, inspect test cases, and review student solution submissions.",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                  ],
                ),
              ),
              AppButton(
                text: "Add Coding Problem",
                icon: LucideIcons.plusCircle,
                variant: AppButtonVariant.primary,
                onPressed: _showAddProblemDialog,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),

          // Filters row
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: const InputDecoration(
                      hintText: "Search coding challenges by title or topic...",
                      prefixIcon: Icon(LucideIcons.search, size: 18),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedDifficulty,
                  underline: const SizedBox(),
                  items: ["All", "Easy", "Medium", "Hard"]
                      .map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 13.5))))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedDifficulty = v ?? "All"),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space4),

          // Problem List
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
          else if (filtered.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No coding problems found.")))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final prob = filtered[i];
                Color diffColor = AppColors.success;
                if (prob["difficulty"] == "Medium") diffColor = AppColors.warning;
                if (prob["difficulty"] == "Hard") diffColor = AppColors.error;

                return AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: AppRadii.cardSmallRadius,
                        ),
                        child: const Icon(LucideIcons.code2, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(prob["title"], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
                                const SizedBox(width: 10),
                                AppBadge(label: prob["difficulty"], color: diffColor.withOpacity(0.15), textColor: diffColor, isPill: true),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text("${prob["topic"]}  •  Solved: ${prob["solvedCount"]} students  •  Acceptance: ${prob["acceptanceRate"]}",
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash2, color: AppColors.error, size: 18),
                        tooltip: "Delete problem",
                        onPressed: () => _deleteProblem(prob["id"]),
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
          if (!isMob) const AppSidebar(isAdmin: true, currentRoute: "/admin/coding"),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  title: "Coding Problems Arena",
                  subtitle: "Knowiix Master Coding Challenges Catalog",
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
