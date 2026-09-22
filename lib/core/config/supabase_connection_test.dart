import 'package:flutter/foundation.dart';

import 'supabase_config.dart';

class SupabaseConnectionTest {
  SupabaseConnectionTest._();

  static Future<void> run() async {
    try {
      final data = await SupabaseConfig.client
          .from('service_categories')
          .select('id, name')
          .limit(5);

      debugPrint('========================================');
      debugPrint('SUPABASE CONNECTION: SUCCESS');
      debugPrint('service_categories rows: ${data.length}');
      debugPrint('data: $data');
      debugPrint('========================================');
    } catch (error, stackTrace) {
      debugPrint('========================================');
      debugPrint('SUPABASE CONNECTION: FAILED');
      debugPrint('error: $error');
      debugPrint('stackTrace: $stackTrace');
      debugPrint('========================================');
    }
  }
}
