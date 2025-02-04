import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';
import 'package:plural_app/src/utils/app_state.dart';

class ListedGardenTile extends StatelessWidget {
  const ListedGardenTile({
    super.key,
    required this.garden,
  });

  final Garden garden;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevations.e7,
      child: ListTile(
        title: Text(
          garden.name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(""),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          GetIt.instance<AppState>().currentGarden = garden;
          Navigator.pop(context);
        }
      ),
    );
  }
}