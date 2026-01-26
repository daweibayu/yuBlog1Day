/// Markdown 解析工具
class MarkdownParser {
  /// 移除 Front Matter
  static String removeFrontMatter(String content) {
    if (!content.trimLeft().startsWith('---')) {
      return content;
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
      }
    }
    
    if (frontMatterEnd > 0) {
      return lines.sublist(frontMatterEnd + 1).join('\n').trim();
    }
    return content;
  }

  /// 处理图片路径，将相对路径转为绝对 URL
  static String processImageUrls(String content, String baseUrl) {
    // 匹配 Markdown 图片语法：![alt](url)
    final imgRegex = RegExp(r'!\[([^\]]*)\]\((/[^)]+)\)');
    return content.replaceAllMapped(imgRegex, (match) {
      final alt = match.group(1) ?? '';
      final path = match.group(2) ?? '';
      return '![$alt]($baseUrl$path)';
    });
  }

  /// 移除 HTML 注释（如 <!--more-->、<!-- xxx --> 等）
  static String removeHtmlComments(String content) {
    return content.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '');
  }

  /// 处理 Markdown 内容
  static String process(String content, {String? imageBaseUrl}) {
    var result = removeFrontMatter(content);
    result = removeHtmlComments(result);
    if (imageBaseUrl != null) {
      result = processImageUrls(result, imageBaseUrl);
    }
    return result.trim();
  }
}
