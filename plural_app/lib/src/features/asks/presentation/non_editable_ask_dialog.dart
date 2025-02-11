 import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header.dart';
import 'package:plural_app/src/common_widgets/app_tooltip_icon.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/themes.dart';

// Ask
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/ask_time_left_text.dart';
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';


Future createNonEditableAskDialog({
  required BuildContext context,
  required Ask ask
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: AskDialogView(ask: ask),
          viewTitle: Strings.viewableAskDialogTitle,
        );
      }
    );
}

class AskDialogView extends StatelessWidget {
  const AskDialogView({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogHeader(
          widget: AskDialogViewHeader(ask: ask),
        ),
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
                    child: Text(ask.description),
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
                    label: Strings.userInstructionsLabel,
                    text: ask.creator!.instructions,
                  ),
                  gapH25,
                  TextColumn(
                    label: Strings.askUsernameLabel,
                    text: ask.creator!.username,
                  ),
                ],
              ),
            ]
          ),
        ),
      ],
    );
  }
}

class AskDialogViewHeader extends StatefulWidget {
  const AskDialogViewHeader({
    required this.ask,
  });

  final Ask ask;

  @override
  State<AskDialogViewHeader> createState() => _AskDialogViewHeaderState();
}

class _AskDialogViewHeaderState extends State<AskDialogViewHeader> {
  late bool isSponsored;

  @override
  void initState() {
    super.initState();

    isSponsored = widget.ask.isSponsoredByCurrentUser;
  }

  Future<void> isSponsoredToggle(bool value) async {
    var asksRepository = GetIt.instance<AsksRepository>();
    var currentUserID = GetIt.instance<AppState>().currentUserID!;


    if (value) {
      await asksRepository.addSponsor(widget.ask.id, currentUserID);
    } else {
      await asksRepository.removeSponsor(widget.ask.id, currentUserID);
    }

    setState(() { isSponsored = value; });
  }

  @override
  Widget build(BuildContext context) {
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        gapH35,
        Row(
          children: [
            Switch(
              thumbColor: thumbColor,
              thumbIcon: thumbIcon,
              value: isSponsored,
              onChanged: (bool value) { isSponsoredToggle(value); },
            ),
            gapW5,
            Tooltip(
              message: isSponsored ?
                Tooltips.unmarkAsSponsored : Tooltips.markAsSponsored,
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
            color: AppThemes.askTargetSumColor,
            fontSize: AppFontSizes.s30,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
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
              Strings.askBoonLabel,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)
            ),
            gapW5,
            Tooltip(
              message: Tooltips.boon,
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
    required this.label,
    required this.text,
  });

  final FontWeight fontWeight;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: AppFontSizes.s16,
                  fontWeight: fontWeight
                )
              ),
            ),
          ],
        )
      ]
    );
  }
}