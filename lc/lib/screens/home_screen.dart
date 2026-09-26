import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import '../theme/app_colors.dart';
import '../widgets/hero_banner.dart';
import '../widgets/popular_movie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final popular = [...movies]..sort((a, b) => b.rating.compareTo(a.rating));
    final popularTop = popular.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 16,
        title: const Text(
          'MovieLog',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 28 / 22,
            letterSpacing: -0.55,
            color: AppColors.violetNumber,
          ),
        ),
        actions: [
          IconButton(
            tooltip: '검색',
            icon: const Icon(Icons.search, size: 22),
            color: AppColors.violetNumber,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '오늘은 어떤\n영화를 볼까요?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  height: 36 / 28,
                  letterSpacing: -0.7,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: HeroBanner(movie: movies.first),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '인기 영화',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 28 / 22,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.go('/movies'),
                    child: const Row(
                      children: [
                        Text(
                          '전체보기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 24 / 16,
                            color: AppColors.violetNumber,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: AppColors.violetNumber,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 264,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: popularTop.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) => index == popularTop.length
                    ? const UpcomingMovieCard()
                    : PopularMovieCard(
                        movie: popularTop[index],
                        rank: index + 1,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
