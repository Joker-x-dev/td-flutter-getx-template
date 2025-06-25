import 'package:get/get.dart';

/// 路由工具类 - 提供可复用的路由操作方法
/// 
/// 这个工具类包含了常用的路由操作函数，可以在项目中任何地方使用
/// 所有方法都是静态的，无需实例化即可调用

/// 跳转到指定页面
/// 
/// **功能：** 通用的页面跳转方法，支持传递参数和泛型返回值
/// 
/// **参数：**
/// - [routeName] (String, 必填): 目标路由名称
///   - 必须是在 app_routes.dart 中定义的有效路由
///   - 例如: '/main', '/login', '/user-details'
/// - [arguments] (Map<String, dynamic>?, 可选): 传递给目标页面的参数
///   - 可以包含任意键值对
///   - 目标页面可通过 Get.arguments 获取
/// 
/// **返回值：**
/// - Future<T?>? 页面返回的结果，类型由泛型 T 指定
/// - 当页面关闭时会返回相应的值
/// 
/// **示例：**
/// ```dart
/// // 基础跳转
/// toPage('/main');
/// 
/// // 带参数跳转
/// toPage('/user-details', arguments: {'userId': '123'});
/// 
/// // 等待返回结果
/// final result = await toPage<String>('/profile');
/// ```
Future<T?>? toPage<T>(String routeName, {Map<String, dynamic>? arguments}) {
  return Get.toNamed<T>(routeName, arguments: arguments);
}

/// 返回上一页
/// 
/// **功能：** 关闭当前页面并返回到上一个页面
/// 
/// **参数：**
/// - [result] (T?, 可选): 返回给上一页面的结果数据
///   - 类型由泛型 T 指定
///   - 上一页面可通过 await 或 .then() 获取此值
/// 
/// **使用场景：**
/// - 用户点击返回按钮
/// - 完成某个操作后关闭页面
/// - 取消操作并返回
/// 
/// **示例：**
/// ```dart
/// // 简单返回
/// back();
/// 
/// // 返回字符串结果
/// back<String>('success');
/// 
/// // 返回复杂对象
/// back<Map<String, dynamic>>({
///   'success': true,
///   'data': userData,
/// });
/// ```
void back<T>([T? result]) {
  Get.back<T>(result: result);
}

/// 返回到指定页面
/// 
/// **功能：** 连续返回多个页面，直到到达指定的路由页面
/// 
/// **参数：**
/// - [routeName] (String, 必填): 目标路由名称
///   - 必须是导航栈中存在的路由
///   - 会移除该路由之后的所有页面
/// 
/// **使用场景：**
/// - 多层级页面跳转后返回到特定页面
/// - 清理复杂的页面栈
/// - 异常处理时返回到安全页面
/// 
/// **注意事项：**
/// - 如果指定的路由不在栈中，会移除所有页面
/// - 谨慎使用，确保目标路由存在
/// 
/// **示例：**
/// ```dart
/// // 返回到主页面
/// backTo('/main');
/// 
/// // 返回到用户列表页
/// backTo('/user-list');
/// ```
void backTo(String routeName) {
  Get.until((route) => Get.currentRoute == routeName);
}

/// 关闭所有弹窗和底部弹窗
/// 
/// **功能：** 强制关闭当前显示的所有弹窗、对话框和底部弹窗
/// 
/// **使用场景：**
/// - 异常情况下清理所有弹窗
/// - 页面切换前确保界面干净
/// - 系统级别的弹窗管理
/// 
/// **特点：**
/// - 不会影响正常的页面导航栈
/// - 只处理弹窗类型的界面元素
/// - 执行后界面回到最后一个完整页面
/// 
/// **示例：**
/// ```dart
/// // 清理所有弹窗
/// closeAllDialogsAndBottomSheets();
/// 
/// // 在页面跳转前清理
/// closeAllDialogsAndBottomSheets();
/// toPage('/new-page');
/// ```
void closeAllDialogsAndBottomSheets() {
  Get.until((route) => !Get.isDialogOpen! && !Get.isBottomSheetOpen!);
}

/// 获取当前路由的所有参数
/// 
/// **功能：** 获取当前页面接收到的所有参数数据
/// 
/// **返回值：**
/// - Map<String, dynamic>? 参数映射表
/// - 如果没有参数则返回 null
/// - 包含页面跳转时传递的所有键值对
/// 
/// **使用场景：**
/// - 页面初始化时获取传入参数
/// - 调试时查看参数内容
/// - 动态处理不确定的参数结构
/// 
/// **示例：**
/// ```dart
/// // 获取所有参数
/// final args = getCurrentArguments();
/// print('接收到的参数: $args');
/// 
/// // 检查参数是否存在
/// if (args != null) {
///   // 处理参数逻辑
/// }
/// 
/// // 遍历所有参数
/// args?.forEach((key, value) {
///   print('$key: $value');
/// });
/// ```
Map<String, dynamic>? getCurrentArguments() {
  return Get.arguments as Map<String, dynamic>?;
}

