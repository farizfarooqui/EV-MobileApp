import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nobile/Controller/BookingController.dart';

class MyBookingScreen extends StatelessWidget {
  MyBookingScreen({super.key});
  final BookingController bookingController = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Bookings',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: GetBuilder<BookingController>(
            builder: (controller) => TabBar(
              controller: controller.tabController,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.7),
              tabs: const [
                Tab(text: 'Requested'),
                Tab(text: 'Completed'),
                Tab(text: 'Canceled'),
              ],
            ),
          ),
        ),
      ),
      body: GetBuilder<BookingController>(
        builder: (controller) => TabBarView(
          controller: controller.tabController,
          children: [
            _buildEmptyState(context, 'No requested bookings found.'),
            _buildEmptyState(context, 'No completed bookings found.'),
            _buildEmptyState(context, 'No canceled bookings found.'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox,
              size: 80, color: Theme.of(context).hintColor.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color
                      ?.withOpacity(0.8),
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            onPressed: () {
              // TODO: Implement reload logic
            },
            icon: const Icon(Icons.refresh),
            label: const Text('reload'),
          ),
        ],
      ),
    );
  }
}
