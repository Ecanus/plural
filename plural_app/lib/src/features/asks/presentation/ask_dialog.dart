// import 'package:flutter/material.dart';

// // Common Widgets
// import 'package:plural_app/src/common_widgets/app_dialog.dart';
// import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// // Constants
// import 'package:plural_app/src/constants/app_sizes.dart';
// import 'package:plural_app/src/constants/strings.dart';

// // Ask
// import 'package:plural_app/src/features/asks/presentation/ask_dialog_header.dart';
// import 'package:plural_app/src/features/asks/presentation/ask_dialog_header_button.dart';

// enum ViewKey {
//   existingAsksList,
//   editAskForm,
//   createAskForm,
// }

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

// class AskDialogExistingAsksList extends StatelessWidget {
//   const AskDialogExistingAsksList({
//     super.key,
//     required this.viewCallback,
//   });

//   final Function viewCallback;

//   @override
//   Widget build(BuildContext context) {

//     void routeToCreateAskForm() {
//       print("ROUTING to the create Ask Form");

//       // Update the parent AskDialogView
//       viewCallback(ViewKey.createAskForm);
//     }

//     void routeToEditAskForm() {
//       print("ROUTING to the create Ask Form");

//       // Update the parent AskDialogView
//       viewCallback(ViewKey.createAskForm);
//     }

//     final Widget headerButton = AskDialogHeaderButton(
//       onPressed: routeToCreateAskForm,
//       icon: Icon(Icons.add),
//       label: Strings.askDialogNavButtonNew
//     );



//     return Column(
//       children: [
//       AskDialogHeader(primaryHeaderButton: headerButton),
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(AppPaddings.p35),
//             children: [
//               ExistingAskListTile(
//                 title: "Ask #1",
//                 subtitle: "2024-09-13\nThe subtitle of Ask #1 is this.",
//                 viewCallback: viewCallback,
//               ),
//               ExistingAskListTile(
//                 title: "Ask #2",
//                 subtitle: "2024-09-13\nPickles!!!",
//                 viewCallback: viewCallback,
//               ),
//               ExistingAskListTile(
//                 title: "Ask #2",
//                 subtitle: "2024-09-13\nTomorrow is the day, I swear! I do?",
//                 viewCallback: viewCallback,
//               ),
//             ]
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ExistingAskListTile extends StatelessWidget {
//   const ExistingAskListTile({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.viewCallback
//   });

//   final String title;
//   final String subtitle;
//   final Function viewCallback;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: AppElevations.e7,
//       child: ListTile(
//         title: Text(title),
//         subtitle: Text(subtitle),
//         trailing: Icon(Icons.arrow_forward_ios),
//         onTap: () { viewCallback(ViewKey.editAskForm); },
//       ),
//     );
//   }
// }

// class AskDialogEditForm extends StatelessWidget {
//   const AskDialogEditForm({
//     super.key,
//     required this.viewCallback,
//   });

//   final Function viewCallback;

//   @override
//   Widget build(BuildContext context) {

//     /// Validates create Ask form, saves form data, then returns to Existing Asks List.
//     void submitUpdateAskForm() {
//       print("Validating EDIT Ask Form. ROUTING to exisiting asks list.");

//       // Update the parent AskDialogView
//       viewCallback(ViewKey.existingAsksList);
//     }

//     final Widget headerButton = AskDialogHeaderButton(
//       onPressed: submitUpdateAskForm,
//       icon: Icon(Icons.edit),
//       label: Strings.askDialogNavButtonEdit
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
//                     // AppTextFormField(hintText: Strings.hintTextTitle,),
//                     // AppTextFormField(hintText: Strings.hintTextTargetAmount,),
//                     // AppTextFormField(hintText: Strings.hintTextDescription,),
//                     // AppTextFormField(hintText: Strings.hintTextDescription,),
//                     // AppTextFormField(hintText: Strings.hintTextDescription,),
//                     // AppTextFormField(hintText: Strings.hintTextDescription,),
//                     // AppTextFormField(hintText: Strings.hintTextDescription,),
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