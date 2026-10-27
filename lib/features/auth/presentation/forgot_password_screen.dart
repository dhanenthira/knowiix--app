import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

enum ResetStep { enterEmail, enterOtp, newPassword, success }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ResetStep _currentStep = ResetStep.enterEmail;

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Countdown timer for OTP expiry
  Timer? _countdownTimer;
  int _secondsRemaining = 600; // 10 minutes

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = 600);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTimer(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  // Step 1: Send OTP to Email
  Future<void> _handleSendOtp() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final res = await ApiClient().dio.post('/auth/forgot-password', data: {
        'email': email,
      });

      setState(() {
        _isLoading = false;
        _currentStep = ResetStep.enterOtp;
        _successMessage = res.data['message'] ?? 'Verification code sent to $email';
      });
      _startTimer();
    } catch (e) {
      String msg = 'Failed to send reset code. Please ensure the email is registered.';
      if (e is DioException && e.response?.data is Map && e.response?.data['detail'] != null) {
        msg = e.response!.data['detail'].toString();
      }
      setState(() {
        _isLoading = false;
        _errorMessage = msg;
      });
    }
  }

  // Step 2: Verify OTP
  Future<void> _handleVerifyOtp() async {
    final email = _emailCtrl.text.trim();
    final otp = _otpCtrl.text.trim();

    if (otp.length != 6) {
      setState(() => _errorMessage = 'Please enter the complete 6-digit verification code.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ApiClient().dio.post('/auth/verify-otp', data: {
        'email': email,
        'otp': otp,
      });

      setState(() {
        _isLoading = false;
        _currentStep = ResetStep.newPassword;
        _successMessage = 'Code verified. Enter your new password below.';
      });
    } catch (e) {
      String msg = 'Invalid or expired verification code.';
      if (e is DioException && e.response?.data is Map && e.response?.data['detail'] != null) {
        msg = e.response!.data['detail'].toString();
      }
      setState(() {
        _isLoading = false;
        _errorMessage = msg;
      });
    }
  }

  // Step 3: Set New Password
  Future<void> _handleResetPassword() async {
    final email = _emailCtrl.text.trim();
    final otp = _otpCtrl.text.trim();
    final newPass = _newPassCtrl.text;
    final confirmPass = _confirmPassCtrl.text;

    if (newPass.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters long.');
      return;
    }

    if (newPass != confirmPass) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await ApiClient().dio.post('/auth/reset-password', data: {
        'email': email,
        'otp': otp,
        'new_password': newPass,
      });

      setState(() {
        _isLoading = false;
        _currentStep = ResetStep.success;
        _successMessage = res.data['message'] ?? 'Password reset successfully!';
      });
    } catch (e) {
      String msg = 'Failed to reset password. Please try again.';
      if (e is DioException && e.response?.data is Map && e.response?.data['detail'] != null) {
        msg = e.response!.data['detail'].toString();
      }
      setState(() {
        _isLoading = false;
        _errorMessage = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.space6),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(AppSpacing.space8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.cardLargeRadius,
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brand Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: AppRadii.cardStandardRadius,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Icon(AppIcons.keyRound, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: AppSpacing.space3),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'CODE',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'ARENA',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: AppColors.primaryLight,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Text(
                        _getHeaderTitle(),
                        style: AppTypography.h2(context, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.space1),
                      Text(
                        _getHeaderSubtitle(),
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall(context, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space6),

                // Error Banner
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.12),
                      borderRadius: AppRadii.inputRadius,
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(AppIcons.alertCircle, size: 18, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                ],

                // Success/Info Banner
                if (_successMessage != null && _currentStep != ResetStep.success) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: AppRadii.inputRadius,
                      border: Border.all(color: AppColors.success.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(AppIcons.checkCircle, size: 18, color: AppColors.success),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _successMessage!,
                            style: const TextStyle(color: AppColors.success, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                ],

                // Step Body
                if (_currentStep == ResetStep.enterEmail) _buildEmailStep(),
                if (_currentStep == ResetStep.enterOtp) _buildOtpStep(),
                if (_currentStep == ResetStep.newPassword) _buildPasswordStep(),
                if (_currentStep == ResetStep.success) _buildSuccessStep(),

                const SizedBox(height: AppSpacing.space5),

                // Back to login link
                if (_currentStep != ResetStep.success)
                  Center(
                    child: TextButton.icon(
                      icon: const Icon(AppIcons.arrowLeft, size: 14, color: AppColors.textMuted),
                      label: const Text(
                        'Back to Sign In',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () => context.go('/auth/login'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentStep) {
      case ResetStep.enterEmail:
        return 'Forgot Password';
      case ResetStep.enterOtp:
        return 'Verify OTP Code';
      case ResetStep.newPassword:
        return 'Set New Password';
      case ResetStep.success:
        return 'Password Updated';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentStep) {
      case ResetStep.enterEmail:
        return 'Enter your registered Gmail or institutional email address to receive a verification code.';
      case ResetStep.enterOtp:
        return 'Check your email inbox or spam folder for the 6-digit CodeArena security code.';
      case ResetStep.newPassword:
        return 'Create a strong, new password with at least 6 characters.';
      case ResetStep.success:
        return 'Your password has been successfully reset. You can now log in.';
    }
  }

  // STEP 1: Email Input
  Widget _buildEmailStep() {
    return Column(
      children: [
        AppTextField(
          label: 'Email Address',
          hint: 'student@codearena.com',
          controller: _emailCtrl,
          prefixIcon: AppIcons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.space5),
        AppButton(
          text: 'Send Reset Code',
          variant: AppButtonVariant.primary,
          icon: AppIcons.send,
          isLoading: _isLoading,
          onPressed: _handleSendOtp,
        ),
      ],
    );
  }

  // STEP 2: OTP Verification
  Widget _buildOtpStep() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sent to: ${_emailCtrl.text}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              InkWell(
                onTap: () => setState(() => _currentStep = ResetStep.enterEmail),
                child: const Text(
                  'Change',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryLight, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        AppTextField(
          label: '6-Digit Verification Code',
          hint: '123456',
          controller: _otpCtrl,
          prefixIcon: AppIcons.keyRound,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.space3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(AppIcons.clock, size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  'Expires in ${_formatTimer(_secondsRemaining)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            TextButton(
              onPressed: _isLoading ? null : _handleSendOtp,
              child: const Text('Resend Code', style: TextStyle(color: AppColors.primaryLight, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space4),
        AppButton(
          text: 'Verify Code',
          variant: AppButtonVariant.primary,
          icon: AppIcons.checkCircle,
          isLoading: _isLoading,
          onPressed: _handleVerifyOtp,
        ),
      ],
    );
  }

  // STEP 3: New Password
  Widget _buildPasswordStep() {
    return Column(
      children: [
        AppTextField(
          label: 'New Password',
          hint: '••••••••',
          controller: _newPassCtrl,
          isPassword: true,
          prefixIcon: AppIcons.lock,
        ),
        const SizedBox(height: AppSpacing.space4),
        AppTextField(
          label: 'Confirm New Password',
          hint: '••••••••',
          controller: _confirmPassCtrl,
          isPassword: true,
          prefixIcon: AppIcons.lock,
        ),
        const SizedBox(height: AppSpacing.space5),
        AppButton(
          text: 'Update Password',
          variant: AppButtonVariant.primary,
          icon: AppIcons.checkCircle2,
          isLoading: _isLoading,
          onPressed: _handleResetPassword,
        ),
      ],
    );
  }

  // STEP 4: Success
  Widget _buildSuccessStep() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withOpacity(0.15),
            border: Border.all(color: AppColors.success, width: 2),
          ),
          child: const Center(
            child: Icon(AppIcons.checkCircle2, color: AppColors.success, size: 36),
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        const Text(
          'Your password has been reset successfully. You can now sign in with your new credentials.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: AppSpacing.space6),
        AppButton(
          text: 'Proceed to Sign In',
          variant: AppButtonVariant.primary,
          icon: AppIcons.arrowRight,
          onPressed: () => context.go('/auth/login'),
        ),
      ],
    );
  }
}
