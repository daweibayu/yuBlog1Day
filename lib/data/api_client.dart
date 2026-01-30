import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

/// API 客户端
class ApiClient {
  static const String baseUrl = 'https://daweibayu.top';
  static const String articlesBase = '$baseUrl/articles';

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// 获取文章列表
  Future<PostsResponse> getPosts() async {
    final response = await _client.get(Uri.parse('$articlesBase/posts.json'));
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final json = jsonDecode(body) as Map<String, dynamic>;
      return PostsResponse.fromJson(json);
    }
    throw Exception('Failed to load posts: ${response.statusCode}');
  }

  /// 获取文章内容（Markdown）
  Future<String> getPostContent(String path) async {
    final response = await _client.get(Uri.parse('$articlesBase/$path'));
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception('Failed to load post content: ${response.statusCode}');
  }

  /// 获取页面内容（如 about.md）
  Future<String> getPageContent(String path) async {
    final response = await _client.get(Uri.parse('$articlesBase/$path'));
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception('Failed to load page content: ${response.statusCode}');
  }

  /// 获取图片 URL
  static String getImageUrl(String relativePath) {
    if (relativePath.startsWith('/')) {
      return '$articlesBase$relativePath';
    }
    return '$articlesBase/$relativePath';
  }

  void dispose() {
    _client.close();
  }
}
