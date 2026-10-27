import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_sidebar.dart';
import 'widgets/coding_filter_grid.dart';
import 'widgets/coding_problem_card.dart';

class CodingHomeScreen extends ConsumerStatefulWidget {
  const CodingHomeScreen({super.key});

  @override
  ConsumerState<CodingHomeScreen> createState() => _CodingHomeScreenState();
}

class _CodingHomeScreenState extends ConsumerState<CodingHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedDifficulty = 'All';
  String _selectedStatus = 'All';
  String _selectedTag = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _problems = [
    {
      'id': 'cp_two_sum',
      'title': 'Two Sum Target Indices',
      'difficulty': 'Easy',
      'topic': 'Arrays & Hash Table',
      'acceptance': '82.4%',
      'submissions': '450',
      'isSolved': true,
      'tags': ['Array', 'Hash Table', 'Top Interview']
    },
    {
      'id': 'cp_valid_paren',
      'title': 'Valid Parentheses Syntax',
      'difficulty': 'Easy',
      'topic': 'Stack & Strings',
      'acceptance': '78.9%',
      'submissions': '390',
      'isSolved': true,
      'tags': ['Stack', 'String']
    },
    {
      'id': 'cp_merge_intervals',
      'title': 'Merge Overlapping Intervals',
      'difficulty': 'Medium',
      'topic': 'Sorting & Arrays',
      'acceptance': '64.1%',
      'submissions': '280',
      'isSolved': false,
      'tags': ['Sorting', 'Intervals']
    },
    {
      'id': 'cp_lru_cache',
      'title': 'LRU Cache Architecture',
      'difficulty': 'Medium',
      'topic': 'Hash Map & Doubly Linked List',
      'acceptance': '58.3%',
      'submissions': '210',
      'isSolved': false,
      'tags': ['Design', 'Linked List']
    },
    {
      'id': 'cp_median_streams',
      'title': 'Find Median from Data Stream',
      'difficulty': 'Hard',
      'topic': 'Heaps & Priority Queues',
      'acceptance': '44.7%',
      'submissions': '140',
      'isSolved': false,
      'tags': ['Heap', 'Stream', 'Hard']
    }
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _problems.where((p) {
      if (_selectedDifficulty != 'All' && p['difficulty'] != _selectedDifficulty) {
        return false;
      }
      if (_selectedStatus == 'Solved' && p['isSolved'] != true) {
        return false;
      }
      if (_selectedStatus == 'Unsolved' && p['isSolved'] == true) {
        return false;
      }
      if (_selectedTag != 'All') {
        final tags = (p['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        if (!tags.contains(_selectedTag)) {
          return false;
        }
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final title = p['title'].toString().toLowerCase();
        final topic = p['topic'].toString().toLowerCase();
        if (!title.contains(query) && !topic.contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppSidebar(currentRoute: '/student/coding'),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.menu, color: AppColors.textPrimary),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(AppIcons.code2, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Technical Arena',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.bell, color: AppColors.textMuted),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: '/student/coding'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search algorithms, topics or tags...',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  prefixIcon: const Icon(AppIcons.search, color: AppColors.textMuted, size: 18),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(AppIcons.x, color: AppColors.textMuted, size: 16),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
            const SizedBox(height: 14),

            // 2x2 Filter Grid Widget
            CodingFilterGrid(
              selectedDifficulty: _selectedDifficulty,
              selectedStatus: _selectedStatus,
              selectedTag: _selectedTag,
              onDifficultyChanged: (val) => setState(() => _selectedDifficulty = val),
              onStatusChanged: (val) => setState(() => _selectedStatus = val),
              onTagChanged: (val) => setState(() => _selectedTag = val),
              onReset: () {
                setState(() {
                  _selectedDifficulty = 'All';
                  _selectedStatus = 'All';
                  _selectedTag = 'All';
                  _searchQuery = '';
                });
              },
            ),
            const SizedBox(height: 18),

            // Results Counter & Quick Sort
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} Challenges Available',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(AppIcons.flame, size: 13, color: AppColors.streak),
                      SizedBox(width: 4),
                      Text(
                        'Trending',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.streak),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Problems List
            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  children: [
                    Icon(AppIcons.helpCircle, color: AppColors.textMuted, size: 36),
                    SizedBox(height: 12),
                    Text(
                      'No coding problems match your filters.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              ...filtered.map(
                (p) => CodingProblemCard(
                  problem: p,
                  onSolve: () {
                    context.push('/student/coding/workspace/${p['id']}');
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
