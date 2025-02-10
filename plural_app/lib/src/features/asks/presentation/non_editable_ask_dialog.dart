import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/app_checkbox_form_field.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_header.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Ask
import 'package:plural_app/src/features/asks/domain/ask.dart';

Future createNonEditableAskDialog({
  required BuildContext context,
  required Ask ask
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          view: AskDialogViewForm(ask: ask),
          viewTitle: Strings.viewableAskDialogTitle,
        );
      }
    );
}

class AskDialogViewForm extends StatelessWidget {
  const AskDialogViewForm({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogHeader(firstHeaderButton: CloseDialogButton(),),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppTextFormFieldFilled(
                            label: Strings.askDeadlineDateLabel,
                            value: ask.formattedDeadlineDate,
                          )
                        ),
                        Expanded(
                          child: AppCheckboxFormFieldFilled(
                            mainAxisAlignment: MainAxisAlignment.center,
                            text: Strings.isAskSponsoredLabel,
                            value: ask.isSponsoredByCurrentUser,
                          ),
                        ),
                      ],
                    ),
                    AppTextFormFieldFilled(
                      label: Strings.askCreatorLabel,
                      value: ask.creator!.fullName,
                    ),
                    AppTextFormFieldFilled(
                      label: Strings.askDescriptionLabel,
                      maxLines: null,
                      value: ask.description,
                    ),
                    AppTextFormFieldFilled(
                      label: Strings.askTargetSumLabel,
                      value: ask.targetSum.toString(),
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }
}