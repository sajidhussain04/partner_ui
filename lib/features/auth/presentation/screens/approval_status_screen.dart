import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/partner_session.dart';
import '../../../../core/routes/app_router.dart';

class ApprovalStatusScreen extends StatelessWidget {
  const ApprovalStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final status = PartnerSession.approvalStatus;
    final isRejected = status == 'rejected';

    final title = isRejected
        ? 'Application Not Approved'
        : 'Application Pending';

    final message = isRejected
        ? 'Your Partner application was not approved. Please contact StyleWow support for more information.'
        : 'Your Partner application has been submitted successfully. Our admin team needs to approve your listing before you can access the Partner dashboard.';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isRejected
                            ? Icons.cancel_outlined
                            : Icons.hourglass_top_rounded,
                        size: 72,
                        color: isRejected
                            ? const Color(0xFFB3261E)
                            : const Color(0xFFFF8901),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF3A3430),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.55,
                          color: Color(0xFF625A54),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F7F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Current status: ${status.toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF3A3430),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await PartnerSession.signOut();

                            if (!context.mounted) return;

                            context.go(AppRoutes.login);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A3430),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'SIGN OUT',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
