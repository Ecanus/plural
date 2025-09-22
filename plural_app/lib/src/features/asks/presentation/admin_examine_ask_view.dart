import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_hyperlinkable_text.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/themes.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/ask_time_left_text.dart';
import 'package:plural_app/src/features/asks/presentation/delete_ask_button.dart';
import 'package:plural_app/src/features/asks/presentation/examine_ask_view.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

Future createAdminExamineAskDialog({
  required BuildContext context,
  required Ask ask
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: AdminExamineAskView(ask: ask),
        );
      }
    );
}

class AdminExamineAskView extends StatelessWidget {
  const AdminExamineAskView({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminExamineAskViewHeader(ask: ask),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p45),
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppPaddings.p40,
                      top: AppPaddings.p5,
                      right: AppPaddings.p40,
                      bottom: AppPaddings.p40,
                    ),
                    child: AppHyperlinkableText(
                      text: ask.description,
                      linkStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    indent: AppIndents.i200,
                    endIndent: AppIndents.i200,
                  ),
                  gapH10,
                  BoonColumn(ask: ask),
                  gapH25,
                  TextColumn(
                    fontWeight: FontWeight.bold,
                    labelText: AskViewText.instructions,
                    bodyText: ask.instructions,
                  ),
                  gapH25,
                  TextColumn(
                    labelText: AskViewText.username,
                    bodyText: ask.creator.username,
                  ),
                ],
              ),
            ],
          ),
        ),
        AppDialogFooter(title: AppDialogFooterText.examineAsk)
      ],
    );
  }
}

class AdminExamineAskViewHeader extends StatelessWidget {
  const AdminExamineAskViewHeader({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          gapH35,
          Container(
            constraints: BoxConstraints(maxWidth: AppWidths.w200),
            child: DeleteAskButton(askID: ask.id, isAdminPage: true,)
          ),
          gapH20,
          AskTimeLeftText(
            ask: ask,
            fontSize: AppFontSizes.s20,
            textColor: Theme.of(context).colorScheme.onPrimary,
          ),
          Text(
            "${ask.targetSum.toString()} ${ask.currency}",
            style: TextStyle(
              color: AppThemes.positiveColor,
              fontSize: AppFontSizes.s30,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}