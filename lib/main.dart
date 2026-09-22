import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/config/supabase_connection_test.dart';
import 'core/config/partner_session.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  await SupabaseConnectionTest.run();

  try {
    if (Supabase.instance.client.auth.currentSession != null) {
      await PartnerSession.loadProfile();
    }
  } catch (e) {
    debugPrint('Partner profile could not be loaded: $e');
    // Keep the Supabase authentication session.
    // A profile/network error must not log the partner out.
  }

  runApp(const PartnerApp());
}

class PartnerApp extends StatelessWidget {
  const PartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stylewow Partner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

