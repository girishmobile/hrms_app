import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:provider/provider.dart';

import '../../../provider/kpi_provider.dart';
import '../widget/kpi_widget.dart';

class MyKpiPage extends StatefulWidget {
  const MyKpiPage({super.key});

  @override
  State<MyKpiPage> createState() => _MyKpiPageState();
}

class _MyKpiPageState extends State<MyKpiPage> {
  final GlobalKey _buttonKey = GlobalKey();

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
    final currentYear = DateTime.now().year.toString();

    // If selectedYear is empty or null, set it to current year
    if (provider.selectedYear.isEmpty) {
      provider.selectedYear = currentYear;
    }
    await provider.getKPIList(date:  provider.selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KpiProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText(
                        text: "My KRA KPI",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorProduct,
                      ),

                      //year drop down
                      GestureDetector(
                        key: _buttonKey,
                        onTap: () => showYearPopover(
                          context: context,
                          provider: provider,
                          buttonKey: _buttonKey,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorProduct.withValues(alpha: 0.05),
                            border: Border.all(color: colorProduct),
                          ),
                          child: Row(
                            spacing: 4,
                            children: [
                              commonText(
                                text: provider.selectedYear,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorProduct,
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: colorProduct,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
                   // padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    itemCount: provider.kpiList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final item = provider.kpiList[index];
                      return buildMonthCard(
                        item: item,
                        provider: provider,
                        context: context,
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
