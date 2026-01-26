import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../widgets/nav_bar.dart';
import '../widgets/post_list_item.dart';

class TagPostsPage extends StatelessWidget {
  final String tag;

  const TagPostsPage({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final posts = appState.getPostsByTag(tag);

          if (appState.isLoading && posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tag,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${posts.length}篇)',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (posts.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('该标签下暂无文章')),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 832),
                        child: PostListItem(post: posts[index]),
                      ),
                    ),
                    childCount: posts.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