/// 获取当前路由参数中的特定值
/// 
/// **功能：** 安全地获取指定键名的参数值，支持类型转换
/// 
/// **参数：**
/// - [key] (String, 必填): 参数的键名
///   - 必须是传递参数时使用的确切键名
///   - 大小写敏感
/// 
/// **返回值：**
/// - T? 指定类型的参数值
/// - 如果键不存在或类型转换失败则返回 null
/// - 支持基本类型和复杂对象
/// 
/// **类型安全：**
/// - 使用泛型确保类型安全
/// - 自动进行类型转换
/// - 转换失败时不会抛出异常
/// 
/// **示例：**
/// ```dart
/// // 获取字符串参数
/// final userId = getArgument<String>('userId');
/// 
/// // 获取数字参数
/// final step = getArgument<int>('step');
/// 
/// // 获取布尔值参数
/// final isEdit = getArgument<bool>('editMode');
/// 
/// // 获取复杂对象
/// final userData = getArgument<Map<String, dynamic>>('userData');
/// 
/// // 安全使用（空值检查）
/// final name = getArgument<String>('name') ?? '默认用户';
/// ```
T? getArgument<T>(String key) {
  final args = getCurrentArguments();
  return args?[key] as T?;
}

/// 检查当前是否可以返回上一页
/// 
/// **功能：** 判断当前页面是否可以执行返回操作
/// 
/// **返回值：**
/// - bool? 是否可以返回
///   - true: 可以返回，导航栈中有上一页
///   - false: 不能返回，当前是栈底页面
///   - null: 状态未知或获取失败
/// 
/// **使用场景：**
/// - 自定义返回按钮的显示逻辑
/// - 防止在首页执行返回操作
/// - 条件性导航控制
/// 
/// **示例：**
/// ```dart
/// // 检查是否可以返回
/// if (canPop() == true) {
///   // 显示返回按钮
///   showBackButton();
/// }
/// 
/// // 安全返回
/// if (canPop() ?? false) {
///   back();
/// } else {
///   // 处理无法返回的情况
///   toPage('/main');
/// }
/// ```
bool? canPop() {
  return Get.routing.isBack;
}

/// 获取当前页面的路由名称
/// 
/// **功能：** 获取当前显示页面的路由路径
/// 
/// **返回值：**
/// - String 当前路由名称
/// - 格式如: '/main', '/login', '/user-details'
/// - 始终返回完整的路由路径
/// 
/// **使用场景：**
/// - 页面埋点和统计
/// - 条件性业务逻辑判断
/// - 调试和日志记录
/// - 动态权限控制
/// 
/// **示例：**
/// ```dart
/// // 获取当前路由
/// final currentRoute = getCurrentRoute();
/// print('当前页面: $currentRoute');
/// 
/// // 条件判断
/// if (getCurrentRoute() == '/main') {
///   // 主页特殊逻辑
/// }
/// 
/// // 日志记录
/// logPageView(getCurrentRoute());
/// ```
String getCurrentRoute() {
  return Get.currentRoute;
}

/// 检查当前是否在指定路由页面
/// 
/// **功能：** 判断当前页面是否为指定的路由
/// 
/// **参数：**
/// - [routeName] (String, 必填): 要检查的路由名称
///   - 必须是完整的路由路径
///   - 大小写敏感
/// 
/// **返回值：**
/// - bool 是否匹配
///   - true: 当前页面是指定路由
///   - false: 当前页面不是指定路由
/// 
/// **使用场景：**
/// - 页面状态判断
/// - 条件性UI显示
/// - 导航逻辑控制
/// - 防重复跳转
/// 
/// **示例：**
/// ```dart
/// // 检查是否在主页
/// if (isCurrentRoute('/main')) {
///   // 主页特殊处理
/// }
/// 
/// // 防重复跳转
/// if (!isCurrentRoute('/login')) {
///   toPage('/login');
/// }
/// 
/// // 条件性显示
/// final showBackButton = !isCurrentRoute('/main');
/// ```
bool isCurrentRoute(String routeName) {
  return Get.currentRoute == routeName;
}

/// 安全返回 - 智能返回处理
/// 
/// **功能：** 智能判断并执行返回操作，如果无法返回则跳转到指定页面
/// 
/// **参数：**
/// - [fallbackRoute] (String?, 可选): 无法返回时的备用路由
///   - 当导航栈为空或无法返回时跳转的页面
///   - 如果不提供则不执行任何操作
/// 
/// **逻辑流程：**
/// 1. 首先检查是否可以返回
/// 2. 如果可以返回，执行正常返回操作
/// 3. 如果不能返回且提供了备用路由，则清空栈并跳转到备用页面
/// 4. 如果不能返回且没有备用路由，则不执行任何操作
/// 
/// **使用场景：**
/// - 通用返回按钮处理
/// - 异常状态下的导航恢复
/// - 确保用户始终有可用的导航路径
/// 
/// **示例：**
/// ```dart
/// // 安全返回，失败时跳转到主页
/// safeBack(fallbackRoute: '/main');
/// 
/// // 安全返回，失败时不做任何操作
/// safeBack();
/// 
/// // 在自定义返回按钮中使用
/// onPressed: () => safeBack(fallbackRoute: '/main'),
/// ```
void safeBack({String? fallbackRoute}) {
  if (canPop() ?? false) {
    back();
  } else if (fallbackRoute != null) {
    Get.offAllNamed(fallbackRoute);
  }
}
