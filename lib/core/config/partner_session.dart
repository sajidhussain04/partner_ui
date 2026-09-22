import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

class PartnerSession {
  PartnerSession._();

  static final SupabaseClient _client = SupabaseConfig.client;

  static int? vendorId;
  static Map<String, dynamic>? profile;

  static User? get authUser => _client.auth.currentUser;

  static bool get hasAuthSession =>
      _client.auth.currentSession != null;

  static bool get isLoggedIn =>
      hasAuthSession && vendorId != null;

  static String get approvalStatus =>
      (profile?['approval_status']?.toString() ?? 'pending').toLowerCase();

  static bool get isApproved => approvalStatus == 'approved';

  static bool get isPending => approvalStatus == 'pending';

  static bool get isRejected => approvalStatus == 'rejected';

  static Future<void> loadProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      vendorId = null;
      profile = null;
      return;
    }

    final data = await _client
        .from('users')
        .select()
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (data == null) {
      vendorId = null;
      profile = null;
      throw Exception('Partner profile was not found.');
    }

    if (data['role']?.toString().toLowerCase() != 'vendor') {
      vendorId = null;
      profile = null;
      throw Exception('This account is not a Partner/Vendor account.');
    }

    vendorId = data['id'] as int;
    profile = Map<String, dynamic>.from(data);
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    try {
      await loadProfile();
    } catch (_) {
      await _client.auth.signOut();
      vendorId = null;
      profile = null;
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
    vendorId = null;
    profile = null;
  }
}
