import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_sidebar.dart';
import 'widgets/explore_topics_track.dart';

class LearningHomeScreen extends ConsumerStatefulWidget {
  const LearningHomeScreen({super.key});

  @override
  ConsumerState<LearningHomeScreen> createState() => _LearningHomeScreenState();
}

class _LearningHomeScreenState extends ConsumerState<LearningHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTopic = 'All';
  String _searchQuery = '';

  final List<String> _topics = [
    'All',
    'Python',
    'Data Structures',
    'Algorithms',
    'JavaScript',
    'SQL & Databases',
    'C++',
    'System Design',
    'Java Core',
    'Git & DevOps',
  ];

  final List<Map<String, dynamic>> _courses = [
    {
      'id': 'py_intro',
      'title': 'Python 3 Mastery',
      'topic': 'Python',
      'desc': 'Interactive Python tutorial covering variables, control structures, functions, OOP, and data pipelines.',
      'lessons': 8,
      'progress': 0.60,
      'icon': AppIcons.code2,
      'color': AppColors.primary,
      'badge': 'Most Popular',
    },
    {
      'id': 'dsa_arrays',
      'title': 'Data Structures & Algorithms',
      'topic': 'Data Structures',
      'desc': 'Visual interactive guide to Arrays, Linked Lists, Stacks, Queues, Trees, Graphs, and Hash Tables.',
      'lessons': 12,
      'progress': 0.35,
      'icon': AppIcons.layers,
      'color': AppColors.secondary,
      'badge': 'High Yield',
    },
    {
      'id': 'js_modern',
      'title': 'Modern JavaScript ES6+',
      'topic': 'JavaScript',
      'desc': 'Arrow functions, Promises, Async/Await, Closures, Prototypes, and DOM manipulation mastery.',
      'lessons': 10,
      'progress': 0.20,
      'icon': AppIcons.zap,
      'color': AppColors.warning,
      'badge': 'Frontend',
    },
    {
      'id': 'sql_queries',
      'title': 'SQL & Database Optimization',
      'topic': 'SQL & Databases',
      'desc': 'Relational design, JOIN queries, Window functions, Indexing, and query performance tuning.',
      'lessons': 6,
      'progress': 0.0,
      'icon': AppIcons.barChart2,
      'color': AppColors.accent,
      'badge': 'Backend',
    },
    {
      'id': 'cpp_competitive',
      'title': 'C++ STL & Problem Solving',
      'topic': 'C++',
      'desc': 'Vectors, Sets, Maps, Priority Queues, Binary Search, and ultra-fast competitive programming templates.',
      'lessons': 7,
      'progress': 0.15,
      'icon': AppIcons.cpu,
      'color': AppColors.purple,
      'badge': 'Placement',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _courses.where((c) {
      final matchesTopic = _selectedTopic == 'All' || c['topic'] == _selectedTopic;
      final matchesSearch = _searchQuery.isEmpty ||
          c['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c['desc'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesTopic && matchesSearch;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppSidebar(currentRoute: '/student/learning'),
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
              child: const Icon(AppIcons.bookOpen, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Learning Arena',
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
      bottomNavigationBar: const AppBottomNav(currentRoute: '/student/learning'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search documentation, topics and tutorials...',
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
            const SizedBox(height: 16),

            // W3Schools style horizontal track with non-overlapping < > buttons
            ExploreTopicsTrack(
              topics: _topics,
              selectedTopic: _selectedTopic,
              onSelectTopic: (topic) => setState(() => _selectedTopic = topic),
            ),
            const SizedBox(height: 20),

            // Continue Learning Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'CONTINUE LEARNING',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryLight,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Text(
                        '60% Finished',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Python 3: Functions & Lambda Expressions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Lesson 5 of 8 • Scope, recursion, and higher-order functions',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.60,
                      minHeight: 5,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/student/learning/lesson/py_intro');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(AppIcons.play, size: 14),
                        SizedBox(width: 6),
                        Text('Resume Tutorial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Courses List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredCourses.length} Interactive Tracks',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _selectedTopic,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Course Cards
            if (filteredCourses.isEmpty)
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
                    Text('No tutorial tracks found.', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                  ],
                ),
              )
            else
              ...filteredCourses.map((c) => _buildCourseCard(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> c) {
    final double progress = (c['progress'] as num).toDouble();
    final Color color = c['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/student/learning/lesson/${c['id']}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(c['icon'] as IconData, color: color, size: 20),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        c['badge'] ?? '',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  c['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  c['desc'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: AppColors.surfaceElevated,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(AppIcons.fileText, size: 13, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${c['lessons']} Modules',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Start Reading',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(AppIcons.arrowRight, size: 14, color: color),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
