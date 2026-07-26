import 'dart:io';

/// Demo Feature 与配套路由的 LCOV 覆盖率门禁。
///
/// 统计 `lib/feature/demo` 与 `lib/routes/demo` 的可执行实现，要求总体及
/// 子模块行覆盖率不低于 98%，总体分支覆盖率不低于 95%，并检查所有
/// 应测试文件均已进入 LCOV。

/// 最低行覆盖率。
const double _minimumLineRate = 0.98;

/// 最低分支覆盖率。
const double _minimumBranchRate = 0.95;

/// 无独立可执行行为的声明文件。
const Set<String> _excludedFiles = <String>{
  'lib/feature/demo/localization/demo_keys.dart',
  'lib/feature/demo/logics/base_demo_logic.dart',
  'lib/feature/demo/logics/screen_adapt_demo_logic.dart',
  'lib/feature/demo/states/base_refresh_demo_state.dart',
  'lib/feature/demo/states/network_demo_state.dart',
  'lib/feature/demo/states/theme_demo_state.dart',
  'lib/routes/demo/demo_routes.dart',
};

/// 执行 Demo LCOV 覆盖率检查。
///
/// [arguments] 首项可指定 LCOV 文件路径，缺省使用 `coverage/lcov.info`。
void main(List<String> arguments) {
  final String lcovPath = arguments.isEmpty
      ? 'coverage/lcov.info'
      : arguments.first;
  final File lcovFile = File(lcovPath);
  if (!lcovFile.existsSync()) {
    stderr.writeln('Demo Coverage 检查失败：未找到 $lcovPath');
    exitCode = 2;
    return;
  }

  final Map<String, _CoverageRecord> records = _parseLcov(
    lcovFile.readAsLinesSync(),
  );
  final Set<String> expectedFiles = _findExpectedDemoFiles();
  final List<String> missingFiles =
      expectedFiles.difference(records.keys.toSet()).toList()..sort();
  final Map<String, _CoverageRecord> includedRecords =
      <String, _CoverageRecord>{
        for (final MapEntry<String, _CoverageRecord> entry in records.entries)
          if (expectedFiles.contains(entry.key)) entry.key: entry.value,
      };
  final _CoverageRecord total = includedRecords.values.fold(
    const _CoverageRecord(),
    (_CoverageRecord sum, _CoverageRecord item) => sum + item,
  );

  final Map<String, List<_CoverageRecord>> modules =
      <String, List<_CoverageRecord>>{};
  for (final MapEntry<String, _CoverageRecord> entry
      in includedRecords.entries) {
    modules
        .putIfAbsent(_moduleOf(entry.key), () => <_CoverageRecord>[])
        .add(entry.value);
  }
  final Map<String, _CoverageRecord> moduleTotals = <String, _CoverageRecord>{
    for (final MapEntry<String, List<_CoverageRecord>> entry in modules.entries)
      entry.key: entry.value.fold(
        const _CoverageRecord(),
        (_CoverageRecord sum, _CoverageRecord item) => sum + item,
      ),
  };

  stdout.writeln('Demo 覆盖率报告');
  stdout.writeln('模块\t行覆盖率\t分支覆盖率\t文件数');
  for (final String module in moduleTotals.keys.toList()..sort()) {
    final _CoverageRecord moduleTotal = moduleTotals[module]!;
    stdout.writeln(
      '$module\t${moduleTotal.lineLabel}\t${moduleTotal.branchLabel}\t${modules[module]!.length}',
    );
  }
  stdout.writeln(
    'Demo 总计\t${total.lineLabel}\t${total.branchLabel}\t${includedRecords.length}/${expectedFiles.length}',
  );

  bool failed = false;
  if (missingFiles.isNotEmpty) {
    failed = true;
    stderr.writeln('未进入 LCOV 的应测试 Demo 文件：');
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
    stderr.writeln('Demo 行覆盖率必须不低于 98%，当前 ${total.lineLabel}。');
  }
  if (total.branchesFound == 0 || total.branchRate < _minimumBranchRate) {
    failed = true;
    stderr.writeln('Demo 分支覆盖率必须不低于 95%，当前 ${total.branchLabel}。');
  }
  if (failed) {
    exitCode = 1;
  }
}

/// 解析 LCOV 中的 Demo 文件覆盖信息。
///
/// [lines] LCOV 文件内容。
///
/// 返回按仓库相对路径索引的覆盖率记录。
Map<String, _CoverageRecord> _parseLcov(List<String> lines) {
  final Map<String, _CoverageRecord> records = <String, _CoverageRecord>{};
  String? currentFile;
  int linesFound = 0;
  int linesHit = 0;
  int branchesFound = 0;
  int branchesHit = 0;

  /// 提交当前 LCOV 记录。
  void commit() {
    if (currentFile != null && _isDemoPath(currentFile!)) {
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
      final String taken = line.substring(5).split(',').last;
      branchesFound++;
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

/// 查找所有应进入覆盖率报告的 Demo 实现文件。
Set<String> _findExpectedDemoFiles() {
  final Set<String> files = <String>{};
  for (final String directoryPath in <String>[
    'lib/feature/demo',
    'lib/routes/demo',
  ]) {
    for (final FileSystemEntity entity in Directory(
      directoryPath,
    ).listSync(recursive: true, followLinks: false)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      final String path = _normalizePath(entity.path);
      if (!path.endsWith('.g.dart') && !_excludedFiles.contains(path)) {
        files.add(path);
      }
    }
  }
  return files;
}

/// 判断路径是否属于 Demo Feature 或配套路由。
///
/// [path] 仓库相对文件路径。
bool _isDemoPath(String path) {
  return path.startsWith('lib/feature/demo/') ||
      path.startsWith('lib/routes/demo/');
}

/// 获取 Demo 文件所属统计模块。
///
/// [path] 仓库相对文件路径。
String _moduleOf(String path) {
  final List<String> segments = path.split('/');
  if (path.startsWith('lib/routes/demo/')) {
    return 'routes';
  }
  return segments.length > 3 ? segments[3] : 'unknown';
}

/// 将绝对路径转换为仓库相对路径并统一分隔符。
///
/// [path] LCOV 或文件系统路径。
String _normalizePath(String path) {
  final String normalized = path.replaceAll('\\', '/');
  final String root = Directory.current.absolute.path.replaceAll('\\', '/');
  return normalized.startsWith('$root/')
      ? normalized.substring(root.length + 1)
      : normalized;
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
  ///
  /// [other] 待合并的覆盖率记录。
  _CoverageRecord operator +(_CoverageRecord other) {
    return _CoverageRecord(
      linesFound: linesFound + other.linesFound,
      linesHit: linesHit + other.linesHit,
      branchesFound: branchesFound + other.branchesFound,
      branchesHit: branchesHit + other.branchesHit,
    );
  }
}
