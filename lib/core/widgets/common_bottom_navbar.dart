import 'package:flutter/material.dart';


import '../constants/color_utils.dart';
import 'component.dart';

class CommonBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const CommonBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colorLogo.withValues(alpha: 0.5),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, -3), // shadow upar ki taraf
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,

        unselectedLabelStyle: commonTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        selectedLabelStyle: commonTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:colorLogo,
        // aap apna colorButton laga sakte ho
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
      ),
    );
  }
}
