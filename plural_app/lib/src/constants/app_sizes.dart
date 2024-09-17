import "package:flutter/material.dart";
import "package:timeline_tile/timeline_tile.dart";

class PluralAppBorderRadii {
  static const r5 = 5.0;
  static const r50 = 50.0;
}

class PluralAppButtonSizes {
  static const s31 = 31.0;
}

class PluralAppColors {
  static const primaryColor = Colors.grey; // Use theme finally
  static const secondaryColor = Colors.white;
  static const onPrimaryColor = Colors.black;
  static const darkGrey = Color.fromARGB(255, 51, 51, 51);
}

class PluralAppConstraints {
  static const c50 = 50.0;
  static const c350 = 350.0;
  static const c375 = 375.0;
  static const c230 = 230.0;
}

class PluralAppDimensions {
  static const d25 = 25.0;
}

class PluralAppElevations {
  static const e5 = 5.0;
  static const e7 = 7.0;
}

class PluralAppFlexes {
  static const f2 = 2;
  static const f6 = 6;
}

class PluralAppFontSizes {
  static const s25 = 25.0;
}

class PluralAppIconSizes {
  static const s30 = 30.0;
}

class PluralAppPaddings {
  static const p0 = 0.0;
  static const p5 = 5.0;
  static const p8 = 8.0;
  static const p10 = 10.0;
  static const p15 = 15.0;
  static const p18 = 18.0;
  static const p20 = 20.0;
  static const p25 = 25.0;
  static const p30 = 30.0;
  static const p35 = 35.0;
  static const p50 = 50.0;
  static const p60 = 60.0;
}

class PluralAppPositions {
  static const pNeg10 = -10.0;
}

class PluralAppRunSpacings {
  static const rs20 = 20.0;
}

// Constant gap widths
const gapW10 = SizedBox(width: PluralAppPaddings.p10);
const gapW15 = SizedBox(width: PluralAppPaddings.p15);

// Constant gap heights
const gapH20 = SizedBox(height: PluralAppPaddings.p20);
const gapH25 = SizedBox(height: PluralAppPaddings.p25);
const gapH30 = SizedBox(height: PluralAppPaddings.p30);
const gapH35 = SizedBox(height: PluralAppPaddings.p35);
const gapH50 = SizedBox(height: PluralAppPaddings.p50);
const gapH60 = SizedBox(height: PluralAppPaddings.p60);

// Constant flexes
const flex2 = Expanded(flex: PluralAppFlexes.f2, child: SizedBox());
const flex6 = Expanded(flex: PluralAppFlexes.f6, child: SizedBox());

// Timeline Tile Values
class PluralAppTimelineValues {
  static const indicatorWidth = 15.0;
  static const timelineThickness = 4.0;
}

const pluralAppIndicatorStyle = IndicatorStyle(
  width: PluralAppTimelineValues.indicatorWidth,
  color: PluralAppColors.primaryColor,
);

const pluralAppLineStyle = LineStyle(
  color: PluralAppColors.primaryColor,
  thickness: PluralAppTimelineValues.timelineThickness,
);