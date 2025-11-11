import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/core/widgets/context_extension.dart';
import 'package:hrms/provider/hotline_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color_utils.dart';
import '../../core/widgets/animated_counter.dart';
import '../../core/widgets/cached_image_widget.dart';
import '../../core/widgets/common_dropdown.dart';
import '../../core/widgets/user_details_by_id_view.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
  }

  Future<void> init() async {
    final provider = Provider.of<HotlineProvider>(context, listen: false);
    await provider.getLeaveCountData();
    await provider.getAllDepartment();
    await provider.getAllDesignation();
    await provider.getAllHotline(status: provider.title);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HotlineProvider>();
    var size = MediaQuery.sizeOf(context);

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
                                  provider.getAllHotline(desId: selected.id);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  commonText(
                    text: "HotLine",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  SizedBox(height: 5),
                  GridView.builder(
                    shrinkWrap: true,

                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                      bottom: 16,
                    ),
                    itemCount: provider.hotlineCount.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 2 columns
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2.6,
                        ),
                    itemBuilder: (context, index) {
                      final item = provider.hotlineCount[index];
                      final color =
                          provider.colors[index %
                              provider
                                  .colors
                                  .length]; // pick color cyclically*/
                      final isSelected = provider.selectedHotlineIndex == index;
                      return buildItemView(
                        item: item,
                        isSelected: isSelected,
                        onTap: () async {
                          /// Update selection in provider
                          provider.selectHotline(index);
                          provider.setHeaderTitle(item.title);

                          /// Call your API with selected value

                          if (item.title == "on_wfh") {
                            await provider.getAllHotline(status: "wfh");
                          } else if (item.title == "on_break") {
                            await provider.getAllHotline(status: "on-break");
                          } else if (item.title == "on_leave") {
                            await provider.getAllHotline(status: "on-leave");
                          } else if (item.title == "online") {
                            await provider.getAllHotline(status: item.title);
                          } else if (item.title == "offline") {
                            await provider.getAllHotline(status: item.title);
                          } else {
                            await provider.getAllHotline();
                          }
                        },
                        color: color,

                        context: context,
                      );
                    },
                  ),

                  commonText(
                    // text:provider.title.toString().toTitleCase()?? "All Employees",
                    text:
                        'Employees - ${provider.title.toString().toTitleCase()}' ??
                        "All Employees",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  SizedBox(height: 5),

                  provider.hotlineListModel?.data?.data?.isNotEmpty == true
                      ? GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columns
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.1,
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
                            return commonInkWell(
                              onTap: () {
                                showCommonBottomSheet(
                                  context: context,
                                  content: Container(
                                    height: size.height * 0.8,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: commonText(
                                                text: "",
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

                                        Expanded(
                                          child: UserDetailsByIdView(
                                            id: '${data?.id ?? 0}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 0,
                                ),

                                decoration: commonBoxDecoration(
                                  color: color.withValues(alpha: 0.04),
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
                                      spacing: 1,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        commonText(
                                          text:
                                              '${data?.firstname} ${data?.lastname}',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: color,
                                          textAlign: TextAlign.center,
                                        ),

                                        commonText(
                                          text: '${data?.designation}',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: colorProduct,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            provider.isLoading ? showLoaderList() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget buildHotLineItem() {
    return Container(height: 60, width: double.infinity, color: Colors.amber);
  }

  Widget buildItemView({
    required HotlineCountModel item,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return commonInkWell(
      onTap: onTap,

      child: Container(
        decoration: commonBoxDecoration(
          borderRadius: 8,
          borderColor: isSelected ? color : colorBorder,
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.04),
          //  borderColor: colorBorder,
          //  color: color.withValues(alpha: 0.04),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            commonText(
              text: item.title.toString().toTitleCase(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorProduct,
            ),
            const SizedBox(width: 6),
            AnimatedCounter(
              leftText: '',
              rightText: '',
              endValue: item.count,
              duration: Duration(seconds: 2),
              style: commonTextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w600,
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
