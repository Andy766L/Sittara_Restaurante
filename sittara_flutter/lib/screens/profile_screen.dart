import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sittara_flutter/services/auth_service.dart';
import 'package:sittara_flutter/screens/login_screen.dart';
import 'package:sittara_flutter/models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      // This should ideally not happen if routing is correct,
      // but as a fallback, show a loading or error state.
      return const Scaffold(
        body: Center(child: Text('No se ha iniciado sesión.')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perfil'),
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileHeader(context, user),
              const SizedBox(height: 16),
              _buildInfoCard(context, user),
              const SizedBox(height: 16),
              _buildSettingsCard(context),
              const SizedBox(height: 16),
              _buildLogoutButton(context, authService),
            ],
          ),
        ),
      ),
      // Placeholder for BottomNavigation
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.avatar),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withAlpha(50),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {}, // Placeholder
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Editar perfil'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información personal',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(context, 'Correo electrónico', user.email),
          const Divider(),
          _buildInfoRow(context, 'Teléfono', user.phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Ajustes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notificaciones'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeThumbColor: Theme.of(context).primaryColor,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Privacidad y seguridad'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // Placeholder
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Ayuda y soporte'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // Placeholder
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthService authService) {
    return TextButton.icon(
      onPressed: () async {
        await authService.logout();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false, // Remove all previous routes
          );
        }
      },
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
