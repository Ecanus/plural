import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

// Asks
import 'package:plural_app/src/features/asks/domain/ask_dialog_manager.dart';

// Widget that houses dimensions and theme shared across
// all Ask dialog boxes used in the app.
class AskDialog extends StatefulWidget {
  const AskDialog({
    super.key,
    required this.view,
    this.viewNavBar,
    required this.viewTitle,
  });

  final Widget view;
  final String viewTitle;
  final Widget? viewNavBar;

  @override
  State<AskDialog> createState() => _AskDialogState();
}

class _AskDialogState extends State<AskDialog> {
  final stateManager = GetIt.instance<AskDialogManager>();

  @override
  void initState() {
    super.initState();

    stateManager.dialogViewNotifier.value = widget.view;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        clipBehavior: Clip.antiAlias,
        constraints: BoxConstraints.expand(
          width: AppConstraints.c600,
          height: AppConstraints.c650,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadii.r15),
        ),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: stateManager.dialogViewNotifier,
                builder: (BuildContext context, Widget view, Widget? _) {
                  return view;
                }
              )
            ),
            widget.viewNavBar ?? Container(),
            Container(
              constraints: BoxConstraints.expand(
                height: AppConstraints.c100,
                width: AppConstraints.c800,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(AppBorderRadii.r15),
                  bottomLeft: Radius.circular(AppBorderRadii.r15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onPrimaryColor,
                    blurRadius: AppDialogValues.blurRadius,
                    spreadRadius: AppDialogValues.spreadRadius,
                    offset: AppDialogValues.offset,
                  ),
                ],
                color: AppColors.darkGrey2,
              ),
              child: Center(
                child: Text(
                  widget.viewTitle,
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: AppFontSizes.s25,
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }
}

// Future createAskDialogBuilder(BuildContext context) {

//   // List<Widget> navButtons = [
//   //   AskDialogNavButton(
//   //     icon: Icon(Icons.ac_unit_rounded),
//   //     tooltip: Strings.askDialogNavButtonCreate,
//   //   ),
//   //   AskDialogNavButton(
//   //     icon: Icon(Icons.zoom_in),
//   //     tooltip: Strings.askDialogNavButtonEdit,
//   //   ),
//   // ];

//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AppDialog(
//         view: AskDialogView(),
//         viewTitle: Strings.asksViewTitle
//       );
//     }
//   );
// }

// class AskDialogView extends StatelessWidget {
//   final ValueNotifier<ViewKey> _viewKey = ValueNotifier<ViewKey>(ViewKey.existingAsksList);
//   final ValueNotifier<int> _askID = ValueNotifier<int>(0);

//   @override
//   Widget build(BuildContext context) {

//     void setViewKey(ViewKey newValue) {
//       print("Set View Key to $newValue");
//       _viewKey.value = newValue;
//     }

//     return ValueListenableBuilder(
//       valueListenable: _viewKey,
//       builder: (BuildContext context, ViewKey value, Widget? child) {
//         switch (value) {
//           case ViewKey.existingAsksList:
//             return AskDialogExistingAsksList(viewCallback: setViewKey,);
//           case ViewKey.editAskForm:
//             return AskDialogEditForm(viewCallback: setViewKey,);
//           case ViewKey.createAskForm:
//             return AskDialogCreateForm(viewCallback: setViewKey,);
//         }
//       },
//     );
//   }
// }

// class AskDialogCreateForm extends StatelessWidget {
//   const AskDialogCreateForm({
//     super.key,
//     required this.viewCallback,
//   });

//   final Function viewCallback;

//   @override
//   Widget build(BuildContext context) {

//     /// Validates create Ask form, saves form data, then returns to Existing Asks List.
//     void submitCreateAskForm() {
//       print("Validating CREATE Ask Form. ROUTING to existing asks list");

//       // Update the parent AskDialogView
//       viewCallback(ViewKey.existingAsksList);
//     }

//     final Widget headerButton = AskDialogHeaderButton(
//       onPressed: submitCreateAskForm,
//       icon: Icon(Icons.add),
//       label: Strings.askDialogNavButtonCreate
//     );

//     return Column(
//       children: [
//         AskDialogHeader(primaryHeaderButton: headerButton),
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(AppPaddings.p35),
//             children: [
//               Form(
//                 child: Column(
//                   children: [
//                     AppTextFormField(hintText: Strings.hintTextTitle,),
//                     AppTextFormField(hintText: Strings.hintTextTargetAmount,),
//                     AppTextFormField(hintText: Strings.hintTextDescription,),
//                     AppTextFormField(hintText: Strings.hintTextDescription,),
//                     AppTextFormField(hintText: Strings.hintTextDescription,),
//                     AppTextFormField(hintText: Strings.hintTextDescription,),
//                     AppTextFormField(hintText: Strings.hintTextDescription,),
//                   ],
//                 ),
//               ),
//             ]
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AskDialogNavButton extends StatelessWidget {
//   const AskDialogNavButton({
//     super.key,
//     required this.icon,
//     required this.tooltip,
//   });

//   final Icon icon;
//   final String tooltip;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         IconButton(
//           constraints: BoxConstraints(
//             maxHeight: AppConstraints.c40,
//             maxWidth: AppConstraints.c40,
//           ),
//           padding: EdgeInsets.all(AppPaddings.p5),
//           icon: icon,
//           tooltip: tooltip,
//           onPressed: () {}
//         ),
//         Text(
//           tooltip,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             fontSize: AppFontSizes.s10,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }