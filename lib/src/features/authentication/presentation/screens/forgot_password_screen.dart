import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }

    if (!_emailController.text.isValidEmail) {
      _showErrorSnackBar('Please enter a valid email');
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(
      resetPasswordProvider(_emailController.text.trim()).future,
    );

    if (mounted) {
      result.fold(
        (failure) {
          setState(() => _isLoading = false);
          _showErrorSnackBar(failure.message);
        },
        (_) {
          setState(() {
            _isLoading = false;
            _emailSent = true;
          });
          _showSuccessSnackBar('Password reset link sent to your email');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              if (!_emailSent) ...
                [
                  Text(
                    'Forgot Your Password?',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your email to receive a password reset link',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      enabled: !_isLoading,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('Send Reset Link'),
                  ),
                ] else ...
                [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.successColor.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: AppColors.successColor,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Email Sent Successfully',
                          style: AppTextStyles.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check your email inbox for a password reset link. You can now close this screen.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Back to Login'),
                        ),
                      ],
                    ),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
