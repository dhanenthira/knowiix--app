import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';

class ExploreTopicsTrack extends StatefulWidget {
  final List<String> topics;
  final String selectedTopic;
  final ValueChanged<String> onSelectTopic;

  const ExploreTopicsTrack({
    super.key,
    required this.topics,
    required this.selectedTopic,
    required this.onSelectTopic,
  });

  @override
  State<ExploreTopicsTrack> createState() => _ExploreTopicsTrackState();
}

class _ExploreTopicsTrackState extends State<ExploreTopicsTrack> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      (_scrollController.offset - 140).clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      (_scrollController.offset + 140).clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Left scroll arrow button <
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(22)),
              onTap: _scrollLeft,
              child: const SizedBox(
                width: 36,
                height: 44,
                child: Center(
                  child: Icon(
                    AppIcons.chevronLeft,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Container(width: 1, height: 24, color: AppColors.border),

          // Scrollable category chips track
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              physics: const BouncingScrollPhysics(),
              itemCount: widget.topics.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final topic = widget.topics[index];
                final isSelected = topic == widget.selectedTopic;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => widget.onSelectTopic(topic),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.border.withOpacity(0.5)),
                      ),
                      child: Center(
                        child: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Right scroll arrow button >
          Container(width: 1, height: 24, color: AppColors.border),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(22)),
              onTap: _scrollRight,
              child: const SizedBox(
                width: 36,
                height: 44,
                child: Center(
                  child: Icon(
                    AppIcons.chevronRight,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
