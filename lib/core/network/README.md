# Network

网络层包是应用程序的网络请求处理层，负责所有与后端服务的通信。该包采用模块化结构，确保网络请求的可维护性和可扩展性。

## 目录结构

### 1. service/
- API 服务接口定义
- 按业务模块组织的 API 实现
- 统一的 API 调用入口

#### 模块化组织
- `api_service.dart`: 统一的服务接口定义文件
- 每个业务模块独立目录，如：
  - `goods/`: 商品相关 API
  - `user/`: 用户相关 API
  - `order/`: 订单相关 API
  - 等等...

### 2. interceptor/
- 网络请求拦截器
- 请求/响应的预处理逻辑
- 统一的错误处理机制

### 3. di/
- 依赖注入配置
- 网络服务的注册和初始化
- 服务实例的生命周期管理

### 4. exception/
- 自定义异常类定义
- 错误处理工具类
- 统一的异常处理策略

### 5. result/
- API请求处理工具
- 统一的请求状态处理
- 标准化的错误处理机制

## API请求处理

### ApiHandler使用

ApiHandler提供了统一的网络请求处理方式：

```dart
await ApiHandler.handle(
  future: api.getData(),
  onStart: () => showLoading(),
  onSuccess: (data) => handleData(data),
  onError: (msg, err) => handleError(msg)
);
```

详细使用说明请参考 [API请求处理器文档](result/README.md)

## 代码生成

### 何时需要生成代码

在以下情况下需要运行代码生成命令：

1. 修改 API 服务接口
   - 在 `api_service.dart` 中添加新的接口方法
   - 修改现有接口的参数或返回类型
   - 添加新的服务类

2. 添加新的业务模块
   - 创建新的模块目录
   - 实现新的 API 服务类
   - 在 `api_service.dart` 中注册新模块

### 生成命令

在项目根目录下执行以下命令：

```shell
# 生成代码（一次性）
dart run build_runner build
```

```shell
# 清理旧的生成文件
dart run build_runner clean
```

```shell
# 持续监听文件变化并自动生成
dart run build_runner watch
```

## 使用指南

1. 添加新的业务模块：
   ```dart
   // 1. 在 service/ 下创建新模块目录
   // 2. 创建对应的 API 服务类
   // 3. 在 api_service.dart 中添加接口定义
   @RestApi(baseUrl: "")
   abstract class NewModuleApi {
     @GET("/data")
     Future<BaseResponse<MyData>> getData();
   }
   ```

2. API 接口规范：
   - 使用 `@RestApi` 注解定义服务接口
   - 使用 HTTP 方法注解（@GET, @POST 等）
   - 请求参数使用 `@Query`、`@Body` 等注解
   - 响应数据使用 `BaseResponse<T>` 封装

3. 错误处理：
   - 使用 ApiHandler 统一处理请求状态
   - 使用拦截器处理通用错误
   - 在业务层处理特定错误

## 注意事项

1. 代码生成
   - 修改 API 接口后必须运行代码生成命令
   - 如遇生成冲突，先执行 clean 后再 build
   - 开发时建议使用 watch 命令自动生成

2. 模块化原则
   - 每个业务模块独立维护自己的 API
   - 相关的 API 放在同一模块目录下
   - 保持模块之间的独立性
   - 在 `api_service.dart` 中统一管理所有模块接口

3. 性能优化
   - 合理使用请求缓存
   - 实现请求取消机制
   - 处理并发请求
   - 监控网络性能

4. 安全考虑
   - 实现统一的认证机制
   - 保护敏感数据
   - 使用 HTTPS
   - 处理证书验证

5. 测试
   - 为每个 API 编写单元测试
   - 模拟不同网络状况
   - 测试错误处理逻辑

## 开发流程

1. 创建新模块
   - 在 service/ 下创建新模块目录
   - 实现 API 服务类
   - 在 api_service.dart 中添加接口

2. 更新现有模块
   - 修改对应模块的 API 实现
   - 更新 api_service.dart 中的接口定义
   - 运行代码生成命令

3. 测试验证
   - 运行单元测试
   - 进行集成测试
   - 验证错误处理 