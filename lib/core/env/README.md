# Env 环境配置

提供应用程序的环境配置管理，支持开发、测试、预生产和生产环境的切换。

## 文件说明

### env_config.dart
环境配置类，定义：
- 环境类型常量
- 环境相关配置参数
- 调试模式控制

主要常量：
- `dev`: 开发环境
- `test`: 测试环境
- `pre`: 预生产环境
- `prod`: 生产环境

配置参数：
- `isDebug`: 是否为调试模式（生产环境默认 false）
- `baseUrl`: 基础 URL 地址

### env.dart
环境管理类，提供：
- 当前环境获取
- 环境配置管理
- 环境切换支持
- 环境状态判断

主要方法：
- `getCurrentEnvironment()`: 获取当前环境
- `getEnvConfig()`: 获取环境配置
- `getCurrentBaseUrl()`: 获取当前域名
- `isNotProductionEnv()`: 判断是否非生产环境

### urls.dart
URL 配置类，定义各环境的基础 URL：
- `devBaseUrl`: 开发环境域名
- `testBaseUrl`: 测试环境域名
- `preBaseUrl`: 预生产环境域名
- `prodBaseUrl`: 生产环境域名

## 使用示例

### 获取当前环境
```dart
// 获取当前环境
String currentEnv = Env.currEnv;

// 获取当前环境配置
EnvConfig config = Env.getEnvConfig(env: currentEnv);

// 获取当前基础 URL
String baseUrl = Env.getCurrentBaseUrl();
```

### 环境判断
```dart
// 判断是否非生产环境
if (Env.isNotProductionEnv()) {
  // 非生产环境特殊处理
}

// 判断是否调试模式
if (config.isDebug) {
  // 调试模式特殊处理
}
```

## 环境切换

### 1. 环境类型
- 开发环境（dev）：用于本地开发
- 测试环境（test）：用于测试验证
- 预生产环境（pre）：用于预发布测试
- 生产环境（prod）：用于正式发布

### 2. 切换规则
- Release 模式下固定使用生产环境
- Debug 模式下可以通过缓存切换环境
- 环境值通过 `environment` 字段存储
- 默认使用开发环境配置

### 3. 缓存对应关系
```dart
0: 使用默认环境（dev）
1: 开发环境（dev）
2: 测试环境（test）
3: 预生产环境（pre）
4: 生产环境（prod）
```

## 注意事项

1. 环境管理
   - Release 模式固定使用生产环境
   - 正确管理环境切换
   - 注意环境配置同步
   - 避免环境配置错误

2. URL 配置
   - 确保 URL 配置正确
   - 注意 URL 格式规范
   - 避免硬编码 URL
   - 统一使用配置 URL

3. 调试模式
   - 合理使用调试标记
   - 注意生产环境关闭调试
   - 避免调试信息泄露
   - 控制日志输出

4. 安全考虑
   - 保护环境配置信息
   - 避免敏感信息泄露
   - 控制环境切换权限
   - 注意网络安全 