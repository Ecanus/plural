import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/garden_clock.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

class GardenHeader extends StatelessWidget {
  const GardenHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;
    final authRespository = getIt<AuthRepository>();
    final currentUser = authRespository.currentUser!;

    return Expanded(
      flex: AppFlexes.f6,
      child: Column(
        children: [
          Text(
              Strings.gardenHeaderText1 + currentUser.firstName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.s25,
              ),
              textAlign: TextAlign.center,
          ),
          GardenClock(),
        ],
      )
    );
  }
}