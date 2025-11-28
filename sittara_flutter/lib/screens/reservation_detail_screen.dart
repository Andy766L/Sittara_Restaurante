import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models.dart';

class ReservationDetailScreen extends StatelessWidget {
  final Reservation reservation;

  const ReservationDetailScreen({super.key, required this.reservation});

  Color _getStatusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return Colors.orange.shade100;
      case ReservationStatus.confirmed:
        return Colors.green.shade100;
      case ReservationStatus.cancelled:
        return Colors.red.shade100;
    }
  }

  Color _getStatusTextColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return Colors.orange.shade700;
      case ReservationStatus.confirmed:
        return Colors.green.shade700;
      case ReservationStatus.cancelled:
        return Colors.red.shade700;
    }
  }

  String _getStatusLabel(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pendiente de confirmación';
      case ReservationStatus.confirmed:
        return 'Confirmada';
      case ReservationStatus.cancelled:
        return 'Cancelada';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Find the corresponding restaurant details
    final Restaurant restaurant = mockRestaurants.firstWhere(
      (r) => r.id == reservation.restaurantId,
      orElse: () => mockRestaurants[0], // Fallback if not found
    );

    const primaryColor = Color(0xFF4C7BF3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de reserva'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                reservation.restaurantImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(reservation.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusLabel(reservation.status),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _getStatusTextColor(reservation.status),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Restaurant Name and Address
                  Text(
                    reservation.restaurantName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ...[
                  const SizedBox(height: 4),
                  Text(
                    restaurant.address,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
                  const SizedBox(height: 24),

                  // Reservation Details Info Cards
                  _buildInfoTile(context, Icons.calendar_today_outlined, 'Fecha', 
                    DateFormat('EEEE, dd \'de\' MMMM \'de\' yyyy', 'es')
                        .format(DateTime.parse(reservation.date))),
                  const SizedBox(height: 12),
                  _buildInfoTile(context, Icons.access_time_outlined, 'Hora', reservation.time),
                  const SizedBox(height: 12),
                  _buildInfoTile(context, Icons.people_outline, 'Personas', '${reservation.guests}'),
                  const SizedBox(height: 24),

                  // Location Section (Simulated Map)
                  ...[
                  Text(
                    'Ubicación',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1694953592902-46d9b0d0c19d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyZXN0YXVyYW50JTIwbG9jYXRpb24lMjBtYXB8ZW52MXx8fHwxNjM4NTAxNzN8MA&ixlib=rb-4.1.0&q=80&w=1080',
                            fit: BoxFit.cover,
                             errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.map, size: 80, color: Colors.grey)),
                          ),
                          Icon(Icons.location_on, size: 60, color: primaryColor.withOpacity(0.8)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Placeholder for opening map directions
                        print('Ver indicaciones para ${restaurant.address}');
                      },
                      icon: const Icon(Icons.navigation_outlined, color: primaryColor),
                      label: const Text('Ver indicaciones', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: primaryColor, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                  // Cancel Reservation Button
                  if (reservation.status != ReservationStatus.cancelled)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Placeholder for cancel logic
                          print('Cancelar reserva ${reservation.id}');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.red.shade500,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Cancelar reserva', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildInfoTile(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4C7BF3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
