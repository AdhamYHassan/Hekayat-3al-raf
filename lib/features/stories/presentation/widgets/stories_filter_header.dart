import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../domain/entities/story_type_entity.dart';

/// Sticky header containing search bar, sort chips, and category filters.
class StoriesFilterHeader extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedSort;
  final String? selectedKindSlug;
  final String? selectedType;
  final List<StoryTypeEntity> storyTypes;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSortSelected;
  final ValueChanged<String?> onKindSelected;
  final ValueChanged<String?> onTypeSelected;

  const StoriesFilterHeader({
    super.key,
    required this.searchController,
    required this.selectedSort,
    required this.selectedKindSlug,
    required this.selectedType,
    required this.storyTypes,
    required this.onSearchChanged,
    required this.onSortSelected,
    required this.onKindSelected,
    required this.onTypeSelected,
  });

  // Sort Mapping: labelKey -> query value
  static const List<({String labelKey, String value})> _sortOptions = [
    (labelKey: 'stories.sort_latest', value: 'latest'),
    (labelKey: 'stories.sort_liked', value: 'liked'),
    (labelKey: 'stories.sort_top', value: 'top'),
    (labelKey: 'stories.sort_viewed', value: 'viewed'),
  ];

  static const List<({String labelKey, String? value})> _typeOptions = [
    (labelKey: 'stories.all', value: null),
    (labelKey: 'stories.type_text', value: 'text'),
    (labelKey: 'stories.type_audio', value: 'audio'),
    (labelKey: 'stories.type_video', value: 'video'),
    (labelKey: 'stories.type_document', value: 'document'),
  ];

  void _showTypeBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorManager.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'stories.content_type'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.paper100,
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _typeOptions.map((opt) {
                    final isSelected = opt.value == selectedType;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        onTypeSelected(opt.value);
                      },
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorManager.gold
                              : ColorManager.primaryLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          opt.labelKey.tr(),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 12.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? ColorManager.primaryDark : ColorManager.paper200,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.primaryDark,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Title & Format Filter Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'stories.title'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.paper100,
                ),
              ),
              InkWell(
                onTap: () => _showTypeBottomSheet(context),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: selectedType != null
                        ? ColorManager.gold.withValues(alpha: 0.2)
                        : ColorManager.primaryLight.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: selectedType != null
                          ? ColorManager.gold
                          : ColorManager.gold.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.slider_horizontal_3,
                        size: 14.sp,
                        color: selectedType != null ? ColorManager.gold : ColorManager.paper300,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        selectedType != null
                            ? _typeOptions.firstWhere((t) => t.value == selectedType).labelKey.tr()
                            : 'stories.story_type'.tr(),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: selectedType != null ? ColorManager.gold : ColorManager.paper300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Row 2: Search Input Field
          Container(
            height: 42.h,
            decoration: BoxDecoration(
              color: ColorManager.primaryLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: ColorManager.gold.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13.sp,
                color: ColorManager.paper100,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'stories.search_hint'.tr(),
                hintStyle: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13.sp,
                  color: ColorManager.paper400,
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  size: 18.sp,
                  color: ColorManager.paper400,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Row 3: Sort Pills (Horizontal Bar)
          SizedBox(
            height: 32.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _sortOptions.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final sort = _sortOptions[index];
                final isSelected = sort.value == selectedSort;

                return InkWell(
                  onTap: () => onSortSelected(sort.value),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorManager.gold
                          : ColorManager.primaryLight.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20.r),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: ColorManager.gold.withValues(alpha: 0.15),
                              width: 1,
                            ),
                    ),
                    child: Text(
                      sort.labelKey.tr(),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? ColorManager.primaryDark : ColorManager.paper300,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 10.h),

          // Row 4: Category / Kind Pills from API
          SizedBox(
            height: 26.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: storyTypes.length + 1,
              separatorBuilder: (context, index) => SizedBox(width: 6.w),
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final slug = isAll ? null : storyTypes[index - 1].slug;
                final name = isAll ? 'stories.all'.tr() : storyTypes[index - 1].name;
                final isSelected = slug == selectedKindSlug;

                return InkWell(
                  onTap: () => onKindSelected(slug),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    child: Text(
                      name,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? ColorManager.gold : ColorManager.paper400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
