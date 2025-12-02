import 'package:flutter/material.dart';
import 'package:sittara_flutter/screens/add_review_screen.dart';
import 'package:sittara_flutter/screens/create_reservation_screen.dart';
import '../data/mock_data.dart';
import '../models.dart';
import '../widgets/review_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    // Filter reviews for the current restaurant
    final restaurantReviews = mockReviews
        .where((review) => review.restaurantId == restaurant.id)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name, Cuisine, Rating
                  _buildHeaderSection(context, restaurantReviews.length),
                  const SizedBox(height: 24),

                  // Book Table Button
                  _buildBookingButton(context),
                  const SizedBox(height: 24),

                  // Info Tiles
                  _buildInfoSection(context),
                  const SizedBox(height: 24),

                  // Description
                  _buildDescriptionSection(context),
                  const SizedBox(height: 24),

                  // Reviews Section
                  _buildReviewsSection(context, restaurantReviews),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.appBarTheme.backgroundColor,
      iconTheme: theme.appBarTheme.iconTheme,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          restaurant.name,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(restaurant.image, fit: BoxFit.cover),
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha((255 * 0.6).round()),
                    Colors.transparent,
                    Colors.black.withAlpha((255 * 0.8).round()),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, int reviewCount) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(restaurant.name, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(restaurant.cuisine, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStars(context, restaurant.rating),
            const SizedBox(width: 8),
            Text(
              '${restaurant.rating} ($reviewCount reseñas)',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStars(BuildContext context, double rating) {
    final theme = Theme.of(context);
    return Row(
      children: List.generate(5, (index) {
        final starColor = theme.primaryColor;
        if (index < rating.floor()) {
          return Icon(Icons.star, color: starColor, size: 20);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: starColor, size: 20);
        } else {
          return Icon(Icons.star_border, color: starColor, size: 20);
        }
      }),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateReservationScreen(restaurant: restaurant),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Reservar mesa',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      children: [
        _buildInfoTile(
          context,
          Icons.location_on_outlined,
          'Dirección',
          restaurant.address,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          context,
          Icons.access_time_outlined,
          'Horario',
          restaurant.hours,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          context,
          Icons.phone_outlined,
          'Teléfono',
          restaurant.phone,
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sobre este restaurante', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          restaurant.description,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context, List<Review> reviews) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reseñas (${reviews.length})',
              style: theme.textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddReviewScreen(restaurant: restaurant),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
              style: TextButton.styleFrom(
                foregroundColor: theme.primaryColor,
                backgroundColor: theme.primaryColor.withAlpha(26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (reviews.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text('Todavía no hay reseñas.'),
            ),
          )
        else
          Column(
            children: reviews
                .map((review) => ReviewCard(review: review))
                .toList(),
          ),
      ],
    );
  }
}
