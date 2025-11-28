import 'package:flutter/material.dart';
import 'package:sittara_flutter/models.dart';
import 'package:sittara_flutter/data/mock_data.dart';
import 'package:sittara_flutter/widgets/reservation_card.dart';
import 'package:sittara_flutter/screens/explore_screen.dart'; // For navigation to explore
import 'package:sittara_flutter/screens/reservation_detail_screen.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final upcomingReservations = mockReservations.where((r) => r.status != ReservationStatus.cancelled).toList();
    final pastReservations = mockReservations.where((r) => r.status == ReservationStatus.cancelled).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (upcomingReservations.isNotEmpty)
              _buildReservationsSection(context, 'Próximas', upcomingReservations),
            
            if (pastReservations.isNotEmpty) ...[
              if (upcomingReservations.isNotEmpty) const SizedBox(height: 24), // Spacer if both exist
              _buildReservationsSection(context, 'Anteriores', pastReservations),
            ],

            if (upcomingReservations.isEmpty && pastReservations.isEmpty)
              _buildNoReservationsView(context),
          ],
        ),
      ),
      // Placeholder for BottomNavigation, similar to ExploreScreen
    );
  }

  Widget _buildReservationsSection(BuildContext context, String title, List<Reservation> reservations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Column(
          children: reservations.map((reservation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ReservationCard(
                reservation: reservation,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationDetailScreen(reservation: reservation),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNoReservationsView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No tienes reservas aún',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ExploreScreen()),
                );
              },
              child: const Text(
                'Explorar restaurantes',
                style: TextStyle(color: Color(0xFF4C7BF3), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
