import 'package:flutter/material.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog.dart';
import 'package:plural_app/src/common_widgets/app_dialog_nav_bar.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';
import 'package:plural_app/src/constants/values.dart';

Future createAskDialogBuilder(BuildContext context) {

  List<Widget> navButtons = [
    AskDialogNavButton(
      icon: Icon(Icons.ac_unit_rounded),
      tooltip: Strings.askDialogNavButtonCreate,
    ),
    AskDialogNavButton(
      icon: Icon(Icons.zoom_in),
      tooltip: Strings.askDialogNavButtonEdit,
    ),
  ];

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(
        view: AskDialogView(),
        viewNavBar: AppDialogNavBar(
          navButtons: navButtons,
        ),
        viewTitle: Strings.asksViewTitle
      );
    }
  );
}

class AskDialogNavButton extends StatelessWidget {
  const AskDialogNavButton({
    super.key,
    required this.icon,
    required this.tooltip,
  });

  final Icon icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          constraints: BoxConstraints(
            maxHeight: AppConstraints.c40,
            maxWidth: AppConstraints.c40,
          ),
          padding: EdgeInsets.all(AppPaddings.p5),
          icon: icon,
          tooltip: tooltip,
          onPressed: () {}
        ),
        Text(
          tooltip,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppFontSizes.s10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class AskDialogView extends StatelessWidget {
  final Widget submitButton = SizedBox(
    width: AppWidths.w200,
    height: AppHeights.h40,
    child: ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.secondaryColor,
        backgroundColor: AppColors.onPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppBorderRadii.r10)),
        ),
      ),
      icon: Icon(Icons.add),
      label: Text("Create Ask")
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          constraints: BoxConstraints.expand(
            height: AppConstraints.c100,
            width: AppConstraints.c800,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(AppBorderRadii.r15),
              bottomLeft: Radius.circular(AppBorderRadii.r15),
            ),
          ),
          child: Center(
            child: submitButton
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppPaddings.p35),
            children: [
              AskDialogForm(),
            ],
          ),
        ),
      ],
    );
  }
}

class AskDialogForm extends StatelessWidget {
  const AskDialogForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          AppTextFormField(hintText: Strings.hintTextTitle,),
          AppTextFormField(hintText: Strings.hintTextTargetAmount,),
          AppTextFormField(hintText: Strings.hintTextDescription,),
          AppTextFormField(hintText: Strings.hintTextDescription,),
          AppTextFormField(hintText: Strings.hintTextDescription,),
          AppTextFormField(hintText: Strings.hintTextDescription,),
          AppTextFormField(hintText: Strings.hintTextDescription,),
        ],
      ),
    );
  }
}

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.hintText,
  });

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppPaddings.p20,
        bottom: AppPaddings.p20
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText
        ),
      ),
    );
  }
}