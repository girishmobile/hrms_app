import 'package:flutter/material.dart';
import 'package:hrms/core/constants/string_utils.dart';
import 'package:hrms/core/routes/app_routes.dart';
import 'package:hrms/main.dart';
import 'package:hrms/view/dashboard/page/account_page.dart';
import 'package:hrms/view/dashboard/page/attendance_page.dart';
import 'package:hrms/view/dashboard/page/calender_page.dart';
import 'package:hrms/view/dashboard/page/home_page.dart';
import 'package:hrms/view/dashboard/page/my_kpi_page.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color_utils.dart';
import '../../core/widgets/cached_image_widget.dart';
import '../../core/widgets/common_bottom_navbar.dart';
import '../../core/widgets/component.dart';
import '../../provider/dashboard_provider.dart';
import '../../provider/profile_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return MyKpiPage();
      case 1:
        return CalenderPage();
      case 2:
        return HomePage();
      case 3:
        return AttendancePage();
      case 4:
        return AccountPage();
      default:
        return Container();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProfileProvider>(
        context,
        listen: false,
      ).loadProfileFromCache();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            commonScaffold(
              backgroundColor: Colors.white,
              appBar: commonAppBar(
                backgroundColor: colorProduct,

                centerTitle: true,
                actions: [
                  Stack(
                    children: [
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          navigatorKey.currentState?.pushNamed(
                            RouteName.notificationScreen,
                          );
                        },
                        icon: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 3,
                        top: 3,

                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: commonBoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Center(
                            child: commonText(
                              text: "0",
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 10),
                ],
                title: provider.appbarTitle ?? home,
                context: context,
                /*  leading: Container(
                  padding: const EdgeInsets.only(left: 0),

                  child: commonInkWell(
                    onTap: () => provider.setIndex(4),
                    child: Center(
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(100),
                            child: CachedImageWidget(
                            height: 35,
                            width: 35,
                            imageUrl: profileImage)),
                      ),
                    ),
                  ),
                ),*/
                leading: Container(
                  padding: const EdgeInsets.only(left: 0),
                  child: commonInkWell(
                    onTap: () => provider.setIndex(4),
                    child: Center(
                      child: Container(
                        decoration: commonBoxDecoration(
                          borderColor: Colors.white,
                          borderWidth: 1,
                          shape: BoxShape.circle,
                        ),
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Consumer<ProfileProvider>(
                            builder: (_, profileProvider, _) {
                              return CachedImageWidget(
                                height: 35,
                                width: 35,
                                imageUrl:
                                    '${profileProvider.profileImage}', // ⚡ cache busting
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0), // Slide from right
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(child: getPage(provider.currentIndex)),
              ),
              // 👈 only current page
              bottomNavigationBar: CommonBottomNavBar(
                currentIndex: provider.currentIndex,
                onTap: (index) {
                  provider.setIndex(index);

                  switch (index) {
                    case 0: // Product
                      /* context.read<OrdersProvider>().resetData();
                      context.read<CustomerProvider>().reset();
                      context.read<ProfileProvider>().resetState();*/
                      break;
                    case 1: // Order
                      /*   context.read<ProductProvider>().reset();
                      context.read<CustomerProvider>().reset();
                      context.read<ProfileProvider>().resetState();*/
                      break;
                    case 2: // Home
                      /*       context.read<ProductProvider>().reset();
                      context.read<OrdersProvider>().resetData();
                      context.read<CustomerProvider>().reset();
                      context.read<ProfileProvider>().resetState();*/
                      break;
                    case 3: // Customer
                      /* context.read<ProductProvider>().reset();
                      context.read<OrdersProvider>().resetData();
                      context.read<ProfileProvider>().resetState();*/
                      break;
                    case 4: // Account
                      /*  context.read<ProductProvider>().reset();
                      context.read<OrdersProvider>().resetData();
                      context.read<CustomerProvider>().reset();*/
                      break;
                  }

                  if (index == 0) provider.setAppBarTitle(myKAP);
                  if (index == 1) provider.setAppBarTitle(calendar);
                  if (index == 2) provider.setAppBarTitle(home);
                  if (index == 3) provider.setAppBarTitle(attendance);
                  if (index == 4) provider.setAppBarTitle(setting);
                },
                items: BottomNavItems.items,
              ),
            ),
          ],
        );
      },
    );
  }
}
