import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Sample Detail Page for testing navigation and page structure
class SampleDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const SampleDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareContent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Page Information',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(content),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Sample Features Section
            Text(
              'Sample Features',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            
            // Feature Cards
            _buildFeatureCard(
              context,
              'Navigation Test',
              'This page demonstrates Flutter navigation using GetX',
              Icons.navigation,
              Colors.blue,
            ),
            
            _buildFeatureCard(
              context,
              'State Management',
              'GetX reactive state management is working correctly',
              Icons.settings,
              Colors.green,
            ),
            
            _buildFeatureCard(
              context,
              'UI Components',
              'Custom widgets and Material Design components',
              Icons.widgets,
              Colors.orange,
            ),
            
            _buildFeatureCard(
              context,
              'Responsive Design',
              'Layout adapts to different screen sizes',
              Icons.phone_android,
              Colors.purple,
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showSuccessMessage,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Test Success'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showInfoDialog,
                    icon: const Icon(Icons.info),
                    label: const Text('Show Info'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      ),
    );
  }

  void _shareContent() {
    Get.snackbar(
      'Share',
      'Content sharing functionality would be implemented here',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: const Icon(Icons.share, color: Colors.white),
    );
  }

  void _showSuccessMessage() {
    Get.snackbar(
      'Success!',
      'All sample features are working correctly',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showInfoDialog() {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('Sample App Info'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This is a sample Flutter application created for testing GitHub Actions workflows.'),
            SizedBox(height: 12),
            Text('Features included:'),
            SizedBox(height: 8),
            Text('• GetX State Management'),
            Text('• Navigation'),
            Text('• Custom Widgets'),
            Text('• Material Design'),
            Text('• Responsive Layout'),
            Text('• Local Storage'),
            Text('• Network Requests'),
            Text('• Permissions'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showSuccessMessage();
            },
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}
