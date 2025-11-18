import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/date_utils.dart';
import '../../provider/kpi_provider.dart';

class KpiDetailsScreen extends StatefulWidget {
  final String? title;
  final Color? color;
  final String? year;

  const KpiDetailsScreen({super.key, this.title, this.color, this.year});

  @override
  State<KpiDetailsScreen> createState() => _KpiDetailsScreenState();
}

class _KpiDetailsScreenState extends State<KpiDetailsScreen> {



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final provider = Provider.of<KpiProvider>(context, listen: false);
    // Get current year dynamically
    int monthNumber = getMonthNumber(widget.title??'');

    await provider.getKPIDetails(month: '$monthNumber',year: widget.year);

  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KpiProvider>(context);
    final kpiList = provider.kpiDetailsModel?.data??[];

    return commonScaffold(
      appBar: commonAppBar(
        context: context,
        centerTitle: true,
        title: 'KPI - ${widget.title} ${widget.year}',
      ),
      body: commonRefreshIndicator(
        onRefresh: ()async {
          init();
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: kpiList.isEmpty
                        ? Center(child: commonText(text: "No ${widget.title ?? ''} available",fontWeight: FontWeight.w600))
                        : ListView.builder(
                            padding: const EdgeInsets.all(0),

                            shrinkWrap: true,
                            itemCount: kpiList.length,
                            itemBuilder: (context, index) {
                              final data = kpiList[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: widget.color ?? colorBorder),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.only(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    spacing: 1,
                                    children: [
                                      fromToView(
                                        date:'${data.kraKpi?.date??0}',

                                        color: widget.color ?? Colors.red,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            left: 0,
                                            right: 16,
                                            bottom: 16,
                                            top: 16,
                                          ),
                                          color:
                                              widget.color?.withValues(alpha: 0.03) ??
                                              Colors.white,
                                          child: Column(
                                            spacing: 8,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              commonItemView(
                                                title: "Target Points",
                                                value: '${data.kraKpi?.targetValue??0}',
                                              ),
                                              commonItemView(
                                                title: "Actual Points",
                                                value: '${data.kraKpi?.actualValue??0}',
                                              ),

                                              commonItemView(
                                                title: "Remarks",

                                                value: '${data.kraKpi?.remarks??0}',
                                              ),
                                            ],
                                          ),
                                        ),
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
            ),
            provider.isLoading?showLoaderList():SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget fromToView({String? date, required Color color}) {
    final parts = formatDateSplit(date);
    return Container(
      decoration: commonBoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: 8,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        spacing: 3,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              commonText(
                color: color,
                text: parts['top'] ?? '',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              commonText(
                color: color,
                text: parts['bottom'] ?? '',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget commonItemView({String? title, String? value, Widget? customView}) {
    return Row(
      children: [
        Expanded(
          child: commonText(
            text: "$title :",
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        Expanded(
          child:
              customView ??
              commonText(
                textAlign: TextAlign.right,
                text: value ?? '',
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}
