import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/arabic_to_english_digits_formatter.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/font_manager.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_cached_network_image.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/profile_user_entity.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

/// Full-screen dedicated interface for modifying user profile information (Name, Email, Phone, Bio, and Avatar).
/// Replaces the cramped bottom modal sheet for optimal typography, ergonomics, and seamless keyboard handling.
class EditProfileScreen extends StatefulWidget {
  final ProfileUserEntity user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  XFile? _selectedAvatar;
  final ImagePicker _picker = ImagePicker();

  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.user.displayName.isNotEmpty
          ? widget.user.displayName
          : widget.user.name,
    );
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _bioController = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        setState(() {
          _selectedAvatar = picked;
        });
      }
    } catch (e) {
      debugPrint('[EditProfile] Failed to pick avatar: $e');
    }
  }

  bool _validateForm() {
    bool isValid = true;
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _nameError = 'auth.name_required'.tr());
      isValid = false;
    } else {
      setState(() => _nameError = null);
    }

    return isValid;
  }

  void _onSave(BuildContext context) {
    if (!_validateForm()) return;

    final initialName = widget.user.displayName.isNotEmpty
        ? widget.user.displayName
        : widget.user.name;
    final currentName = _nameController.text.trim();
    final currentPhone = _phoneController.text.trim();
    final currentBio = _bioController.text.trim();

    // Only send fields that actually changed (Partial Update / PATCH semantic)
    final String? nameToSend = currentName != initialName ? currentName : null;
    final String? phoneToSend = currentPhone != widget.user.phone
        ? currentPhone
        : null;
    final String? bioToSend = currentBio != widget.user.bio ? currentBio : null;
    final String? avatarPathToSend = _selectedAvatar?.path;

    // If nothing changed at all, just close screen
    if (nameToSend == null &&
        phoneToSend == null &&
        bioToSend == null &&
        avatarPathToSend == null) {
      context.pop();
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      name: nameToSend,
      phone: phoneToSend,
      phoneRegion: phoneToSend != null ? 'EG' : null,
      bio: bioToSend,
      avatarFilePath: avatarPathToSend,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) {
        if (curr is ProfileLoaded) {
          return curr.updateSuccessMessage != null ||
              curr.updateErrorMessage != null;
        }
        if (curr is ProfileError) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          if (state.updateSuccessMessage != null) {
            AppSnackBar.showSuccess(
              context,
              message: state.updateSuccessMessage!,
            );
            context.pop();
          } else if (state.updateErrorMessage != null) {
            AppSnackBar.showError(context, message: state.updateErrorMessage!);
          }
        } else if (state is ProfileError) {
          AppSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isUpdating = state is ProfileLoaded && state.isUpdating;

        return Scaffold(
          backgroundColor: ColorManager.primaryDark,
          appBar: AppBar(
            backgroundColor: ColorManager.primaryDark,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            titleSpacing: 16.w,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'profile.edit_profile'.tr(),
                  style: AppFonts.alexandria(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.paper100,
                  ),
                ),
                const AppBackButton(),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.h),
              child: Container(
                color: ColorManager.gold.withValues(alpha: 0.15),
                height: 1.h,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Avatar Picker Section
                  Center(
                    child: GestureDetector(
                      onTap: isUpdating ? null : _pickAvatar,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100.r,
                            height: 100.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorManager.gold,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorManager.gold.withValues(
                                    alpha: 0.15,
                                  ),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _selectedAvatar != null
                                  ? Image.file(
                                      File(_selectedAvatar!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : widget.user.avatar != null &&
                                        widget.user.avatar!.isNotEmpty
                                  ? AppCachedNetworkImage(
                                      imageUrl: widget.user.avatar!,
                                      width: 100.r,
                                      height: 100.r,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: ColorManager.primaryLight,
                                      child: Icon(
                                        CupertinoIcons.person_fill,
                                        size: 52.sp,
                                        color: ColorManager.goldLight,
                                      ),
                                    ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(7.r),
                            decoration: BoxDecoration(
                              color: ColorManager.gold,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorManager.primaryDark,
                                width: 2.5,
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.camera_fill,
                              size: 15.sp,
                              color: ColorManager.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: Text(
                      'auth.change_avatar'.tr(),
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 12.sp,
                        color: ColorManager.goldLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // 2. Full Name
                  _buildFieldLabel('auth.full_name'.tr(), isRequired: true),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'auth.full_name_hint'.tr(),
                    icon: CupertinoIcons.person,
                    errorMessage: _nameError,
                    enabled: !isUpdating,
                    onChanged: (val) {
                      if (_nameError != null && val.trim().isNotEmpty) {
                        setState(() => _nameError = null);
                      }
                    },
                  ),
                  SizedBox(height: 18.h),

                  // 3. Email (Read-Only as mandated by backend security policy)
                  _buildFieldLabel('auth.email'.tr()),
                  _buildTextField(
                    controller: _emailController,
                    hint: 'auth.email_hint'.tr(),
                    icon: CupertinoIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                  ),
                  SizedBox(height: 18.h),

                  // 4. Phone Number
                  _buildFieldLabel('auth.phone_number'.tr()),
                  _buildTextField(
                    controller: _phoneController,
                    hint: '01012345678',
                    icon: CupertinoIcons.phone,
                    keyboardType: TextInputType.phone,
                    enabled: !isUpdating,
                  ),
                  SizedBox(height: 18.h),

                  // 5. Bio
                  _buildFieldLabel('profile.bio_label'.tr()),
                  _buildTextField(
                    controller: _bioController,
                    hint: 'profile.bio_hint'.tr(),
                    icon: CupertinoIcons.text_quote,
                    maxLines: 4,
                    enabled: !isUpdating,
                  ),

                  SizedBox(height: 36.h),

                  // 6. Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isUpdating ? null : () => _onSave(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.gold,
                        foregroundColor: ColorManager.primaryDark,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      icon: isUpdating
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorManager.primaryDark,
                              ),
                            )
                          : const Icon(CupertinoIcons.checkmark_alt, size: 20),
                      label: Text(
                        isUpdating
                            ? 'common.saving'.tr()
                            : 'common.save_changes'.tr(),
                        style: AppFonts.alexandria(
                          fontSize: 14.sp,
                          color: ColorManager.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppFonts.ibmPlexSansArabic(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w500,
              color: ColorManager.paper200,
            ),
          ),
          if (isRequired) ...[
            SizedBox(width: 4.w),
            Text(
              '*',
              style: AppFonts.alexandria(
                fontSize: 13.sp,
                color: ColorManager.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? errorMessage,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    final hasError = errorMessage != null && errorMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
          keyboardType: keyboardType,
          inputFormatters: [
            if (keyboardType == TextInputType.phone ||
                keyboardType == TextInputType.number)
              const ArabicToEnglishDigitsFormatter(),
          ],
          onChanged: onChanged,
          style: AppFonts.ibmPlexSansArabic(
            fontSize: 13.5.sp,
            color: ColorManager.paper100,
          ),
          cursorColor: ColorManager.gold,
          decoration: InputDecoration(
            prefixIcon: maxLines == 1
                ? Icon(
                    icon,
                    color: hasError
                        ? ColorManager.error
                        : ColorManager.goldLight,
                    size: 18.sp,
                  )
                : null,
            hintText: hint,
            hintStyle: AppFonts.ibmPlexSansArabic(
              fontSize: 12.5.sp,
              color: ColorManager.paper400.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: ColorManager.primaryLight.withValues(alpha: 0.35),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.15),
                width: hasError ? 1.4 : 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.15),
                width: hasError ? 1.4 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.5),
                width: 1.4,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 6.h, right: 4.w, left: 4.w),
            child: Text(
              errorMessage,
              style: AppFonts.ibmPlexSansArabic(
                fontSize: 11.5.sp,
                color: ColorManager.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
