import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/helpers/arabic_to_english_digits_formatter.dart';
import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/profile_state.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/widgets/profile_shimmer_loading.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          if (state.updateSuccessMessage != null) {
            AppSnackBar.showSuccess(
              context,
              message: state.updateSuccessMessage!,
            );
          } else if (state.updateErrorMessage != null) {
            AppSnackBar.showError(
              context,
              message: state.updateErrorMessage!,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorManager.primaryDark,
          body: SafeArea(
            top: false,
            bottom: false,
            child: switch (state) {
              ProfileInitial() || ProfileLoading() => const ProfileShimmerLoading(),
              ProfileError(:final message) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.exclamationmark_triangle,
                          color: ColorManager.gold,
                          size: 48.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ibmPlexSansArabic(
                            color: ColorManager.paper200,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<ProfileCubit>().loadProfile(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.gold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Text(
                            'common.retry'.tr(),
                            style: GoogleFonts.alexandria(
                              color: ColorManager.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ProfileLoaded(:final user) => _ProfileContent(user: user),
            },
          ),
        );
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final ProfileUserEntity user;

  const _ProfileContent({required this.user});

  String _formatJoinDate(BuildContext context, DateTime? dateJoined) {
    if (dateJoined == null) {
      return 'profile.joined_date'.tr(args: ['٢٠٢٦']);
    }
    final isAr = context.locale.languageCode == 'ar';
    final formatter = DateFormat('MMMM yyyy', isAr ? 'ar' : 'en');
    final formatted = formatter.format(dateJoined);
    return 'profile.joined_date'.tr(args: [formatted]);
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorManager.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: ColorManager.gold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Text(
          'profile.logout_confirm_title'.tr(),
          style: GoogleFonts.alexandria(
            color: ColorManager.paper100,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'profile.logout_confirm_desc'.tr(),
          style: GoogleFonts.ibmPlexSansArabic(
            color: ColorManager.paper200,
            fontSize: 13.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'common.cancel'.tr(),
              style: GoogleFonts.ibmPlexSansArabic(
                color: ColorManager.paper400,
                fontSize: 13.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'profile.logout'.tr(),
              style: GoogleFonts.ibmPlexSansArabic(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await SecureStorageHelper.clearToken();
      await SecureStorageHelper.clearRefreshToken();
      if (context.mounted) {
        context.go(Routes.home);
      }
    }
  }

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        side: BorderSide(
          color: ColorManager.gold.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: _EditProfileModalSheet(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user.displayName.isNotEmpty
        ? user.displayName
        : (user.name.isNotEmpty ? user.name : 'أحمد سالم');

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. App Bar Header with Logo & Back button
        SliverAppBar(
          backgroundColor: ColorManager.primaryDark.withValues(alpha: 0.95),
          pinned: true,
          elevation: 2,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 16.w,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppCachedNetworkImage(
                imageUrl: 'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
                height: 32.h,
                fit: BoxFit.contain,
                memCacheHeight: 90,
                errorWidget: Text(
                  'app_name'.tr(),
                  style: GoogleFonts.arefRuqaa(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.gold,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'common.back'.tr(),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.goldLight,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.chevron_left_rounded,
                        color: ColorManager.goldLight,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. Profile Hero Header with Background & Avatar
        SliverToBoxAdapter(
          child: Stack(
            children: [
              // Hero Background with Gradient
              Positioned.fill(
                child: Stack(
                  children: [
                    AppCachedNetworkImage(
                      imageUrl: 'https://hekayat-ala-el-raff-m9tr.bolt.host/home/hero-bike.webp',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.6),
                      width: double.infinity,
                      height: double.infinity,
                      memCacheWidth: 750,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorManager.primaryDark.withValues(alpha: 0.60),
                            ColorManager.primaryDark.withValues(alpha: 0.85),
                            ColorManager.primaryDark,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar & Info Content
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
                child: Column(
                  children: [
                    // Avatar with Edit Badge
                    Center(
                      child: GestureDetector(
                        onTap: () => _showEditProfileSheet(context),
                        child: Stack(
                          children: [
                            Container(
                              width: 96.r,
                              height: 96.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorManager.gold.withValues(alpha: 0.40),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: user.avatar != null &&
                                        user.avatar!.isNotEmpty
                                    ? AppCachedNetworkImage(
                                        imageUrl: user.avatar!,
                                        fit: BoxFit.cover,
                                        width: 88.r,
                                        height: 88.r,
                                        memCacheWidth: 200,
                                        memCacheHeight: 200,
                                        errorWidget: _buildDefaultAvatar(),
                                      )
                                    : _buildDefaultAvatar(),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 28.r,
                                height: 28.r,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFE8CB7D), Color(0xFFC9A24B)],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorManager.primaryDark,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  CupertinoIcons.pencil,
                                  color: ColorManager.primaryDark,
                                  size: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // User Name
                    Text(
                      displayName,
                      style: GoogleFonts.alexandria(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.paper100,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Location & Dynamic Join date from API
                    Text(
                      '${'profile.default_city'.tr()} · ${_formatJoinDate(context, user.dateJoined)}',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12.sp,
                        color: ColorManager.goldLight,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Dynamic Bio from API (or fallback if empty)
                    SizedBox(
                      width: 280.w,
                      child: Text(
                        user.bio.isNotEmpty
                            ? user.bio
                            : 'profile.no_bio'.tr(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12.5.sp,
                          height: 1.5,
                          color: user.bio.isNotEmpty
                              ? ColorManager.paper200.withValues(alpha: 0.85)
                              : ColorManager.paper400.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 3. Contact Info Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('profile.contact_info'.tr()),
                SizedBox(height: 8.h),
                _buildContactCard(
                  icon: CupertinoIcons.phone_fill,
                  label: 'profile.mobile'.tr(),
                  value: user.phone.isNotEmpty ? user.phone : '—',
                  isLtr: true,
                ),
                SizedBox(height: 8.h),
                _buildContactCard(
                  icon: CupertinoIcons.mail_solid,
                  label: 'profile.email'.tr(),
                  value: user.email.isNotEmpty ? user.email : '—',
                  isLtr: true,
                ),
                SizedBox(height: 8.h),
                _buildContactCard(
                  icon: CupertinoIcons.location_solid,
                  label: 'profile.city'.tr(),
                  value: 'profile.default_city'.tr(),
                ),
              ],
            ),
          ),
        ),

        // 4. Menu Options Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('profile.menu'.tr()),
                SizedBox(height: 8.h),
                _buildMenuItemCard(
                  icon: CupertinoIcons.pencil,
                  title: 'profile.edit_profile'.tr(),
                  subtitle: 'profile.edit_profile_sub'.tr(),
                  onTap: () => _showEditProfileSheet(context),
                ),
                SizedBox(height: 8.h),
                _buildMenuItemCard(
                  icon: CupertinoIcons.book_fill,
                  title: 'profile.my_stories'.tr(),
                  subtitle: 'profile.stories_count'.tr(args: ['${user.storiesCount}']),
                  onTap: () {
                    context.push(Routes.myStories);
                  },
                ),
                SizedBox(height: 8.h),
                _buildMenuItemCard(
                  icon: CupertinoIcons.chat_bubble_2_fill,
                  title: 'profile.my_questions'.tr(),
                  subtitle: 'profile.my_questions_sub'.tr(),
                  onTap: () {
                    AppSnackBar.showInfo(
                      context,
                      message: 'profile.coming_soon'.tr(),
                    );
                  },
                ),
                SizedBox(height: 8.h),
                _buildMenuItemCard(
                  icon: CupertinoIcons.gear_alt_fill,
                  title: 'profile.settings'.tr(),
                  subtitle: 'profile.settings_sub'.tr(),
                  onTap: () {
                    Navigator.of(context).pop(); // Back to More Screen
                  },
                ),
                SizedBox(height: 24.h),

                // Logout Button
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 12.h,
                      ),
                    ),
                    icon: Icon(
                      CupertinoIcons.square_arrow_right,
                      color: const Color(0xFFF87171),
                      size: 16.sp,
                    ),
                    label: Text(
                      'profile.logout'.tr(),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF87171),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: ColorManager.primaryLight,
      child: AppCachedNetworkImage(
        imageUrl: 'https://hekayat-ala-el-raff-m9tr.bolt.host/amb-1.webp',
        fit: BoxFit.cover,
        width: 88.r,
        height: 88.r,
        memCacheWidth: 200,
        memCacheHeight: 200,
        errorWidget: Icon(
          CupertinoIcons.person_fill,
          size: 48.sp,
          color: ColorManager.goldLight,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 20.w, height: 1.5.h, color: ColorManager.gold),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.ibmPlexSansArabic(
            color: ColorManager.gold,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    bool isLtr = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: ColorManager.gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: ColorManager.goldLight,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 10.5.sp,
                    color: ColorManager.paper400,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  textDirection: isLtr ? ui.TextDirection.ltr : null,
                  textAlign: isLtr ? TextAlign.right : null,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13.5.sp,
                    color: ColorManager.paper100,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorManager.primaryLight.withValues(alpha: 0.30),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.gold.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: ColorManager.gold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: ColorManager.goldLight,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.alexandria(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.paper100,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11.sp,
                      color: ColorManager.paper400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              color: ColorManager.gold.withValues(alpha: 0.50),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileModalSheet extends StatefulWidget {
  final ProfileUserEntity user;

  const _EditProfileModalSheet({required this.user});

  @override
  State<_EditProfileModalSheet> createState() => _EditProfileModalSheetState();
}

class _EditProfileModalSheetState extends State<_EditProfileModalSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.user.displayName.isNotEmpty
          ? widget.user.displayName
          : widget.user.name,
    );
    _phoneController = TextEditingController(text: widget.user.phone);
    _bioController = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final bio = _bioController.text.trim();

    if (name.isEmpty) {
      AppSnackBar.showError(
        context,
        message: 'validation.author_required'.tr(),
      );
      return;
    }

    Navigator.of(context).pop();
    context.read<ProfileCubit>().updateProfile(
          name: name,
          phone: phone,
          bio: bio,
          avatar: widget.user.avatar,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'profile.edit_profile'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.paper100,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: ColorManager.paper400,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Name field
          Text(
            'profile.name_label'.tr(),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12.sp,
              color: ColorManager.paper300,
            ),
          ),
          SizedBox(height: 6.h),
          _buildTextField(
            controller: _nameController,
            hint: 'أدخل اسمك الكامل',
          ),
          SizedBox(height: 12.h),

          // Phone field
          Text(
            'profile.phone_label'.tr(),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12.sp,
              color: ColorManager.paper300,
            ),
          ),
          SizedBox(height: 6.h),
          _buildTextField(
            controller: _phoneController,
            hint: '+201000000000',
            keyboardType: TextInputType.phone,
            isLtr: true,
          ),
          SizedBox(height: 12.h),

          // Bio field
          Text(
            'profile.bio_label'.tr(),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12.sp,
              color: ColorManager.paper300,
            ),
          ),
          SizedBox(height: 6.h),
          _buildTextField(
            controller: _bioController,
            hint: 'اكتب نبذة مختصرة عنك...',
            maxLines: 3,
          ),
          SizedBox(height: 20.h),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.gold,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                'profile.save_changes'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isLtr = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: [
        if (keyboardType == TextInputType.phone ||
            keyboardType == TextInputType.number)
          const ArabicToEnglishDigitsFormatter(),
      ],
      maxLines: maxLines,
      style: GoogleFonts.ibmPlexSansArabic(
        fontSize: 13.5.sp,
        color: ColorManager.paper100,
      ),
      textDirection: isLtr ? ui.TextDirection.ltr : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.ibmPlexSansArabic(
          fontSize: 13.sp,
          color: ColorManager.paper400.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: ColorManager.primaryLight.withValues(alpha: 0.4),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: ColorManager.gold.withValues(alpha: 0.15),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: ColorManager.gold.withValues(alpha: 0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: ColorManager.gold,
          ),
        ),
      ),
    );
  }
}
