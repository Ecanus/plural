import "package:flutter/material.dart";

class AppBorderRadii {
  static const r5 = 5.0;
  static const r10 = 10.0;
  static const r15 = 15.0;
  static const r50 = 50.0;
}

class AppButtonSizes {
  static const s31 = 31.0;
}

class AppConstraints {
  static const c40 = 40.0;
  static const c45 = 45.0;
  static const c50 = 50.0;
  static const c55 = 55.0;
  static const c65 = 65.0;
  static const c75 = 75.0;
  static const c80 = 80.0;
  static const c100 = 100.0;
  static const c230 = 230.0;
  static const c350 = 350.0;
  static const c375 = 375.0;
  static const c600 = 600.0;
  static const c650 = 650.0;
  static const c800 = 800.0;
}

class AppWidths {
  static const w25 = 25.0;
  static const w150 = 150.0;
  static const w200 = 200.0;
}

class AppHeights {
  static const h25 = 25.0;
  static const h40 = 40.0;
}

class AppElevations {
  static const e5 = 5.0;
  static const e7 = 7.0;
}

class AppFlexes {
  static const f2 = 2;
  static const f6 = 6;
}

class AppFontSizes {
  static const s10 = 10.0;
  static const s25 = 25.0;
}

class AppIconSizes {
  static const s30 = 30.0;
}

class AppPaddings {
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

class AppPositions {
  static const pNeg10 = -10.0;
}

class AppRunSpacings {
  static const rs20 = 20.0;
}

// Constant gap widths
const gapW10 = SizedBox(width: AppPaddings.p10);
const gapW15 = SizedBox(width: AppPaddings.p15);
const gapW20 = SizedBox(width: AppPaddings.p20);

// Constant gap heights
const gapH10 = SizedBox(height: AppPaddings.p10);
const gapH20 = SizedBox(height: AppPaddings.p20);
const gapH25 = SizedBox(height: AppPaddings.p25);
const gapH30 = SizedBox(height: AppPaddings.p30);
const gapH35 = SizedBox(height: AppPaddings.p35);
const gapH50 = SizedBox(height: AppPaddings.p50);
const gapH60 = SizedBox(height: AppPaddings.p60);

// Constant flexes
const flex2 = Expanded(flex: AppFlexes.f2, child: SizedBox());
const flex6 = Expanded(flex: AppFlexes.f6, child: SizedBox());

// Timeline Tile Values
class AppTimelineSizes {
  static const indicatorWidth = 15.0;
  static const timelineThickness = 4.0;
}