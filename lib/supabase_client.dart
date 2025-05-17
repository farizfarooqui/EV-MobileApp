import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://sadrbyxspmduptgbpekl.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhZHJieXhzcG1kdXB0Z2JwZWtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY4MTk2NjUsImV4cCI6MjA2MjM5NTY2NX0.Wp2OdsE7lRm-NCEXch2MYLcZZ3FNHLFeVsMuklqn-hA',
    );
  }
} 