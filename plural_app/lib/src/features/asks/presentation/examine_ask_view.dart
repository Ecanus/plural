 import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_hyperlinkable_text.dart';
import 'package:plural_app/src/common_widgets/app_snackbars.dart';
import 'package:plural_app/src/common_widgets/app_tooltip_icon.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/themes.dart';

// Ask
import 'package:plural_app/src/features/asks/data/asks_api.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/ask_time_left_text.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';


Future createExamineAskDialog({
  required BuildContext context,
  required Ask ask
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: ExamineAskView(ask: ask),
        );
      }
    );
}

class ExamineAskView extends StatelessWidget {
  const ExamineAskView({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExamineAskHeader(ask: ask),
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
            ]
          ),
        ),
        AppDialogFooter(title: AppDialogFooterText.viewAsk)
      ],
    );
  }
}

class ExamineAskHeader extends StatefulWidget {
  const ExamineAskHeader({
    required this.ask,
  });

  final Ask ask;

  @override
  State<ExamineAskHeader> createState() => _ExamineAskHeaderState();
}

class _ExamineAskHeaderState extends State<ExamineAskHeader> {
  late bool _isSponsored;

  @override
  void initState() {
    super.initState();

    _isSponsored = widget.ask.isSponsoredByCurrentUser;
  }

  @override
  Widget build(BuildContext context) {

    Future<void> isSponsoredToggle(bool value) async {
      var currentUserID = GetIt.instance<AppState>().currentUserID!;

      if (value) {
        await addSponsor(widget.ask.id, currentUserID);

        var snackBar = AppSnackbars.getSnackbar(
          SnackbarText.askSponsored,
          showCloseIcon: false,
          snackbarType: SnackbarType.success
        );

        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        await removeSponsor(widget.ask.id, currentUserID);
      }

      setState(() { _isSponsored = value; });
    }

    WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty.resolveWith<Icon>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.surface
            );
          }

          return Icon(Icons.check, color: Colors.transparent);
        }
      );

    WidgetStateProperty<Color> thumbColor =
      WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return Theme.of(context).colorScheme.onPrimary;
          } else {
            return Theme.of(context).colorScheme.onPrimary;
          }
        }
      );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          gapH35,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                thumbColor: thumbColor,
                thumbIcon: thumbIcon,
                value: _isSponsored,
                onChanged: (bool value) => isSponsoredToggle(value),
              ),
              gapW5,
              Tooltip(
                message: _isSponsored ?
                  AskViewText.unmarkAsSponsored : AskViewText.markAsSponsored,
                child: AppTooltipIcon()
              )
            ],
          ),
          gapH20,
          AskTimeLeftText(
            ask: widget.ask,
            fontSize: AppFontSizes.s20,
            textColor: Theme.of(context).colorScheme.onPrimary,
          ),
          Text(
            "${widget.ask.targetSum.toString()} ${widget.ask.currency}",
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

class BoonColumn extends StatelessWidget {
  const BoonColumn({
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return ask.boon > 0 ?
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AskViewText.boon,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)
            ),
            gapW5,
            Tooltip(
              message: AskViewText.tooltipBoon,
              child: AppTooltipIcon()
            )
          ],
        ),
        Text(
          "${ask.boon.toString()} ${ask.currency}",
          style: TextStyle(
            fontSize: AppFontSizes.s25,
            fontWeight: FontWeight.bold,
          ),
        )
      ]
    )
    : SizedBox();
  }
}

class TextColumn extends StatelessWidget {
  const TextColumn({
    this.fontWeight = FontWeight.normal,
    required this.labelText,
    required this.bodyText,
  });

  final FontWeight fontWeight;
  final String labelText;
  final String bodyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label row
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)
            ),
          ],
        ),
        // Body row
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: AppHyperlinkableText(
                text: bodyText,
                linkStyle: TextStyle(
                  fontSize: AppFontSizes.s16,
                  fontWeight: fontWeight,
                  color: Theme.of(context).primaryColor,
                ),
                textStyle: TextStyle(
                  fontSize: AppFontSizes.s16,
                  fontWeight: fontWeight
                ),
              ),
            ),
          ],
        )
      ]
    );
  }
}