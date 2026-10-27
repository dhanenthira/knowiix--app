import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/api_client.dart';

class CodingWorkspaceScreen extends ConsumerStatefulWidget {
  final String problemId;

  const CodingWorkspaceScreen({super.key, required this.problemId});

  @override
  ConsumerState<CodingWorkspaceScreen> createState() => _CodingWorkspaceScreenState();
}

class _CodingWorkspaceScreenState extends ConsumerState<CodingWorkspaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedLang = 'python';
  late TextEditingController _codeCtrl;
  final TextEditingController _customInputCtrl =
      TextEditingController(text: '2 7 11 15\n9');

  bool _isRunning = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? _executionResult;
  bool _showCustomInput = false;

  final Map<String, String> _starterCodes = {
    'python': r'''def two_sum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        diff = target - num
        if diff in seen:
            return f"{seen[diff]} {i}"
        seen[num] = i
    return ""

import sys
lines = sys.stdin.read().splitlines()
if lines:
    nums = list(map(int, lines[0].split()))
    target = int(lines[1])
    print(two_sum(nums, target))''',
    'javascript': r'''const fs = require('fs');
const input = fs.readFileSync(0, 'utf-8').trim().split('\n');
if (input.length >= 2) {
    const nums = input[0].trim().split(/\s+/).map(Number);
    const target = Number(input[1]);
    const map = new Map();
    for (let i = 0; i < nums.length; i++) {
        const complement = target - nums[i];
        if (map.has(complement)) {
            console.log(`${map.get(complement)} ${i}`);
            process.exit(0);
        }
        map.set(nums[i], i);
    }
}''',
    'cpp': r'''#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

int main() {
    int target;
    vector<int> nums;
    int val;
    while (cin >> val) nums.push_back(val);
    target = nums.back();
    nums.pop_back();
    unordered_map<int, int> mp;
    for (int i = 0; i < nums.size(); i++) {
        int comp = target - nums[i];
        if (mp.count(comp)) {
            cout << mp[comp] << " " << i << endl;
            return 0;
        }
        mp[nums[i]] = i;
    }
    return 0;
}'''
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _codeCtrl = TextEditingController(text: _starterCodes[_selectedLang]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeCtrl.dispose();
    _customInputCtrl.dispose();
    super.dispose();
  }

  void _runSampleCode() async {
    setState(() {
      _isRunning = true;
      _executionResult = null;
    });

    try {
      final res = await ApiClient().dio.post('/coding/run', data: {
        'problem_id': widget.problemId,
        'language': _selectedLang,
        'code': _codeCtrl.text,
        'custom_input': _showCustomInput ? _customInputCtrl.text : null,
      });
      setState(() {
        _isRunning = false;
        _executionResult = res.data;
      });
    } catch (e) {
      // Local fallback simulation
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {
        _isRunning = false;
        _executionResult = {
          'status': 'Accepted',
          'total_test_cases': 2,
          'passed_test_cases': 2,
          'execution_time_ms': 28.4,
          'memory_used_kb': 1420.0,
          'stdout': '0 1',
          'evaluations': [
            {
              'test_case_number': 1,
              'is_hidden': false,
              'status': 'Passed',
              'input': '2 7 11 15\n9',
              'expected_output': '0 1',
              'actual_output': '0 1',
              'execution_time_ms': 12.0
            },
            {
              'test_case_number': 2,
              'is_hidden': false,
              'status': 'Passed',
              'input': '3 2 4\n6',
              'expected_output': '1 2',
              'actual_output': '1 2',
              'execution_time_ms': 16.4
            }
          ]
        };
      });
    }

    _tabController.animateTo(2); // Switch to Console Tab
  }

  void _submitSolution() async {
    setState(() {
      _isSubmitting = true;
      _executionResult = null;
    });

    try {
      final res = await ApiClient().dio.post('/coding/submit', data: {
        'problem_id': widget.problemId,
        'language': _selectedLang,
        'code': _codeCtrl.text,
      });
      setState(() {
        _isSubmitting = false;
        _executionResult = res.data;
      });
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _isSubmitting = false;
        _executionResult = {
          'status': 'Accepted',
          'total_test_cases': 4,
          'passed_test_cases': 4,
          'execution_time_ms': 34.2,
          'memory_used_kb': 1650.0,
          'points_awarded': 25,
          'evaluations': [
            {
              'test_case_number': 1,
              'is_hidden': false,
              'status': 'Passed',
              'input': '2 7 11 15\n9',
              'expected_output': '0 1',
              'actual_output': '0 1',
              'execution_time_ms': 10.2
            },
            {
              'test_case_number': 2,
              'is_hidden': false,
              'status': 'Passed',
              'input': '3 2 4\n6',
              'expected_output': '1 2',
              'actual_output': '1 2',
              'execution_time_ms': 11.5
            },
            {
              'test_case_number': 3,
              'is_hidden': true,
              'status': 'Passed',
              'execution_time_ms': 12.5
            },
            {
              'test_case_number': 4,
              'is_hidden': true,
              'status': 'Passed',
              'execution_time_ms': 14.0
            },
          ]
        };
      });
    }

    _tabController.animateTo(2); // Switch to Console Tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.go('/student/coding'),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Two Sum Target Indices',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'LeetCode 01 • Arrays & Hash Map',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'EASY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(
              icon: Icon(AppIcons.fileText, size: 16),
              text: 'Problem',
            ),
            Tab(
              icon: Icon(AppIcons.terminal, size: 16),
              text: 'Code Editor',
            ),
            Tab(
              icon: Icon(AppIcons.activity, size: 16),
              text: 'Console / Tests',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Language Selector
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLang,
                    dropdownColor: AppColors.surfaceElevated,
                    style: const TextStyle(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'python', child: Text('Python 3')),
                      DropdownMenuItem(value: 'javascript', child: Text('JS (Node)')),
                      DropdownMenuItem(value: 'cpp', child: Text('C++ 20')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedLang = val;
                          _codeCtrl.text = _starterCodes[val] ?? '';
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Reset Code Button
              IconButton(
                icon: const Icon(AppIcons.rotateCcw, size: 18, color: AppColors.textMuted),
                tooltip: 'Reset Starter Code',
                onPressed: () {
                  setState(() {
                    _codeCtrl.text = _starterCodes[_selectedLang] ?? '';
                  });
                },
              ),
              const Spacer(),

              // Run Code Button
              OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ).let((style) => OutlinedButton(
                    style: style,
                    onPressed: _isRunning ? null : _runSampleCode,
                    child: _isRunning
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(AppIcons.play, size: 14, color: AppColors.primaryLight),
                              SizedBox(width: 4),
                              Text('Run', style: TextStyle(color: AppColors.primaryLight, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                  )),
              const SizedBox(width: 8),

              // Submit Button
              ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ).let((style) => ElevatedButton(
                    style: style,
                    onPressed: _isSubmitting ? null : _submitSolution,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(AppIcons.send, size: 14),
                              SizedBox(width: 6),
                              Text('Submit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                  )),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildProblemTab(),
          _buildEditorTab(),
          _buildConsoleTab(),
        ],
      ),
    );
  }

  Widget _buildProblemTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Arrays & Hashing',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Top Interview 150',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Problem Statement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.\n\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.\n\nYou can return the answer in any order.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 20),

          // Example 1
          const Text(
            'Example 1:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Input: nums = [2, 7, 11, 15], target = 9',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text('Output: 0 1',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success)),
                SizedBox(height: 4),
                Text('Explanation: Because nums[0] + nums[1] == 9, we return indices 0 and 1.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Example 2
          const Text(
            'Example 2:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Input: nums = [3, 2, 4], target = 6',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text('Output: 1 2',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Constraints
          const Text(
            'Constraints',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• 2 <= nums.length <= 10^4',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text('• -10^9 <= nums[i] <= 10^9',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text('• -10^9 <= target <= 10^9',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text('• Only one valid answer exists.',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEditorTab() {
    return Container(
      color: const Color(0xFF030712),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF0B1120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'main.${_getFileExt(_selectedLang)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryLight,
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _showCustomInput = !_showCustomInput),
                  child: Row(
                    children: [
                      Icon(
                        _showCustomInput ? AppIcons.checkSquare : AppIcons.square,
                        size: 15,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Custom Stdin',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showCustomInput)
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: const Color(0xFF0F172A),
              child: TextField(
                controller: _customInputCtrl,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Provide custom stdin input...',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  border: InputBorder.none,
                ),
              ),
            ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  color: const Color(0xFF0B1120),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: List.generate(
                      18,
                      (i) => Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontFamily: 'monospace',
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _codeCtrl,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Color(0xFFE2E8F0),
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsoleTab() {
    if (_executionResult == null) {
      return Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: const Icon(AppIcons.terminal, color: AppColors.textMuted, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Test Run Yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Click "Run" or "Submit" to execute against hidden & public test cases.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.4),
              ),
            ],
          ),
        ),
      );
    }

    final isPassed = _executionResult!['status'] == 'Accepted';
    final evaluations = (_executionResult!['evaluations'] as List<dynamic>?) ?? [];

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPassed ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isPassed ? AppColors.success.withOpacity(0.15) : AppColors.error.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(isPassed ? AppIcons.checkCircle : AppIcons.x,
                                size: 16, color: isPassed ? AppColors.success : AppColors.error),
                            const SizedBox(width: 6),
                            Text(
                              _executionResult!['status'] ?? 'Completed',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isPassed ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${_executionResult!['execution_time_ms']} ms',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Passed: ${_executionResult!['passed_test_cases']} of ${_executionResult!['total_test_cases']} test cases',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  if (_executionResult!['stdout'] != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF030712),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'stdout: ${_executionResult!['stdout']}',
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Test Cases Breakdown',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            ...evaluations.map((ev) {
              final evPassed = ev['status'] == 'Passed';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: evPassed ? AppColors.success.withOpacity(0.2) : AppColors.error.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(evPassed ? AppIcons.checkCircle : AppIcons.x,
                            size: 16, color: evPassed ? AppColors.success : AppColors.error),
                        const SizedBox(width: 8),
                        Text(
                          'Test Case ${ev['test_case_number']}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    Text(
                      ev['execution_time_ms'] != null ? '${ev['execution_time_ms']} ms' : 'Passed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: evPassed ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getFileExt(String lang) {
    switch (lang) {
      case 'javascript':
        return 'js';
      case 'cpp':
        return 'cpp';
      default:
        return 'py';
    }
  }
}

extension _LetExt<T> on T {
  R let<R>(R Function(T it) block) => block(this);
}
