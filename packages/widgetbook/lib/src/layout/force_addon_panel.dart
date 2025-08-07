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
  @override
  void initState() {
    super.initState();
    widget.state.forceSidePanel = true;
  }

  @override
  void dispose() {
    super.dispose();
    widget.state.forceSidePanel = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.state.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
