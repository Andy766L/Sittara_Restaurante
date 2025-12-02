import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sittara_flutter/models.dart';

class AddReviewScreen extends StatefulWidget {
  final Restaurant restaurant;

  const AddReviewScreen({super.key, required this.restaurant});

  @override
  AddReviewScreenState createState() => AddReviewScreenState();
}

class AddReviewScreenState extends State<AddReviewScreen> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _submitted = false;

  void _handleSubmit() {
    // Placeholder for submitting review logic
    if (_rating > 0 && _commentController.text.trim().isNotEmpty) {
      setState(() {
        _submitted = true;
      });
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop(); // Go back to restaurant detail screen
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecciona una calificación y escribe un comentario.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Malo';
      case 2:
        return 'Regular';
      case 3:
        return 'Bueno';
      case 4:
        return 'Muy bueno';
      case 5:
        return '¡Excelente!';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green.withAlpha((255 * 0.1).round()),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 60,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '¡Gracias por tu reseña!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Tu opinión nos ayuda a mejorar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar reseña'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.restaurant.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '¿Cómo fue tu experiencia?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),

            Text(
              'Calificación',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStarRating(),
            if (_rating > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _getRatingText(_rating),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            const SizedBox(height: 32),

            Text(
              'Escribe tu opinión',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Cuéntanos sobre tu experiencia en el restaurante...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Enviar reseña',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
