import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/calendar_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../provider/calendar_provider.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}
class _CalenderPageState extends State<CalenderPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final provider = Provider.of<CalendarProvider>(context, listen: false);

    provider.getCalenderList(_selectedDay);
    setState(() {}); // 🔥 Force rebuild once data is ready
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, provider, child) {
        final selectedEvents = provider.getEventsForDay(_selectedDay);

        return Stack(
          children: [
            Column(
              children: [
                TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: commonTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorProduct,
                    ),
                  ),
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  eventLoader: provider.getEventsForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    provider.getCalenderList(focusedDay); // 🔥 fetch new month
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: colorProduct,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: colorProduct.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle:
                    commonTextStyle(color: Colors.redAccent),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events == null || events.isEmpty) return const SizedBox();

                      final firstEvent = events.first;
                      if (firstEvent is! Map<String, dynamic>) return const SizedBox();

                      final type = firstEvent['type']?.toString() ?? '';

                      Color color;
                      if (type == 'leave') {
                        color = Colors.red;
                      } else if (type == 'attendance') {
                        color = Colors.green;
                      } else {
                        color = Colors.blue;
                      }

                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 20, thickness: 0.5, color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _Legend(color: Colors.red, label: 'Leave'),
                    _Legend(color: Colors.green, label: 'Attendance'),
                    _Legend(color: Colors.blue, label: 'Birthday'),
                  ],
                ),
                const Divider(height: 20, thickness: 0.5, color: Colors.grey),
                Expanded(
                  child: selectedEvents.isEmpty
                      ? Center(
                    child: commonText(
                      text: "No events on this day",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      : ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = selectedEvents[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: commonBoxDecoration(

                          borderColor: colorBorder
                        ),
                        child: Row(
                          spacing: 10,
                          children: [

                            Container(
                              decoration: commonBoxDecoration(
                                color: event['type'] == 'leave'
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : event['type'] == 'attendance'
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.blue.withValues(alpha: 0.1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  event['type'] == 'leave'
                                      ? Icons.event_busy
                                      : event['type'] == 'attendance'
                                      ? Icons.check_circle
                                      : Icons.cake,
                                  color: event['type'] == 'leave'
                                      ? Colors.red
                                      : event['type'] == 'attendance'
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                              ),
                            ),

                           Expanded(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 commonText(
                                   color: colorProduct,
                                   text: event['title'] ?? '',
                                   fontWeight: FontWeight.w500,
                                 ),
                                 commonText(
                                   text:
                                   "Type: ${event['type'].toString().toUpperCase()}",
                                   fontSize: 10,
                                 )
                               ],
                             ),
                           )

                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            provider.isLoading?showLoaderList():SizedBox.shrink()
          ],
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: commonBoxDecoration(color: color, shape: BoxShape.circle),
        ),

        commonText(text: label, fontWeight: FontWeight.w500,fontSize: 12),
      ],
    );
  }
}