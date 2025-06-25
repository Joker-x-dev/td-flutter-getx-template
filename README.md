# TDFlutterGetx Template

> 基于 GetX + TDesign 的 Flutter 项目模板，整合常用功能和开发实践

## 🚀 项目简介

TDFlutterGetx Template 是一个个人整理的 Flutter 项目模板，整合了常用的技术栈和开发实践。该模板旨在帮助开发者快速搭建项目结构，减少重复的配置工作。

### ✨ 主要特性

- **🎯 常用架构**: 基于 GetX 状态管理的 MVVM 架构
- **🎨 UI 组件**: 集成腾讯 TDesign 组件库
- **🌐 网络请求**: 封装了常用的网络请求功能
- **📱 屏幕适配**: 内置屏幕适配解决方案
- **🔧 开发工具**: 集成了代码生成、调试等常用工具
- **📦 模块化**: 按功能模块组织代码结构
- **🎯 开发实践**: 整理了个人开发中的一些实用方法

### 🛠 技术栈

- **状态管理**: GetX 4.x
- **UI 框架**: TDesign Flutter
- **网络请求**: Dio + Retrofit
- **数据序列化**: JSON Annotation + JSON Serializable  
- **屏幕适配**: Flutter ScreenUtil
- **本地存储**: SharedPreferences
- **路由管理**: GetX Navigation
- **调试工具**: Alice + Logger

## 📁 项目结构

```
lib/
├── core/                    # 核心功能模块
│   ├── base/               # 基础类和接口
│   │   ├── base/           # 通用基础类
│   │   ├── base_dialog/    # 弹窗基类
│   │   ├── base_list/      # 列表页面基类
│   │   ├── base_network/   # 网络请求基类
│   │   ├── base_refresh/   # 刷新页面基类
│   │   └── base_tab/       # 标签页面基类
│   ├── config/             # 应用配置
│   ├── design_system/      # 设计系统组件
│   │   ├── theme/          # 主题配置
│   │   └── widgets/        # 通用组件
│   ├── env/               # 环境配置
│   ├── extensions/         # 扩展方法库
│   ├── model/             # 数据模型
│   │   ├── entity/         # 实体类
│   │   ├── request/        # 请求模型
│   │   └── response/       # 响应模型
│   ├── network/           # 网络请求相关
│   │   ├── interceptor/    # 拦截器
│   │   ├── service/        # API 服务
│   │   └── result/         # 结果处理
│   ├── ui/                # UI 组件
│   └── util/              # 工具类
├── feature/               # 业务功能模块
├── res/                   # 资源管理
├── routes/                # 路由管理
├── application.dart       # 应用程序入口配置
└── main.dart             # 主入口文件
```

## 🚀 快速开始

### 环境要求

- Flutter SDK: >= 3.7.2
- Dart SDK: >= 3.7.2

### 安装依赖

```bash
flutter pub get
```

### 代码生成

#### 模型类和API接口生成

在项目开发中，当修改了以下内容时，需要运行代码生成命令：

1. 修改了模型类（Model）
    - 添加或修改了 `@JsonSerializable()` 注解的类
    - 更新了模型类的属性或方法

2. 修改了API接口
    - 添加或修改了 API 请求方法
    - 更新了接口参数或返回值类型

#### 代码生成命令

请确保在项目根目录下执行以下命令：

```bash
# 生成代码（一次性）
dart run build_runner build
```

```bash
# 清理旧的生成文件
dart run build_runner clean
```

```bash
# 持续监听文件变化并自动生成
dart run build_runner watch
```

#### 注意事项

1. 执行命令时必须在项目根目录（包含 pubspec.yaml 文件的目录）
2. 如果遇到生成冲突，建议先执行 clean 命令，再执行 build 命令
3. 开发过程中推荐使用 watch 命令，可以自动监听文件变化并生成代码

### 运行项目

```bash
# 调试模式
flutter run
```

```bash
# 发布模式
flutter run --release
```

## 📦 打包发布

### Android 打包

```bash
# 生成 APK
flutter build apk --release --obfuscate --split-debug-info=./debug_info
```

```bash
# 生成 AAB（推荐用于 Google Play）
flutter build appbundle --release --obfuscate --split-debug-info=./debug_info
```

### iOS 打包

```bash
# 生成 iOS 应用
flutter build ios --release --obfuscate --split-debug-info=./debug_info
```

## 🎯 模块说明

### Base 基础类

提供了常用的页面基类，包括：

- **BaseView/BaseLogic**: 通用页面基类
- **BaseNetworkView/BaseNetworkLogic**: 网络请求页面基类  
- **BaseListView/BaseListLogic**: 列表页面基类
- **BaseTabView/BaseTabLogic**: 标签页面基类
- **BaseDialogView**: 弹窗基类

### 设计系统

- 统一的颜色、字体、间距定义
- 常用的通用组件
- 屏幕适配支持

### 网络层

- 基础的 API 请求封装
- 数据序列化/反序列化
- 简单的错误处理
- 请求/响应拦截器

### 工具类

- 路由管理工具
- 存储工具
- 日志工具
- 其他实用工具

## 📝 使用说明

### 目录规范

- 使用小写字母和下划线命名
- 相关功能的文件放在同一目录
- 按功能模块划分目录

### 代码风格

- 遵循 Dart 官方代码规范
- 使用 flutter_lints 进行基础代码检查
- 保持代码的可读性和一致性

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request 来完善这个项目模板。

---

⭐ 如果这个项目对您有帮助，请给我一个 Star！