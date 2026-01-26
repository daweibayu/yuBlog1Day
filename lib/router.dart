import 'package:go_router/go_router.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/post_page.dart';
import 'ui/pages/tags_page.dart';
import 'ui/pages/tag_posts_page.dart';
import 'ui/pages/about_page.dart';
import 'ui/pages/not_found_page.dart';

final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PostPage(id: id);
      },
    ),
    GoRoute(
      path: '/tags',
      builder: (context, state) => const TagsPage(),
    ),
    GoRoute(
      path: '/tag/:name',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? '';
        return TagPostsPage(tag: name);
      },
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
  ],
);
