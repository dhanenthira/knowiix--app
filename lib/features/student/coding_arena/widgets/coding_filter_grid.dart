import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';

class CodingFilterGrid extends StatelessWidget {
  final String selectedDifficulty;
  final String selectedStatus;
  final String selectedTag;
  final ValueChanged<String> onDifficultyChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onTagChanged;
  final VoidCallback onReset;

  const CodingFilterGrid({
    super.key,
    required this.selectedDifficulty,
    required this.selectedStatus,
    required this.selectedTag,
    required this.onDifficultyChanged,
    required this.onStatusChanged,
    required this.onTagChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(AppIcons.settings, size: 16, color: AppColors.primaryLight),
                  SizedBox(width: 6),
                  Text(
                    'Problem Filters',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (selectedDifficulty != 'All' || selectedStatus != 'All' || selectedTag != 'All')
                InkWell(
                  onTap: onReset,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // 2x2 Grid for Mobile View
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  title: 'Difficulty',
                  currentValue: selectedDifficulty,
                  options: const ['All', 'Easy', 'Medium', 'Hard'],
                  onChanged: onDifficultyChanged,
                  icon: AppIcons.barChart2,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFilterDropdown(
                  title: 'Status',
                  currentValue: selectedStatus,
                  options: const ['All', 'Solved', 'Unsolved'],
                  onChanged: onStatusChanged,
                  icon: AppIcons.checkCircle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  title: 'Topic',
                  currentValue: selectedTag,
                  options: const ['All', 'Array', 'String', 'Stack', 'Linked List', 'Heap', 'Sorting'],
                  onChanged: onTagChanged,
                  icon: AppIcons.layers,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sort By', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                          Text('Most Popular', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                      Icon(AppIcons.chevronRight, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              dropdownColor: AppColors.surfaceElevated,
              icon: const Icon(AppIcons.chevronRight, size: 14, color: AppColors.textMuted),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              items: options.map((opt) {
                return DropdownMenuItem<String>(
                  value: opt,
                  child: Text(opt, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
