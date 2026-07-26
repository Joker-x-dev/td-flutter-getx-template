import 'dart:io';

/// Core LCOV 覆盖率门禁。
///
/// 仅统计 `lib/core` 可执行实现，排除生成文件、Preview Data、抽象接口、
/// 纯导出和无可执行语句的常量配置文件。Core 总体、一级模块及每个链式
/// 扩展实现文件的行覆盖率不得低于 98%，总分支与扩展族分支不得低于 95%。
const double _minimumLineRate = 0.98;

/// Core 与链式扩展族最低分支覆盖率。
const double _minimumBranchRate = 0.95;

/// 执行 Core LCOV 覆盖率检查。
///
/// [arguments] 首项可指定 LCOV 文件路径，缺省使用 `coverage/lcov.info`。
void main(List<String> arguments) {
  final String lcovPath = arguments.isEmpty
      ? 'coverage/lcov.info'
      : arguments.first;
  final File lcovFile = File(lcovPath);
  if (!lcovFile.existsSync()) {
    stderr.writeln('Core Coverage 检查失败：未找到 $lcovPath');
    exitCode = 2;
    return;
  }

  final Map<String, _CoverageRecord> records = _parseLcov(
    lcovFile.readAsLinesSync(),
  );
  final Set<String> expectedFiles = _findExpectedCoreFiles();
  final Set<String> coveredFiles = records.keys.toSet();
  final List<String> missingFiles =
      expectedFiles.difference(coveredFiles).toList()..sort();

  final Map<String, _CoverageRecord> includedRecords =
      <String, _CoverageRecord>{
        for (final MapEntry<String, _CoverageRecord> entry in records.entries)
          if (expectedFiles.contains(entry.key)) entry.key: entry.value,
      };
  final _CoverageRecord total = includedRecords.values.fold(
    const _CoverageRecord(),
    (_CoverageRecord sum, _CoverageRecord item) => sum + item,
  );

  stdout.writeln('Core 覆盖率报告');
  stdout.writeln('模块\t行覆盖率\t分支覆盖率\t文件数');
  final Map<String, List<_CoverageRecord>> modules =
      <String, List<_CoverageRecord>>{};
  for (final MapEntry<String, _CoverageRecord> entry
      in includedRecords.entries) {
    final String module = _moduleOf(entry.key);
    modules.putIfAbsent(module, () => <_CoverageRecord>[]).add(entry.value);
  }
  final Map<String, _CoverageRecord> moduleTotals = <String, _CoverageRecord>{
    for (final MapEntry<String, List<_CoverageRecord>> entry in modules.entries)
      entry.key: entry.value.fold(
        const _CoverageRecord(),
        (_CoverageRecord sum, _CoverageRecord item) => sum + item,
      ),
  };
  for (final String module in moduleTotals.keys.toList()..sort()) {
    final _CoverageRecord moduleTotal = moduleTotals[module]!;
    stdout.writeln(
      '$module\t${moduleTotal.lineLabel}\t${moduleTotal.branchLabel}\t${modules[module]!.length}',
    );
  }
  stdout.writeln(
    'Core 总计\t${total.lineLabel}\t${total.branchLabel}\t${includedRecords.length}/${expectedFiles.length}',
  );

  final Map<String, _CoverageRecord> extensionRecords =
      <String, _CoverageRecord>{
        for (final MapEntry<String, _CoverageRecord> entry
            in includedRecords.entries)
          if (_isExtensionImplementation(entry.key)) entry.key: entry.value,
      };
  final Map<String, List<_CoverageRecord>> extensionFamilies =
      <String, List<_CoverageRecord>>{};
  stdout.writeln('链式扩展逐文件覆盖率');
  stdout.writeln('文件\t行覆盖率\t分支覆盖率');
  for (final String path in extensionRecords.keys.toList()..sort()) {
    final _CoverageRecord record = extensionRecords[path]!;
    extensionFamilies
        .putIfAbsent(_extensionFamily(path), () => <_CoverageRecord>[])
        .add(record);
    stdout.writeln('$path\t${record.lineLabel}\t${record.branchLabel}');
  }
  final Map<String, _CoverageRecord> extensionFamilyTotals =
      <String, _CoverageRecord>{
        for (final MapEntry<String, List<_CoverageRecord>> entry
            in extensionFamilies.entries)
          entry.key: entry.value.fold(
            const _CoverageRecord(),
            (_CoverageRecord sum, _CoverageRecord item) => sum + item,
          ),
      };
  stdout.writeln('链式扩展聚合覆盖率');
  stdout.writeln('扩展族\t行覆盖率\t分支覆盖率\t文件数');
  for (final String family in extensionFamilyTotals.keys.toList()..sort()) {
    final _CoverageRecord familyTotal = extensionFamilyTotals[family]!;
    stdout.writeln(
      '$family\t${familyTotal.lineLabel}\t${familyTotal.branchLabel}\t${extensionFamilies[family]!.length}',
    );
  }

  bool failed = false;
  if (missingFiles.isNotEmpty) {
    failed = true;
    stderr.writeln('未进入 LCOV 的应测试 Core 文件：');
    for (final String file in missingFiles) {
      stderr.writeln('- $file');
    }
  }
  for (final MapEntry<String, _CoverageRecord> entry in moduleTotals.entries) {
    if (entry.value.linesFound == 0 ||
        entry.value.lineRate < _minimumLineRate) {
      failed = true;
      stderr.writeln(
        '${entry.key} 模块行覆盖率必须不低于 98%，当前 ${entry.value.lineLabel}。',
      );
    }
  }
  if (total.linesFound == 0 || total.lineRate < _minimumLineRate) {
    failed = true;
    stderr.writeln('Core 行覆盖率必须不低于 98%，当前 ${total.lineLabel}。');
  }
  if (total.branchesFound == 0 || total.branchRate < _minimumBranchRate) {
    failed = true;
    stderr.writeln('Core 分支覆盖率必须不低于 95%，当前 ${total.branchLabel}。');
  }
  for (final MapEntry<String, _CoverageRecord> entry
      in extensionRecords.entries) {
    if (entry.value.linesFound == 0 ||
        entry.value.lineRate < _minimumLineRate) {
      failed = true;
      stderr.writeln('${entry.key} 行覆盖率必须不低于 98%，当前 ${entry.value.lineLabel}。');
    }
  }
  for (final String family in <String>['Widget', 'Animated']) {
    final _CoverageRecord? familyTotal = extensionFamilyTotals[family];
    if (familyTotal == null ||
        familyTotal.branchesFound == 0 ||
        familyTotal.branchRate < _minimumBranchRate) {
      failed = true;
      stderr.writeln(
        '$family 链式扩展分支覆盖率必须不低于 95%，当前 ${familyTotal?.branchLabel ?? '无覆盖数据'}。',
      );
    }
  }
  if (failed) {
    exitCode = 1;
  }
}

