class EnvConfig {
  ///开发环境
  static const String dev = "dev";

  ///测试环境
  static const String test = "test";

  ///测试环境
  static const String pre = "pre";

  ///正式环境
  static const String prod = "prod";

  ///默认debug模式，在prod时 置为false
  final bool isDebug;

  ///在此处添加需要区分环境的参数
  final String baseUrl;

  EnvConfig({
    required this.baseUrl,
    this.isDebug = true,
  });
}
