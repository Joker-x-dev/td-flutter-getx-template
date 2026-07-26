# 分页父类

`BaseListLogic<E>`、`BaseListState<E>` 与 `BaseListView<T, E>` 位于 `lib/core/base/base_list/`。它建立在 `BaseNetwork` 之上，接入 `EasyRefresh` 的下拉刷新、上拉加载、无更多数据和失败状态，适合商品流、消息流、搜索结果等同构分页列表。

## 适用边界

分页接口必须返回 `BaseListResponse<E>`，其中包含列表与分页信息。仅需下拉刷新一个详情页时使用 [BaseRefresh](./base-refresh.md)；需要瀑布流或异构内容时可重写 `builderItemWidget()`，保留 Logic 的分页状态机。

## 默认状态与 API

| 成员 | 默认值 | 说明 |
| --- | --- | --- |
| `pageSize` | `20` | 单页数量，由业务 State 重写 getter 配置 |
| `currentPage` | `1` | 当前请求页码 |
| `pageParams` | `{pageSize, pageNum}` | 调用 `updatePageParams()` 后生成的基础参数 |
| `dataList` | 空 `RxList<E>` | 当前已加载的数据 |
| `noMoreData` | `false` | 是否终止加载更多 |
| `easyRefreshController` | `controlFinishLoad: true` | EasyRefresh 完成加载状态控制器 |
| `requestSetStatus` | `false` | 刷新期间不把整页切换为 loading |

| 方法 | 作用 |
| --- | --- |
| `refresh()` | 页码归一、清除无更多标记、更新参数并请求第一页 |
| `loadMore()` | 非末页时页码加一并请求下一页 |
| `requestOk()` | 替换或追加记录，依据总页数结束 EasyRefresh |
| `processDataList()` | 数据写入后加工列表的可选入口 |
| `updateListPageStatusEmpty()` | 第一页无数据时切换空页面的可选入口 |
| `setRefreshStatus*()` | 更新 EasyRefresh 成功、失败、无更多等状态 |
| `setFakeData()` | Demo、Preview 使用的静态数据入口 |

## 基于 NetworkListDemo 的完整示例

```dart
/// 商品分页列表状态。
class NetworkListDemoState extends BaseListState<Goods> {
  /// 示例接口每页请求 15 条商品。
  @override
  int get pageSize => 15;
}

/// 商品分页列表 Logic。
class NetworkListDemoLogic extends BaseListLogic<Goods> {
  /// 商品分页页面状态。
  final NetworkListDemoState networkListDemoState = NetworkListDemoState();

  /// 分页父类复用页面声明的 State。
  @override
  NetworkListDemoState get listState => networkListDemoState;

  /// 商品数据仓库，页面生命周期内复用同一数据入口。
  final GoodsRepository _goodsRepository = GoodsRepository();

  @override
  Future<BaseResponse<BaseListResponse<Goods>>> Function()? get apiRequest =>
      () => _goodsRepository.getGoodsPage(
        // 请求参数始终取父类维护的当前页与页大小。
        GoodsSearchRequest(
          page: listState.currentPage,
          size: listState.pageSize,
        ),
      );
}

/// 商品分页列表 View。
class NetworkListDemoView extends BaseListView<NetworkListDemoLogic, Goods> {
  NetworkListDemoView({super.key, super.logic});

  @override
  String? get navTitle => '网络列表';

  @override
  Widget itemWidget(Goods item, int index) {
    // 父类完成 ListView、分隔、刷新和加载更多；子类只描述单项。
    return GoodsListCard(goods: item);
  }
}
```

## 分页状态流程

首次成功时，`currentPage == 1`，父类以 `assignAll` 替换旧列表；加载更多时以 `addAll` 追加。父类根据 `pagination.total` 与 `pagination.size` 计算总页数；当前页达到总页数或总页数为零时设置 `noMoreData` 并结束 footer 为 `noMore`。

请求失败时：若当前列表为空，页面切为错误状态；无论是否已有数据，`EasyRefresh` 都结束为失败状态，因此已加载的内容不会被错误页覆盖。
加载更多失败时页码会恢复到上一成功页，下一次重试仍请求同一页；下一页返回空列表时保留已有内容并标记无更多数据。

## Preview 写法

```dart
/// 列表预览使用静态数据，禁止发起网络请求。
@ResponsivePreview()
Widget previewNetworkListDemoView() {
  final NetworkListDemoLogic logic = NetworkListDemoLogic();
  // 写入预览数据后直接标记成功，使 BaseNetworkView 渲染列表内容。
  logic.listState.dataList.assignAll(previewGoods);
  logic.setStatusSuccess();
  return NetworkListDemoView(logic: logic);
}
```

## 注意事项

- 不要在 `requestOk()` 中自行执行 `finishLoad()`，除非完整理解父类状态机；默认实现已处理。
- 自定义 `pageSize` 时在业务 State 中重写 getter，并让业务 Logic 重写 `listState` 返回该 State；不要在 `onInit()` 中修改分页配置。
- 后端 `total`、`size` 缺失时父类会安全处理并视为无更多数据；接口模型应尽量完整返回分页字段。

## 关联阅读

- [BaseNetwork](./base-network.md)
- [BaseRefresh](./base-refresh.md)
- [Widget Preview](../扩展/widget-preview.md)
