import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nobile/Model/StationModel.dart';

class StationDetailsScreen extends StatefulWidget {
  final ChargingStation station;

  const StationDetailsScreen({super.key, required this.station});

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  Map<String, DateTime> selectedDates = {};

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

  @override
  void initState() {
    super.initState();
    for (var port in widget.station.ports) {
      selectedDates[port.id] = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final station = widget.station;

    return Scaffold(
      appBar: AppBar(title: Text(station.stationName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (station.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(station.imageUrl,
                    height: 200, width: double.infinity, fit: BoxFit.cover),
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
                    color: station.verified ? Colors.green : Colors.grey),
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
                children:
                    station.amenities.map((a) => Chip(label: Text(a))).toList(),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Charging Ports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...station.ports.map((port) {
              final selectedDay = selectedDates[port.id]!;
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
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(DateFormat('EEE\ndd MMM').format(date),
                                textAlign: TextAlign.center),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedDates[port.id] = date;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (todaySlots.isEmpty)
                    const Text("No slots available for this day."),
                  ...todaySlots.map((slot) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                          slot.isBooked ? Icons.lock : Icons.lock_open,
                          color: slot.isBooked ? Colors.red : Colors.green),
                      title: Text(
                          '${formatTime(slot.startTime)} - ${formatTime(slot.endTime)}'),
                      subtitle: Text(slot.isBooked ? 'Booked' : 'Available'),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