/// 解析 LCOV 中的 Core 文件覆盖信息。
Map<String, _CoverageRecord> _parseLcov(List<String> lines) {
  final Map<String, _CoverageRecord> records = <String, _CoverageRecord>{};
  String? currentFile;
  int linesFound = 0;
  int linesHit = 0;
  int branchesFound = 0;
  int branchesHit = 0;

  /// 提交当前 LCOV 记录。
  void commit() {
    if (currentFile != null && _isCorePath(currentFile!)) {
      records[currentFile!] = _CoverageRecord(
        linesFound: linesFound,
        linesHit: linesHit,
        branchesFound: branchesFound,
        branchesHit: branchesHit,
      );
    }
    currentFile = null;
    linesFound = 0;
    linesHit = 0;
    branchesFound = 0;
    branchesHit = 0;
  }

  for (final String line in lines) {
    if (line.startsWith('SF:')) {
      commit();
      currentFile = _normalizePath(line.substring(3));
    } else if (line.startsWith('DA:')) {
      final List<String> values = line.substring(3).split(',');
      linesFound++;
      if (int.tryParse(values[1]) case final int count when count > 0) {
        linesHit++;
      }
    } else if (line.startsWith('BRDA:')) {
      final List<String> values = line.substring(5).split(',');
      branchesFound++;
      final String taken = values.last;
      if (taken != '-' && (int.tryParse(taken) ?? 0) > 0) {
        branchesHit++;
      }
    } else if (line == 'end_of_record') {
      commit();
    }
  }
  commit();
  return records;
}

