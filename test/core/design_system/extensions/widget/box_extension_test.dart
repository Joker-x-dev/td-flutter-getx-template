import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/design_system/extensions/widget/clip_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/layout_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/padding_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/size_extension.dart';

/// 盒模型、约束和裁剪扩展测试。

void main() {
  test('Padding 参数遵循具体方向优先级并覆盖全部快捷方法', () {
    const Widget child = SizedBox();
    final padding = child.pad(
      all: 1,
      horizontal: 2,
      vertical: 3,
      top: 4,
      right: 5,
    ) as Padding;
    expect(padding.padding, const EdgeInsets.fromLTRB(2, 4, 5, 3));

    final directional = child.padDirectional(
      all: 1,
      horizontal: 2,
      vertical: 3,
      top: 4,
      end: 5,
    ) as Padding;
    expect(
      directional.padding,
      const EdgeInsetsDirectional.fromSTEB(2, 4, 5, 3),
    );
    expect((child.padSymmetric(horizontal: 6, vertical: 7) as Padding).padding, const EdgeInsets.symmetric(horizontal: 6, vertical: 7));
    expect((child.padAll(8) as Padding).padding, const EdgeInsets.all(8));
    expect((child.padTop(9) as Padding).padding, const EdgeInsets.only(top: 9));
    expect((child.padBottom(10) as Padding).padding, const EdgeInsets.only(bottom: 10));
    expect((child.padLeft(11) as Padding).padding, const EdgeInsets.only(left: 11));
    expect((child.padRight(12) as Padding).padding, const EdgeInsets.only(right: 12));
    expect((child.padHorizontal(13) as Padding).padding, const EdgeInsets.symmetric(horizontal: 13));
    expect((child.padVertical(14) as Padding).padding, const EdgeInsets.symmetric(vertical: 14));
  });

  test('Size 扩展映射尺寸和约束', () {
    const Widget child = SizedBox();
    expect((child.width(10) as SizedBox).width, 10);
    expect((child.height(11) as SizedBox).height, 11);
    expect((child.size(12, 13) as SizedBox).width, 12);
    expect((child.square(14) as SizedBox).height, 14);

    final constrained = child.constrained(
      minWidth: 1,
      maxWidth: 2,
      minHeight: 3,
      maxHeight: 4,
    ) as ConstrainedBox;
    expect(constrained.constraints, const BoxConstraints(minWidth: 1, maxWidth: 2, minHeight: 3, maxHeight: 4));
    expect((child.aspectRatio(1.5) as AspectRatio).aspectRatio, 1.5);
    expect((child.limitedBox(maxWidth: 20, maxHeight: 21) as LimitedBox).maxWidth, 20);
    expect((child.fractionallySizedBox(widthFactor: 0.5) as FractionallySizedBox).widthFactor, 0.5);
    expect((child.minSize(width: 22, height: 23) as ConstrainedBox).constraints.minWidth, 22);
    expect((child.maxSize(width: 24, height: 25) as ConstrainedBox).constraints.maxHeight, 25);
    expect((child.tight(width: 26, height: 27) as ConstrainedBox).constraints, const BoxConstraints.tightFor(width: 26, height: 27));
    expect(child.unconstrained(), isA<UnconstrainedBox>());
    expect(child.intrinsicSize(), same(child));
    expect(child.intrinsicSize(stepWidth: 4), isA<IntrinsicWidth>());
    expect(child.intrinsicSize(stepHeight: 5), isA<IntrinsicHeight>());
    expect(child.intrinsicSize(stepWidth: 4, stepHeight: 5), isA<IntrinsicHeight>());
    expect(child.intrinsicWidth(stepWidth: 3), isA<IntrinsicWidth>());
    expect(child.intrinsicHeight(), isA<IntrinsicHeight>());
  });

  test('Layout 扩展完整传递布局和语义参数', () {
    const child = SizedBox();
    expect((child.alignment(Alignment.bottomRight, widthFactor: 2) as Align).alignment, Alignment.bottomRight);
    expect((child.center(heightFactor: 3) as Center).heightFactor, 3);
    expect((child.expanded(flex: 2) as Expanded).flex, 2);
    expect((child.flexible(flex: 3, fit: FlexFit.tight) as Flexible).fit, FlexFit.tight);
    expect((child.positioned(left: 1, top: 2, width: 3, height: 4) as Positioned).left, 1);
    expect((child.positionedDirectional(start: 5, end: 6) as PositionedDirectional).start, 5);
    expect((child.positionedFill(left: 7) as Positioned).left, 7);
    expect((child.safeArea(left: false, minimum: const EdgeInsets.all(8)) as SafeArea).left, isFalse);
    expect((child.overflow(maxWidth: 9, alignment: Alignment.topLeft) as OverflowBox).maxWidth, 9);
    expect((child.fittedBox(fit: BoxFit.cover, clipBehavior: Clip.hardEdge) as FittedBox).fit, BoxFit.cover);
    expect((child.baseline(baseline: 10, baselineType: TextBaseline.ideographic) as Baseline).baseline, 10);

    var tapped = false;
    final semantics = child.semantics(
      label: '操作',
      value: '值',
      hint: '提示',
      onTap: () => tapped = true,
      enabled: true,
      checked: false,
      selected: true,
      toggled: false,
      button: true,
      slider: false,
      keyboardKey: true,
      link: false,
      header: true,
      textField: false,
      readOnly: true,
      focusable: true,
      focused: false,
      inMutuallyExclusiveGroup: true,
      obscured: false,
      multiline: true,
      scopesRoute: false,
      namesRoute: false,
      hidden: false,
      image: false,
      liveRegion: true,
      maxValueLength: 10,
      currentValueLength: 2,
      container: true,
    ) as Semantics;
    expect(semantics.properties.label, '操作');
    semantics.properties.onTap?.call();
    expect(tapped, isTrue);
    expect((child.visibility(visible: false) as Visibility).visible, isFalse);
    expect((child.offstage(false) as Offstage).offstage, isFalse);
    expect((child.ignoringSemantics(excluding: false) as ExcludeSemantics).excluding, isFalse);
  });

  test('Clip 扩展生成目标裁剪器与裁剪行为', () {
    const child = SizedBox();
    expect((child.clipRRect(BorderRadius.circular(4)) as ClipRRect).borderRadius, BorderRadius.circular(4));
    expect((child.clipRadius(5) as ClipRRect).borderRadius, BorderRadius.circular(5));
    expect((child.clipCircle(clipBehavior: Clip.hardEdge) as ClipOval).clipBehavior, Clip.hardEdge);
    expect(child.clipOval(), isA<ClipOval>());
    expect((child.clipRect(clipBehavior: Clip.antiAlias) as ClipRect).clipBehavior, Clip.antiAlias);
    final clipper = _TriangleClipper();
    final clipped = child.clipPath(clipper, clipBehavior: Clip.antiAliasWithSaveLayer) as ClipPath;
    expect(clipped.clipper, same(clipper));
    expect(clipped.clipBehavior, Clip.antiAliasWithSaveLayer);
  });
}

/// 测试用三角形裁剪器。
class _TriangleClipper extends CustomClipper<Path> {
  /// 构建覆盖测试区域的三角形路径。
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
  }

  /// 固定裁剪器无需重算路径。
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
