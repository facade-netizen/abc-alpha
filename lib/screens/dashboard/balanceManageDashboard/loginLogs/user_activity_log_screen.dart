import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_user_activity_logs_bloc.dart';
import '../../../../model/activity_log_model.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/calender.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/custom_table.dart';
import '../../../../reusable/formatters.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/style.dart';

class UserActivityLogScreen extends StatefulWidget {
  const UserActivityLogScreen({super.key});

  @override
  State<UserActivityLogScreen> createState() => _UserActivityLogScreenState();
}

class _UserActivityLogScreenState extends State<UserActivityLogScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  DateTime get now => DateTime.now();
  void fetchActivityLogs({DateTime? fromDate, DateTime? toDate}) {
    if (userIdController.text.isEmpty) {
      showSnackBar(context, "Please select user from above", error: true);
      return;
    }
    final from = stringDateToDateTimeString(fromDate?.toString() ?? fromDateController.text, startOfDay: true);
    final to = stringDateToDateTimeString(toDate?.toString() ?? toDateController.text);
    context.read<FetchUserActivityLogsBloc>().add(FetchUserActivityLogs(userId: userIdController.text, from: from, to: to));
  }

  Widget buildQuickFilterButton(String title, DateTime fromDate) {
    return CustomOCTAButton(
      title: title,
      action: () => fetchActivityLogs(fromDate: fromDate, toDate: now),
    );
  }

  @override
  void dispose() {
    userIdController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text("Login Logs", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              hb20,
              Row(
                children: [
                  const Text('User Id'),
                  wb10,
                  SizedBox(
                    height: 30,
                    width: 200,
                    child: TextFormField(
                      controller: userIdController,
                      decoration: tfInputDecoration.copyWith(hintText: "Enter userId...", contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                    ),
                  ),
                  wb10,
                  CustomECTAButton(title: 'Search', action: fetchActivityLogs),
                ],
              ),
              hb10,

              /// Filter Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: accountStatementHeaderBg,
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hb10,
                    PeriodFilterCard(fromDateController: fromDateController, toDateController: toDateController),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        buildQuickFilterButton('Just For Today', DateTime(now.year, now.month, now.day)),
                        buildQuickFilterButton('From Yesterday', now.subtract(const Duration(days: 1))),
                        buildQuickFilterButton('Last 7 days', now.subtract(const Duration(days: 7))),
                        buildQuickFilterButton('Last 30 days', now.subtract(const Duration(days: 30))),
                        buildQuickFilterButton('Last 2 Months', now.subtract(const Duration(days: 60))),
                      ],
                    ),
                    hb10,
                  ],
                ),
              ),

              BlocBuilder<FetchUserActivityLogsBloc, FetchUserActivityLogsState>(
                builder: (context, als) {
                  List<ActivityLogsData> activityLogs = [];
                  if (als is FetchUserActivityLogsProgress) {
                    return LoaderContainerWithMessage();
                  }

                  if (als is FetchUserActivityLogsSuccess) {
                    activityLogs = als.activityLogsResponse.data;
                  }

                  return CustomTable<ActivityLogsData>(
                    key: Key('user_activity_logs_table_at_${DateTime.now().toIso8601String()}'),
                    tableTopPadding: 5,
                    rowVerticalPadding: 8,
                    data: activityLogs,
                    columns: activityLogColumns,
                  );
                },
              ),

              hb12,
            ],
          ),
        ),
      ),
    );
  }
}
