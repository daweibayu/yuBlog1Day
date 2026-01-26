import 'package:flutter/foundation.dart';
import '../data/models.dart';
import '../repository/articles_repository.dart';

/// 应用状态
class AppState extends ChangeNotifier {
  final ArticlesRepository _repository;

  AppState({ArticlesRepository? repository})
      : _repository = repository ?? ArticlesRepository();

  // 文章列表状态
  List<Post> _posts = [];
  List<String> _tags = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  List<String> get tags => _tags;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 加载文章列表
  Future<void> loadPosts({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.getPosts(forceRefresh: forceRefresh);
      _posts = response.posts;
      _tags = response.tags;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 根据标签筛选文章
  List<Post> getPostsByTag(String tag) {
    return _posts.where((p) => p.tags.contains(tag)).toList();
  }

  /// 根据 ID 获取文章
  Post? getPostById(String id) {
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 获取上一篇/下一篇
  ({Post? prev, Post? next}) getAdjacentPosts(String currentId) {
    final index = _posts.indexWhere((p) => p.id == currentId);
    if (index == -1) {
      return (prev: null, next: null);
    }
    return (
      prev: index > 0 ? _posts[index - 1] : null,
      next: index < _posts.length - 1 ? _posts[index + 1] : null,
    );
  }

  /// 获取文章内容
  Future<String> getPostContent(String path) {
    return _repository.getPostContent(path);
  }

  /// 获取页面内容
  Future<String> getPageContent(String path) {
    return _repository.getPageContent(path);
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
