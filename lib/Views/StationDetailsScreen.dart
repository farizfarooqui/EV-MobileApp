import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/StationDetailController.dart';
import 'package:nobile/Model/StationModel.dart';
import 'package:nobile/Views/Widgets/SmallLoader.dart';

class StationDetailsScreen extends StatelessWidget {
  final String stationId;

  const StationDetailsScreen({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    final stationController = Get.put(StationDetailsController(stationId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    // Date pickers per port
    final Map<String, Rx<DateTime>> selectedDates = {};

    List<DateTime> getNext7Days() {
      return List.generate(
          6, (index) => DateTime.now().add(Duration(days: index + 1)));
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
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF121212)
          : Colors.white,
      appBar: AppBar(
        title: const Text("Station Details"),
        // backgroundColor: colorScheme.background,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        final station = stationController.station.value;
        if (station == null) {
          return const Center(child: SmallLoader());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Glowing accent
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 16),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.7),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                  color: colorScheme.primary,
                ),
                child:
                    const Icon(Icons.ev_station, color: Colors.white, size: 36),
              ),
              if (station.imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      station.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            station.stationName,
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onBackground,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          station.verified
                              ? Icons.verified
                              : Icons.verified_outlined,
                          color: station.verified
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${station.city}, ${station.state}, ${station.country}',
                      style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7)),
                    ),
                    Text(
                      '${station.address}, Zip: ${station.zipCode}',
                      style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 16),
                    if (station.description.isNotEmpty) ...[
                      Text('Description',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Text(station.description, style: textTheme.bodyMedium),
                      const SizedBox(height: 16),
                    ],
                    if (station.amenities.isNotEmpty) ...[
                      Text('Amenities',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        children: station.amenities
                            .map((a) => Chip(
                                  label: Text(
                                    a,
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: colorScheme.primary),
                                  ),
                                  backgroundColor:
                                      colorScheme.primary.withOpacity(0.08),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: colorPrimary),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text('Charging Ports',
                        style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    ...station.ports.map((port) {
                      selectedDates.putIfAbsent(
                          port.id, () => Rx<DateTime>(DateTime.now()));
                      final dateRx = selectedDates[port.id]!;
                      return Obx(() {
                        final selectedDay = dateRx.value;
                        final dayList = getNext7Days();
                        final todaySlots =
                            getSlotsForDay(port.slots, selectedDay);
                        return Card(
                          color: theme.brightness == Brightness.dark
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: ExpansionTile(
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor:
                                  theme.brightness == Brightness.dark
                                      ? const Color(0xFF1E1E1E)
                                      : Colors.white,
                              collapsedBackgroundColor:
                                  theme.brightness == Brightness.dark
                                      ? const Color(0xFF1E1E1E)
                                      : Colors.white,
                              title: Row(
                                children: [
                                  Text(port.type,
                                      style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 10),
                                  Text('	${port.pricing}/hr',
                                      style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.primary)),
                                  const Spacer(),
                                  Icon(
                                      port.isActive
                                          ? Icons.power
                                          : Icons.power_off,
                                      color: port.isActive
                                          ? colorScheme.primary
                                          : colorScheme.error),
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
                                      final isSelected =
                                          date.day == selectedDay.day &&
                                              date.month == selectedDay.month &&
                                              date.year == selectedDay.year;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: ChoiceChip(
                                          label: Text(
                                            DateFormat('EEE\ndd MMM')
                                                .format(date),
                                            textAlign: TextAlign.center,
                                          ),
                                          checkmarkColor: colorPrimary,
                                          selected: isSelected,
                                          selectedColor: colorScheme.primary
                                              .withOpacity(0.2),
                                          backgroundColor: theme.brightness ==
                                                  Brightness.dark
                                              ? const Color(0xFF1E1E1E)
                                              : Colors.white,
                                          side: BorderSide(
                                            color: isSelected
                                                ? colorScheme.primary
                                                : (theme.brightness ==
                                                        Brightness.dark
                                                    ? Colors.white24
                                                    : Colors.black12),
                                            width: 1.5,
                                          ),
                                          labelStyle:
                                              textTheme.bodySmall?.copyWith(
                                            color: isSelected
                                                ? colorScheme.primary
                                                : colorScheme.onSurface,
                                          ),
                                          onSelected: (_) =>
                                              dateRx.value = date,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...todaySlots.map((slot) => Obx(() {
                                      final selectedSlotId = stationController
                                          .selectedSlotPerPort[port.id];
                                      final isSelected =
                                          selectedSlotId == slot.id;
                                      return Card(
                                        color:
                                            theme.brightness == Brightness.dark
                                                ? const Color(0xFF1E1E1E)
                                                : Colors.white,
                                        elevation: 1,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 0),
                                          leading: Radio<String>(
                                            value: slot.id,
                                            groupValue: selectedSlotId,
                                            onChanged: slot.isBooked
                                                ? null
                                                : (val) {
                                                    stationController
                                                        .selectSlot(
                                                            port.id, slot.id);
                                                  },
                                            activeColor: colorScheme.primary,
                                          ),
                                          title: Text(
                                              '${formatTime(slot.startTime)} - ${formatTime(slot.endTime)}',
                                              style: textTheme.bodyMedium),
                                          subtitle: RichText(
                                            text: TextSpan(
                                              text: 'Status: ',
                                              style: textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: colorScheme
                                                          .onBackground
                                                          .withOpacity(0.7)),
                                              children: [
                                                TextSpan(
                                                  text: slot.isBooked
                                                      ? 'Booked'
                                                      : 'Available',
                                                  style: TextStyle(
                                                    color: slot.isBooked
                                                        ? colorScheme.error
                                                        : colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: isSelected && !slot.isBooked
                                              ? OutlinedButton(
                                                  onPressed: () async {
                                                    final confirmed =
                                                        await Get.dialog<bool>(
                                                      AlertDialog(
                                                        backgroundColor:
                                                            colorScheme.surface,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        title: Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color:
                                                                    colorScheme
                                                                        .primary,
                                                                size: 32),
                                                            const SizedBox(
                                                                width: 8),
                                                            const Text(
                                                              'Confirm Booking',
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Text(
                                                          'Do you want to book this slot?\n\nTime: ${formatTime(slot.startTime)} - ${formatTime(slot.endTime)}',
                                                          style: textTheme
                                                              .bodyMedium,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Get.back(
                                                                    result:
                                                                        false),
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  colorScheme
                                                                      .primary,
                                                              foregroundColor:
                                                                  colorScheme
                                                                      .onPrimary,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                            ),
                                                            onPressed: () =>
                                                                Get.back(
                                                                    result:
                                                                        true),
                                                            child: const Text(
                                                              'Confirm',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    if (confirmed == true) {
                                                      await stationController
                                                          .bookSlot(
                                                        portId: port.id,
                                                        stationName:
                                                            station.stationName,
                                                        address:
                                                            station.address,
                                                        slotId: slot.id,
                                                        startTime:
                                                            slot.startTime,
                                                        endTime: slot.endTime,
                                                        totalPrice:
                                                            port.pricing,
                                                      );
                                                      Get.snackbar(
                                                        'Booking Confirmed',
                                                        'Your slot has been booked successfully!',
                                                        backgroundColor:
                                                            colorScheme.primary,
                                                        colorText: colorScheme
                                                            .onPrimary,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        margin: const EdgeInsets
                                                            .all(16),
                                                        borderRadius: 16,
                                                        icon: Icon(
                                                            Icons.check_circle,
                                                            color: colorScheme
                                                                .onPrimary),
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                      );
                                                    }
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color:
                                                            colorScheme.primary,
                                                        width: 1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                    foregroundColor:
                                                        colorScheme.primary,
                                                  ),
                                                  child: const Text('Book'),
                                                )
                                              : null,
                                        ),
                                      );
                                    })),
                              ],
                            ),
                          ),
                        );
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
