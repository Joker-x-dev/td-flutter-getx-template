# Util 工具模块开发规范

## 目录结构

```
util/
├── alert/        # 弹窗工具
│   └── alert_util.dart
├── common/       # 通用工具
│   └── common_util.dart
├── log/          # 日志工具
│   └── log_util.dart
├── size/         # 尺寸工具
│   └── size_util.dart
├── storage/      # 存储工具
│   ├── storage_util.dart
│   └── user_storage_util.dart
└── toast/        # 提示工具
    └── toast_util.dart
```

## 工具类分类规范

### 1. 工具类分类原则

- 按功能模块分类存放
- 每个功能模块创建独立目录
- 相关工具类放在同一目录下

### 2. 命名规范

- 目录名：使用小写字母，表示功能模块
- 文件名：使用小写字母，单词间用下划线连接，以 `_util.dart` 结尾
- 类名：使用大驼峰命名法，以 `Util` 结尾

## 开发规范

### 1. 工具类设计原则

- **单一职责**：每个工具类应专注于特定的功能领域
- **静态方法优先**：优先使用静态方法，避免需要实例化
- **无状态**：工具类应该是无状态的，不依赖于实例变量
- **参数明确**：方法参数应该明确且易于理解

### 2. 代码规范

- 必须添加类和方法的文档注释
- 方法名应该清晰表达功能
- 合理使用异步方法
- 添加必要的参数校验
- 统一的错误处理方式

### 3. 使用建议

- 优先使用已有工具类
- 避免重复实现相似功能
- 合理处理异常情况
- 注意性能优化

## 示例

### 工具类示例

```dart
// log_util.dart
class LogUtil {
  static void debug(String tag, String message) {
    // 实现...
  }
  
  static void error(String tag, dynamic error, [StackTrace? stackTrace]) {
    // 实现...
  }
}
```

## 注意事项

1. 工具类方法应该是可测试的
2. 避免在工具类中引入业务逻辑
3. 保持代码的可维护性
4. 合理使用日志记录
5. 注意方法的性能影响