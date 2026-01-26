import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../widgets/nav_bar.dart';

class PostPage extends StatefulWidget {
  final String id;

  const PostPage({super.key, required this.id});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String? _content;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final appState = context.read<AppState>();
    
    // 确保文章列表已加载
    if (appState.posts.isEmpty) {
      await appState.loadPosts();
    }

    final post = appState.getPostById(widget.id);
    if (post == null) {
      setState(() {
        _error = '文章不存在';
        _isLoading = false;
      });
      return;
    }

    try {
      final content = await appState.getPostContent(post.path);
      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final post = appState.getPostById(widget.id);
          final adjacent = appState.getAdjacentPosts(widget.id);

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('返回首页'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 文章头部
                    if (post != null) _buildHeader(context, post),
                    const Divider(height: 32),
                    // Markdown 内容
                    if (_content != null)
                      MarkdownBlock(data: _content!),
                    const Divider(height: 32),
                    // 上一篇/下一篇
                    _buildNavigation(context, adjacent),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Post post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title.isNotEmpty ? post.title : post.id,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            if (post.date.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(post.date),
                ],
              ),
            if (post.author.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Text(post.author),
                ],
              ),
          ],
        ),
        if (post.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: post.tags.map((tag) {
              return ActionChip(
                label: Text(tag),
                onPressed: () => context.go('/tag/$tag'),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildNavigation(
    BuildContext context,
    ({Post? prev, Post? next}) adjacent,
  ) {
    return Row(
      children: [
        if (adjacent.prev != null)
          Expanded(
            child: _NavButton(
              label: '上一篇',
              title: adjacent.prev!.title.isNotEmpty
                  ? adjacent.prev!.title
                  : adjacent.prev!.id,
              onTap: () => context.go('/post/${adjacent.prev!.id}'),
              alignment: CrossAxisAlignment.start,
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 16),
        if (adjacent.next != null)
          Expanded(
            child: _NavButton(
              label: '下一篇',
              title: adjacent.next!.title.isNotEmpty
                  ? adjacent.next!.title
                  : adjacent.next!.id,
              onTap: () => context.go('/post/${adjacent.next!.id}'),
              alignment: CrossAxisAlignment.end,
            ),
          )
        else
          const Spacer(),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String title;
  final VoidCallback onTap;
  final CrossAxisAlignment alignment;

  const _NavButton({
    required this.label,
    required this.title,
    required this.onTap,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
