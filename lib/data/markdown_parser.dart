/// Markdown 解析工具
class MarkdownParser {
  static const String defaultExcerptSeparator = '<!--more-->';

  /// 解析 Front Matter，返回 (frontMatter, body)
  static (Map<String, String>, String) parseFrontMatter(String content) {
    final frontMatter = <String, String>{};

    if (!content.trimLeft().startsWith('---')) {
      return (frontMatter, content);
    }

    final lines = content.split('\n');
    int frontMatterEnd = -1;
    bool foundFirst = false;

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim() == '---') {
        if (!foundFirst) {
          foundFirst = true;
        } else {
          frontMatterEnd = i;
          break;
        }
      } else if (foundFirst && lines[i].contains(':')) {
        final colonIndex = lines[i].indexOf(':');
        final key = lines[i].substring(0, colonIndex).trim();
        var value = lines[i].substring(colonIndex + 1).trim();
        // 移除引号
        if ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.substring(1, value.length - 1);
        }
        frontMatter[key] = value;
      }
    }

    if (frontMatterEnd > 0) {
      return (frontMatter, lines.sublist(frontMatterEnd + 1).join('\n').trim());
    }
    return (frontMatter, content);
  }

  /// 处理图片路径，将相对路径转为绝对 URL
  static String processImageUrls(String content, String baseUrl) {
    final imgRegex = RegExp(r'!\[([^\]]*)\]\((/[^)]+)\)');
    return content.replaceAllMapped(imgRegex, (match) {
      final alt = match.group(1) ?? '';
      final path = match.group(2) ?? '';
      return '![$alt]($baseUrl$path)';
    });
  }

  /// 处理 Markdown 内容
  static String process(String content, {String? imageBaseUrl}) {
    final (frontMatter, body) = parseFrontMatter(content);

    // 获取 excerpt_separator 并移除
    final separator = frontMatter['excerpt_separator'] ?? defaultExcerptSeparator;
    var result = body.replaceAll(separator, '');

    if (imageBaseUrl != null) {
      result = processImageUrls(result, imageBaseUrl);
    }
    return result.trim();
  }
}
