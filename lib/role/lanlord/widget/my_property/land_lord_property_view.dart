import 'package:flutter/material.dart';
import 'package:rentverse/role/lanlord/presentation/pages/part_add_property.dart';
import 'package:rentverse/role/lanlord/widget/my_property/listing_tab.dart';
import 'package:rentverse/role/lanlord/widget/my_property/submission_tab.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LandLordPropertyView extends StatelessWidget {
  const LandLordPropertyView({super.key});

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
          'My Property',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(LucideIcons.moreHorizontal), onPressed: () {}),
        ],
        bottom: const TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Color(0xFF1CD8D2),
          labelColor: Color(0xFF1CD8D2),
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(text: 'Submission'),
            Tab(text: 'My Listing'),
          ],
        ),
      ),
      body: const TabBarView(children: [SubmissionTab(), ListingTab()]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1CD8D2),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PartAddPropertyPage()),
          );
        },
        child: Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}
