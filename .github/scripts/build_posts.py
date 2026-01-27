#!/usr/bin/env python3
"""
构建脚本：扫描 posts/*.md，解析 Front Matter，生成 posts.json
"""
import os
import re
import json
from datetime import datetime
from pathlib import Path

def parse_front_matter(content: str) -> tuple[dict, str]:
    """解析 Front Matter 和正文"""
    if not content.startswith('---'):
        return {}, content
    
    parts = content.split('---', 2)
    if len(parts) < 3:
        return {}, content
    
    front_matter = {}
    for line in parts[1].strip().split('\n'):
        if ':' in line:
            key, value = line.split(':', 1)
            key = key.strip()
            value = value.strip().strip('"').strip("'")
            # 处理 tags 字段
            if key == 'tags':
                if value.startswith('['):
                    # YAML 数组格式
                    value = [t.strip().strip('"').strip("'") for t in value[1:-1].split(',')]
                else:
                    # 单个标签
                    value = [value] if value else []
            # 处理 pinned 和 hidden 字段
            elif key in ('pinned', 'hidden'):
                value = value.lower() == 'true'
            front_matter[key] = value
    
    body = parts[2].strip()
    return front_matter, body

def extract_excerpt(body: str, separator: str = '<!--more-->', max_chars: int = 150) -> str:
    """提取摘要"""
    # 去除开头的 separator
    body = body.lstrip()
    if body.startswith(separator):
        body = body[len(separator):].lstrip()
    
    if separator in body:
        excerpt = body.split(separator)[0].strip()
    else:
        excerpt = body[:max_chars * 2]  # 取更多内容，后面会截断
    
    # 去除 Markdown 语法
    excerpt = re.sub(r'```[\s\S]*?```', '', excerpt)  # 代码块
    excerpt = re.sub(r'#+\s*', '', excerpt)  # 标题
    excerpt = re.sub(r'\*\*|__', '', excerpt)  # 粗体
    excerpt = re.sub(r'\*|_', '', excerpt)  # 斜体
    excerpt = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', excerpt)  # 链接
    excerpt = re.sub(r'`[^`]+`', '', excerpt)  # 行内代码
    excerpt = re.sub(r'!\[([^\]]*)\]\([^)]+\)', '', excerpt)  # 图片
    excerpt = re.sub(r'\n+', ' ', excerpt)  # 换行
    excerpt = re.sub(r'\s+', ' ', excerpt)  # 多空格
    excerpt = excerpt.strip()
    
    return excerpt[:max_chars] if len(excerpt) > max_chars else excerpt

def parse_date_from_filename(filename: str) -> str:
    """从文件名解析日期，格式：YYYY-MM-DD-xxx.md"""
    match = re.match(r'^(\d{4}-\d{2}-\d{2})', filename)
    return match.group(1) if match else ''

def build_posts_json(posts_dir: str, output_file: str, page_size: int = 10):
    """构建 posts.json"""
    posts = []
    all_tags = set()
    
    posts_path = Path(posts_dir)
    if not posts_path.exists():
        print(f"Warning: {posts_dir} does not exist")
        return
    
    for md_file in sorted(posts_path.glob('*.md'), reverse=True):
        content = md_file.read_text(encoding='utf-8')
        front_matter, body = parse_front_matter(content)
        
        # 跳过隐藏文章
        if front_matter.get('hidden', False):
            continue
        
        post_id = md_file.stem  # 文件名不含扩展名
        
        # 日期：优先使用 Front Matter，否则从文件名解析
        date = front_matter.get('date', '') or parse_date_from_filename(md_file.name)
        
        tags = front_matter.get('tags', [])
        if isinstance(tags, str):
            tags = [tags] if tags else []
        
        all_tags.update(tags)
        
        separator = front_matter.get('excerpt_separator', '<!--more-->')
        excerpt = extract_excerpt(body, separator)
        
        post = {
            'id': post_id,
            'title': front_matter.get('title', ''),
            'date': date,
            'tags': tags,
            'author': front_matter.get('author', ''),
            'excerpt': excerpt,
            'cover': front_matter.get('cover', ''),
            'pinned': front_matter.get('pinned', False),
            'path': f'posts/{md_file.name}'
        }
        posts.append(post)
    
    # 排序：置顶优先，然后按日期倒序（无日期排最后）
    def sort_key(p):
        pinned = 0 if p['pinned'] else 1
        date = p['date'] if p['date'] else '0000-00-00'
        return (pinned, date)
    
    posts.sort(key=sort_key, reverse=False)
    posts.sort(key=lambda p: (0 if p['pinned'] else 1, p['date'] or '0000-00-00'), reverse=True)
    
    # 重新排序：pinned=True 的在前，然后按日期倒序
    pinned_posts = [p for p in posts if p['pinned']]
    normal_posts = [p for p in posts if not p['pinned']]
    pinned_posts.sort(key=lambda p: p['date'] or '0000-00-00', reverse=True)
    normal_posts.sort(key=lambda p: p['date'] or '0000-00-00', reverse=True)
    posts = pinned_posts + normal_posts
    
    result = {
        'generatedAt': datetime.utcnow().isoformat() + 'Z',
        'pageSize': page_size,
        'posts': posts,
        'tags': sorted(list(all_tags))
    }
    
    output_path = Path(output_file)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f"Generated {output_file} with {len(posts)} posts and {len(all_tags)} tags")

if __name__ == '__main__':
    import sys
    posts_dir = sys.argv[1] if len(sys.argv) > 1 else 'posts'
    output_file = sys.argv[2] if len(sys.argv) > 2 else 'posts.json'
    build_posts_json(posts_dir, output_file)
