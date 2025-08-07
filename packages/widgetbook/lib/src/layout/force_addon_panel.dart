import 'package:flutter/widgets.dart';

import '../../widgetbook.dart';

class ForceAddonPanel extends StatefulWidget {
  const ForceAddonPanel({
    super.key,
    required this.child,
    required this.state,
  });

  final Widget child;
  final WidgetbookState state;

  @override
  State<ForceAddonPanel> createState() => _ForceAddonPanelState();
}

class _ForceAddonPanelState extends State<ForceAddonPanel> {
  String? _pagePath;

  @override
  void initState() {
    super.initState();
    widget.state.forceSidePanel = true;
    _pagePath = widget.state.uri.queryParameters['path'];
  }

  @override
  void dispose() {
    final pagePath = _pagePath;
    if (pagePath != null && pagePath != widget.state.uri.queryParameters['path']) {
      widget.state.forceSidePanel = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.state.notifyListeners();
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}