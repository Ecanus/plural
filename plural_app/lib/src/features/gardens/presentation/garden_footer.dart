import 'package:flutter/material.dart';

// Auth
import 'package:plural_app/src/features/gardens/presentation/app_bottom_bar.dart';

class GardenFooter extends StatefulWidget {
  const GardenFooter({
    this.isAdminPage = false,
  });

  final bool isAdminPage;

  @override
  State<GardenFooter> createState() => _GardenFooterState();
}

class _GardenFooterState extends State<GardenFooter> {

  @override
  Widget build(BuildContext context) {
    return AppBottomBar(isAdminPage: widget.isAdminPage);
  }
}
