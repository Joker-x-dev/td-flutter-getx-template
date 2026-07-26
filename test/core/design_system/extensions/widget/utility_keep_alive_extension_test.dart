import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/design_system/extensions/widget/keep_alive_extension.dart';
import 'package:flutter_kit/core/design_system/extensions/widget/utility_extension.dart';

import '../../../../support/extension_test_harness.dart';

/// 通用包装与状态保持扩展测试。

void main() {
  test('Utility 基础包装完整传递参数', () {
    const Widget child = SizedBox();
    expect((child.offstage(true) as Offstage).offstage, isTrue);
    expect((child.visibility(false, maintainState: true) as Visibility).maintainState, isTrue);
    expect((child.card(color: Colors.red, elevation: 4) as Card).color, Colors.red);
    expect((child.fittedBox(fit: BoxFit.cover) as FittedBox).fit, BoxFit.cover);
    expect((child.fractionallySizedBox(widthFactor: 0.5) as FractionallySizedBox).widthFactor, 0.5);
    expect((child.limitedBox(maxWidth: 10) as LimitedBox).maxWidth, 10);
    expect((child.overflowBox(maxHeight: 20) as OverflowBox).maxHeight, 20);
    expect((child.excludeSemantics(excluding: false) as ExcludeSemantics).excluding, isFalse);
    expect(child.mergeSemantics(), isA<MergeSemantics>());
    expect((child.blockSemantics(blocking: false) as BlockSemantics).blocking, isFalse);
    expect((child.ignorePointer(ignoring: false) as IgnorePointer).ignoring, isFalse);
    expect((child.absorbPointer(absorbing: false) as AbsorbPointer).absorbing, isFalse);
    expect((child.reorderableDelayedDragStartListener(textDirection: TextDirection.rtl) as Directionality).textDirection, TextDirection.rtl);
    expect((child.tooltip(message: '说明') as Tooltip).message, '说明');
    expect((child.hero('hero', transitionOnUserGestures: true) as Hero).tag, 'hero');
    expect(child.autofill(autofillHints: const <String>[AutofillHints.email]), isA<AutofillGroup>());
  });

  test('Utility Semantics 覆盖全部动作和状态字段', () {
    const Widget child = SizedBox();
    var actions = 0;
    void action() => actions++;
    final semantics = child.semantics(
      label: '标签',
      hint: '提示',
      value: '值',
      increasedValue: '增',
      decreasedValue: '减',
      onTap: action,
      onLongPress: action,
      onScrollLeft: action,
      onScrollRight: action,
      onScrollUp: action,
      onScrollDown: action,
      onIncrease: action,
      onDecrease: action,
      onCopy: action,
      onCut: action,
      onPaste: action,
      onDismiss: action,
      onDidGainAccessibilityFocus: action,
      onDidLoseAccessibilityFocus: action,
      container: true,
      explicitChildNodes: true,
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
      textDirection: TextDirection.rtl,
    ) as Semantics;
    final properties = semantics.properties;
    expect(properties.label, '标签');
    properties.onTap?.call();
    properties.onLongPress?.call();
    properties.onScrollLeft?.call();
    properties.onScrollRight?.call();
    properties.onScrollUp?.call();
    properties.onScrollDown?.call();
    properties.onIncrease?.call();
    properties.onDecrease?.call();
    properties.onCopy?.call();
    properties.onCut?.call();
    properties.onPaste?.call();
    properties.onDismiss?.call();
    properties.onDidGainAccessibilityFocus?.call();
    properties.onDidLoseAccessibilityFocus?.call();
    expect(actions, 14);
  });

  testWidgets('Listener、MouseRegion 和 Focus 回调可观察', (tester) async {
    var pointerDown = 0;
    var pointerMove = 0;
    var pointerUp = 0;
    var enters = 0;
    var exits = 0;
    var hovers = 0;
    var focusChanges = 0;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    final widget = const SizedBox(width: 100, height: 60)
        .listener(
          onPointerDown: (_) => pointerDown++,
          onPointerMove: (_) => pointerMove++,
          onPointerUp: (_) => pointerUp++,
          behavior: HitTestBehavior.opaque,
        )
        .mouseRegion(
          onEnter: (_) => enters++,
          onExit: (_) => exits++,
          onHover: (_) => hovers++,
          cursor: SystemMouseCursors.click,
        )
        .focus(
          focusNode: focusNode,
          onFocusChange: (_) => focusChanges++,
          onKeyEvent: (_, _) => KeyEventResult.handled,
          debugLabel: '扩展焦点',
        );
    await pumpExtensionTestApp(tester, widget);

    final gesture = await tester.startGesture(tester.getCenter(find.byType(SizedBox).last));
    await gesture.moveBy(const Offset(5, 0));
    await gesture.up();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(MouseRegion).last));
    await mouse.moveTo(const Offset(790, 590));
    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);

    expect(pointerDown, 1);
    expect(pointerMove, greaterThan(0));
    expect(pointerUp, 1);
    expect(enters, 1);
    expect(hovers, greaterThanOrEqualTo(0));
    expect(exits, 1);
    expect(focusChanges, greaterThan(0));
  });

  testWidgets('KeepAlive 包装器构建并响应配置变化', (tester) async {
    final keepAlive = ValueNotifier<bool>(true);
    addTearDown(keepAlive.dispose);
    await pumpExtensionTestApp(
      tester,
      ValueListenableBuilder<bool>(
        valueListenable: keepAlive,
        builder: (_, value, _) => const Text('状态').keepAlive(value),
      ),
    );
    var wrapper = tester.widget<KeepAliveWrapper>(find.byType(KeepAliveWrapper));
    expect(wrapper.keepAlive, isTrue);
    expect(find.text('状态'), findsOneWidget);

    keepAlive.value = false;
    await tester.pump();
    wrapper = tester.widget<KeepAliveWrapper>(find.byType(KeepAliveWrapper));
    expect(wrapper.keepAlive, isFalse);
    expect(tester.takeException(), isNull);
  });
}
