import 'package:flutter/material.dart';
import '../../shared/widgets/widgets.dart';
import '../../core/theme/app_spacing.dart';

class UIKitPage extends StatelessWidget {
  const UIKitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText('UI Kit', variant: AppTextVariant.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Atoms Section
            _buildSection(
              title: 'Atoms',
              children: [
                _buildSubsection(
                  title: 'Button',
                  children: [
                    AppButton(
                      label: 'Primary Button',
                      onPressed: () {},
                      variant: AppButtonVariant.primary,
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Secondary Button',
                      onPressed: () {},
                      variant: AppButtonVariant.secondary,
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Text Button',
                      onPressed: () {},
                      variant: AppButtonVariant.text,
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Full Width Button',
                      onPressed: () {},
                      isFullWidth: true,
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Loading Button',
                      onPressed: () {},
                      isLoading: true,
                    ),
                  ],
                ),
                _buildSubsection(
                  title: 'Text Field',
                  children: [
                    AppTextField(
                      label: 'Label',
                      hint: 'Placeholder text',
                      helperText: 'Helper text',
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'With Error',
                      hint: 'Enter text',
                      errorText: 'This field is required',
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'With Icons',
                      hint: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.clear),
                    ),
                  ],
                ),
                _buildSubsection(
                  title: 'Text',
                  children: [
                    AppText('Display Large', variant: AppTextVariant.displayLarge),
                    AppText('Headline Large', variant: AppTextVariant.headlineLarge),
                    AppText('Title Large', variant: AppTextVariant.titleLarge),
                    AppText('Body Large', variant: AppTextVariant.body),
                    AppText('Label Large', variant: AppTextVariant.label),
                    AppText('Caption', variant: AppTextVariant.caption),
                    SizedBox(height: AppSpacing.md),
                    AppText('Primary Text', color: AppTextColor.primary),
                    AppText('Secondary Text', color: AppTextColor.secondary),
                    AppText('Error Text', color: AppTextColor.error),
                    AppText('Success Text', color: AppTextColor.success),
                  ],
                ),
                _buildSubsection(
                  title: 'Icon',
                  children: [
                    Row(
                      children: [
                        AppIcon(Icons.star, size: AppIconSize.small),
                        SizedBox(width: AppSpacing.md),
                        AppIcon(Icons.star, size: AppIconSize.medium),
                        SizedBox(width: AppSpacing.md),
                        AppIcon(Icons.star, size: AppIconSize.large),
                        SizedBox(width: AppSpacing.md),
                        AppIcon(Icons.star, size: AppIconSize.xlarge),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        AppIcon(Icons.check_circle, color: AppIconColor.success),
                        SizedBox(width: AppSpacing.md),
                        AppIcon(Icons.error, color: AppIconColor.error),
                        SizedBox(width: AppSpacing.md),
                        AppIcon(Icons.info, color: AppIconColor.primary),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            // Molecules Section
            _buildSection(
              title: 'Molecules',
              children: [
                _buildSubsection(
                  title: 'Card',
                  children: [
                    AppCard(
                      variant: AppCardVariant.elevated,
                      child: AppText('Elevated Card'),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppCard(
                      variant: AppCardVariant.outlined,
                      child: AppText('Outlined Card'),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppCard(
                      variant: AppCardVariant.filled,
                      child: AppText('Filled Card'),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppCard(
                      variant: AppCardVariant.elevated,
                      onTap: () {},
                      child: AppText('Clickable Card'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          variant: AppTextVariant.headlineMedium,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: AppSpacing.lg),
        ...children,
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildSubsection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          variant: AppTextVariant.titleMedium,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: AppSpacing.md),
        ...children,
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
