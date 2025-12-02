import { createClient } from '@supabase/supabase-js';

// Replace with your actual Supabase URL and anon key
const supabaseUrl = 'https://luczxrkmqvontlnncfqa.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1Y3p4cmttcXZvbnRsbm5jZnFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2NDIxNTMsImV4cCI6MjA4MDIxODE1M30.1Po_FcYLF-7L0dWsba85zpDA34QHnQwnq0WR10TXAqo';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
