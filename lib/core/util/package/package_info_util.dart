import 'package:package_info_plus/package_info_plus.dart';

/// PackageInfo工具类
/// 用于获取应用的包信息，如应用名称、包名、版本号、构建号等
class PackageInfoUtil {
  static PackageInfo? _packageInfo;

  /// 初始化PackageInfo
  /// 建议在应用启动时调用
  static Future<void> init() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
  }

  /// 获取PackageInfo实例
  /// 如果未初始化，会先进行初始化
  static Future<PackageInfo> getPackageInfo() async {
    if (_packageInfo == null) {
      await init();
    }
    return _packageInfo!;
  }

  /// 获取应用名称
  static Future<String> getAppName() async {
    return (await getPackageInfo()).appName;
  }

  /// 获取包名
  static Future<String> getPackageName() async {
    return (await getPackageInfo()).packageName;
  }

  /// 获取版本号
  static Future<String> getVersion() async {
    return (await getPackageInfo()).version;
  }

  /// 获取构建号
  static Future<String> getBuildNumber() async {
    return (await getPackageInfo()).buildNumber;
  }

  /// 获取应用完整版本信息（版本号+构建号）
  static Future<String> getFullVersion() async {
    final info = await getPackageInfo();
    return '${info.version}+${info.buildNumber}';
  }

  /// 比较构建版本号
  /// 返回：1表示当前版本大于目标版本，0表示相等，-1表示当前版本小于目标版本
  static Future<int> compareVersion(String targetVersion) async {
    String currentBuildNumber = await getBuildNumber();

    // 将构建号转换为整数进行比较
    int currentBuild;
    int targetBuild;

    try {
      currentBuild = int.parse(currentBuildNumber);
      targetBuild = int.parse(targetVersion);

      if (currentBuild > targetBuild) return 1;
      if (currentBuild < targetBuild) return -1;
      return 0;
    } catch (e) {
      // 如果无法解析为整数，则回退到字符串比较
      if (currentBuildNumber.compareTo(targetVersion) > 0) return 1;
      if (currentBuildNumber.compareTo(targetVersion) < 0) return -1;
      return 0;
    }
  }

  /// 检查是否需要更新
  /// 如果当前版本低于目标版本，返回true
  static Future<bool> needUpdate(String targetVersion) async {
    int result = await compareVersion(targetVersion);
    return result < 0;
  }

  /// 获取所有包信息，以Map形式返回
  static Future<Map<String, String>> getAllInfo() async {
    final info = await getPackageInfo();
    return {
      'appName': info.appName,
      'packageName': info.packageName,
      'version': info.version,
      'buildNumber': info.buildNumber,
    };
  }

  /// 获取简单的调试信息字符串
  static Future<String> getDebugInfo() async {
    final info = await getPackageInfo();
    return '${info.appName} ${info.version}+${info.buildNumber}';
  }

  /// 比较语义版本号（例如：1.0.4）
  /// 返回：1表示当前版本大于目标版本，0表示相等，-1表示当前版本小于目标版本
  static Future<int> compareSemanticVersion(String targetVersion) async {
    String currentVersion = await getVersion();

    List<int> current =
        currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    List<int> target =
        targetVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // 确保两个列表长度相同
    int maxLength = max(current.length, target.length);
    while (current.length < maxLength) {
      current.add(0);
    }
    while (target.length < maxLength) {
      target.add(0);
    }

    // 比较版本号
    for (int i = 0; i < maxLength; i++) {
      if (current[i] > target[i]) return 1;
      if (current[i] < target[i]) return -1;
    }

    return 0;
  }

  /// 比较完整版本（同时比较版本号和构建号）
  /// 参数：targetVersion - 语义版本号，targetBuildNumber - 构建号
  /// 返回：1表示当前版本大于目标版本，0表示相等，-1表示当前版本小于目标版本
  static Future<int> compareFullVersion(
    String targetVersion,
    String targetBuildNumber,
  ) async {
    // 先比较语义版本号
    int versionCompare = await compareSemanticVersion(targetVersion);
    if (versionCompare != 0) {
      return versionCompare;
    }

    // 如果语义版本号相同，则比较构建号
    return await compareVersion(targetBuildNumber);
  }

  /// 检查是否需要更新 (基于语义版本号)
  /// 如果当前语义版本号低于目标版本号，返回true
  static Future<bool> needSemanticUpdate(String targetVersion) async {
    int result = await compareSemanticVersion(targetVersion);
    return result < 0;
  }

  /// 检查是否需要更新 (基于完整版本比较)
  /// 先比较语义版本号，如果相同则比较构建号
  static Future<bool> needFullUpdate(
    String targetVersion,
    String targetBuildNumber,
  ) async {
    int result = await compareFullVersion(targetVersion, targetBuildNumber);
    return result < 0;
  }

  /// 从完整版本字符串中提取语义版本号和构建号
  /// 格式应为：语义版本号+构建号，例如：1.0.4+2025040901
  /// 返回一个包含[version, buildNumber]的列表
  static List<String> parseVersionString(String fullVersionString) {
    List<String> parts = fullVersionString.split('+');
    if (parts.length == 2) {
      return parts;
    }
    // 如果格式不匹配，返回原字符串和空构建号
    return [fullVersionString, ''];
  }

  /// 检查版本更新，支持多种格式：
  /// 1. 单纯的构建号比较 (如：2025040901)
  /// 2. 语义版本号比较 (如：1.0.4)
  /// 3. 完整版本比较 (如：1.0.4+2025040901)
  static Future<bool> checkUpdate(String versionString) async {
    // 判断版本字符串类型
    if (versionString.contains('+')) {
      // 完整版本格式 (1.0.4+2025040901)
      List<String> parts = parseVersionString(versionString);
      return await needFullUpdate(parts[0], parts[1]);
    } else if (versionString.contains('.')) {
      // 语义版本格式 (1.0.4)
      return await needSemanticUpdate(versionString);
    } else {
      // 构建号格式 (2025040901)
      return await needUpdate(versionString);
    }
  }
}

/// 获取集合中的最大值
int max(int a, int b) {
  return a > b ? a : b;
}
