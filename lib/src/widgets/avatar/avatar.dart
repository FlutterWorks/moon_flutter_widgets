import 'package:flutter/material.dart';

import 'package:moon_design/src/theme/avatar_sizes.dart';
import 'package:moon_design/src/theme/colors.dart';
import 'package:moon_design/src/theme/theme.dart';
import 'package:moon_design/src/utils/extensions.dart';
import 'package:moon_design/src/utils/max_border_radius.dart';
import 'package:moon_design/src/widgets/avatar/avatar_clipper.dart';

enum MoonAvatarSize {
  xs,
  sm,
  md,
  lg,
  xl,
  x2l,
}

enum MoonBadgeAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class MoonAvatar extends StatelessWidget {
  /// The height of the avatar.
  final double? width;

  /// The width of the avatar.
  final double? height;

  /// The border radius of the avatar.
  final BorderRadius? borderRadius;

  /// The size of the avatars badge.
  final double? badgeSize;

  /// The margin value of the avatars badge.
  final double? badgeMarginValue;

  /// Whether to show the avatar badge or not.
  final bool showBadge;

  /// The color of the avatar badge.
  final Color? badgeColor;

  /// The background color of the avatar.
  final Color? backgroundColor;

  /// The size of the avatar.
  final MoonAvatarSize? avatarSize;

  /// The alignment of the avatar badge.
  final MoonBadgeAlignment badgeAlignment;

  /// The background image of the avatar.
  final ImageProvider<Object>? backgroundImage;

  /// The child of the avatar.
  final Widget? child;

  const MoonAvatar({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.badgeSize,
    this.badgeMarginValue,
    this.showBadge = false,
    this.badgeColor,
    this.backgroundColor,
    this.avatarSize,
    this.badgeAlignment = MoonBadgeAlignment.bottomRight,
    this.backgroundImage,
    this.child,
  });

  Alignment _avatarAlignmentMapper() {
    switch (badgeAlignment) {
      case MoonBadgeAlignment.topLeft:
        return Alignment.topLeft;
      case MoonBadgeAlignment.topRight:
        return Alignment.topRight;
      case MoonBadgeAlignment.bottomLeft:
        return Alignment.bottomLeft;
      case MoonBadgeAlignment.bottomRight:
        return Alignment.bottomRight;
      default:
        return Alignment.bottomLeft;
    }
  }

  MoonAvatarSizes _getMoonAvatarSize(BuildContext context, MoonAvatarSize? moonAvatarSize) {
    switch (moonAvatarSize) {
      case MoonAvatarSize.xs:
        return context.moonTheme?.avatarTheme.xs ?? MoonAvatarSizes.xs;
      case MoonAvatarSize.sm:
        return context.moonTheme?.avatarTheme.sm ?? MoonAvatarSizes.sm;
      case MoonAvatarSize.md:
        return context.moonTheme?.avatarTheme.md ?? MoonAvatarSizes.md;
      case MoonAvatarSize.lg:
        return context.moonTheme?.avatarTheme.lg ?? MoonAvatarSizes.lg;
      case MoonAvatarSize.xl:
        return context.moonTheme?.avatarTheme.xl ?? MoonAvatarSizes.xl;
      case MoonAvatarSize.x2l:
        return context.moonTheme?.avatarTheme.x2l ?? MoonAvatarSizes.x2l;
      default:
        return context.moonTheme?.avatarTheme.md ?? MoonAvatarSizes.md;
    }
  }

  Color _getTextColor({required bool isDarkMode, required Color backgroundColor}) {
    final backgroundLuminance = backgroundColor.computeLuminance();
    if (backgroundLuminance > 0.5) {
      return MoonColors.light.bulma;
    } else {
      return MoonColors.dark.bulma;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MoonAvatarSizes effectiveMoonAvatarSize = _getMoonAvatarSize(context, avatarSize);

    final double effectiveAvatarWidth = width ?? effectiveMoonAvatarSize.avatarSizeValue;
    final double effectiveAvatarHeight = height ?? effectiveMoonAvatarSize.avatarSizeValue;

    final double effectiveBadgeSize = badgeSize ?? effectiveMoonAvatarSize.badgeSizeValue;
    final double effectiveBadgeMarginValue = badgeMarginValue ?? effectiveMoonAvatarSize.badgeMarginValue;

    final BorderRadius effectiveBorderRadius = borderRadius ?? effectiveMoonAvatarSize.borderRadius;
    final double avatarBorderRadiusValue = maxBorderRadius(effectiveBorderRadius);

    final Color effectiveBackgroundColor = backgroundColor ?? context.moonColors?.gohan ?? MoonColors.light.gohan;
    final Color effectiveBadgeColor = badgeColor ?? context.moonColors?.roshi100 ?? MoonColors.light.roshi100;

    final Color effectiveTextColor =
        _getTextColor(isDarkMode: context.isDarkMode, backgroundColor: effectiveBackgroundColor);

    return SizedBox(
      width: effectiveAvatarWidth,
      height: effectiveAvatarHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: AvatarClipper(
                showBadge: showBadge,
                width: effectiveAvatarWidth,
                height: effectiveAvatarHeight,
                borderRadiusValue: avatarBorderRadiusValue,
                badgeSize: effectiveBadgeSize,
                badgeMarginValue: effectiveBadgeMarginValue,
                badgeAlignment: badgeAlignment,
              ),
              child: DefaultTextStyle(
                style: effectiveMoonAvatarSize.textStyle.copyWith(color: effectiveTextColor),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: effectiveBackgroundColor,
                    image: backgroundImage != null
                        ? DecorationImage(
                            image: backgroundImage!,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
          if (showBadge)
            Align(
              alignment: _avatarAlignmentMapper(),
              child: Container(
                height: effectiveBadgeSize,
                width: effectiveBadgeSize,
                decoration: BoxDecoration(
                  color: effectiveBadgeColor,
                  borderRadius: BorderRadius.circular(effectiveBadgeSize / 2),
                ),
              ),
            )
        ],
      ),
    );
  }
}