import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  List<TreeNode> nodes = [];
  String? selectedNodeId;
  bool isLoading = true;
  String? lastAction;

  @override
  void initState() {
    super.initState();
    _loadDirectoryStructure();
  }

  /// Carrega a estrutura completa do diretório
  Future<void> _loadDirectoryStructure() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Usando um caminho mais provável de existir no ambiente do usuário
      final directory = Directory('.');
      if (!await directory.exists()) {
        throw Exception('Diretório não encontrado: ${directory.path}');
      }

      // Carrega a estrutura completa
      final rootNode = await _createNodeFromDirectory(directory);

      // Não expandimos mais as pastas por padrão
      // As pastas começam fechadas e o usuário deve clicar para expandir

      setState(() {
        nodes = [rootNode];
        isLoading = false;
      });
    } catch (e) {
      log('Erro ao carregar diretório: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Expande todas as pastas na estrutura de diretórios
  void _expandAllFolders(TreeNode node) {
    if (node.isFolder) {
      node.isExpanded = true;
      for (var child in node.children) {
        _expandAllFolders(child);
      }
    }
  }

  /// Cria um nó a partir de um diretório
  Future<TreeNode> _createNodeFromDirectory(FileSystemEntity entity) async {
    final stat = await entity.stat();
    final name = entity.path.split(Platform.pathSeparator).last;
    final isDirectory = entity is Directory;

    if (!isDirectory) {
      // Arquivo
      return TreeNode(
        id: entity.path,
        label: name,
        iconData: _getFileIcon(name),
        iconColor: _getFileIconColor(name),
        isFolder: false,
      );
    }

    // Diretório
    final dir = Directory(entity.path);
    final List<FileSystemEntity> entities = [];

    try {
      await for (final child in dir.list(followLinks: false)) {
        entities.add(child);
      }

      // Ordena: primeiro diretórios, depois arquivos
      entities.sort((a, b) {
        final aIsDir = a is Directory;
        final bIsDir = b is Directory;

        // Se ambos são diretórios ou ambos são arquivos, ordena por nome
        if (aIsDir == bIsDir) {
          return a.path
              .split(Platform.pathSeparator)
              .last
              .compareTo(b.path.split(Platform.pathSeparator).last);
        }

        // Diretórios vêm primeiro
        return aIsDir ? -1 : 1;
      });

      // Processa os itens ordenados
      final List<TreeNode> children = [];
      for (final child in entities) {
        final childNode = await _createNodeFromDirectory(child);
        children.add(childNode);
      }

      return TreeNode(
        id: entity.path,
        label: name,
        iconData: Icons.folder,
        iconColor: Colors.amber,
        isFolder: true,
        isExpanded: false, // Pastas começam fechadas por padrão
        children: children,
      );
    } catch (e) {
      log('Erro ao ler diretório ${dir.path}: $e');
      return TreeNode(
        id: entity.path,
        label: name,
        iconData: Icons.folder,
        iconColor: Colors.amber,
        isFolder: true,
        isExpanded: false,
        children: [],
      );
    }
  }

  /// Retorna o ícone apropriado para o tipo de arquivo
  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'dart':
        return Icons.code;
      case 'yaml':
      case 'yml':
        return Icons.settings;
      case 'md':
        return Icons.description;
      case 'json':
        return Icons.data_object;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Retorna a cor do ícone para o tipo de arquivo
  Color? _getFileIconColor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'dart':
        return Colors.blue;
      case 'yaml':
      case 'yml':
        return Colors.purple;
      case 'md':
        return Colors.green;
      case 'json':
        return Colors.orange;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  /// Retorna os itens de menu de contexto para um nó
  List<TreeViewMenuItem> _getContextMenuItems(TreeNode node) {
    final List<TreeViewMenuItem> items = [];

    // Itens comuns para arquivos e pastas
    items.add(
      TreeViewMenuItem(
        id: 'info',
        label: 'Informações',
        icon: Icons.info_outline,
      ),
    );

    // Itens específicos para pastas
    if (node.isFolder) {
      items.add(
        TreeViewMenuItem(
          id: 'expand',
          label: node.isExpanded ? 'Recolher' : 'Expandir',
          icon: node.isExpanded ? Icons.unfold_less : Icons.unfold_more,
        ),
      );

      items.add(
        TreeViewMenuItem(
          id: 'add_file',
          label: 'Novo Arquivo',
          icon: Icons.add_circle_outline,
          dividerAfter: true,
        ),
      );
    }

    // Itens para arquivos
    else {
      items.add(
        TreeViewMenuItem(
          id: 'open',
          label: 'Abrir',
          icon: Icons.open_in_new,
          dividerAfter: true,
        ),
      );
    }

    // Itens comuns no final
    items.add(
      TreeViewMenuItem(
        id: 'rename',
        label: 'Renomear',
        icon: Icons.edit,
      ),
    );

    items.add(
      TreeViewMenuItem(
        id: 'delete',
        label: 'Excluir',
        icon: Icons.delete_outline,
        enabled: true,
      ),
    );

    return items;
  }

  /// Manipula a seleção de um item do menu de contexto
  void _handleContextMenuItemSelected(TreeNode node, String itemId) {
    setState(() {
      lastAction = 'Menu: $itemId em ${node.label}';
    });

    switch (itemId) {
      case 'expand':
        setState(() {
          node.isExpanded = !node.isExpanded;
        });
        break;
      case 'info':
        _showNodeInfo(node);
        break;
      case 'delete':
        _showDeleteConfirmation(node);
        break;
      default:
        log('Ação do menu: $itemId para ${node.label}');
    }
  }

  /// Exibe informações sobre o nó
  void _showNodeInfo(TreeNode node) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(node.label),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${node.isFolder ? "Pasta" : "Arquivo"}'),
            Text('Caminho: ${node.id}'),
            if (node.isFolder) Text('Itens: ${node.children.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  /// Exibe confirmação de exclusão
  void _showDeleteConfirmation(TreeNode node) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir "${node.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              log('Simulando exclusão de ${node.label}');
              // Aqui você implementaria a exclusão real
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  /// Remove um nó da árvore
  void _removeNode(TreeNode source) {
    // Função recursiva para encontrar e remover o nó
    bool removeNodeRecursive(List<TreeNode> nodeList, TreeNode nodeToRemove) {
      // Verifica se o nó está na lista atual
      for (int i = 0; i < nodeList.length; i++) {
        if (nodeList[i].id == nodeToRemove.id) {
          // Encontrou o nó, remove-o
          nodeList.removeAt(i);
          return true; // Indica que o nó foi removido
        }

        // Se o nó atual for uma pasta, busca recursivamente nos filhos
        if (nodeList[i].isFolder && nodeList[i].children.isNotEmpty) {
          bool removed =
              removeNodeRecursive(nodeList[i].children, nodeToRemove);
          if (removed) {
            return true; // Propaga a informação de que o nó foi removido
          }
        }
      }

      return false; // Nó não encontrado nesta ramificação
    }

    // Inicia a busca recursiva a partir da raiz
    setState(() {
      removeNodeRecursive(nodes, source);
    });
  }

  /// Atualiza o estado de seleção de um nó e todos os seus filhos recursivamente
  void _updateNodeSelectionRecursively(TreeNode node, bool isSelected) {
    // Atualiza o estado do nó atual
    setState(() {
      node.isSelected = isSelected;

      // Se for uma pasta, atualiza todos os filhos recursivamente
      if (node.isFolder && node.children.isNotEmpty) {
        for (var child in node.children) {
          _updateNodeSelectionRecursively(child, isSelected);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('TreeView Example')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _expandAllFolders(nodes[0]);
                        });
                      },
                      child: const Text('Expandir Tudo'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _collapseAllFolders(nodes[0]);
                        });
                      },
                      child: const Text('Recolher Tudo'),
                    ),
                  ],
                ),
                if (lastAction != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Última ação: $lastAction',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 300,
              child: ModTreeView(
                nodes: nodes,
                showIcons: true,
                newItemIcon: Icon(Icons.circle, color: Colors.green, size: 18),
                updateIcon: Icon(Icons.circle, color: Colors.orange, size: 18),
                syncIcon: Icon(Icons.sync, color: Colors.blue, size: 18),
                showCheckboxes: true,
                onNodeCheckChanged: (p0, p1) {
                  log('onNodeCheckChanged: $p0, $p1');
                  _updateNodeSelectionRecursively(p0, p1);
                },
                theme: TreeViewTheme(
                  indentation: 24.0,
                  iconSize: 20.0,
                  selectionColor: Theme.of(context).highlightColor,
                  expanderType: ExpanderType.triangle,
                  showLines: true,
                  // lineColor: Theme.of(context).dividerColor,
                  // textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  // iconColor: Theme.of(context).iconTheme.color,
                  lineColor: Colors.red,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  iconColor: Colors.yellow,
                ),
                onNodeSelected: (node) {
                  setState(() {
                    node.stateMode = NodeStateMode.synced;
                    selectedNodeId = node.id;
                    lastAction = 'Selecionado: ${node.label}';
                  });
                  log('Selected: ${node.label}');
                },
                onNodeExpanded: (node) {
                  setState(() {
                    node.isExpanded = true;
                    lastAction = 'Expandido: ${node.label}';
                  });
                  log('Expanded: ${node.label}');
                },
                onNodeCollapsed: (node) {
                  setState(() {
                    node.isExpanded = false;
                    lastAction = 'Recolhido: ${node.label}';
                  });
                  log('Collapsed: ${node.label}');
                },
                onNodeDropped: (source, target) {
                  setState(() {
                    lastAction = 'Movido: ${source.label} para ${target.label}';
                  });
                  log('Dropped ${source.label} into ${target.label}');
                  if (target.isFolder) {
                    final newNode =
                        source.copyWith(id: '${target.id}\\${source.label}');

                    target.children.add(newNode);
                    target.children.sort((a, b) {
                      // Primeiro ordena por pasta (pastas primeiro)
                      if (a.isFolder && !b.isFolder) return -1;
                      if (!a.isFolder && b.isFolder) return 1;
                      // Depois ordena por label (ordem alfabética)
                      return a.label.compareTo(b.label);
                    });
                    _removeNode(source);
                  }
                },
                onNodeRightClick: (node) {
                  setState(() {
                    lastAction = 'Clique direito: ${node.label}';
                  });
                  log('Right clicked: ${node.label}');
                },
                getContextMenuItems: _getContextMenuItems,
                onContextMenuItemSelected: _handleContextMenuItemSelected,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ModCodeExample(
              code: '''// TreeView Básico
ModTreeView(
  nodes: nodes,
  showIcons: true,
  showCheckboxes: true,
  theme: TreeViewTheme(
    indentation: 24.0,
    iconSize: 20.0,
    selectionColor: Theme.of(context).highlightColor,
    expanderType: ExpanderType.triangle,
    showLines: true,
    lineColor: Colors.red,
    textColor: Theme.of(context).textTheme.bodyMedium?.color,
    iconColor: Colors.yellow,
  ),
  onNodeSelected: (node) {
    log('Selected: \${node.label}');
  },
  onNodeExpanded: (node) {
    log('Expanded: \${node.label}');
  },
  onNodeCollapsed: (node) {
    log('Collapsed: \${node.label}');
  },
  onNodeDropped: (source, target) {
    log('Dropped \${source.label} into \${target.label}');
  },
  onNodeCheckChanged: (node, isSelected) {
    log('Check changed: \${node.label}, \$isSelected');
  },
  getContextMenuItems: _getContextMenuItems,
  onContextMenuItemSelected: _handleContextMenuItemSelected,
),

// TreeNode
TreeNode(
  id: 'unique_id',
  label: 'File Name',
  iconData: Icons.folder,
  iconColor: Colors.amber,
  isFolder: true,
  isExpanded: false,
  children: [],
),''',
            ),
          ),
        ],
      ),
    );
  }

  /// Recolhe todas as pastas na estrutura de diretórios
  void _collapseAllFolders(TreeNode node) {
    if (node.isFolder) {
      node.isExpanded = false;
      for (var child in node.children) {
        _collapseAllFolders(child);
      }
    }
  }
}
