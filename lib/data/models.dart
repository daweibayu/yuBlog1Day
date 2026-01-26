/// 文章数据模型
class Post {
  final String id;
  final String title;
  final String date;
  final List<String> tags;
  final String author;
  final String excerpt;
  final String cover;
  final bool pinned;
  final String path;

  const Post({
    required this.id,
    required this.title,
    required this.date,
    required this.tags,
    required this.author,
    required this.excerpt,
    required this.cover,
    required this.pinned,
    required this.path,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      author: json['author'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      pinned: json['pinned'] as bool? ?? false,
      path: json['path'] as String? ?? '',
    );
  }
}

/// posts.json 响应数据
class PostsResponse {
  final String generatedAt;
  final int pageSize;
  final List<Post> posts;
  final List<String> tags;

  const PostsResponse({
    required this.generatedAt,
    required this.pageSize,
    required this.posts,
    required this.tags,
  });

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    return PostsResponse(
      generatedAt: json['generatedAt'] as String? ?? '',
      pageSize: json['pageSize'] as int? ?? 10,
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
