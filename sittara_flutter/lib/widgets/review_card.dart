import 'package:flutter/material.dart';
import '../models.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 2,
      shadowColor: Colors.black.withAlpha((255 * 0.05).round()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(review.userAvatar),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              // Fallback child in case of error
              child: Icon(
                Icons.person_outline,
                size: 28,
                color: theme.iconTheme.color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.userName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        review.date,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildStars(review.rating.toInt()),
                  const SizedBox(height: 12),
                  Text(
                    review.comment,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.4, // line-height
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
