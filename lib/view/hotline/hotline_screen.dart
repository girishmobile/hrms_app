import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/core/widgets/context_extension.dart';
import 'package:hrms/provider/hotline_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color_utils.dart';
import '../../core/widgets/animated_counter.dart';
import '../../core/widgets/cached_image_widget.dart';
import '../../core/widgets/common_dropdown.dart';
import '../../data/models/hotline/hotline_count_model.dart';

class HotlineScreen extends StatefulWidget {
  const HotlineScreen({super.key});

  @override
  State<HotlineScreen> createState() => _HotlineScreenState();
}

class _HotlineScreenState extends State<HotlineScreen> {
  @override
  void initState() {
    super.initState();
    print("HotlineScreen initState called ✅");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
  }

  Future<void> init() async {
    try {
      final provider = Provider.of<HotlineProvider>(context, listen: false);
      print("Fetching data...");
      await provider.getLeaveCountData();
      await provider.getAllDepartment();
      await provider.getAllDesignation();
      await provider.getAllHotline();
      print("✅ Data fetched successfully");
    } catch (e, st) {
      print("❌ Error in init: $e");
      print(st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HotlineProvider>();

    final departmentNames = provider.departments
        .map((e) => e.name ?? '')
        .toList();
    final selectedDeptName = provider.selectedDepartment?.name;

    final designationNames = provider.designationList
        .map((e) => e.name ?? '')
        .toList();
    final selectedDesignationName = provider.selectDesignation?.name;
    return commonScaffold(
      appBar: commonAppBar(
        title: "Hotline",
        context: context,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showCommonBottomSheet(
                content: Consumer<HotlineProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: commonText(
                                text: "Filter Hotline",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: commonBoxDecoration(
                                shape: BoxShape.circle,

                                color: colorProduct,
                              ),
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    size: 14,
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(
                              text: "Department",
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8),

                            CommonDropdown(
                              items: departmentNames,
                              initialValue: selectedDeptName,
                              hint: "Select Department",
                              onChanged: (value) {
                                if (value != null) {
                                  final selected = provider.departments
                                      .firstWhere((d) => d.name == value);
                                  provider.selectDepartment(selected);

                                  //        provider.getAllHotline(depId: selected.id);
                                  print(
                                    "Selected Department ID: ${selected.id}",
                                  );
                                  print(
                                    "Selected Department Name: ${selected.name}",
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(
                              text: "Designation",
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8),
                            CommonDropdown(
                              items: designationNames.toSet().toList(),
                              // remove duplicates
                              initialValue:
                                  designationNames.contains(
                                    selectedDesignationName,
                                  )
                                  ? selectedDesignationName
                                  : null,
                              hint: "Select Department",
                              onChanged: (value) {
                                if (value != null) {
                                  final selected = provider.designationList
                                      .firstWhere((d) => d.name == value);
                                  provider.selectDesignationData(selected);

                                  print(
                                    "Selected Designation ID: ${selected.id}",
                                  );
                                  print(
                                    "Selected Designation Name: ${selected.name}",
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(
                              text: "Search Employee",
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8),
                            commonTextField(
                              onChanged: (value){
                                if (value.length >= 3) {
                                  provider.getAllHotline(search: value);
                                  Navigator.of(context).pop();
                                }
                              },
                              hintText: "Search Employee",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    );
                  },
                ),
                context: context,
              );
            },
            icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
          ),
        ],
      ),
      body: commonPopScope(
        onBack: (){
          Provider.of<HotlineProvider>(context, listen: false).clearData();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  GridView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(), // ✅ Prevent scroll conflict
                    padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
                    itemCount: provider.hotlineCount.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 2 columns
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.0, // ✅ Adjust ratio to prevent overflow
                    ),
                    itemBuilder: (context, index) {
                      final item = provider.hotlineCount[index];
                      final color =
                          provider.colors[index %
                              provider.colors.length]; // pick color cyclically*/
                      return buildItemView(
                        item: item,
                        color: color,

                        context: context,
                      );
                    },
                  ),

                  commonText(
                    text: provider.selectDesignation != null
                        ? 'All ${provider.selectDesignation?.name}'
                        : provider.selectedDepartment != null
                        ? 'All ${provider.selectedDepartment?.name}'
                        : "All Employees",
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),

                  SizedBox(height: 8),
                  provider.hotlineListModel?.data?.data?.isNotEmpty == true
                      ? GridView.builder(
                          shrinkWrap: true,

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columns
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.5,
                              ),
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              provider.hotlineListModel?.data?.data?.length,
                          itemBuilder: (context, index) {
                            var data =
                                provider.hotlineListModel?.data?.data?[index];
                            final color =
                                provider.colors[index %
                                    provider
                                        .colors
                                        .length]; // pick color cyclically*/
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 0,
                              ),

                              decoration: commonBoxDecoration(
                                color: color.withValues(alpha: 0.05),
                                borderColor: colorBorder,
                                borderRadius: 8,
                              ),

                              child: Column(
                                spacing: 10,

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedImageWidget(
                                      borderRadius: 10,
                                      imageUrl: data?.profileImage,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit
                                          .cover, // <-- Ensures image fills the height nicely
                                    ),
                                  ),
                                  Column(
                                    spacing: 3,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      commonText(
                                        text:
                                            '${data?.firstname} ${data?.lastname}',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: colorProduct,
                                      ),

                                      commonText(
                                        text: '${data?.designation}',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: colorProduct,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : SizedBox.shrink(),
                ],
              ),
              provider.isLoading ? showLoaderList() : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemView({
    required HotlineCountModel item,

    required Color color,
    required BuildContext context,
  }) {
    return commonInkWell(
      onTap: () {},

      child: Container(
        constraints: const BoxConstraints.expand(), // ✅ Constrain child
        decoration: commonBoxDecoration(
          borderRadius: 8,
          borderColor: colorBorder,
          color: color.withValues(alpha: 0.04),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            commonText(
              text: item.title.toString().toTitleCase(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorProduct,
            ),
            const SizedBox(height: 6),
            AnimatedCounter(
              leftText: '',
              rightText: '',
              endValue: item.count,
              duration: Duration(seconds: 2),
              style: commonTextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Debug helper: print when HotlineScreen becomes visible in the widget tree
    debugPrint('HotlineScreen didChangeDependencies ✅');
  }
}
