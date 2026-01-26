import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    
    return AppBar(
      title: InkWell(
        onTap: () => context.go('/'),
        child: const Text('yuBlog'),
      ),
      actions: [
        _NavItem(
          label: 'Posts',
          path: '/',
          isActive: currentPath == '/',
        ),
        _NavItem(
          label: 'Tags',
          path: '/tags',
          isActive: currentPath == '/tags' || currentPath.startsWith('/tag/'),
        ),
        _NavItem(
          label: 'About',
          path: '/about',
          isActive: currentPath == '/about',
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final String path;
  final bool isActive;

  const _NavItem({
    required this.label,
    required this.path,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(path),
      child: Text(
        label,
        style: TextStyle(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
