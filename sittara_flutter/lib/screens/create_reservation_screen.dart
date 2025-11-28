import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sittara_flutter/models.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateReservationScreen extends StatefulWidget {
  final Restaurant restaurant;

  const CreateReservationScreen({super.key, required this.restaurant});

  @override
  _CreateReservationScreenState createState() => _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedTime = '20:00';
  int _guests = 2;
  bool _showSuccess = false;

  final List<String> _times = [
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _handleConfirm() {
    setState(() {
      _showSuccess = true;
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        // This should pop back two screens (past details) or go to a summary screen
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return _buildSuccessView(context);
    }
    return _buildFormView(context);
  }
  
  Widget _buildFormView(BuildContext context) {
    const primaryColor = Color(0xFF4C7BF3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar mesa'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.restaurant.address, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Date Selection
            _buildSectionHeader(context, Icons.calendar_today_outlined, 'Selecciona una fecha'),
            const SizedBox(height: 8),
            Container(
               padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: primaryColor.withOpacity(0.5), shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              ),
            ),
            const SizedBox(height: 24),

            // Time Selection
            _buildSectionHeader(context, Icons.access_time_outlined, 'Selecciona una hora'),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _times.length,
              itemBuilder: (context, index) {
                final time = _times[index];
                final isSelected = time == _selectedTime;
                return ElevatedButton(
                  onPressed: () => setState(() => _selectedTime = time),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? primaryColor : Colors.grey.shade100,
                    foregroundColor: isSelected ? Colors.white : Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(time),
                );
              },
            ),
             const SizedBox(height: 24),

            // Guest Counter
             _buildSectionHeader(context, Icons.people_outline, 'Número de personas'),
            const SizedBox(height: 8),
             Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => setState(() => _guests = _guests > 1 ? _guests - 1 : 1),
                    color: primaryColor,
                  ),
                   Text('$_guests', style: Theme.of(context).textTheme.titleLarge),
                   IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => _guests = _guests < 20 ? _guests + 1 : 20),
                     color: primaryColor,
                  ),
                 ],
               ),
             ),
             const SizedBox(height: 32),

            // Confirm Button
             SizedBox(
              width: double.infinity,
               child: ElevatedButton(
                onPressed: _handleConfirm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Confirmar reserva', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                           ),
             ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4C7BF3), size: 20),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.check_circle_outline, size: 60, color: Colors.green.shade700),
            ),
            const SizedBox(height: 32),
            Text(
              '¡Reserva confirmada!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Tu mesa en ${widget.restaurant.name} ha sido reservada exitosamente.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
