# UI 模块开发规范

## 目录结构

```
ui/
├── dialog/       # 对话框组件
│   └── loading_dialog.dart    # 加载对话框
└── widgets/      # 业务相关组件
```

## 组件分类规范

### 1. Dialog 对话框组件

- 存放位置：`dialog/` 目录
- 命名规范：使用小写字母，单词间用下划线连接，以 `_dialog.dart` 结尾
- 示例：`loading_dialog.dart`, `confirm_dialog.dart`
- 使用场景：全局通用的对话框组件，如加载提示、确认框等

### 2. 业务组件

- 存放位置：`widgets/` 目录
- 命名规范：
  - 文件名：使用小写字母，单词间用下划线连接，以 `.dart` 结尾
  - 类名：使用大驼峰命名法
- 组织方式：
  - 单一职责：每个组件文件只包含一个主要的组件类
  - 相关组件：如果多个组件紧密相关，可以放在同一个文件中

## 开发规范

### 1. 组件设计原则

- **单一职责**：每个组件应该只做一件事，保持功能的单一性
- **可复用性**：组件设计时考虑复用性，避免过度耦合业务逻辑
- **参数配置**：提供必要的参数配置，使组件具有足够的灵活性

### 2. 代码规范

- 必须添加组件的文档注释，说明组件的用途和参数
- 使用 `const` 构造函数，提高性能
- 合理使用 `StatelessWidget` 和 `StatefulWidget`
- 遵循 Flutter 的性能优化建议

### 3. 组件使用建议

- 优先使用 design_system 中的基础组件
- 业务组件应该是对基础组件的组合和扩展
- 避免在业务组件中直接操作全局状态
- 通过回调函数进行组件间的通信

## 示例

### Dialog 组件示例

```dart
// loading_dialog.dart
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);
  
  // 组件实现...
}
```

### 业务组件示例

```dart
// user_avatar.dart
class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  
  const UserAvatar({
    Key? key,
    required this.imageUrl,
    this.size = 40,
  }) : super(key: key);
  
  // 组件实现...
}
```

## 注意事项

1. 组件开发时需要考虑不同屏幕尺寸的适配
2. 注意组件的性能优化，避免不必要的重建
3. 遵循项目的设计规范和主题定制
4. 合理使用 Flutter 的生命周期方法
5. 保持代码的可维护性和可测试性