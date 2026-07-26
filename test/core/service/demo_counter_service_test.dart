import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_kit/core/service/demo_counter_service.dart';

/// DemoCounterService 计数边界测试。
void main() {
  test('初始值为零且支持增加和重置', () {
    final DemoCounterService service = DemoCounterService();

    expect(service.count.value, 0);
    service.increase();
    service.increase();
    expect(service.count.value, 2);
    service.reset();
    expect(service.count.value, 0);
  });

  test('减少操作不会产生负数', () {
    final DemoCounterService service = DemoCounterService();

    service.decrease();
    expect(service.count.value, 0);
    service.increase();
    service.decrease();
    expect(service.count.value, 0);
  });
}
