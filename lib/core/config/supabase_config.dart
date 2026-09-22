import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static const String url =
      'https://jaaxyzjrvbcksoguigob.supabase.co';

  static const String publishableKey =
      'sb_publishable_AIHXGQ_zQ11TInueG2zvgw_NkbtAaxc';

  static SupabaseClient get client => Supabase.instance.client;
}
