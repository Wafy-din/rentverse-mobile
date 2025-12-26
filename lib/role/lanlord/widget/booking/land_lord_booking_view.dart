import 'package:flutter/material.dart';
import 'package:rentverse/role/lanlord/widget/my_property/confirmed_tab.dart';
import 'package:rentverse/role/lanlord/widget/my_property/paid_tab.dart';
import 'package:rentverse/role/lanlord/widget/my_property/payment_tab.dart';
import 'package:rentverse/role/lanlord/widget/my_property/rejected_tab.dart';
import 'package:rentverse/role/lanlord/widget/my_property/request_tab.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LandLordBookingView extends StatelessWidget {
  const LandLordBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Bookings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        bottom: const TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Color(0xFF1CD8D2),
          labelColor: Color(0xFF1CD8D2),
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(text: 'Request'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Payment'),
            Tab(text: 'Paid'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          RequestTab(),
          ConfirmedTab(),
          PaymentTab(),
          PaidTab(),
          RejectedTab(),
        ],
      ),
    );
  }
}
