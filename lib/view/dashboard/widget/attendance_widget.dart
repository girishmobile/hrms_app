import 'package:flutter/material.dart';

import '../../../core/constants/color_utils.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../core/widgets/component.dart';

Widget buildItemView({
  required Map<String, dynamic> item,

  required BuildContext context,
}) {
  return commonInkWell(
    child: Container(
      decoration: commonBoxDecoration(
        borderRadius: 8,
        color: (item['color'] as Color).withValues(alpha: 0.05),
        borderColor: colorBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            commonText(
              text: item['title'] ?? '',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorProduct,
            ),
            const SizedBox(height: 6),
            AnimatedCounter(
              leftText: '',
              rightText: item['desc'],
              endValue: item['value'],
              duration: Duration(seconds: 2),
              style: commonTextStyle(
                fontSize: 22,
                 color: item['color'],
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
