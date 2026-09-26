import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../theme/app_colors.dart';
import '../widgets/genre_filter_sheet.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  // 시트에서 '확인'을 눌러 적용한 장르. 비어 있으면 필터 없음(전체).
  Set<String> _appliedGenres = {};

  List<Movie> get _filteredMovies => _appliedGenres.isEmpty
      ? movies
      : movies.where((movie) => movie.matchesAnyGenre(_appliedGenres)).toList();

  Future<void> _openFilterSheet() async {
    final selected = await showGenreFilterSheet(
      context,
      genres: movieGenres,
      selected: _appliedGenres,
    );
    if (selected == null || !mounted) return;

    setState(() => _appliedGenres = selected);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMovies;
    final hasFilter = _appliedGenres.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 16,
        title: const Text('영화'),
        actions: [
          IconButton(
            tooltip: '검색',
            icon: const Icon(Icons.search, size: 22),
            color: AppColors.textSecondary,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: '장르 필터',
                icon: const Icon(Icons.filter_list),
                color: hasFilter ? AppColors.violet : AppColors.textSecondary,
                onPressed: _openFilterSheet,
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        '조건에 맞는 영화가 없어요.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 24,
                            mainAxisExtent: 316.5,
                          ),
                      itemBuilder: (context, index) =>
                          MovieCard(movie: filtered[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
