import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

// ─── Data model ────────────────────────────────────────────────────────────────
class _Review {
  const _Review({
    required this.name,
    required this.stars,
    required this.comment,
    required this.date,
  });
  final String name;
  final int stars;
  final String comment;
  final String date;
}

const List<_Review> _reviews = [
  _Review(
    name: 'Arjun Sharma',
    stars: 5,
    comment: 'Amazing experience! The beard trim was precise and the staff was very professional. Will definitely visit again.',
    date: 'Aug 5, 2026',
  ),
  _Review(
    name: 'Priya Mehta',
    stars: 5,
    comment: 'Love my balayage! The stylist understood exactly what I wanted. The salon ambience is also very relaxing.',
    date: 'Aug 5, 2026',
  ),
  _Review(
    name: 'Rohit Verma',
    stars: 4,
    comment: 'Great Moroccan hair spa treatment. My hair feels so soft and shiny. Just slightly long wait time.',
    date: 'Aug 4, 2026',
  ),
  _Review(
    name: 'Sneha Patel',
    stars: 5,
    comment: 'The facial was absolutely wonderful. Skin feels rejuvenated. Super clean and hygienic place.',
    date: 'Aug 4, 2026',
  ),
];

double get _avgRating {
  if (_reviews.isEmpty) return 0;
  return _reviews.fold(0, (sum, r) => sum + r.stars) / _reviews.length;
}

// ─── Screen ────────────────────────────────────────────────────────────────────
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Feedback', style: AppTypography.pageTitle)
                .animate()
                .fadeIn(duration: 300.ms),
            const SizedBox(height: 20),

            // ── Rating Summary ────────────────────────────────────────────────
            _AverageRatingCard(
              avgRating: _avgRating,
              reviewCount: _reviews.length,
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 60.ms)
                .slideY(begin: -0.05, end: 0, duration: 300.ms),
            const SizedBox(height: 16),

            // ── Review List ────────────────────────────────────────────────────
            const _ReviewListCard(reviews: _reviews)
                .animate()
                .fadeIn(duration: 350.ms, delay: 140.ms),
          ],
        ),
      ),
    );
  }
}

// ─── Average Rating Card ───────────────────────────────────────────────────────
class _AverageRatingCard extends StatelessWidget {
  const _AverageRatingCard({
    required this.avgRating,
    required this.reviewCount,
  });

  final double avgRating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final int filled = avgRating.round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: LayoutBuilder(builder: (context, constraints) {
        final bool wide = constraints.maxWidth > 500;
        final Widget ratingDisplay = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Big score
            Text(
              avgRating.toStringAsFixed(1),
              style: AppTypography.ratingScore
                  .copyWith(color: AppColors.starFilled, fontSize: 42),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: List.generate(5, (i) => Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Icon(
                      i < filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 22,
                      color: i < filled ? AppColors.starFilled : AppColors.starEmpty,
                    ),
                  )),
                ),
                const SizedBox(height: 4),
                Text(
                  '$reviewCount REVIEWS',
                  style: AppTypography.labelSM.copyWith(
                    color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ],
        );

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AVERAGE RATING', style: AppTypography.labelSM),
              const SizedBox(height: 16),
              ratingDisplay,
            ],
          );
        }

        return Row(
          children: [
            ratingDisplay,
            const Spacer(),
            // Star breakdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(5, (i) {
                final int star = 5 - i;
                final int count = _reviews.where((r) => r.stars == star).length;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$star', style: AppTypography.labelXS),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded,
                          size: 11, color: AppColors.starFilled),
                      const SizedBox(width: 8),
                      Container(
                        width: 80,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: reviewCount > 0 ? count / reviewCount : 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.starFilled,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 16,
                        child: Text('$count', style: AppTypography.labelXS),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Review List Card ─────────────────────────────────────────────────────────
class _ReviewListCard extends StatelessWidget {
  const _ReviewListCard({required this.reviews});
  final List<_Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Feedback', style: AppTypography.sectionTitle),
          const SizedBox(height: 20),
          if (reviews.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(children: [
                  const Icon(Icons.rate_review_outlined,
                      size: 40, color: AppColors.borderLight),
                  const SizedBox(height: 12),
                  Text('No feedback received yet.',
                      style: AppTypography.bodySM
                          .copyWith(color: AppColors.textMuted)),
                ]),
              ),
            )
          else
            ...reviews.asMap().entries.map((e) => _ReviewItem(
                  review: e.value,
                  index: e.key,
                  isLast: e.key == reviews.length - 1,
                )),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({
    required this.review,
    required this.index,
    required this.isLast,
  });

  final _Review review;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar initials
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.categoryBadgeBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                review.name.substring(0, 1),
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.sidebarActive,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(review.name, style: AppTypography.labelLG),
                      Text(review.date,
                          style: AppTypography.labelXS
                              .copyWith(fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < review.stars
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 14,
                      color: i < review.stars
                          ? AppColors.starFilled
                          : AppColors.starEmpty,
                    )),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.comment,
                    style: AppTypography.bodySM.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(
              duration: 300.ms,
              delay: Duration(milliseconds: 180 + index * 80),
            ),
        if (!isLast) ...[
          const SizedBox(height: 20),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 12,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
