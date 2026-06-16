import 'package:flutter/material.dart';

import '../constants/images.dart';

class NoData extends StatelessWidget {
  const NoData({super.key, this.msg});
  final String? msg;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Image.asset(AssetsConstants.nodata, height: 200), Text(msg ?? "No Data Available")],
      ),
    );
  }
}
