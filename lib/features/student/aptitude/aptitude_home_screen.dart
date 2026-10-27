import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_sidebar.dart';
import 'models/aptitude_question.dart';
import 'widgets/company_pack_card.dart';
import 'widgets/topic_tabs_row.dart';
import 'widgets/aptitude_question_card.dart';

class AptitudeHomeScreen extends StatefulWidget {
  const AptitudeHomeScreen({super.key});

  @override
  State<AptitudeHomeScreen> createState() => _AptitudeHomeScreenState();
}

class _AptitudeHomeScreenState extends State<AptitudeHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Quantitative',
    'Logical',
    'Verbal',
    'Data Interpretation',
  ];

  final List<Map<String, dynamic>> _companyPacks = [
    {
      'company': 'TCS NQT 2026',
      'role': 'Ninja & Digital',
      'count': 60,
      'difficulty': 'medium',
      'color': const Color(0xFF3B82F6),
    },
    {
      'company': 'Infosys SP / SE',
      'role': 'Specialist Programmer',
      'count': 45,
      'difficulty': 'hard',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'company': 'Cognizant GenC',
      'role': 'Next & Elevate',
      'count': 50,
      'difficulty': 'medium',
      'color': const Color(0xFF06B6D4),
    },
    {
      'company': 'Wipro Elite',
      'role': 'Project Engineer',
      'count': 40,
      'difficulty': 'easy',
      'color': const Color(0xFF10B981),
    },
    {
      'company': 'Accenture ASE',
      'role': 'Associate Software Eng',
      'count': 55,
      'difficulty': 'medium',
      'color': const Color(0xFFF59E0B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredQuestions = defaultAptitudeBank.where((q) {
      final matchesCategory = _selectedCategory == 'All' || q.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          q.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          q.topic.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          q.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppSidebar(currentRoute: '/student/aptitude'),
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
              child: const Icon(AppIcons.brain, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Aptitude Arena',
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
      bottomNavigationBar: const AppBottomNav(currentRoute: '/student/aptitude'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.streak.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppIcons.flame, color: AppColors.streak, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'PLACEMENT PREP 2026',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.streak,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Master Aptitude Tests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Step-by-step sequential questions covering Quant, Logic & Verbal without distraction.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ).let((style) => ElevatedButton(
                        style: style,
                        onPressed: () {
                          context.push(
                            '/student/aptitude/quiz?category=${Uri.encodeComponent(_selectedCategory)}',
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppIcons.playCircle, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Start Rapid Assessment',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Stats Row
            Row(
              children: [
                _buildStatPill('Total Questions', '${defaultAptitudeBank.length * 30}+', AppIcons.fileText),
                const SizedBox(width: 8),
                _buildStatPill('Categories', '${_categories.length - 1}', AppIcons.layers),
                const SizedBox(width: 8),
                _buildStatPill('Avg Accuracy', '78%', AppIcons.target),
              ],
            ),
            const SizedBox(height: 24),

            // Company Packs Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Company Placement Packs',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Company Packs Carousel
            SizedBox(
              height: 138,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _companyPacks.length,
                itemBuilder: (context, index) {
                  final pack = _companyPacks[index];
                  return CompanyPackCard(
                    companyName: pack['company'],
                    role: pack['role'],
                    questionCount: pack['count'],
                    difficulty: pack['difficulty'],
                    accentColor: pack['color'],
                    onTap: () {
                      context.push(
                        '/student/aptitude/quiz?category=Quantitative&company=${Uri.encodeComponent(pack['company'])}',
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Explore Categories Title
            const Text(
              'Explore by Domain',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Categories horizontal chip track
            TopicTabsRow(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onSelectCategory: (cat) {
                setState(() => _selectedCategory = cat);
              },
            ),
            const SizedBox(height: 16),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search questions, topics or formulas...',
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
            const SizedBox(height: 18),

            // Questions Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredQuestions.length} Questions Available',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push('/student/aptitude/quiz?category=$_selectedCategory');
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Practice Mode',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                      ),
                      SizedBox(width: 4),
                      Icon(AppIcons.arrowRight, size: 14, color: AppColors.primaryLight),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Questions List
            if (filteredQuestions.isEmpty)
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
                      'No questions match your filter.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              ...filteredQuestions.map(
                (q) => AptitudeQuestionCard(
                  question: q,
                  onPractice: () {
                    context.push('/student/aptitude/quiz?category=${Uri.encodeComponent(q.category)}&startId=${q.id}');
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.primaryLight),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _LetExt<T> on T {
  R let<R>(R Function(T it) block) => block(this);
}
