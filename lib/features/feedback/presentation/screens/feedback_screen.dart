import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/config/partner_session.dart';
import '../../../../core/data/partner_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class _Review {
  const _Review({
    required this.name,
    required this.email,
    required this.service,
    required this.stars,
    required this.comment,
    required this.date,
  });

  final String name;
  final String email;
  final String service;
  final int stars;
  final String comment;
  final String date;

  factory _Review.fromMap(Map<String, dynamic> map) {
    final ratingValue = map['rating'];
    final rating = ratingValue is num
        ? ratingValue.toInt()
        : int.tryParse(ratingValue?.toString() ?? '') ?? 0;

    final rawDate = map['feedback_at'] ?? map['date'];

    return _Review(
      name: map['client_name']?.toString().trim().isNotEmpty == true
          ? map['client_name'].toString().trim()
          : 'Customer',
      email: map['user_email']?.toString() ?? '',
      service: map['service_title']?.toString() ?? '',
      stars: rating.clamp(1, 5),
      comment: map['feedback']?.toString() ?? '',
      date: _formatDate(rawDate),
    );
  }

  static String _formatDate(dynamic value) {
    if (value == null) return 'Date unavailable';

    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return value.toString();

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final PartnerRepository _repository = PartnerRepository.instance;

  List<_Review> _reviews = [];
  bool _loading = true;
  String? _errorMessage;

  int? get _vendorId => PartnerSession.vendorId;

  double get _avgRating {
    if (_reviews.isEmpty) return 0;

    final total = _reviews.fold<int>(
      0,
      (sum, review) => sum + review.stars,
    );

    return total / _reviews.length;
  }

  int _starCount(int star) {
    return _reviews.where((review) => review.stars == star).length;
  }

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    final vendorId = _vendorId;

    if (vendorId == null) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage =
            'Partner session is not available. Please log in again.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final rows = await _repository.vendorFeedback(vendorId);
      final reviews = rows.map(_Review.fromMap).toList();

      if (!mounted) return;

      setState(() {
        _reviews = reviews;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = _friendlyError(error);
      });
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();

    if (message.contains('SocketException') ||
        message.contains('Failed host lookup') ||
        message.contains('Network')) {
      return 'Unable to connect to the database. Check your internet connection and try again.';
    }

    if (message.contains('JWT') ||
        message.contains('session') ||
        message.contains('authenticated')) {
      return 'Your session may have expired. Please log in again.';
    }

    if (message.contains('permission') ||
        message.contains('RLS') ||
        message.contains('row-level')) {
      return 'You do not have permission to view this feedback.';
    }

    return 'Unable to load customer feedback. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: RefreshIndicator(
        onRefresh: _loadFeedback,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Feedback',
                style: AppTypography.pageTitle,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 20),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                _FeedbackError(
                  message: _errorMessage!,
                  onRetry: _loadFeedback,
                )
              else ...[
                _AverageRatingCard(
                  avgRating: _avgRating,
                  reviewCount: _reviews.length,
                  starCount: _starCount,
                ).animate().fadeIn(duration: 300.ms, delay: 60.ms).slideY(
                      begin: -0.05,
                      end: 0,
                      duration: 300.ms,
                    ),
                const SizedBox(height: 16),
                _ReviewListCard(reviews: _reviews)
                    .animate()
                    .fadeIn(duration: 350.ms, delay: 140.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackError extends StatelessWidget {
  const _FeedbackError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 42,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodySM.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }
}

class _AverageRatingCard extends StatelessWidget {
  const _AverageRatingCard({
    required this.avgRating,
    required this.reviewCount,
    required this.starCount,
  });

  final double avgRating;
  final int reviewCount;
  final int Function(int star) starCount;

  @override
  Widget build(BuildContext context) {
    final int filled = avgRating.round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool wide = constraints.maxWidth > 500;

          final Widget ratingDisplay = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: AppTypography.ratingScore.copyWith(
                  color: AppColors.starFilled,
                  fontSize: 42,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (i) => Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          i < filled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 22,
                          color: i < filled
                              ? AppColors.starFilled
                              : AppColors.starEmpty,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$reviewCount REVIEWS',
                    style: AppTypography.labelSM.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          );

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AVERAGE RATING',
                  style: AppTypography.labelSM,
                ),
                const SizedBox(height: 16),
                ratingDisplay,
              ],
            );
          }

          return Row(
            children: [
              ratingDisplay,
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  5,
                  (i) {
                    final int star = 5 - i;
                    final int count = starCount(star);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$star',
                            style: AppTypography.labelXS,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star_rounded,
                            size: 11,
                            color: AppColors.starFilled,
                          ),
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
                              widthFactor:
                                  reviewCount > 0 ? count / reviewCount : 0,
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
                            child: Text(
                              '$count',
                              style: AppTypography.labelXS,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

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
          Text(
            'Customer Feedback',
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: 20),
          if (reviews.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.rate_review_outlined,
                      size: 40,
                      color: AppColors.borderLight,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No feedback received yet.',
                      style: AppTypography.bodySM.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...reviews.asMap().entries.map(
                  (entry) => _ReviewItem(
                    review: entry.value,
                    index: entry.key,
                    isLast: entry.key == reviews.length - 1,
                  ),
                ),
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
    final initial = review.name.trim().isEmpty
        ? '?'
        : review.name.trim().substring(0, 1).toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.categoryBadgeBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
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
                    children: [
                      Expanded(
                        child: Text(
                          review.name,
                          style: AppTypography.labelLG,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        review.date,
                        style: AppTypography.labelXS.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  if (review.email.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      review.email,
                      style: AppTypography.labelXS.copyWith(
                        color: AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < review.stars
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 14,
                        color: i < review.stars
                            ? AppColors.starFilled
                            : AppColors.starEmpty,
                      ),
                    ),
                  ),
                  if (review.service.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      review.service,
                      style: AppTypography.labelSM.copyWith(
                        color: AppColors.sidebarActive,
                      ),
                    ),
                  ],
                  if (review.comment.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      review.comment,
                      style: AppTypography.bodySM.copyWith(height: 1.5),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ).animate().fadeIn(
              duration: 300.ms,
              delay: Duration(
                milliseconds: 180 + index * 80,
              ),
            ),
        if (!isLast) ...[
          const SizedBox(height: 20),
          const Divider(
            color: AppColors.borderLight,
            height: 1,
          ),
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
