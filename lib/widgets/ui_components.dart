import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../constants/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxShadow? shadow;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.shadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.card),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(size),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(context, variant, size, isDark),
        child: isLoading
            ? SizedBox(
                width: _getIconSize(size),
                height: _getIconSize(size),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(variant, isDark),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: _getIconSize(size)),
                    const SizedBox(width: 8),
                  ],
                  child,
                ],
              ),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context, ButtonVariant variant, ButtonSize size, bool isDark) {
    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(variant, isDark),
      foregroundColor: _getForegroundColor(variant, isDark),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius(size)),
        side: variant == ButtonVariant.outline
            ? BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)
            : BorderSide.none,
      ),
      padding: _getPadding(size),
    );
  }

  Color _getBackgroundColor(ButtonVariant variant, bool isDark) {
    switch (variant) {
      case ButtonVariant.primary:
        return isDark ? AppColors.darkPrimary : AppColors.primary;
      case ButtonVariant.secondary:
        return isDark ? AppColors.darkSecondary : AppColors.secondary;
      case ButtonVariant.destructive:
        return AppColors.destructive;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(ButtonVariant variant, bool isDark) {
    switch (variant) {
      case ButtonVariant.primary:
        return isDark ? AppColors.darkPrimaryForeground : AppColors.primaryForeground;
      case ButtonVariant.secondary:
        return isDark ? AppColors.darkSecondaryForeground : AppColors.secondaryForeground;
      case ButtonVariant.destructive:
        return AppColors.destructiveForeground;
      case ButtonVariant.outline:
        return isDark ? AppColors.darkForeground : AppColors.foreground;
      case ButtonVariant.ghost:
        return isDark ? AppColors.darkForeground : AppColors.foreground;
    }
  }

  double _getHeight(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 48;
    }
  }

  EdgeInsets _getPadding(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    }
  }

  double _getBorderRadius(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 6;
      case ButtonSize.medium:
        return 8;
      case ButtonSize.large:
        return 10;
    }
  }

  double _getIconSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }
}

enum ButtonVariant { primary, secondary, destructive, outline, ghost }
enum ButtonSize { small, medium, large }

class AppInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int? maxLines;
  final InputSize size;

  const AppInput({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.size = InputSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkForeground : AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.darkForeground : AppColors.foreground,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled 
                ? (isDark ? AppColors.darkCard : AppColors.card)
                : (isDark ? AppColors.darkMuted : AppColors.muted),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius(size)),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius(size)),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius(size)),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkRing : AppColors.ring,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius(size)),
              borderSide: const BorderSide(color: AppColors.destructive),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius(size)),
              borderSide: const BorderSide(color: AppColors.destructive, width: 2),
            ),
            contentPadding: _getPadding(size),
            errorText: errorText,
          ),
        ),
      ],
    );
  }

  double _getBorderRadius(InputSize size) {
    switch (size) {
      case InputSize.small:
        return 6;
      case InputSize.medium:
        return 8;
      case InputSize.large:
        return 10;
    }
  }

  EdgeInsets _getPadding(InputSize size) {
    switch (size) {
      case InputSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case InputSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case InputSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }
}

enum InputSize { small, medium, large }

class AppBadge extends StatelessWidget {
  final Widget child;
  final BadgeVariant variant;
  final BadgeSize size;

  const AppBadge({
    super.key,
    required this.child,
    this.variant = BadgeVariant.default_,
    this.size = BadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: _getPadding(size),
      decoration: BoxDecoration(
        color: _getBackgroundColor(variant, isDark),
        borderRadius: BorderRadius.circular(_getBorderRadius(size)),
      ),
      child: DefaultTextStyle(
        style: _getTextStyle(context, variant, size, isDark),
        child: child,
      ),
    );
  }

  Color _getBackgroundColor(BadgeVariant variant, bool isDark) {
    switch (variant) {
      case BadgeVariant.default_:
        return isDark ? AppColors.darkSecondary : AppColors.secondary;
      case BadgeVariant.secondary:
        return isDark ? AppColors.darkMuted : AppColors.muted;
      case BadgeVariant.destructive:
        return AppColors.destructive;
      case BadgeVariant.outline:
        return Colors.transparent;
    }
  }

  TextStyle _getTextStyle(BuildContext context, BadgeVariant variant, BadgeSize size, bool isDark) {
    final baseStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w500,
    );
    
    switch (variant) {
      case BadgeVariant.default_:
        return baseStyle?.copyWith(
          color: isDark ? AppColors.darkSecondaryForeground : AppColors.secondaryForeground,
        ) ?? const TextStyle();
      case BadgeVariant.secondary:
        return baseStyle?.copyWith(
          color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
        ) ?? const TextStyle();
      case BadgeVariant.destructive:
        return baseStyle?.copyWith(
          color: AppColors.destructiveForeground,
        ) ?? const TextStyle();
      case BadgeVariant.outline:
        return baseStyle?.copyWith(
          color: isDark ? AppColors.darkForeground : AppColors.foreground,
        ) ?? const TextStyle();
    }
  }

  EdgeInsets _getPadding(BadgeSize size) {
    switch (size) {
      case BadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case BadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case BadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    }
  }

  double _getBorderRadius(BadgeSize size) {
    switch (size) {
      case BadgeSize.small:
        return 4;
      case BadgeSize.medium:
        return 6;
      case BadgeSize.large:
        return 8;
    }
  }
}

enum BadgeVariant { default_, secondary, destructive, outline }
enum BadgeSize { small, medium, large }

class AnimatedList extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final double verticalOffset;

  const AnimatedList({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.verticalOffset = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: duration,
            child: SlideAnimation(
              verticalOffset: verticalOffset,
              child: FadeInAnimation(
                child: children[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
