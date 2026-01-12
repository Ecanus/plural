import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_hyperlinkable_text.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/route_to_view_button.dart';

class ExamineDoDocumentView extends StatelessWidget {
  const ExamineDoDocumentView({
    required this.userGardenRecord,
  });

  final AppUserGardenRecord userGardenRecord;

  @override
  Widget build(BuildContext context) {
    final appDialogViewRouter = GetIt.instance<AppDialogViewRouter>();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              AppHyperlinkableText(
                text: GetIt.instance<AppState>().currentGarden!.doDocument,
                linkStyle: TextStyle(
                  fontSize: AppFontSizes.s15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
                textStyle: TextStyle(
                  fontSize: AppFontSizes.s15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              gapH60,
              DoDocumentReadCheckboxListTile(userGardenRecord: userGardenRecord)
            ],
          )
        ),
        AppDialogFooterBuffer(
          buttons: [
            RouteToViewButton(
              callback: appDialogViewRouter.routeToCurrentGardenSettingsView,
              icon: Icons.arrow_back,
              message: GardenSettingsViewText.returnToGardenSettings,
            )
          ]
        ),
        AppDialogFooter(title: AppDialogFooterText.doDocument)
      ],
    );
  }
}

class DoDocumentReadCheckboxListTile extends StatefulWidget {
  const DoDocumentReadCheckboxListTile({
    required this.userGardenRecord,
  });

  final AppUserGardenRecord userGardenRecord;

  @override
  State<DoDocumentReadCheckboxListTile> createState() => _DoDocumentReadCheckboxListTileState();
}

class _DoDocumentReadCheckboxListTileState extends State<DoDocumentReadCheckboxListTile> {
  late bool _checkboxValue;

  @override
  void initState() {
    super.initState();
    _checkboxValue = widget.userGardenRecord.hasReadDoDocument;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadii.r5),
        color: Theme.of(context).colorScheme.primaryContainer
      ),
      child: Card(
        elevation: AppElevations.e0,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: CheckboxListTile(
          title: Text(
            _checkboxValue ? DoDocumentText.read : DoDocumentText.markAsRead,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w400,
            ),
          ),
          activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
          checkColor: Theme.of(context).colorScheme.primaryContainer,
          controlAffinity: ListTileControlAffinity.leading,
          value: _checkboxValue,
          onChanged: _checkboxValue ? null : (bool? value) {
            updateCurrentUserGardenRecordDoDocumentReadDate();
            setState(() { _checkboxValue = true; });
          }
        ),
      ),
    );

  }
}