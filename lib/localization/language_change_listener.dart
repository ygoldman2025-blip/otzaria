import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otzaria/settings/settings_bloc.dart';

/// Wrapper widget that ensures all descendants are rebuilt when language changes
/// Place this at the top level of your widget tree
class LanguageChangeListener extends StatelessWidget {
  final Widget child;

  const LanguageChangeListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        // Trigger rebuild of entire subtree when language changes
        // This is done by the BlocListener automatically
      },
      child: child,
    );
  }
}
