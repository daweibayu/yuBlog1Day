import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../widgets/nav_bar.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading && appState.tags.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (appState.tags.isEmpty) {
            return const Center(child: Text('暂无标签'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '所有标签',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: appState.tags.map((tag) {
                        final count = appState.getPostsByTag(tag).length;
                        return ActionChip(
                          label: Text('$tag ($count)'),
                          onPressed: () => context.go('/tag/$tag'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
