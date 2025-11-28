import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onTap;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onTap,
  });

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
        return 'Pendiente';
      case ReservationStatus.confirmed:
        return 'Confirmada';
      case ReservationStatus.cancelled:
        return 'Cancelada';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Row(
          children: [
            // Restaurant Image
            SizedBox(
              width: 96,
              height: 96,
              child: Image.network(
                reservation.restaurantImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
              ),
            ),
            
            // Reservation Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            reservation.restaurantName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(reservation.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusLabel(reservation.status),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: _getStatusTextColor(reservation.status),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es').format(DateTime.parse(reservation.date)),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Time and Guests
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          reservation.time,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          '${reservation.guests} personas',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
