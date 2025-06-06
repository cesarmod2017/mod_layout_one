import 'package:flutter/material.dart';

// Models
class TreeNode {
  final String id;
  final String label;
  final IconData iconData;
  final Color? iconColor;
  final bool isFolder;
  bool isExpanded;
  bool isSelected;
  final List<TreeNode> children;
  dynamic data;
  NodeStateMode stateMode;

  TreeNode({
    required this.id,
    required this.label,
    required this.iconData,
    this.iconColor,
    this.isFolder = false,
    this.isExpanded = false,
    this.isSelected = false,
    this.children = const [],
    this.data,
    this.stateMode = NodeStateMode.synced,
  });

  TreeNode copyWith({
    String? id,
    String? label,
    IconData? iconData,
    Color? iconColor,
    bool? isFolder,
    bool? isExpanded,
    bool? isSelected,
    List<TreeNode>? children,
    dynamic data,
    NodeStateMode? stateMode,
  }) {
    return TreeNode(
      id: id ?? this.id,
      label: label ?? this.label,
      iconData: iconData ?? this.iconData,
      iconColor: iconColor ?? this.iconColor,
      isFolder: isFolder ?? this.isFolder,
      isExpanded: isExpanded ?? this.isExpanded,
      isSelected: isSelected ?? this.isSelected,
      children: children ?? this.children,
      data: data ?? this.data,
      stateMode: stateMode ?? this.stateMode,
    );
  }
}

enum NodeStateMode {
  synced, // No icon shown
  new_item, // Show newIcon
  update, // Show updateIcon
  sync, // Show syncIcon
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
    this.selectionColor =
        const Color(0x1A2196F3), // Light blue with 10% opacity
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

/// Represents a menu item in the context menu for TreeView
class TreeViewMenuItem {
  /// Unique identifier for the menu item
  final String id;

  /// Display text for the menu item
  final String label;

  /// Optional icon to display with the menu item
  final IconData? icon;

  /// Whether the menu item is enabled or disabled
  final bool enabled;

  /// Whether to show a divider after this menu item
  final bool dividerAfter;

  /// Creates a new TreeViewMenuItem
  const TreeViewMenuItem({
    required this.id,
    required this.label,
    this.icon,
    this.enabled = true,
    this.dividerAfter = false,
  });
}

// Main TreeView Widget
class ModTreeView extends StatefulWidget {
  final List<TreeNode> nodes;
  final TreeViewTheme theme;
  final bool enableDragDrop;
  final bool showIcons;
  final bool showCheckboxes;
  final Icon? newItemIcon;
  final Icon? updateIcon;
  final Icon? syncIcon;
  final Function(TreeNode)? onNodeSelected;
  final Function(TreeNode)? onNodeExpanded;
  final Function(TreeNode)? onNodeCollapsed;
  final Function(TreeNode, TreeNode)? onNodeDropped;
  final Function(TreeNode)? onNodeRightClick;
  final Function(TreeNode, bool)? onNodeCheckChanged;
  final int Function(TreeNode, TreeNode)? sortComparator;

  /// Callback to get context menu items for a node
  /// Return a list of TreeViewMenuItem to show in the context menu
  final List<TreeViewMenuItem> Function(TreeNode)? getContextMenuItems;

  /// Callback when a context menu item is selected
  final Function(TreeNode, String)? onContextMenuItemSelected;

  const ModTreeView({
    super.key,
    required this.nodes,
    this.theme = const TreeViewTheme(),
    this.enableDragDrop = true,
    this.showIcons = true,
    this.showCheckboxes = false,
    this.newItemIcon,
    this.updateIcon,
    this.syncIcon,
    this.onNodeSelected,
    this.onNodeExpanded,
    this.onNodeCollapsed,
    this.onNodeDropped,
    this.onNodeRightClick,
    this.onNodeCheckChanged,
    this.sortComparator,
    this.getContextMenuItems,
    this.onContextMenuItemSelected,
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

    return Draggable<TreeNode>(
      data: node,
      feedback: Material(
        elevation: 4.0,
        child: SizedBox(
          width: 200, // Fixed width for the dragged item
          child: _buildNodeContent(node, level, isPreview: true),
        ),
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
      onWillAcceptWithDetails: (details) {
        return _canAcceptDrop(details.data, folder);
      },
      onAcceptWithDetails: (details) {
        widget.onNodeDropped?.call(details.data, folder);
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
      onSecondaryTapDown: (details) {
        // Store the tap position for context menu
        _showContextMenu(context, node, details.globalPosition);
      },
      child: Container(
        padding: EdgeInsets.only(left: widget.theme.indentation * level),
        height: 30, // Increased height for better touch target
        decoration: BoxDecoration(
          color: isSelected ? widget.theme.selectionColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            // Add checkbox if enabled
            if (widget.showCheckboxes)
              Checkbox(
                value: node.isSelected,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      // Update the selection state
                      final updatedNode = node.copyWith(isSelected: value);
                      _updateNodeInTree(updatedNode);
                    });
                    // Call the callback
                    widget.onNodeCheckChanged?.call(node, value);
                  }
                },
              ),
            if (node.isFolder) _buildExpander(node),
            if (widget.showIcons)
              Icon(
                node.iconData,
                size: widget.theme.iconSize,
                color: node.iconColor ?? widget.theme.iconColor,
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
            // Add state indicator icons if applicable
            if (node.stateMode != NodeStateMode.synced) ...[
              const SizedBox(width: 4),
              _buildStateIcon(node.stateMode),
            ],
          ],
        ),
      ),
    );
  }