/// 查找所有应进入覆盖率报告的 Core 实现文件。
Set<String> _findExpectedCoreFiles() {
  final Set<String> files = <String>{};
  for (final FileSystemEntity entity in Directory(
    'lib/core',
  ).listSync(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }
    final String path = _normalizePath(entity.path);
    if (_isExcluded(path, entity.readAsStringSync())) {
      continue;
    }
    files.add(path);
  }
  return files;
}

/// 判断文件是否属于 Core。
bool _isCorePath(String path) => path.startsWith('lib/core/');

/// 判断 Core 文件是否属于覆盖率排除项。
bool _isExcluded(String path, String source) {
  if (path.endsWith('.g.dart') ||
      path.startsWith('lib/core/data/preview/') ||
      path.endsWith('_data_source.dart') ||
      path.startsWith('lib/core/network/datasource/') &&
          path.endsWith('_impl.dart') ||
      path == 'lib/core/base/base_tab/base_tab_state.dart' ||
      path == 'lib/core/config/app_config.dart' ||
      path == 'lib/core/design_system/theme/layout.dart' ||
      path == 'lib/core/ui/preview/app_preview_annotations.dart' ||
      path.contains('/localization/') && path.endsWith('_keys.dart') ||
      RegExp(r'lib/core/env/env_(dev|test|pre|prod)\.dart$').hasMatch(path)) {
    return true;
  }

  final Iterable<String> codeLines = source
      .split('\n')
      .map((String line) {
        return line.trim();
      })
      .where((String line) {
        return line.isNotEmpty &&
            !line.startsWith('//') &&
            !line.startsWith('import ') &&
            !line.startsWith('export ') &&
            !line.startsWith('part ') &&
            line != 'library;';
      });
  return codeLines.isEmpty;
}

/// 判断文件是否为需要逐文件校验的链式扩展实现。
bool _isExtensionImplementation(String path) {
  return path.startsWith('lib/core/design_system/extensions/widget/') ||
      path.startsWith('lib/core/design_system/extensions/animated/');
}

/// 获取链式扩展实现所属扩展族。
String _extensionFamily(String path) {
  if (path.startsWith('lib/core/design_system/extensions/widget/')) {
    return 'Widget';
  }
  if (path.startsWith('lib/core/design_system/extensions/animated/')) {
    return 'Animated';
  }
  return 'Unknown';
}

/// 将绝对路径转换为仓库相对路径并统一分隔符。
String _normalizePath(String path) {
  final String normalized = path.replaceAll('\\', '/');
  final String root = Directory.current.absolute.path.replaceAll('\\', '/');
  return normalized.startsWith('$root/')
      ? normalized.substring(root.length + 1)
      : normalized;
}

/// 获取 Core 一级子模块名称。
String _moduleOf(String path) {
  final List<String> segments = path.split('/');
  return segments.length > 2 ? segments[2] : 'unknown';
}

/// 单个文件或模块的覆盖率计数。
class _CoverageRecord {
  /// 创建覆盖率计数。
  const _CoverageRecord({
    this.linesFound = 0,
    this.linesHit = 0,
    this.branchesFound = 0,
    this.branchesHit = 0,
  });

  /// 可执行行数。
  final int linesFound;

  /// 已覆盖行数。
  final int linesHit;

  /// 分支总数。
  final int branchesFound;

  /// 已覆盖分支数。
  final int branchesHit;

  /// 行覆盖率。
  double get lineRate => linesFound == 0 ? 0 : linesHit / linesFound;

  /// 分支覆盖率。
  double get branchRate => branchesFound == 0 ? 0 : branchesHit / branchesFound;

  /// 行覆盖率展示文本。
  String get lineLabel =>
      '${(lineRate * 100).toStringAsFixed(2)}% ($linesHit/$linesFound)';

  /// 分支覆盖率展示文本。
  String get branchLabel => branchesFound == 0
      ? '无分支数据'
      : '${(branchRate * 100).toStringAsFixed(2)}% ($branchesHit/$branchesFound)';

  /// 合并覆盖率计数。
  _CoverageRecord operator +(_CoverageRecord other) {
    return _CoverageRecord(
      linesFound: linesFound + other.linesFound,
      linesHit: linesHit + other.linesHit,
      branchesFound: branchesFound + other.branchesFound,
      branchesHit: branchesHit + other.branchesHit,
    );
  }
}
