import '../../../core/base/base/base_logic.dart';
import '../../../core/util/common/common_util.dart';
import '../../../core/util/toast/toast_util.dart';
import '../dialogs/confirm_dialog.dart';
import '../dialogs/input_dialog.dart';
import '../dialogs/list_dialog.dart';
import '../dialogs/loading_dialog.dart';
import '../states/base_dialog_demo_state.dart';

class BaseDialogDemoLogic extends BaseLogic {
  final BaseDialogDemoState baseDialogDemoState = BaseDialogDemoState();

  /// 展示确认对话框
  void showConfirmDialog() {
    ConfirmDialog(
      dialogTitle: '删除确认',
      content: '您确定要删除这个项目吗？\n删除后无法恢复',
      cancelText: '取消',
      confirmText: '删除',
      onCancel: _onConfirmCancel,
      onConfirm: _onConfirmDelete,
    ).show();
  }

  /// 展示输入对话框
  void showInputDialog() {
    InputDialog(
      dialogTitle: '请输入备注',
      hintText: '请输入您的备注信息...',
      confirmText: '保存',
      cancelText: '取消',
      onConfirm: _onInputConfirm,
      onCancel: _onInputCancel,
    ).show();
  }

  /// 展示列表选择对话框
  void showListDialog() {
    ListDialog(
      dialogTitle: '选择城市',
      items: [
        '北京市',
        '上海市',
        '广州市',
        '深圳市',
        '杭州市',
        '南京市',
        '成都市',
        '武汉市',
        '西安市',
        '苏州市',
        '天津市',
        '重庆市',
        '青岛市',
        '长沙市',
        '大连市',
        '厦门市',
        '无锡市',
        '福州市',
        '济南市',
        '宁波市',
        '昆明市',
        '石家庄市',
        '长春市',
        '合肥市',
        '贵阳市',
        '太原市',
        '南昌市',
        '南宁市',
        '银川市',
        '西宁市',
        '哈尔滨市',
        '兰州市',
        '乌鲁木齐市',
        '拉萨市',
        '呼和浩特市',
      ],
      onItemSelected: _onListItemSelected,
    ).show();
  }

  /// 展示加载对话框
  void showLoadingDialog() {
    baseDialogDemoState.isLoading.value = true;
    LoadingDialog(dialogTitle: '处理中', loadingText: '正在保存数据，请稍候...').show();

    // 模拟异步操作
    Future.delayed(const Duration(seconds: 3), () {
      CommonUtil.closePop();
      baseDialogDemoState.isLoading.value = false;
      ToastUtil.success('操作完成');
    });
  }

  /// 确认对话框 - 取消回调
  void _onConfirmCancel() {
    ToastUtil.show('取消删除');
  }

  /// 确认对话框 - 确认回调
  void _onConfirmDelete() {
    ToastUtil.success('删除成功');
  }

  /// 输入对话框 - 取消回调
  void _onInputCancel() {
    ToastUtil.show('取消输入');
  }

  /// 输入对话框 - 确认回调
  void _onInputConfirm(String content) {
    if (CommonUtil.isNull(content)) {
      ToastUtil.warning('输入内容为空');
    } else {
      ToastUtil.success('保存成功：$content');
    }
  }

  /// 列表对话框 - 选择回调
  void _onListItemSelected(int index, String item) {
    ToastUtil.success('已选择：$item');
  }
}