  // Build state indicator icon based on node state
  Widget _buildStateIcon(NodeStateMode stateMode) {
    switch (stateMode) {
      case NodeStateMode.new_item:
        return widget.newItemIcon ?? const SizedBox.shrink();
      case NodeStateMode.update:
        return widget.updateIcon ?? const SizedBox.shrink();
      case NodeStateMode.sync:
        return RotationTransition(
          turns: AlwaysStoppedAnimation(45 / 360),
          child: widget.syncIcon ?? const SizedBox.shrink(),
        );
      case NodeStateMode.synced:
      default:
        return const SizedBox.shrink();
    }
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
    // Não pode soltar um item em si mesmo
    if (source.id == target.id) return false;

    // Só pode soltar em pastas
    if (!target.isFolder) return false;

    // Verificar se o target é descendente do source (não pode soltar em seu próprio descendente)
    if (_isDescendant(source, target)) return false;

    // Permitir soltar em qualquer outra pasta
    return true;
  }

  // Verifica se 'descendant' é descendente de 'ancestor'
  bool _isDescendant(TreeNode ancestor, TreeNode descendant) {
    // Se o nó ancestral não tem filhos, não pode ter descendentes
    if (ancestor.children.isEmpty) return false;

    // Verifica se o descendant é filho direto do ancestor
    for (final child in ancestor.children) {
      // Se encontrou o nó como filho direto
      if (child.id == descendant.id) return true;

      // Verifica recursivamente nos filhos
      if (_isDescendant(child, descendant)) return true;
    }

    return false;
  }

  /// Shows the context menu for a node
  void _showContextMenu(BuildContext context, TreeNode node,
      [Offset? tapPosition]) {
    // Call the onNodeRightClick callback first
    widget.onNodeRightClick?.call(node);

    // If no context menu items provider is set, don't show menu
    if (widget.getContextMenuItems == null) return;

    // Get the menu items for this node
    final items = widget.getContextMenuItems!(node);
    if (items.isEmpty) return;

    // Select the node when right-clicking
    setState(() {
      _selectedNodeId = node.id;
    });

    // Calculate position for the popup menu
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // Use the tap position if provided, otherwise calculate from the widget
    RelativeRect position;
    if (tapPosition != null) {
      // Use the exact tap position
      position = RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        overlay.size.width - tapPosition.dx,
        overlay.size.height - tapPosition.dy,
      );
    } else {
      // Fallback to widget position
      final RenderBox button = context.findRenderObject() as RenderBox;
      final Offset widgetPosition =
          button.localToGlobal(Offset.zero, ancestor: overlay);
      position = RelativeRect.fromLTRB(
        widgetPosition.dx,
        widgetPosition.dy,
        overlay.size.width - widgetPosition.dx - button.size.width,
        overlay.size.height - widgetPosition.dy - button.size.height,
      );
    }

    // Show the popup menu at the tap position
    showMenu<String>(
      context: context,
      position: position,
      items: _buildPopupMenuItems(items),
    ).then((String? itemId) {
      if (itemId != null && widget.onContextMenuItemSelected != null) {
        widget.onContextMenuItemSelected!(node, itemId);
      }
    });
  }

  /// Builds the popup menu items from TreeViewMenuItem list
  List<PopupMenuEntry<String>> _buildPopupMenuItems(
      List<TreeViewMenuItem> items) {
    final List<PopupMenuEntry<String>> menuItems = [];

    for (final item in items) {
      menuItems.add(
        PopupMenuItem<String>(
          value: item.id,
          enabled: item.enabled,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(item.label),
            ],
          ),
        ),
      );

      if (item.dividerAfter) {
        menuItems.add(const PopupMenuDivider());
      }
    }

    return menuItems;
  }

  // Helper method to update a node in the tree
  void _updateNodeInTree(TreeNode updatedNode) {
    // Function to recursively update nodes in the tree
    List<TreeNode> updateNodes(List<TreeNode> nodes) {
      return nodes.map((node) {
        if (node.id == updatedNode.id) {
          return updatedNode;
        } else if (node.children.isNotEmpty) {
          return node.copyWith(children: updateNodes(node.children));
        }
        return node;
      }).toList();
    }

    // Update the widget's nodes list
    final updatedNodes = updateNodes(widget.nodes);

    // If this is a stateful widget that manages its own nodes list
    // You would update the state here
  }
}
