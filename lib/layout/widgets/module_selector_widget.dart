import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/controllers/layout_controller.dart';
import 'package:mod_layout_one/layout/models/module_model.dart';

class ModuleSelector extends StatelessWidget {
  final List<ModuleMenu> modules;
  final Function(ModuleMenu) onModuleSelected;

  const ModuleSelector({
    super.key,
    required this.modules,
    required this.onModuleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController controller = Get.find();

    return Obx(() {
      final currentModule = controller.selectedModule.value;
      final isExpanded = controller.isMenuExpanded.value;

      if (!isExpanded) {
        return Container(
          width: 70,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: IconButton(
            icon: Icon(
              currentModule?.icon ?? Icons.apps,
              size: currentModule?.iconSize,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => _showModulePopup(context),
            tooltip: 'Selecionar Módulo'.tr,
          ),
        );
      }

      return InkWell(
        onTap: () => _showModulePopup(context),
        child: Container(
          width: isExpanded ? double.infinity : 240,
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              if (currentModule?.image != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: currentModule!.image!,
                )
              else
                Icon(
                  currentModule?.icon ?? Icons.apps,
                  size: currentModule?.iconSize ?? 24,
                  color: Theme.of(context).iconTheme.color,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentModule?.name ?? 'Selecione um módulo',
                      style: TextStyle(
                        fontWeight:
                            currentModule?.fontWeight ?? FontWeight.bold,
                        fontSize: currentModule?.fontSize,
                      ),
                    ),
                    if (currentModule?.description != null)
                      Text(
                        currentModule!.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    });
  }

  void _showModulePopup(BuildContext context) {
    // No menu contraído, exibir um popup ao lado do ícone
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<void>(
          enabled: false,
          height: 30,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Módulos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        ...modules.map((module) {
          return PopupMenuItem<void>(
            child: Row(
              children: [
                if (module.image != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(width: 24, height: 24, child: module.image),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      module.icon ?? Icons.apps,
                      size: module.iconSize,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        module.name,
                        style: TextStyle(
                          fontSize: module.fontSize,
                          fontWeight: module.fontWeight,
                        ),
                      ),
                      if (module.description != null)
                        Text(
                          module.description!,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              onModuleSelected(module);
            },
          );
        }),
      ],
    );
  }
}
