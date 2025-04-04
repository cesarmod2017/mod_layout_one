import 'package:flutter/material.dart';

// Models
class TreeNode {
  final String id;
  final String label;
  final IconData icon;
  final bool isFolder;
  bool isExpanded;
  bool isSelected;
  final List<TreeNode> children;
  final dynamic data;

  TreeNode({
    required this.id,
    required this.label,
    required this.icon,
    this.isFolder = false,
    this.isExpanded = false,
    this.isSelected = false,
    this.children = const [],
    this.data,
  });

  TreeNode copyWith({
    String? id,
    String? label,
    IconData? icon,
    bool? isFolder,
    bool? isExpanded,
    bool? isSelected,
    List<TreeNode>? children,
    dynamic data,
  }) {
    return TreeNode(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      isFolder: isFolder ?? this.isFolder,
      isExpanded: isExpanded ?? this.isExpanded,
      isSelected: isSelected ?? this.isSelected,
      children: children ?? this.children,
      data: data ?? this.data,
    );
  }
}

// Theme configuration
class TreeViewTheme {
  final double indentation;
  final double iconSize;
  final Color selectionColor;
  final ExpanderType expanderType;
  final bool showLines;
  final Color? lineColor;
  final Color? textColor;
  final Color? iconColor;

  const TreeViewTheme({
    this.indentation = 20.0,
    this.iconSize = 16.0,
    this.selectionColor = const Color(0x1A2196F3), // Light blue with 10% opacity
    this.expanderType = ExpanderType.triangle,
    this.showLines = true,
    this.lineColor,
    this.textColor,
    this.iconColor,
  });
}

enum ExpanderType {
  triangle,
  arrow,
  plusMinus,
}

// Main TreeView Widget
class ModTreeView extends StatefulWidget {
  final List<TreeNode> nodes;
  final TreeViewTheme theme;
  final bool enableDragDrop;
  final bool showIcons;
  final Function(TreeNode)? onNodeSelected;
  final Function(TreeNode)? onNodeExpanded;
  final Function(TreeNode)? onNodeCollapsed;
  final Function(TreeNode, TreeNode)? onNodeDropped;
  final Function(TreeNode)? onNodeRightClick;
  final int Function(TreeNode, TreeNode)? sortComparator;

  const ModTreeView({
    super.key,
    required this.nodes,
    this.theme = const TreeViewTheme(),
    this.enableDragDrop = true,
    this.showIcons = true,
    this.onNodeSelected,
    this.onNodeExpanded,
    this.onNodeCollapsed,
    this.onNodeDropped,
    this.onNodeRightClick,
    this.sortComparator,
  });

  @override
  State<ModTreeView> createState() => _ModTreeViewState();
}

class _ModTreeViewState extends State<ModTreeView> {
  String? _selectedNodeId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.nodes.length,
      itemBuilder: (context, index) {
        return _buildTreeNode(widget.nodes[index], 0);
      },
    );
  }

  Widget _buildTreeNode(TreeNode node, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDraggableItem(node, level),
        if (node.isExpanded && node.children.isNotEmpty)
          ...node.children.map((child) => _buildTreeNode(child, level + 1)),
      ],
    );
  }

  Widget _buildDraggableItem(TreeNode node, int level) {
    if (!widget.enableDragDrop) {
      return _buildNodeContent(node, level);
    }

    return LongPressDraggable<TreeNode>(
      data: node,
      feedback: Material(
        elevation: 4.0,
        child: _buildNodeContent(node, level, isPreview: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildNodeContent(node, level),
      ),
      child: node.isFolder
          ? _buildDropTarget(node, level)
          : _buildNodeContent(node, level),
    );
  }

  Widget _buildDropTarget(TreeNode folder, int level) {
    return DragTarget<TreeNode>(
      onWillAccept: (draggedNode) {
        if (draggedNode == null) return false;
        return _canAcceptDrop(draggedNode, folder);
      },
      onAccept: (draggedNode) {
        widget.onNodeDropped?.call(draggedNode, folder);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty
                ? widget.theme.selectionColor
                : Colors.transparent,
          ),
          child: _buildNodeContent(folder, level),
        );
      },
    );
  }

  Widget _buildNodeContent(TreeNode node, int level, {bool isPreview = false}) {
    // Check if this node is selected
    final isSelected = node.id == _selectedNodeId;
    
    return GestureDetector(
      onTap: () => _handleNodeTap(node),
      onSecondaryTap: () => widget.onNodeRightClick?.call(node),
      child: Container(
        padding: EdgeInsets.only(left: widget.theme.indentation * level),
        height: 30, // Increased height for better touch target
        decoration: BoxDecoration(
          color: isSelected ? widget.theme.selectionColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            if (node.isFolder) _buildExpander(node),
            if (widget.showIcons)
              Icon(
                node.icon,
                size: widget.theme.iconSize,
                color: widget.theme.iconColor,
              ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                node.label,
                style: TextStyle(
                  color: widget.theme.textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpander(TreeNode node) {
    IconData icon;
    switch (widget.theme.expanderType) {
      case ExpanderType.triangle:
        icon = node.isExpanded ? Icons.arrow_drop_down : Icons.arrow_right;
        break;
      case ExpanderType.arrow:
        icon = node.isExpanded
            ? Icons.keyboard_arrow_down
            : Icons.keyboard_arrow_right;
        break;
      case ExpanderType.plusMinus:
        icon = node.isExpanded ? Icons.remove : Icons.add;
        break;
    }

    return IconButton(
      icon: Icon(icon, size: widget.theme.iconSize),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: widget.theme.iconSize,
        minHeight: widget.theme.iconSize,
      ),
      onPressed: () => _handleNodeExpand(node),
    );
  }

  void _handleNodeTap(TreeNode node) {
    setState(() {
      _selectedNodeId = node.id;
    });
    
    // If it's a folder, toggle expansion
    if (node.isFolder) {
      _handleNodeExpand(node);
    }
    
    // Call the selection callback
    widget.onNodeSelected?.call(node);
  }

  void _handleNodeExpand(TreeNode node) {
    if (!node.isFolder) return; // Only expand folders
    
    setState(() {
      node.isExpanded = !node.isExpanded;
    });
    
    if (node.isExpanded) {
      widget.onNodeExpanded?.call(node);
    } else {
      widget.onNodeCollapsed?.call(node);
    }
  }

  bool _canAcceptDrop(TreeNode source, TreeNode target) {
    if (!target.isFolder) return false;
    if (source == target) return false;
    return !_isAncestor(source, target);
  }

  bool _isAncestor(TreeNode potentialAncestor, TreeNode node) {
    if (node.children.isEmpty) return false;
    if (node.children.contains(potentialAncestor)) return true;
    return node.children.any((child) => _isAncestor(potentialAncestor, child));
  }
}
