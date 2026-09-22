import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Data access for the authenticated Partner/Vendor.
///
/// All vendor-owned queries are scoped by the vendor id resolved by
/// PartnerSession. This class never uses a service-role key.
class PartnerRepository {
  PartnerRepository._();

  static final PartnerRepository instance = PartnerRepository._();

  SupabaseClient get db => SupabaseConfig.client;

  Future<List<Map<String, dynamic>>> vendorServices(int vendorId) async {
    final rows = await db
        .from('services')
        .select('id,vendor_id,title,category,price,duration,image_url')
        .eq('vendor_id', vendorId)
        .order('title');

    return List<Map<String, dynamic>>.from(rows);
  }

  Future<Map<String, dynamic>> createService({
    required int vendorId,
    required String title,
    required String category,
    required num price,
    required String duration,
    String? imageUrl,
  }) async {
    final row = await db
        .from('services')
        .insert({
          'vendor_id': vendorId,
          'title': title,
          'category': category,
          'price': price,
          'duration': duration,
          'image_url': imageUrl,
        })
        .select('id,vendor_id,title,category,price,duration,image_url')
        .single();

    return Map<String, dynamic>.from(row);
  }

  Future<Map<String, dynamic>> updateService({
    required int serviceId,
    required int vendorId,
    required String title,
    required String category,
    required num price,
    required String duration,
    String? imageUrl,
  }) async {
    final row = await db
        .from('services')
        .update({
          'title': title,
          'category': category,
          'price': price,
          'duration': duration,
          'image_url': imageUrl,
        })
        .eq('id', serviceId)
        .eq('vendor_id', vendorId)
        .select('id,vendor_id,title,category,price,duration,image_url')
        .single();

    return Map<String, dynamic>.from(row);
  }

  Future<void> deleteService({
    required int serviceId,
    required int vendorId,
  }) async {
    await db
        .from('services')
        .delete()
        .eq('id', serviceId)
        .eq('vendor_id', vendorId);
  }

  Future<List<Map<String, dynamic>>> vendorBookings(int vendorId) async {
    final rows = await db
        .from('bookings')
        .select(
          'id,vendor_id,service_title,user_email,client_name,date,time,status,duration_minutes,created_at',
        )
        .eq('vendor_id', vendorId)
        .order('date', ascending: false)
        .order('time', ascending: false);

    return List<Map<String, dynamic>>.from(rows);
  }

  Future<Map<String, dynamic>> updateBookingStatus({
    required int bookingId,
    required int vendorId,
    required String status,
  }) async {
    final rows = await db
        .from('bookings')
        .update({
          'status': status,
        })
        .eq('id', bookingId)
        .eq('vendor_id', vendorId)
        .select(
          'id,vendor_id,service_title,user_email,client_name,date,time,status,duration_minutes,created_at',
        );

    if (rows.isEmpty) {
      throw Exception(
        'Booking status was not updated. The appointment may no longer exist or you do not have permission.',
      );
    }

    return Map<String, dynamic>.from(rows.first);
  }

  Future<Map<String, dynamic>> vendorOverview(int vendorId) async {
    final bookings = await db
        .from('bookings')
        .select(
          'id,vendor_id,service_title,user_email,client_name,date,time,status,duration_minutes,created_at',
        )
        .eq('vendor_id', vendorId);

    final services = await db
        .from('services')
        .select('id,vendor_id,title,category,price,duration,image_url')
        .eq('vendor_id', vendorId)
        .order('title');

    final bookingRows = List<Map<String, dynamic>>.from(bookings);
    final serviceRows = List<Map<String, dynamic>>.from(services);

    int countStatus(String status) {
      return bookingRows.where((row) {
        return row['status']?.toString().toLowerCase() == status.toLowerCase();
      }).length;
    }

    bookingRows.sort((a, b) {
      final aDate = '${a['date'] ?? ''} ${a['time'] ?? ''}';
      final bDate = '${b['date'] ?? ''} ${b['time'] ?? ''}';
      return bDate.compareTo(aDate);
    });

    return {
      'bookings': bookingRows,
      'services': serviceRows,
      'totalBookings': bookingRows.length,
      'pendingBookings': countStatus('Pending'),
      'confirmedBookings': countStatus('Confirmed'),
      'completedBookings': countStatus('Completed'),
      'cancelledBookings': countStatus('Cancelled'),
    };
  }

  Future<List<Map<String, dynamic>>> vendorFeedback(int vendorId) async {
    final rows = await db
        .from('bookings')
        .select(
          'id,vendor_id,service_title,user_email,client_name,date,rating,feedback,feedback_at',
        )
        .eq('vendor_id', vendorId)
        .not('rating', 'is', null)
        .not('feedback', 'is', null)
        .order('feedback_at', ascending: false);

    return List<Map<String, dynamic>>.from(rows);
  }
}
