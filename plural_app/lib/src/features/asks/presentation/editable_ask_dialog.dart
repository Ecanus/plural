import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/app_checkbox_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Ask
import 'package:plural_app/src/features/asks/domain/ask.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog_header.dart';
import 'package:plural_app/src/features/asks/presentation/ask_dialog_header_button.dart';

Future createEditableAskDialog({
  required BuildContext context,
  required Ask ask
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(
        view: AskDialogEditForm(ask: ask),
        viewTitle: Strings.editableAskDialogTitle
      );
    }
  );
}

class AskDialogEditForm extends StatelessWidget {
  const AskDialogEditForm({
    super.key,
    required this.ask,
  });

  final Ask ask;

  @override
  Widget build(BuildContext context) {
    final Widget submitFormButton = AskDialogHeaderButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.mode_edit_outlined),
      label: Strings.updateLabel
    );

    return Column(
      children: [
        AskDialogHeader(primaryHeaderButton: submitFormButton),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              Form(
                child: Column(
                  children: [
                    AppCheckboxFormField(
                      value: ask.isFullySponsored,
                      text: Strings.isAskFullySponsoredLabel,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppDatePickerFormField(initialValue: ask.deadlineDate),
                        ),
                        gapW20,
                        Expanded(
                          child: AppTextFormField(
                            initialValue: ask.targetDonationSum.toString(),
                          ),
                        ),
                      ],
                    ),
                    AppTextFormField(
                      initialValue: ask.description,
                      maxLines: null,),
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