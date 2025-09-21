import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sample_widgets/sample_card.dart';
import 'sample_widgets/sample_list_view.dart';
import 'sample_controllers/sample_controller.dart';

/// Sample Home Page for testing GitHub Actions workflow
/// This demonstrates various Flutter features and widgets
class SampleHomePage extends StatelessWidget {
  const SampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SampleController controller = Get.put(SampleController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App - GitHub Actions Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            const SampleCard(
              title: 'Welcome to Sample App',
              subtitle: 'Testing GitHub Actions Workflow',
              icon: Icons.rocket_launch,
            ),
            
            const SizedBox(height: 16),
            
            // Counter Section
            Obx(() => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Counter: ${controller.counter.value}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.increment,
                          icon: const Icon(Icons.add),
                          label: const Text('Increment'),
                        ),
                        ElevatedButton.icon(
                          onPressed: controller.decrement,
                          icon: const Icon(Icons.remove),
                          label: const Text('Decrement'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
            
            const SizedBox(height: 16),
            
            // Data List Section
            Text(
              'Sample Data List',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Obx(() => SampleListView(items: controller.sampleItems)),
            
            const SizedBox(height: 16),
            
            // Feature Test Buttons
            Text(
              'Feature Tests',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.testNetworking,
                  icon: const Icon(Icons.cloud),
                  label: const Text('Test Network'),
                ),
                ElevatedButton.icon(
                  onPressed: controller.testLocalStorage,
                  icon: const Icon(Icons.storage),
                  label: const Text('Test Storage'),
                ),
                ElevatedButton.icon(
                  onPressed: controller.testNavigation,
                  icon: const Icon(Icons.navigation),
                  label: const Text('Test Navigation'),
                ),
                ElevatedButton.icon(
                  onPressed: controller.testPermissions,
                  icon: const Icon(Icons.security),
                  label: const Text('Test Permissions'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.showSampleDialog,
        tooltip: 'Show Sample Dialog',
        child: const Icon(Icons.message),
      ),
    );
  }
}
