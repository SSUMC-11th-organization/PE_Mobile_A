import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/movie.dart';
import '../theme/app_colors.dart';
import '../widgets/rating_dialog.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final int? movieId;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  static const double _averageRating = 4.5;
  static const String _reviewCount = '(1,245)';

  bool _isFavorite = false;
  double _myRating = 0;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    _showMessage(_isFavorite ? '즐겨찾기에 추가했습니다.' : '즐겨찾기에서 삭제했습니다.');
  }

  Future<void> _openRatingDialog() async {
    final rating = await showDialog<double>(
      context: context,
      builder: (context) => RatingDialog(initialRating: _myRating),
    );
    if (rating == null || !mounted) return;

    setState(() => _myRating = rating);
    _showMessage('$rating점을 남겼습니다.');
  }

  @override
  Widget build(BuildContext context) {
    final movie = findMovieById(widget.movieId);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        centerTitle: true,
        title: const Text(
          'Cinema Archive',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 28 / 22,
            color: AppColors.violet,
          ),
        ),
        leading: IconButton(
          tooltip: '뒤로가기',
          icon: const Icon(Icons.arrow_back, size: 20),
          color: AppColors.violet,
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            tooltip: '공유',
            icon: const Icon(Icons.share_outlined, size: 20),
            color: AppColors.violet,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: movie == null
          ? const Center(child: Text('영화를 찾을 수 없어요.'))
          : Column(
              children: [
                Expanded(child: _buildContent(movie)),
                _buildActionBar(),
              ],
            ),
    );
  }

  Widget _buildContent(Movie movie) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ColoredBox(
              color: AppColors.tagBackground,
              child: Image.asset(movie.posterAsset, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    height: 36 / 28,
                    color: AppColors.textDetail,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${movie.year} • ${movie.tags.take(2).join('/')} • ${movie.runtimeMinutes}분',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: 0.25,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: _averageRating,
                      itemCount: 5,
                      itemSize: 16.67,
                      unratedColor: const Color(0xFFDDD8E8),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star_rounded,
                        color: AppColors.violet,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '$_averageRating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 24 / 16,
                        letterSpacing: 0.15,
                        color: AppColors.textDetail,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      _reviewCount,
                      style: TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 0.25,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (_myRating > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '내 평점 $_myRating점',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.violet,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in movie.tags)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.tagBackground,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 20 / 14,
                              letterSpacing: 0.1,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.outline)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '시놉시스',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 28 / 22,
                      color: AppColors.textDetail,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final paragraph in movie.synopsisParagraphs) ...[
                    Text(
                      paragraph,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 26 / 16,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (paragraph != movie.synopsisParagraphs.last)
                      const SizedBox(height: 26),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.warmWhite,
        border: Border(top: BorderSide(color: AppColors.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                  ),
                  label: const Text('즐겨찾기'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.violet,
                    side: const BorderSide(color: AppColors.violet),
                    minimumSize: const Size.fromHeight(48),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openRatingDialog,
                  icon: const Icon(Icons.rate_review_outlined, size: 20),
                  label: const Text('평점 남기기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.violet,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
