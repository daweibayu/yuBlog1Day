import '../data/api_client.dart';
import '../data/models.dart';
import '../data/markdown_parser.dart';

/// 文章仓库
class ArticlesRepository {
  final ApiClient _apiClient;
  
  PostsResponse? _cachedPosts;

  ArticlesRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// 获取文章列表
  Future<PostsResponse> getPosts({bool forceRefresh = false}) async {
    if (_cachedPosts != null && !forceRefresh) {
      return _cachedPosts!;
    }
    _cachedPosts = await _apiClient.getPosts();
    return _cachedPosts!;
  }

  /// 根据 ID 获取文章元数据
  Future<Post?> getPostById(String id) async {
    final posts = await getPosts();
    try {
      return posts.posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 获取文章内容（已处理的 Markdown）
  Future<String> getPostContent(String path) async {
    final raw = await _apiClient.getPostContent(path);
    return MarkdownParser.process(
      raw,
      imageBaseUrl: ApiClient.articlesBase,
    );
  }

  /// 获取页面内容（如 about.md）
  Future<String> getPageContent(String path) async {
    final raw = await _apiClient.getPageContent(path);
    return MarkdownParser.process(
      raw,
      imageBaseUrl: ApiClient.articlesBase,
    );
  }

  /// 获取所有标签
  Future<List<String>> getAllTags() async {
    final posts = await getPosts();
    return posts.tags;
  }

  /// 根据标签筛选文章
  Future<List<Post>> getPostsByTag(String tag) async {
    final posts = await getPosts();
    return posts.posts.where((p) => p.tags.contains(tag)).toList();
  }

  /// 获取上一篇/下一篇文章
  Future<({Post? prev, Post? next})> getAdjacentPosts(String currentId) async {
    final posts = await getPosts();
    final index = posts.posts.indexWhere((p) => p.id == currentId);
    if (index == -1) {
      return (prev: null, next: null);
    }
    return (
      prev: index > 0 ? posts.posts[index - 1] : null,
      next: index < posts.posts.length - 1 ? posts.posts[index + 1] : null,
    );
  }

  void dispose() {
    _apiClient.dispose();
  }
}
