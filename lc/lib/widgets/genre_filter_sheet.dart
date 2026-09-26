import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 장르 필터 BottomSheet를 열고, '확인'을 눌렀을 때 선택한 장르를 돌려준다.
/// 바깥을 눌러 닫으면 null을 반환해 기존 필터를 유지한다.
Future<Set<String>?> showGenreFilterSheet(
  BuildContext context, {
  required List<String> genres,
  required Set<String> selected,
}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: AppColors.warmWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.87,
      builder: (context, scrollController) => GenreFilterSheet(
        genres: genres,
        initialSelected: selected,
        scrollController: scrollController,
      ),
    ),
  );
}

class GenreFilterSheet extends StatefulWidget {
  const GenreFilterSheet({
    super.key,
    required this.genres,
    required this.initialSelected,
    required this.scrollController,
  });

  final List<String> genres;
  final Set<String> initialSelected;
  final ScrollController scrollController;

  @override
  State<GenreFilterSheet> createState() => _GenreFilterSheetState();
}

class _GenreFilterSheetState extends State<GenreFilterSheet> {
  // 시트 안에서만 바뀌고, '확인'을 눌러야 목록에 반영된다.
  late final Set<String> _selected = {...widget.initialSelected};

  void _toggle(String genre, bool checked) {
    setState(() {
      if (checked) {
        _selected.add(genre);
      } else {
        _selected.remove(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '장르 필터',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF25232A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '여러 장르를 선택할 수 있어요',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6A6571)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Scrollbar(
            controller: widget.scrollController,
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: widget.genres.length,
              itemBuilder: (context, index) {
                final genre = widget.genres[index];
                final checked = _selected.contains(genre);
                return InkWell(
                  onTap: () => _toggle(genre, !checked),
                  child: SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Transform.scale(
                              scale: 22 / 18,
                              child: Checkbox(
                                value: checked,
                                onChanged: (value) =>
                                    _toggle(genre, value ?? false),
                                activeColor: AppColors.violet,
                                checkColor: Colors.white,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(
                                  color: AppColors.gray,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            genre,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF25232A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE7E0EC)),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_selected),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.violet,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('확인'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
