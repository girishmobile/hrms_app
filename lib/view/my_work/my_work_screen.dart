import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:provider/provider.dart';

import '../../core/hive/app_config_cache.dart';
import '../../core/hive/user_model.dart';
import '../../data/models/work/my_work_model.dart';
import '../../provider/dashboard_provider.dart';

class MyWorkScreen extends StatefulWidget {
  const MyWorkScreen({super.key});

  @override
  State<MyWorkScreen> createState() => _MyWorkScreenState();
}

class _MyWorkScreenState extends State<MyWorkScreen> {
  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    try {
      final profile = Provider.of<DashboardProvider>(context, listen: false);
      UserModel? user = await AppConfigCache.getUserModel();
      debugPrint('User ID: ${user?.data?.user?.id}');
      await profile.getMYHours(id: user?.data?.user?.id ?? 0);
    } catch (e) {
      debugPrint('Error initializing MyWorkScreen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        centerTitle: true,
        title: "My Work",
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Consumer<DashboardProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return  Center(child: showLoaderList());
            }
            
            if (provider.myWorkModel == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 50, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'Error loading data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        UserModel? user = await AppConfigCache.getUserModel();
                        await provider.getMYHours(id: user?.data?.user?.id ?? 0);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Calculate billable and non-billable hours
            double totalBillableHours = 0;
            double totalNonBillableHours = 0;
            double totalBillableEffort = 0;
            double totalNonBillableEffort = 0;

            for (var project in provider.myWorkModel?.data ?? []) {
              if (project.tasks != null) {
                for (var task in project.tasks!) {
                  if (task.timelogs != null) {
                    for (var log in task.timelogs!) {
                      if (log.billingType == "Billable") {
                        totalBillableHours += log.hours ?? 0;
                        if (task.effortAllocation?.totalEffort != null) {
                          totalBillableEffort += task.effortAllocation!.totalEffort!;
                        }
                      } else if (log.billingType == "NonBillable") {
                        totalNonBillableHours += log.hours ?? 0;
                        if (task.effortAllocation?.totalEffort != null) {
                          totalNonBillableEffort += task.effortAllocation!.totalEffort!;
                        }
                      }
                    }
                  }
                }
              }
            }

            return commonRefreshIndicator(
              onRefresh: () async {
                UserModel? user = await AppConfigCache.getUserModel();
                await provider.getMYHours(id: user?.data?.user?.id ?? 0);
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      commonView(
                        spentValue: "${totalBillableHours.toStringAsFixed(2)} hr",
                        allocationHours: "${totalBillableEffort.toStringAsFixed(0)} hr"
                      ),
                      SizedBox(height: 15,),
                      commonView(
                        color: Colors.amber,
                        title: "Non-Billable",
                        spentValue: "${totalNonBillableHours.toStringAsFixed(2)} hr",
                        allocationHours: "${totalNonBillableEffort.toStringAsFixed(0)} hr"
                      ),
                      SizedBox(height: 15,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonText(text:"Projects - ${ provider.myWorkModel?.data?.length??0}",fontSize: 16,fontWeight: FontWeight.w600),

                        ],
                      ),
                      Expanded(
                        child: provider.isLoading 
                            ?  Center(
                                child: showLoaderList(),
                              )
                            : provider.myWorkModel?.data == null
                                ? const Center(
                                    child: Text('Error loading data. Please try again.'),
                                  )
                                : provider.myWorkModel?.data?.isEmpty==true
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.work_off, size: 50, color: Colors.grey[400]),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'No work data available',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                          padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount:
                                    provider.myWorkModel?.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final project =
                                      provider.myWorkModel?.data?[index];
                                  final color =
                                  provider.colors[index %
                                      provider.colors.length]; // pick color cyclically
                                  if (project == null) {
                                    return const SizedBox.shrink();
                                  }

                                  return Container(
                                    decoration: commonBoxDecoration(
                                      borderColor: colorBorder,
                                      color: color.withValues(alpha: 0.05)
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 10,
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent,
                                      ),
                                      child: ExpansionTile(
                                        title: commonText(
                                          color: colorProduct,

                                          fontWeight: FontWeight.w600,
                                          text:
                                              project.title ??
                                              'Untitled Project',
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Row(
                                            spacing: 10,
                                            children: [
                                              Container(
                                                decoration: commonBoxDecoration(
                                                  color: color.withValues(alpha: 0.2),
                                                  borderColor: colorBorder,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3,
                                                ),
                                                child: commonText(

                                                  fontWeight: FontWeight.w500,
                                                  text:
                                                      'Tasks: ${project.tasks?.length ?? 0}',
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Container(
                                                decoration: commonBoxDecoration(
                                                  color: color.withValues(alpha: 0.2),
                                                  borderColor: colorBorder,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3,
                                                ),
                                                child: commonText(
                                                  fontWeight: FontWeight.w500,
                                                  text:
                                                      'Total Hours: ${project.totalHours?.toStringAsFixed(1) ?? "0.0"}',
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //leading: const Icon(Icons.folder),
                                        children: [
                                          if (project.tasks != null &&
                                              project.tasks!.isNotEmpty)
                                            ...project.tasks!
                                                .map(
                                                  (task) => Container(
                                                    decoration: commonBoxDecoration(
                                                      borderColor: colorBorder,color: Colors.white
                                                    ),
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    child: ExpansionTile(
                                                      trailing: const SizedBox.shrink(), // hides the arrow
                                                      title: commonText(
                                                        text:
                                                            task.title ??
                                                            'Untitled Task',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                      subtitle: Column(
                                                        spacing: 5,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,

                                                        children: [
                                                          commonText(
                                                            text:
                                                                'Status: ${task.status ?? "Unknown"}',
                                                            fontSize: 11,
                                                          ),

                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: commonText(
                                                                  fontSize: 11,
                                                                  text:
                                                                      'Start: ${_formatDate(task.dates?.start)}',
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: commonText(
                                                                  fontSize: 11,
                                                                  text:
                                                                      'Due: ${_formatDate(task.dates?.start)}',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList()
                                          else
                                            const Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Text('No tasks available'),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  provider.isLoading ? showLoaderList() : SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget commonView({Color ?color,String? title,String ?spentValue,String ? allocationHours }){
    return
      Container(
        decoration: commonBoxDecoration(
            borderColor: colorBorder,
            color: color?.withValues(alpha: 0.1)??Colors.green.withValues(alpha: 0.1)
        ),
        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonText(text: title??"Billable",fontWeight: FontWeight.w700,fontSize: 14),
            Row(
              children: [
                commonText(text: "Total Time Spent: ",fontWeight: FontWeight.w600,fontSize: 12),
                commonText(text: spentValue??"128.02 hr",fontSize: 12),
              ],
            ),

            Row(
              children: [
                commonText(text: "Total Allocation Effort: ",fontWeight: FontWeight.w600,fontSize: 12),
                commonText(text: allocationHours??"123 hr",fontSize: 12),
              ],
            ),
          ],
        ),
      );
  }
}
