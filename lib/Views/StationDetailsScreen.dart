import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nobile/Controller/BookingController.dart';
import 'package:nobile/Controller/StationDetailController.dart';
import 'package:nobile/Model/StationModel.dart';
import 'package:nobile/Views/Widgets/SmallLoader.dart';

class StationDetailsScreen extends StatelessWidget {
  final String stationId;

  const StationDetailsScreen({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    final stationController = Get.put(StationDetailsController(stationId));
    final bookingController = Get.put(BookingController());

    // Date pickers per port
    final Map<String, Rx<DateTime>> selectedDates = {};

    List<DateTime> getNext7Days() {
      return List.generate(
          7, (index) => DateTime.now().add(Duration(days: index)));
    }

    List<Slot> getSlotsForDay(List<Slot> slots, DateTime day) {
      return slots
          .where((slot) =>
              slot.startTime.year == day.year &&
              slot.startTime.month == day.month &&
              slot.startTime.day == day.day)
          .toList();
    }

    String formatTime(DateTime time) => DateFormat('h:mm a').format(time);

    Future<void> handleBooking(Slot slot, ChargingPort port) async {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start Time: ${formatTime(slot.startTime)}'),
              Text('End Time: ${formatTime(slot.endTime)}'),
              Text('Port Type: ${port.type}'),
              Text('Price: \$${port.pricing}/hr'),
              Text(
                  'Total Price: \$${(port.pricing * (slot.endTime.difference(slot.startTime).inHours)).toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Book Now'),
            ),
          ],
        ),
      );

      if (result == true) {
        final success = await bookingController.createBooking(
          stationId: stationId,
          portId: port.id,
          slotId: slot.id,
          startTime: slot.startTime,
          endTime: slot.endTime,
          totalPrice:
              port.pricing * (slot.endTime.difference(slot.startTime).inHours),
        );

        if (success) {
          Get.back(); // Return to previous screen
          Get.snackbar(
            'Success',
            'Booking created successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Station Details")),
      body: Obx(() {
        final station = stationController.station.value;

        if (station == null) {
          return const Center(child: SmallLoader());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (station.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    station.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(station.stationName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Icon(
                    station.verified ? Icons.verified : Icons.verified_outlined,
                    color: station.verified ? Colors.green : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('${station.city}, ${station.state}, ${station.country}'),
              Text('${station.address}, Zip: ${station.zipCode}'),
              const SizedBox(height: 12),
              if (station.description.isNotEmpty) ...[
                const Text('Description',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(station.description),
                const SizedBox(height: 16),
              ],
              if (station.amenities.isNotEmpty) ...[
                const Text('Amenities',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: station.amenities
                      .map((a) => Chip(label: Text(a)))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              const Text('Charging Ports',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...station.ports.map((port) {
                // Initialize selected date if not present
                selectedDates.putIfAbsent(
                    port.id, () => Rx<DateTime>(DateTime.now()));

                final dateRx = selectedDates[port.id]!;

                return Obx(() {
                  final selectedDay = dateRx.value;
                  final dayList = getNext7Days();
                  final todaySlots = getSlotsForDay(port.slots, selectedDay);

                  return ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                    childrenPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.grey.shade100,
                    collapsedBackgroundColor: Colors.grey.shade200,
                    title: Row(
                      children: [
                        Text(port.type,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Text('\$${port.pricing}/hr',
                            style: const TextStyle(color: Colors.green)),
                        const Spacer(),
                        Icon(port.isActive ? Icons.power : Icons.power_off,
                            color: port.isActive ? Colors.green : Colors.red),
                      ],
                    ),
                    children: [
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dayList.length,
                          itemBuilder: (context, index) {
                            final date = dayList[index];
                            final isSelected = date.day == selectedDay.day &&
                                date.month == selectedDay.month &&
                                date.year == selectedDay.year;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(
                                    DateFormat('EEE\ndd MMM').format(date),
                                    textAlign: TextAlign.center),
                                selected: isSelected,
                                onSelected: (_) => dateRx.value = date,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (todaySlots.isEmpty)
                        const Text("No slots available for this day."),
                      ...todaySlots.map((slot) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                                slot.isBooked ? Icons.lock : Icons.lock_open,
                                color:
                                    slot.isBooked ? Colors.red : Colors.green),
                            title: Text(
                                '${formatTime(slot.startTime)} - ${formatTime(slot.endTime)}'),
                            subtitle:
                                Text(slot.isBooked ? 'Booked' : 'Available'),
                            trailing: !slot.isBooked
                                ? ElevatedButton(
                                    onPressed: () => handleBooking(slot, port),
                                    child: const Text('Book'),
                                  )
                                : null,
                          )),
                    ],
                  );
                });
              }),
            ],
          ),
        );
      }),
    );
  }
}
