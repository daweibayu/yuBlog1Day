import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../widgets/nav_bar.dart';
import '../widgets/post_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      if (appState.posts.isEmpty) {
        appState.loadPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading && appState.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (appState.error != null && appState.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text('加载失败: ${appState.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => appState.loadPosts(forceRefresh: true),
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          if (appState.posts.isEmpty) {
            return const Center(
              child: Text('暂无文章'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => appState.loadPosts(forceRefresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: appState.posts.length,
              itemBuilder: (context, index) {
                return PostListItem(post: appState.posts[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
