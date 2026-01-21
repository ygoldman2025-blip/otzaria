import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otzaria/settings/settings_bloc.dart';
import 'package:otzaria/settings/settings_state.dart';

/// Mixin that automatically listens to language changes and rebuilds the screen
/// Use this on any StatefulWidget screen that uses context.tr()
///
/// Example:
/// class MyScreen extends StatefulWidget {
///   @override
///   State<MyScreen> createState() => _MyScreenState();
/// }
///
/// class _MyScreenState extends State<MyScreen> with LocalizableScreenMixin {
///   @override
///   Widget buildScreen(BuildContext context, SettingsState settingsState) {
///     return Scaffold(
///       body: Text(context.tr('key')),
///     );
///   }
/// }
mixin LocalizableScreenMixin<T extends StatefulWidget> on State<T> {
  /// Override this method instead of build()
  /// It will automatically be called whenever language changes
  Widget buildScreen(BuildContext context, SettingsState settingsState);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) => buildScreen(context, settingsState),
    );
  }
}
