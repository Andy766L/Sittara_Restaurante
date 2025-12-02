import 'package:supabase_flutter/supabase_flutter.dart';

// These should ideally be loaded from environment variables for production.
// For development, we'll hardcode them here for simplicity.
const String supabaseUrl = 'https://luczxrkmqvontlnncfqa.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1Y3p4cmttcXZvbnRsbm5jZnFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2NDIxNTMsImV4cCI6MjA4MDIxODE1M30.1Po_FcYLF-7L0dWsba85zpDA34QHnQwnq0WR10TXAqo';

// Global Supabase client instance
final supabase = Supabase.instance.client;
