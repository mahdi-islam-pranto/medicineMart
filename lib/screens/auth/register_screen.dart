import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../theme/app_colors.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart';
import 'login_screen.dart';

/// Registration screen for pharmacy owners
///
/// This screen provides a comprehensive registration form matching the design inspiration
/// with all required fields including NID image upload functionality.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pharmacyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedDistrict;
  String? _selectedPoliceStation;
  File? _nidImage;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _pharmacyNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistrationError) {
            _showErrorDialog(state.message, state.validationErrors);
          } else if (state is AuthRegistrationSuccess) {
            _showSuccessDialog(state.message);
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Full Name Field
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Phone Number Field
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Pharmacy Name Field
                    _buildTextField(
                      controller: _pharmacyNameController,
                      label: 'Pharmacy Name',
                      icon: Icons.local_pharmacy_outlined,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Pharmacy name is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // District Dropdown
                    _buildDropdownField(
                      value: _selectedDistrict,
                      label: 'District',
                      icon: Icons.location_on_outlined,
                      items: Districts.all,
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                          _selectedPoliceStation = null; // Reset police station
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a district';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Police Station Dropdown
                    _buildDropdownField(
                      value: _selectedPoliceStation,
                      label: 'Police Station',
                      icon: Icons.location_on_outlined,
                      items: _getPoliceStations(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPoliceStation = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a police station';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Pharmacy Address Field
                    _buildTextField(
                      controller: _addressController,
                      label: 'Pharmacy Full Address',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Pharmacy address is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // NID Upload Section
                    _buildNidUploadSection(),

                    const SizedBox(height: 16),

                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Password is required';
                        }
                        if (value!.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password Field
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      obscureText: !_isConfirmPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state is AuthRegistrationLoading
                            ? null
                            : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: state is AuthRegistrationLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.textOnPrimary),
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // navigate to login screen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds a custom text field with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  /// Builds a dropdown field with consistent styling
  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        dropdownColor: AppColors.surface,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.primary,
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  /// Builds the NID upload section
  Widget _buildNidUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Required label
        // RichText(
        //   text: const TextSpan(
        //     text: 'Upload NID Picture',
        //     style: TextStyle(
        //       color: AppColors.textPrimary,
        //       fontSize: 14,
        //       fontWeight: FontWeight.w500,
        //     ),
        //     children: [
        //       TextSpan(
        //         text: ' *',
        //         style: TextStyle(
        //           color: AppColors.error,
        //           fontSize: 14,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _nidImage != null ? AppColors.primary : AppColors.borderLight,
              width: _nidImage != null ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: _pickNidImage,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _nidImage != null
                        ? Icons.check_circle
                        : Icons.upload_file_outlined,
                    color: _nidImage != null
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nidImage != null
                              ? 'NID Image Selected'
                              : 'Tap to upload NID picture (Required)',
                          style: TextStyle(
                            color: _nidImage != null
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: _nidImage != null
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                        if (_nidImage != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _nidImage!.path.split('/').last,
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_nidImage != null)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _nidImage = null;
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Gets police stations based on selected district (mock data)
  List<String> _getPoliceStations() {
    if (_selectedDistrict == null) return [];

    // Mock police stations - in real app, this would be fetched from API
    return [
      '$_selectedDistrict Sadar',
      '${_selectedDistrict} Model',
      '${_selectedDistrict} Kotwali',
      'Dhanmondi',
      'Ramna',
      'Tejgaon',
    ];
  }

  /// Picks NID image from gallery or camera
  Future<void> _pickNidImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _nidImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image. Please try again.');
    }
  }

  /// Handles registration form submission
  void _handleRegister() {
    // Validate form fields first
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Validate NID image is selected (mandatory)
    if (_nidImage == null) {
      _showErrorDialog(
          'Please upload your NID picture to continue registration.');
      return;
    }

    // All validations passed, proceed with registration
    final request = RegistrationRequest(
      fullName: _fullNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      pharmacyName: _pharmacyNameController.text.trim(),
      district: _selectedDistrict!,
      policeStation: _selectedPoliceStation!,
      pharmacyFullAddress: _addressController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      nidImagePath: _nidImage!.path, // Now guaranteed to be non-null
    );

    context.read<AuthCubit>().register(request);
  }

  /// Shows error dialog
  void _showErrorDialog(String message, [List<String>? validationErrors]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Error',
            style: TextStyle(fontSize: 16, color: AppColors.error)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (validationErrors != null && validationErrors.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...validationErrors.map((error) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '• $error',
                      style: const TextStyle(fontSize: 14),
                    ),
                  )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows success dialog and navigates to login
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Registration Successful',
          style: TextStyle(color: Colors.green),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('Continue to Login'),
          ),
        ],
      ),
    );
  }
}
