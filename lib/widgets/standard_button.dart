import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  const StandardButton({
    super.key,
    required this.textInfo,
    this.onClick,
    this.isAccent = false,
    this.isLoading = false,
  });

  final String textInfo;
  final VoidCallback? onClick;
  final bool isAccent;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: onClick,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(
            width: 1,
            color: isAccent
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          backgroundColor: isAccent
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          foregroundColor: isAccent
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: isAccent
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
                strokeWidth: 4,
              )
            : Text(
                textInfo,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
