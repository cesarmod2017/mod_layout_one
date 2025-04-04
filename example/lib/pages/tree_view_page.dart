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
        icon: _getFileIcon(name),
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
          return a.path.split(Platform.pathSeparator).last
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
        icon: Icons.folder,
        isFolder: true,
        isExpanded: false, // Pastas começam fechadas por padrão
        children: children,
      );
      
    } catch (e) {
      log('Erro ao ler diretório ${dir.path}: $e');
      return TreeNode(
        id: entity.path,
        label: name,
        icon: Icons.folder,
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
            child: Row(
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
          ),
          Expanded(
            child: ModTreeView(
              nodes: nodes,
              theme: TreeViewTheme(
                indentation: 24.0,
                iconSize: 20.0,
                selectionColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                expanderType: ExpanderType.triangle,
                showLines: true,
                lineColor: Theme.of(context).dividerColor,
                textColor: Theme.of(context).textTheme.bodyMedium?.color,
                iconColor: Theme.of(context).iconTheme.color,
              ),
              onNodeSelected: (node) {
                setState(() {
                  selectedNodeId = node.id;
                });
                log('Selected: ${node.label}');
              },
              onNodeExpanded: (node) {
                setState(() {
                  node.isExpanded = true;
                });
                log('Expanded: ${node.label}');
              },
              onNodeCollapsed: (node) {
                setState(() {
                  node.isExpanded = false;
                });
                log('Collapsed: ${node.label}');
              },
              onNodeDropped: (source, target) {
                log('Dropped ${source.label} into ${target.label}');
                // Implement your file system move operation here
              },
              onNodeRightClick: (node) {
                log('Right clicked: ${node.label}');
                // Implement context menu here
              },
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
