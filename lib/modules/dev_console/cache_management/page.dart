import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/dev_console/cache_management/controller.dart';
import 'package:jobprogress/modules/dev_console/cache_management/widgets/cache_section_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CacheManagementPage extends StatelessWidget {
  const CacheManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CacheManagementController>(
      init: CacheManagementController(),
      builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left alignment for all content
            children: [
              // Data Distribution Note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: JPAppTheme.themeColors.lightestGray,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: JPAppTheme.themeColors.lightestGray),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: JPAppTheme.themeColors.tertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        JPText(
                          text: 'note'.tr,
                          fontWeight: JPFontWeight.medium,
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.text,
                          textAlign: TextAlign.left, // Left alignment
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    JPText(
                      text: 'cache_data_distribution_note'.tr,
                      textSize: JPTextSize.heading6,
                      textColor: JPAppTheme.themeColors.tertiary,
                      textAlign: TextAlign.left, // Left alignment
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // Total Cache Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: JPAppTheme.themeColors.base,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: JPAppTheme.themeColors.primary),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.storage,
                      color: JPAppTheme.themeColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
                        children: [
                          JPText(
                            text: 'storage_distribution'.tr, // Updated key
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading4,
                            textAlign: TextAlign.left, // Left alignment
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          JPText(
                            text: 'total_size_items'.trParams({
                              'size': controller.formatSize(controller.totalCacheSize),
                              'items': controller.totalItemCount.toString(),
                            }),
                            textSize: JPTextSize.heading6,
                            fontWeight: JPFontWeight.medium,
                            textColor: JPAppTheme.themeColors.themeBlue,
                            textAlign: TextAlign.left, // Left alignment
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(
                height: 24,
              ),

              // Shared Preferences Section (no clear button)
              CacheSectionTile(
                icon: Icons.settings_outlined,
                title: 'app_preferences'.tr,
                subtitle: 'user_preferences_and_app_settings'.tr,
                size: controller.formatSize(controller.sharedPrefsSize),
                itemCount: controller.sharedPrefsItemCount,
                showClearButton: false, // Remove clear button
                isLoading: controller.isSharedPrefsLoading, // Individual loader
              ),

              const SizedBox(height: 8),

              // Cookies Section (no clear button)
              CacheSectionTile(
                icon: Icons.cookie_outlined,
                title: 'cookies'.tr,
                subtitle: 'authentication_and_session_cookies'.tr,
                size: controller.formatSize(controller.cookiesSize),
                itemCount: controller.cookiesItemCount,
                showClearButton: false, // Remove clear button
                isLoading: controller.isCookiesLoading, // Individual loader
              ),

              const SizedBox(height: 8),

              // App Cache Section (keep clear button)
              CacheSectionTile(
                icon: Icons.cached_outlined,
                title: 'app_cache'.tr,
                subtitle: 'application_cache_and_stored_data'.tr,
                size: controller.formatSize(controller.cachesSize),
                itemCount: controller.cachesItemCount,
                onClear: controller.clearCachesConfirmation,
                showClearButton: true, // Keep clear button
                isLoading: controller.isCachesLoading, // Individual loader
              ),

              const SizedBox(height: 8),

              // Uploads Section (keep clear button)
              CacheSectionTile(
                icon: Icons.file_upload_outlined,
                title: 'uploads'.tr,
                subtitle: 'uploaded_files_and_documents'.tr,
                size: controller.formatSize(controller.uploadsSize),
                itemCount: controller.uploadsItemCount,
                onClear: controller.clearUploadsConfirmation,
                showClearButton: true, // Keep clear button
                isLoading: controller.isUploadsLoading, // Individual loader
              ),

              const SizedBox(height: 8),

              // Database Section (no clear button)
              CacheSectionTile(
                icon: Icons.storage_outlined,
                title: 'database'.tr,
                subtitle: 'local_database_storage'.tr,
                size: controller.formatSize(controller.databaseSize),
                itemCount: 1, // Database is one item
                showItemCount: false, // Don't show item count for database
                showClearButton: false, // Remove clear button
                isLoading: controller.isDatabaseLoading, // Individual loader
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
} 