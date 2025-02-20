import 'package:flutter/material.dart';

// Common Functions
import 'package:plural_app/src/common_functions/form_validators.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/currencies.dart';
import 'package:plural_app/src/constants/styles.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

class AppCurrencyPickerFormField extends StatefulWidget {
  AppCurrencyPickerFormField({
    required this.appForm,
    required this.fieldName,
    this.initialValue,
    this.label = "",
    this.maxLength = AppMaxLengths.max3,
  });

  final AppForm appForm;
  final String fieldName;
  final String? initialValue;
  final String label;
  final int maxLength;

  @override
  State<AppCurrencyPickerFormField> createState() => _AppCurrencyPickerFormFieldState();
}

class _AppCurrencyPickerFormFieldState extends State<AppCurrencyPickerFormField> {
  final _controller = TextEditingController();

  late List<CurrencyCard> _sortedCurrencyCards;

  @override
  void initState() {
    super.initState();

    _controller.text = widget.initialValue ?? "";

    // Currencies
    var keys = Currencies.all.keys.toList();
    keys.sort();

    _sortedCurrencyCards = keys.map(
      (String currencyCode) {
        var currencyMap = Currencies.all[currencyCode]!;

        return CurrencyCard(
          code: currencyCode,
          symbol: currencyMap[Currencies.symbolKey],
        );
      }
    ).toList();
  }

  void _setControllerText(String newCurrencyCode) {
    setState(() { _controller.text = newCurrencyCode; });
  }

  @override
  Widget build(BuildContext context) {
    var showDialogButton = IconButton(
      onPressed: () => showCurrencyPicker(
        context,
        _setControllerText,
        _sortedCurrencyCards
      ),
      icon: const Icon(Icons.mode_edit_outlined),
    );

    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        border: AppStyles.textFieldBorder,
        enabledBorder: AppStyles.textFieldBorder,
        errorText: widget.appForm.getError(fieldName: widget.fieldName),
        floatingLabelStyle: AppStyles.floatingLabelStyle,
        focusedBorder: AppStyles.textFieldFocusedBorder,
        focusedErrorBorder: AppStyles.textFieldFocusedErrorBorder,
        label: Text(widget.label),
        suffixIcon: showDialogButton,
      ),
      onSaved: (value) => widget.appForm.save(
        fieldName: widget.fieldName,
        value: value,
        formFieldType: FormFieldType.currency,
      ),
      validator: (value) => validateCurrency(value)
    );
  }
}

Future<void> showCurrencyPicker(
  BuildContext context,
  Function setTextCallback,
  List<CurrencyCard> currencyCards,
) async {
  final String? currencyCode = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return CurrencyPickerDialog(currencyCards: currencyCards);
    }
  );

  if (currencyCode != null) setTextCallback(currencyCode);
}

class CurrencyPickerDialog extends StatelessWidget {
  const CurrencyPickerDialog({
    required this.currencyCards,
  });

  final List<CurrencyCard> currencyCards;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(),
      child: Container(
        padding: const EdgeInsets.only(
          top: AppPaddings.p50,
          bottom: AppPaddings.p20
        ),
        constraints: BoxConstraints.expand(
          width: AppConstraints.c400,
          height: AppConstraints.c600,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddings.p15,
                ),
                children: currencyCards,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close)
            )
          ],
        ),
      ),
    );
  }
}

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    required this.code,
    required this.symbol,
  });

  final String code;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(),
      elevation: AppElevations.e5,
      child: ListTile(
        onTap: () => Navigator.pop(context, code),
        tileColor: Theme.of(context).colorScheme.secondaryFixed,
        title: Text(code),
        trailing: Text(symbol),
      ),
    );
  }
}