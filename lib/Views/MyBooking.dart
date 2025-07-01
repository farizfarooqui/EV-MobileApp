import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nobile/Controller/BookingController.dart';
import 'package:nobile/Model/StationModel.dart';

class MyBookingScreen extends StatelessWidget {
  MyBookingScreen({super.key});
  final BookingController bookingController = Get.put(BookingController());

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy h:mm a').format(dateTime);
  }

  Widget _buildBookingCard(Booking booking, bool isActive) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking.status == 'approved'
                        ? Colors.green
                        : booking.status == 'pending'
                            ? Colors.orange
                            : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Start Time: ${formatDateTime(booking.startTime)}'),
            Text('End Time: ${formatDateTime(booking.endTime)}'),
            Text('Total Price: \$${booking.totalPrice.toStringAsFixed(2)}'),
            if (isActive && booking.status == 'approved') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      final result = await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text('Cancel Booking'),
                          content: const Text(
                              'Are you sure you want to cancel this booking?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: () => Get.back(result: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Yes, Cancel'),
                            ),
                          ],
                        ),
                      );

                      if (result == true) {
                        final success =
                            await bookingController.cancelBooking(booking.id);
                        if (success) {
                          Get.snackbar(
                            'Success',
                            'Booking cancelled successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      }
                    },
                    child: const Text('Cancel Booking'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, bool isActive) {
    if (bookings.isEmpty) {
      return _buildEmptyState(Get.context!,
          'No ${isActive ? 'active' : 'completed'} bookings found.');
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index], isActive);
      },
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
              bookingController.fetchUserBookings();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
          ),
        ],
      ),
    );
  }

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
                Tab(text: 'Active'),
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
            _buildBookingList(controller.activeBookings, true),
            _buildBookingList(controller.completedBookings, false),
            _buildBookingList(controller.canceledBookings, false),
          ],
        ),
      ),
    );
  }
}
