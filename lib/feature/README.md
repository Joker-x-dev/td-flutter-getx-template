# Feature

业务功能模块包是应用程序的核心业务实现层，采用模块化和领域驱动的设计方式组织代码。

## 模块组织示例

```
feature/
├── main/                # 主页模块
│   ├── views/           # 视图层
│   ├── logics/          # 业务逻辑层
│   ├── states/          # 状态管理层
│   ├── bindings/        # 依赖注入绑定
│   └── widgets/         # 模块专用组件
├── user/                # 用户模块
│   ├── views/
│   ├── logics/
│   ├── states/
│   ├── bindings/
│   └── widgets/
└── other_module/       # 其他业务模块
    ├── views/
    ├── logics/
    ├── states/
    ├── bindings/
    └── widgets/
```

## 模块开发规范

### 1. 目录结构规范
每个业务模块必须包含以下目录：
- `views/`: 页面视图实现
- `logics/`: 业务逻辑层
- `states/`: 状态管理层
- `bindings/`: 依赖注入绑定配置
- `widgets/`: 模块专用的组件（可选）

### 2. 文件命名规范
- 视图文件：`xxx_view.dart`
- 逻辑文件：`xxx_logic.dart`
- 状态文件：`xxx_state.dart`
- 绑定文件：`xxx_binding.dart`
- 组件文件：`xxx_widget.dart`

### 3. 代码组织规范
```dart
// view 示例
import 'package:styled_widget/styled_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class MeView extends BaseView<MeLogic> {
  const MeView({super.key});

  @override
  String? get navTitle => '我的';

  @override
  Widget body() => TDText('我的页面', font: fontBodyExtraLarge).center();
}

// logic 示例
class MeLogic extends BaseLogic {
  final MeState meState = MeState();
  
  // 业务逻辑实现
  // 通过 meState 访问状态数据
}

// state 示例
class MeState {
  final Rx<User?> data = Rx<User?>(null);
  final RxBool loading = true.obs;
}

// binding 示例
class MeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeLogic>(() => MeLogic());
  }
}

```

## 开发指南

### 1. 创建新模块
1. 在 feature/ 下创建新的模块目录（与 main 同级）
2. 创建必要的子目录（views、logics、states、bindings）
3. 实现必要的基础类
4. 在路由配置中注册新模块

### 2. 模块开发原则
- 单一职责原则：每个模块只负责一个特定的业务领域
- 高内聚低耦合：模块内部紧密关联，模块间松散耦合
- 依赖注入：使用 GetX 的依赖注入管理模块依赖
- 状态管理：采用 MVVM 架构，状态与逻辑分离
- 数据流向：View -> Logic -> State -> View

### 3. 视图开发规范
- 使用 BaseView 作为基类
- 遵循设计系统规范
- 合理拆分组件
- 保持视图层的简洁性
- 通过 logic.xxxState 访问状态数据

### 4. 逻辑层开发规范
- 使用 BaseLogic 作为基类
- 合理划分业务逻辑
- 通过 State 实例管理数据状态
- 规范的生命周期管理
- 状态访问通过 xxxState 属性进行

### 5. 状态层开发规范
- 使用不可变数据结构
- 提供 copyWith 方法用于状态更新
- 状态类应该是纯数据类
- 避免在状态类中包含业务逻辑

## 注意事项

### 1. 代码质量
- 遵循代码规范
- 编写单元测试
- 进行代码审查
- 注重代码可维护性

### 2. 性能优化
- 合理使用状态管理
- 避免不必要的重建
- 及时释放资源
- 优化页面性能

### 3. 模块隔离
- 避免模块间直接依赖
- 使用服务层进行通信
- 保持模块的独立性
- 合理使用依赖注入

### 4. 测试要求
- 编写单元测试
- 进行集成测试
- 进行 UI 测试
- 测试覆盖率要求

## 开发流程

### 1. 新功能开发
1. 创建功能分支
2. 创建模块目录结构
3. 实现基础类
4. 编写业务逻辑
5. 编写测试用例
6. 代码审查
7. 合并到主分支

### 2. 功能维护
1. 遵循现有的模块结构
2. 保持代码风格一致
3. 更新测试用例
4. 进行充分测试
5. 文档更新

### 3. 发布流程
1. 完成功能测试
2. 进行性能测试
3. 更新版本号
4. 生成更新日志
5. 打包发布