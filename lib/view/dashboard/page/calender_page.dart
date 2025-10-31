import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/calendar_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarProvider(),
      child: Container(

        child: Consumer<CalendarProvider>(
          builder: (context, provider, child) {
            final selectedEvents = provider.getEventsForDay(_selectedDay);

            return Column(
              children: [
                TableCalendar(
                  headerStyle:  HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: commonTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorProduct,
                    ),
                  ),
                  focusedDay: _selectedDay,
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  eventLoader: provider.getEventsForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: colorProduct,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: colorProduct.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: commonTextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    selectedTextStyle: commonTextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    weekendTextStyle: commonTextStyle (color: Colors.redAccent),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return const SizedBox();

                      final firstEvent = events.first;
                      if (firstEvent is! Map<String, dynamic>) {
                        return const SizedBox();
                      }

                      final eventType = firstEvent['type']?.toString() ?? '';
                      Color color;
                      if (eventType == 'leave') {
                        color = Colors.red;
                      } else if (eventType == 'attendance') {
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
                const SizedBox(height: 5),
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _Legend(color: Colors.red, label: 'Leave'),
                    _Legend(color: Colors.green, label: 'Attendance'),
                    _Legend(color: Colors.blue, label: 'Holiday'),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(height: 20, thickness: 0.5, color: Colors.grey),

                // Show selected date events below calendar
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
                          padding: EdgeInsets.zero,
                          itemCount: selectedEvents.length,
                          itemBuilder: (context, index) {
                            final event = selectedEvents[index];
                            return Container(
                              decoration: commonBoxDecoration(
                                borderColor: colorBorder,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: Icon(
                                  event['type'] == 'leave'
                                      ? Icons.event_busy
                                      : event['type'] == 'attendance'
                                      ? Icons.check_circle
                                      : Icons.flag,
                                  color: event['type'] == 'leave'
                                      ? Colors.red
                                      : event['type'] == 'attendance'
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                                title: commonText(
                                  text: event['title'] ?? '',
                                  fontWeight: FontWeight.w500,
                                ),
                                subtitle: commonText(
                                  fontSize: 12,
                                  text:
                                      'Type: ${event['type'].toString().toUpperCase()}',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
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
