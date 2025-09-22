import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../sample_models/sample_item.dart';
import '../sample_controllers/sample_controller.dart';

/// Sample List View Widget for testing list rendering and interactions
class SampleListView extends StatelessWidget {
  final List<SampleItem> items;
  final bool showActions;

  const SampleListView({
    super.key,
    required this.items,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SampleEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return SampleListTile(
          item: item,
          showActions: showActions,
        );
      },
    );
  }
}

/// Individual list tile for sample items
class SampleListTile extends StatelessWidget {
  final SampleItem item;
  final bool showActions;

  const SampleListTile({
    super.key,
    required this.item,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<SampleController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(),
          child: Text(
            item.category.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted 
                ? theme.textTheme.bodySmall?.color 
                : theme.textTheme.titleMedium?.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(),
                const SizedBox(width: 8),
                _buildPriorityChip(),
                if (item.isOverdue) ...[
                  const SizedBox(width: 8),
                  _buildOverdueChip(),
                ],
              ],
            ),
          ],
        ),
        trailing: showActions ? _buildActions(controller) : null,
        onTap: () => _showItemDetails(context),
      ),
    );
  }

  Color _getCategoryColor() {
    final colorString = item.categoryColor.replaceAll('#', '');
    return Color(int.parse('FF$colorString', radix: 16));
  }

  Widget _buildStatusChip() {
    return Chip(
      label: Text(
        item.statusText,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor:
          item.isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
      side: BorderSide(
        color: item.isCompleted ? Colors.green : Colors.orange,
        width: 1,
      ),
    );
  }

  Widget _buildPriorityChip() {
    MaterialColor chipColor;
    switch (item.priorityLevel) {
      case 5:
        chipColor = Colors.red;
        break;
      case 4:
        chipColor = Colors.orange;
        break;
      case 3:
        chipColor = Colors.yellow;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        item.priorityText,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: chipColor.shade100,
      side: BorderSide(color: chipColor, width: 1),
    );
  }

  Widget _buildOverdueChip() {
    return const Chip(
      label: Text(
        'Overdue',
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
  }

  Widget _buildActions(SampleController controller) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleAction(value, controller),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(item.isCompleted ? Icons.undo : Icons.check),
              const SizedBox(width: 8),
              Text(item.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'details',
          child: Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: 8),
              Text('View Details'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAction(String action, SampleController controller) {
    switch (action) {
      case 'toggle':
        controller.toggleItemCompletion(item.id);
        break;
      case 'details':
        _showItemDetails(Get.context!);
        break;
      case 'delete':
        _showDeleteConfirmation(controller);
        break;
    }
  }

  void _showItemDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${item.description}'),
            const SizedBox(height: 8),
            Text('Category: ${item.category}'),
            const SizedBox(height: 8),
            Text('Status: ${item.statusText}'),
            const SizedBox(height: 8),
            Text('Priority: ${item.priorityText}'),
            const SizedBox(height: 8),
            Text('Created: ${_formatDate(item.createdAt)}'),
            if (item.updatedAt != null) ...[
              const SizedBox(height: 8),
              Text('Updated: ${_formatDate(item.updatedAt!)}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(SampleController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeSampleItem(item.id);
              Get.back();
              Get.snackbar(
                'Deleted',
                'Item "${item.title}" has been deleted',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Empty state widget when no items are available
class SampleEmptyState extends StatelessWidget {
  const SampleEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(height: 16),
          Text(
            'No Items Found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some sample items to see them here',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
