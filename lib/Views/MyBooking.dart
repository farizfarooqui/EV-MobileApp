import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/BookingController.dart';
import 'package:nobile/Model/StationModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyBookingScreen extends StatelessWidget {
  MyBookingScreen({super.key});
  final BookingController bookingController = Get.put(BookingController());
  final RefreshController _activeRefreshController = RefreshController();
  final RefreshController _completedRefreshController = RefreshController();
  final RefreshController _canceledRefreshController = RefreshController();

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy h:mm a').format(dateTime);
  }

  Widget _buildBookingCard(
    Booking booking,
    bool isActive,
    RefreshController controller,
  ) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final now = DateTime.now();
    final isCancelable = booking.status.toLowerCase() == 'active' &&
        booking.endTime.isAfter(now);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(Icons.ev_station,
                      color: colorScheme.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.stationName ?? 'EV Station',
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: colorScheme.primary, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking.address ?? '',
                              style: textTheme.bodySmall?.copyWith(
                                  color:
                                      colorScheme.onSurface.withOpacity(0.7)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: booking.status.toLowerCase() == 'active'
                        ? Colors.green
                        : booking.status.toLowerCase() == 'canceled'
                            ? Colors.red
                            : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        booking.status.toLowerCase() == 'active'
                            ? Icons.check_circle
                            : booking.status.toLowerCase() == 'canceled'
                                ? Icons.cancel
                                : Icons.hourglass_bottom,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.status.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Start: ${formatDateTime(booking.startTime)}',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time, color: colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'End: ${formatDateTime(booking.endTime)}',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.attach_money, color: colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Total: ₹${booking.totalPrice.toStringAsFixed(2)}',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Booking ID: ${booking.id.substring(0, 8)}',
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
                ),
                const Spacer(),
                isCancelable
                    ? GestureDetector(
                        onTap: () async {
                          final confirmed = await Get.dialog<bool>(
                            AlertDialog(
                              backgroundColor: colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Row(
                                children: [
                                  Icon(Icons.cancel,
                                      color: Colors.red, size: 32),
                                  const SizedBox(width: 8),
                                  const Text('Cancel Booking',
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              content: Text(
                                'Are you sure you want to cancel this booking?\nThis action cannot be undone.',
                                style: textTheme.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(result: false),
                                  child: const Text('No'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => Get.back(result: true),
                                  child: const Text('Yes, Cancel'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            final success =
                                await bookingController.cancelBooking(
                                    bookingId: booking.id,
                                    portId: booking.portId,
                                    slotId: booking.slotId,
                                    stationId: booking.stationId);
                            if (success) {
                              Get.snackbar(
                                'Booking Canceled',
                                'Your booking has been canceled.',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 16,
                                icon: const Icon(Icons.cancel,
                                    color: Colors.white),
                                duration: const Duration(seconds: 3),
                              );
                              await bookingController.fetchUserBookings();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(
      List<Booking> bookings, bool isActive, RefreshController controller) {
    if (bookings.isEmpty) {
      return _buildEmptyState(Get.context!,
          'No ${isActive ? 'active' : 'completed'} bookings found.');
    }
    return SmartRefresher(
      controller: controller,
      header: const WaterDropHeader(
        waterDropColor: colorPrimary,
      ),
      onRefresh: () async {
        await bookingController.fetchUserBookings();
        controller.refreshCompleted();
      },
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(bookings[index], isActive, controller);
        },
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
            _buildBookingList(
                controller.activeBookings, true, _activeRefreshController),
            _buildBookingList(controller.completedBookings, false,
                _completedRefreshController),
            _buildBookingList(
                controller.canceledBookings, false, _canceledRefreshController),
          ],
        ),
      ),
    );
  }
}
