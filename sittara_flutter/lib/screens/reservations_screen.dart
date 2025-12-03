import 'package:flutter/material.dart';
import 'package:sittara_flutter/models.dart';
import 'package:sittara_flutter/data/mock_data.dart';
import 'package:sittara_flutter/widgets/reservation_card.dart';
import 'package:sittara_flutter/screens/explore_screen.dart';
import 'package:sittara_flutter/screens/reservation_detail_screen.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  // Local state for reservations to allow modification
  late List<Reservation> _reservations;

  @override
  void initState() {
    super.initState();
    // Initialize with mock data
    _reservations = List.from(mockReservations);
  }

  void _cancelReservation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelar Reserva'),
          content: const Text('¿Estás seguro de que deseas cancelar esta reserva?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                setState(() {
                  // Remove from local list
                  _reservations.removeWhere((r) => r.id == reservation.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reserva cancelada correctamente'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcomingReservations = _reservations
        .where((r) => r.status != ReservationStatus.cancelled)
        .toList();
    final pastReservations = _reservations
        .where((r) => r.status == ReservationStatus.cancelled)
        .toList();

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
              _buildReservationsSection(
                context,
                'Próximas',
                upcomingReservations,
                canCancel: true,
              ),

            if (pastReservations.isNotEmpty) ...[
              if (upcomingReservations.isNotEmpty)
                const SizedBox(height: 24),
              _buildReservationsSection(
                context,
                'Anteriores',
                pastReservations,
                canCancel: false,
              ),
            ],

            if (upcomingReservations.isEmpty && pastReservations.isEmpty)
              _buildNoReservationsView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationsSection(
    BuildContext context,
    String title,
    List<Reservation> reservations, {
    required bool canCancel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Column(
          children: reservations.map((reservation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Dismissible(
                key: Key(reservation.id),
                direction: canCancel
                    ? DismissDirection.endToStart
                    : DismissDirection.none,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  _cancelReservation(reservation);
                  return false; // Don't dismiss automatically, let the dialog handle it
                },
                child: Column(
                  children: [
                    ReservationCard(
                      reservation: reservation,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReservationDetailScreen(reservation: reservation),
                          ),
                        );
                      },
                    ),
                    if (canCancel)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _cancelReservation(reservation),
                          icon: const Icon(Icons.cancel_outlined, size: 20, color: Colors.red),
                          label: const Text(
                            'Cancelar reserva',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                  ],
                ),
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ExploreScreen(),
                  ),
                );
              },
              child: const Text(
                'Explorar restaurantes',
                style: TextStyle(
                  color: Color(0xFF4C7BF3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
