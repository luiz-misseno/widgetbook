import 'package:flutter/material.dart';

import '../../../../widgetbook.dart';
import 'component_tile.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.node,
    required this.selectedPath,
    required this.searchQuery,
    this.isExpanded = false,
  });

  final WidgetbookNode node;
  final String? selectedPath;
  final String? searchQuery;
  final bool isExpanded;

  bool get isSelected {
    final child = node.find(
      (child) => child.path == selectedPath,
    );

    return child != null;
  }

  bool get isVisible {
    final isNodeSearched = searchQuery != null &&
        node.name.toLowerCase().contains(searchQuery!.toLowerCase());

    if (isNodeSearched) return true;

    final child = node.find(
      (child) => child.name.toLowerCase().contains(searchQuery!.toLowerCase()),
      searchInParent: true,
    );

    return child != null;
  }

  bool get _isExpanded {
    if (isExpanded) return true;

    if (searchQuery == null || searchQuery!.isEmpty) return isSelected;

    return isSelected || isVisible;
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return ExpansionTile(
      key: UniqueKey(),
      title: RichText(
        text: TextSpan(
          children: _buildHighlightedText(node.name, searchQuery, context),
        ),
      ),
      initiallyExpanded: _isExpanded,
      childrenPadding: const EdgeInsets.only(left: 16),
      children: node.children!
          .map(
            (child) => child.isLeaf
                ? ComponentTile(
                    node: child,
                    isSelected: child.path == selectedPath,
                  )
                : CategoryTile(
                    node: child,
                    selectedPath: selectedPath,
                    searchQuery: searchQuery,
                  ),
          )
          .toList(),
    );
  }

  List<TextSpan> _buildHighlightedText(
    String text,
    String? query,
    BuildContext context,
  ) {
    if (query == null || query.isEmpty) {
      return [
        TextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ];
    }

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    var start = 0;
    var index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      );

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return spans;
  }
}
