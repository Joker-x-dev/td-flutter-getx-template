import 'package:flutter/material.dart';

/// 布局常量
/// 提供各种布局对齐方式的快捷访问，简化布局代码

//======================== 主轴对齐 MainAxisAlignment ========================

/// 主轴起始对齐
/// 适用于Row、Column的mainAxisAlignment属性
const mainStart = MainAxisAlignment.start;

/// 主轴结束对齐
/// 适用于Row、Column的mainAxisAlignment属性
const mainEnd = MainAxisAlignment.end;

/// 主轴居中对齐
/// 适用于Row、Column的mainAxisAlignment属性
const mainCenter = MainAxisAlignment.center;

/// 均匀分布，间隔相等
/// 适用于Row、Column的mainAxisAlignment属性
const mainBetween = MainAxisAlignment.spaceBetween;

/// 均匀分布，间隔相等，边缘有半个间隔
/// 适用于Row、Column的mainAxisAlignment属性
const mainAround = MainAxisAlignment.spaceAround;

/// 均匀分布，间隔相等，包括边缘
/// 适用于Row、Column的mainAxisAlignment属性
const mainEvenly = MainAxisAlignment.spaceEvenly;

//======================== 交叉轴对齐 CrossAxisAlignment ========================

/// 交叉轴起始对齐
/// 适用于Row、Column的crossAxisAlignment属性
const crossStart = CrossAxisAlignment.start;

/// 交叉轴结束对齐
/// 适用于Row、Column的crossAxisAlignment属性
const crossEnd = CrossAxisAlignment.end;

/// 交叉轴居中对齐
/// 适用于Row、Column的crossAxisAlignment属性
const crossCenter = CrossAxisAlignment.center;

/// 拉伸以填充交叉轴
/// 适用于Row、Column的crossAxisAlignment属性
const crossStretch = CrossAxisAlignment.stretch;

/// 基线对齐（需要指定文本基线）
/// 适用于Row、Column的crossAxisAlignment属性
const crossBaseline = CrossAxisAlignment.baseline;

//======================== Wrap对齐 WrapAlignment ========================

/// 起始对齐
/// 适用于Wrap小部件的alignment属性
const wrapStart = WrapAlignment.start;

/// 结束对齐
/// 适用于Wrap小部件的alignment属性
const wrapEnd = WrapAlignment.end;

/// 居中对齐
/// 适用于Wrap小部件的alignment属性
const wrapCenter = WrapAlignment.center;

/// 均匀分布
/// 适用于Wrap小部件的alignment属性
const wrapBetween = WrapAlignment.spaceBetween;

/// 均匀分布，间隔相等，边缘有半个间隔
/// 适用于Wrap小部件的alignment属性
const wrapAround = WrapAlignment.spaceAround;

/// 均匀分布，间隔相等，包括边缘
/// 适用于Wrap小部件的alignment属性
const wrapEvenly = WrapAlignment.spaceEvenly;

//======================== 对齐位置 Alignment ========================

/// 左上角
/// 适用于Align或Container的alignment属性
const alignTopLeft = Alignment.topLeft;

/// 上中间
/// 适用于Align或Container的alignment属性
const alignTopCenter = Alignment.topCenter;

/// 右上角
/// 适用于Align或Container的alignment属性
const alignTopRight = Alignment.topRight;

/// 左中间
/// 适用于Align或Container的alignment属性
const alignCenterLeft = Alignment.centerLeft;

/// 中间
/// 适用于Align或Container的alignment属性
const alignCenter = Alignment.center;

/// 右中间
/// 适用于Align或Container的alignment属性
const alignCenterRight = Alignment.centerRight;

/// 左下角
/// 适用于Align或Container的alignment属性
const alignBottomLeft = Alignment.bottomLeft;

/// 下中间
/// 适用于Align或Container的alignment属性
const alignBottomCenter = Alignment.bottomCenter;

/// 右下角
/// 适用于Align或Container的alignment属性
const alignBottomRight = Alignment.bottomRight;
