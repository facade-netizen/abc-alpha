import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'button.dart';
import 'colors.dart';
import 'navigators.dart';
import 'sized_box_hw.dart';
import 'style.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime?) onDateSelected;
  final bool? allowFutureDates;

  const CustomDatePickerDialog({super.key, required this.initialDate, required this.onDateSelected, this.allowFutureDates = false});

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime selectedDate;
  late ValueNotifier<int> selectedYear;
  late ValueNotifier<int> selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedYear = ValueNotifier(selectedDate.year);
    selectedMonth = ValueNotifier(selectedDate.month);
    selectedYear.addListener(_onDateHeaderChanged);
    selectedMonth.addListener(_onDateHeaderChanged);
  }

  void _onDateHeaderChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    selectedYear.removeListener(_onDateHeaderChanged);
    selectedMonth.removeListener(_onDateHeaderChanged);
    selectedYear.dispose();
    selectedMonth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: 300,
        padding: EdgeInsets.zero,
        color: white,
        child: Column(mainAxisSize: MainAxisSize.min, children: [_buildHeader(), _buildCalendar(widget.allowFutureDates), _buildButtons()]),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Color(0xFF3A5A8A),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left, color: Colors.white),
            onPressed: () {
              if (selectedMonth.value == 1) {
                selectedMonth.value = 12;
                selectedYear.value--;
              } else {
                selectedMonth.value--;
              }
            },
          ),
          Row(
            children: [
              Container(
                width: 100,
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.6),
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<int>(
                    valueListenable: selectedYear,
                    isExpanded: true,
                    buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 0), height: 28),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    iconStyleData: const IconStyleData(icon: Icon(Icons.arrow_drop_down, size: 16, color: Colors.black)),
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    items: List.generate(50, (i) => DateTime.now().year - 25 + i).map((year) => DropdownItem<int>(value: year, child: Text(year.toString()))).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedYear.value = value;
                      }
                    },
                  ),
                ),
              ),
              wb4,
              Container(
                width: 100,
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500, width: 0.6),
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<int>(
                    valueListenable: selectedMonth,
                    isExpanded: true,
                    buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 0), height: 28),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    iconStyleData: const IconStyleData(icon: Icon(Icons.arrow_drop_down, size: 16, color: Colors.black)),
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    items: List.generate(12, (i) => i + 1).map((month) => DropdownItem<int>(value: month, child: Text(DateFormat.MMM().format(DateTime(0, month))))).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedMonth.value = value;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.arrow_right, color: Colors.white),
            onPressed: () {
              if (selectedMonth.value == 12) {
                selectedMonth.value = 1;
                selectedYear.value++;
              } else {
                selectedMonth.value++;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(bool? allowFutureDates) {
    List<Widget> rows = [];
    rows.add(
      Container(
        color: Colors.grey.shade300,
        child: Row(
          children: [
            _cell("wk #", bold: true),
            ...["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((d) => _cell(d, bold: true)),
          ],
        ),
      ),
    );

    DateTime today = DateTime.now();
    DateTime lastDate = today;
    DateTime minDate = today.subtract(const Duration(days: 90));
    DateTime firstDayOfMonth = DateTime(selectedYear.value, selectedMonth.value, 1);
    int firstWeekday = firstDayOfMonth.weekday; // Mon=1...Sun=7
    DateTime startDate = firstDayOfMonth.subtract(Duration(days: firstWeekday - 1));

    for (int week = 0; week < 6; week++) {
      DateTime weekStart = startDate.add(Duration(days: week * 7));
      int weekNum = _weekNumber(weekStart);

      rows.add(
        Row(
          children: [
            _cell(weekNum.toString(), bold: true),
            ...List.generate(7, (day) {
              DateTime currentDay = weekStart.add(Duration(days: day));
              bool isSelected = currentDay.year == selectedDate.year && currentDay.month == selectedDate.month && currentDay.day == selectedDate.day;
              bool isCurrentMonth = currentDay.month == selectedMonth.value;
              bool isFutureDate = (allowFutureDates != true) && currentDay.isAfter(lastDate);
              bool isBeforeMinDate = currentDay.isBefore(minDate);
              Color textColor = Colors.black;
              if (day == 5) textColor = Colors.blue;
              if (day == 6) textColor = Colors.red;
              if (isFutureDate || isBeforeMinDate) {
                textColor = Colors.grey;
              }
              return GestureDetector(
                onTap: (isFutureDate || isBeforeMinDate)
                    ? null
                    : () {
                        setState(() {
                          selectedDate = currentDay;
                        });
                        widget.onDateSelected(selectedDate);
                        removeScreen(context);
                      },
                child: _cell(
                  currentDay.day.toString(),
                  color: isSelected
                      ? Colors.amber
                      : isCurrentMonth
                      ? Colors.white
                      : Colors.grey.shade200,
                  textColor: textColor,
                ),
              );
            }),
          ],
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _cell(String text, {bool bold = false, Color? color, Color textColor = Colors.black}) {
    return Container(
      width: 36,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: textColor, fontSize: 12),
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomOutlineTextButton(
            height: 25,
            width: 50,
            onPressed: () {
              widget.onDateSelected(selectedDate);
              removeScreen(context);
            },
            title: 'Clear',
            fontSize: 12,
            textColor: black,
          ),
          CustomOutlineTextButton(
            height: 25,
            width: 50,
            onPressed: () {
              DateTime today = DateTime.now();
              setState(() {
                selectedDate = today;
                selectedYear.value = today.year;
                selectedMonth.value = today.month;
              });
              widget.onDateSelected(selectedDate);
              removeScreen(context);
            },
            title: 'Today',
            fontSize: 12,
            textColor: black,
          ),
          CustomOutlineTextButton(
            height: 25,
            width: 50,
            onPressed: () {
              widget.onDateSelected(selectedDate);
              removeScreen(context);
            },
            title: 'Close',
            textColor: black,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  int _weekNumber(DateTime date) {
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);
    int daysSinceFirst = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirst + firstDayOfYear.weekday) / 7).ceil();
  }
}

class DateBox extends StatelessWidget {
  final VoidCallback? onTap;
  final Color borderColor;
  final Color focusedColor;
  final double borderRadius;
  final double height;
  final double width;
  final double fontSize;
  final TextEditingController? controller;
  const DateBox({
    super.key,
    this.onTap,
    this.borderColor = Colors.grey,
    this.focusedColor = Colors.black,
    this.borderRadius = 5,
    this.height = 25,
    this.width = 120,
    this.fontSize = 12,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        decoration: tfInputDecoration.copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          suffixIcon: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Container(
                decoration: BoxDecoration(color: tileOrFontColor, borderRadius: BorderRadius.circular(3)),
                child: Icon(Icons.calendar_month, size: 15, color: white),
              ),
            ),
          ),
        ),
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

class PeriodFilterCard extends StatefulWidget {
  const PeriodFilterCard({super.key, required this.fromDateController, required this.toDateController});

  final TextEditingController fromDateController;
  final TextEditingController toDateController;

  @override
  State<PeriodFilterCard> createState() => _PeriodFilterCardState();
}

class _PeriodFilterCardState extends State<PeriodFilterCard> {
  OverlayEntry? _overlayEntry;
  static const double cellWidth = 35;
  static const double totalWidth = cellWidth * 8 + 2;

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  int _weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirst = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirst + firstDayOfYear.weekday) / 7).ceil();
  }

  void _swapFromTo(DateTime from, DateTime to) {
    widget.fromDateController.text = DateFormat('yyyy-MM-dd').format(from);
    widget.toDateController.text = DateFormat('yyyy-MM-dd').format(to);
  }

  Widget _cell(String text, {bool bold = false, Color? color, Color textColor = Colors.black}) {
    return Container(
      width: cellWidth,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: textColor, fontSize: 12),
      ),
    );
  }

  Widget _buildCalendar(DateTime selectedDate, int selectedYear, int selectedMonth, Function(DateTime) onDateSelected) {
    final today = DateTime.now();
    final lastDate = today;
    final minDate = today.subtract(const Duration(days: 60));

    final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    final startDate = firstDayOfMonth.subtract(Duration(days: firstWeekday - 1));

    List<Widget> rows = [];

    rows.add(
      Container(
        width: totalWidth,
        color: Colors.grey.shade300,
        child: Row(
          children: [
            _cell("wk #", bold: true),
            ...["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((d) => _cell(d, bold: true)),
          ],
        ),
      ),
    );

    for (int week = 0; week < 6; week++) {
      final weekStart = startDate.add(Duration(days: week * 7));
      final weekNum = _weekNumber(weekStart);

      rows.add(
        Row(
          children: [
            _cell(weekNum.toString(), bold: true),
            ...List.generate(7, (day) {
              final currentDay = weekStart.add(Duration(days: day));

              final isCurrentMonth = currentDay.month == selectedMonth && currentDay.year == selectedYear;

              //hide prev/next month dates
              if (!isCurrentMonth) {
                return _cell('', color: Colors.white, textColor: Colors.transparent);
              }

              final isSelected = currentDay.year == selectedDate.year && currentDay.month == selectedDate.month && currentDay.day == selectedDate.day;

              final isFuture = currentDay.isAfter(lastDate);
              final isPastLimit = currentDay.isBefore(minDate);

              //final textColor = (isFuture || isPastLimit) ? Colors.grey : Colors.black;
              Color textColor = Colors.black;
              if (day == 5) textColor = Colors.blue;
              if (day == 6) textColor = Colors.red;
              if (isFuture || isPastLimit) {
                textColor = Colors.grey;
              }
              return InkWell(
                onTap: (isFuture || isPastLimit)
                    ? null
                    : () {
                        onDateSelected(currentDay);
                        _removeOverlay();
                      },
                child: _cell(
                  currentDay.day.toString(),
                  color: isFuture || isPastLimit
                      ? Color(0xFFEEEEEE)
                      : isSelected
                      ? Colors.amber
                      : isCurrentMonth
                      ? Colors.white
                      : Colors.grey.shade200,
                  textColor: textColor,
                ),
              );
            }),
          ],
        ),
      );
    }

    return Column(children: rows);
  }

  void _showOverlay(BuildContext context, GlobalKey triggerKey, DateTime initialDate, Function(DateTime?) onDateSelected) {
    final renderBox = triggerKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    //persistent state using ValueNotifier (no reset issue)
    final selectedDateNotifier = ValueNotifier<DateTime>(initialDate);
    final selectedYearNotifier = ValueNotifier<int>(initialDate.year);
    final selectedMonthNotifier = ValueNotifier<int>(initialDate.month);

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return GestureDetector(
          // onTap: _removeOverlay,
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.transparent)),
              Positioned(
                left: position.dx,
                top: position.dy + 30,
                child: Material(
                  elevation: 8,
                  child: ValueListenableBuilder(
                    valueListenable: selectedMonthNotifier,
                    builder: (context, _, __) {
                      return ValueListenableBuilder(
                        valueListenable: selectedYearNotifier,
                        builder: (context, __, ___) {
                          return ValueListenableBuilder(
                            valueListenable: selectedDateNotifier,
                            builder: (context, selectedDate, ____) {
                              final selectedYear = selectedYearNotifier.value;
                              final selectedMonth = selectedMonthNotifier.value;

                              return Container(
                                width: totalWidth,
                                decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(color: Colors.grey.shade400),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // HEADER
                                    Container(
                                      height: 50,
                                      width: totalWidth,
                                      color: tileOrFontColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.arrow_left, color: Colors.white),
                                            onPressed: () {
                                              if (selectedMonth == 1) {
                                                selectedMonthNotifier.value = 12;
                                                selectedYearNotifier.value--;
                                              } else {
                                                selectedMonthNotifier.value--;
                                              }
                                            },
                                          ),
                                          Row(
                                            children: [
                                              MenuAnchor(
                                                style: MenuStyle(
                                                  backgroundColor: WidgetStateProperty.all(white),
                                                  side: WidgetStateProperty.all(BorderSide(color: black, width: 0.5)),
                                                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                                                ),
                                                builder: (context, controller, child) {
                                                  return InkWell(
                                                    onTap: () => controller.isOpen ? controller.close() : controller.open(),
                                                    child: Container(
                                                      width: 80,
                                                      height: 28,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text('$selectedYear'),
                                                            Icon(Icons.arrow_drop_down, color: black),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                menuChildren: List.generate(3, (i) => DateTime.now().year - 1 + i).map((year) {
                                                  return SizedBox(
                                                    width: 80,
                                                    height: 28,
                                                    child: MenuItemButton(
                                                      onPressed: () {
                                                        selectedYearNotifier.value = year;
                                                      },
                                                      child: Text('$year', style: TextStyle(color: black)),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              wb4,
                                              MenuAnchor(
                                                style: MenuStyle(
                                                  backgroundColor: WidgetStateProperty.all(white),
                                                  side: WidgetStateProperty.all(BorderSide(color: black, width: 0.5)),
                                                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                                                ),
                                                builder: (context, controller, child) {
                                                  return InkWell(
                                                    onTap: () => controller.isOpen ? controller.close() : controller.open(),
                                                    child: Container(
                                                      width: 100,
                                                      height: 28,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(DateFormat.MMM().format(DateTime(0, selectedMonth))),
                                                            Icon(Icons.arrow_drop_down, color: black),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                menuChildren: List.generate(12, (i) => i + 1).map((m) {
                                                  return SizedBox(
                                                    width: 100,
                                                    height: 28,
                                                    child: MenuItemButton(
                                                      onPressed: () {
                                                        selectedMonthNotifier.value = m;
                                                      },
                                                      child: Text(DateFormat.MMM().format(DateTime(0, m)), style: TextStyle(color: black)),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.arrow_right, color: Colors.white),
                                            onPressed: () {
                                              if (selectedMonth == 12) {
                                                selectedMonthNotifier.value = 1;
                                                selectedYearNotifier.value++;
                                              } else {
                                                selectedMonthNotifier.value++;
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    // CALENDAR
                                    _buildCalendar(selectedDate, selectedYear, selectedMonth, (date) {
                                      selectedDateNotifier.value = date;
                                      onDateSelected(date);
                                    }),

                                    // BUTTONS
                                    Container(
                                      width: totalWidth,
                                      decoration: BoxDecoration(
                                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Row(
                                        spacing: 5,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            height: 25,
                                            child: CustomOutlineButton(
                                              action: () {
                                                onDateSelected(null);
                                                _removeOverlay();
                                              },
                                              title: 'Clear',
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: 25,
                                              child: CustomOutlineButton(
                                                action: () {
                                                  final today = DateTime.now();
                                                  onDateSelected(today);
                                                  _removeOverlay();
                                                },
                                                title: 'Today',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            height: 25,
                                            child: CustomOutlineButton(action: _removeOverlay, title: 'Close'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    final fiveDaysBefore = today.subtract(const Duration(days: 5));

    if (widget.fromDateController.text.isEmpty) {
      widget.fromDateController.text = DateFormat('yyyy-MM-dd').format(fiveDaysBefore);
    }

    if (widget.toDateController.text.isEmpty) {
      widget.toDateController.text = DateFormat('yyyy-MM-dd').format(today);
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  final fromKey = GlobalKey();
  final toKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text("Period"),
        Wrap(
          children: [
            DateBox(
              key: fromKey,
              controller: widget.fromDateController,
              onTap: () {
                _showOverlay(context, fromKey, DateTime.now(), (date) {
                  if (date != null) {
                    final toText = widget.toDateController.text;

                    if (toText.isNotEmpty) {
                      final toDate = DateFormat('yyyy-MM-dd').parse(toText);
                      // if from > to → SWAP
                      if (date.isAfter(toDate)) {
                        _swapFromTo(toDate, date);
                        return;
                      }
                    }

                    widget.fromDateController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                });
              },
            ),
            wb4,
            Container(
              decoration: BoxDecoration(
                color: white.withValues(alpha: 0.5),
                border: Border.all(color: grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 30,
              width: 50,
              child: const Center(
                child: Text('09:00', style: TextStyle(fontSize: 13, color: grey)),
              ),
            ),
          ],
        ),
        const Text("to"),
        Wrap(
          children: [
            DateBox(
              key: toKey,
              controller: widget.toDateController,
              onTap: () {
                _showOverlay(context, toKey, DateTime.now(), (date) {
                  if (date != null) {
                    final fromText = widget.fromDateController.text;
                    if (fromText.isNotEmpty) {
                      final fromDate = DateFormat('yyyy-MM-dd').parse(fromText);
                      // if to < from → SWAP
                      if (date.isBefore(fromDate)) {
                        _swapFromTo(date, fromDate);
                        return;
                      }
                    }

                    widget.toDateController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                });
              },
            ),
            wb4,
            Container(
              decoration: BoxDecoration(
                color: white.withValues(alpha: 0.5),
                border: Border.all(color: grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 30,
              width: 50,
              child: const Center(
                child: Text('08:59', style: TextStyle(fontSize: 13, color: grey)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({super.key, this.action, required this.title});
  final void Function()? action;
  final String title;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: white,
        side: BorderSide(color: Color(0xFFC9C9C9)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: black),
      ),
    );
  }
}
