/// 错误类型枚举
enum ErrorType {
  /// 网络连接错误
  networkError,

  /// JSON解析错误
  parseError,

  /// 请求超时
  timeoutError,

  /// 服务器返回错误
  serverError,

  /// 未知错误
  unknownError,
}

/// 错误信息格式化工具类
///
/// 用于格式化各种API请求错误，提供更有意义的错误消息。
/// 主要支持以下错误类型的格式化：
/// 1. JSON解析错误 - 提取实体类名和类型不匹配信息
/// 2. 网络连接错误 - 提供友好的网络错误提示
/// 3. 请求超时错误 - 提供超时信息
/// 4. 其他未知错误 - 提供通用错误信息
class ErrorFormatter {
  /// 格式化错误信息
  ///
  /// 根据错误内容智能识别错误类型，并返回友好的错误提示
  /// [error] 原始错误对象
  /// [stackTrace] 错误堆栈信息，用于辅助分析
  /// 返回格式化后的错误信息
  static String formatError(dynamic error, [StackTrace? stackTrace]) {
    final errorType = _getErrorType(error);
    return _formatByType(error, errorType);
  }

  /// 获取错误类型
  static ErrorType _getErrorType(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('SocketException') ||
        errorString.contains('Connection refused') ||
        errorString.contains('Network is unreachable')) {
      return ErrorType.networkError;
    } else if (errorString.contains('is not a subtype of type') ||
        (errorString.contains('Unhandled Exception') &&
            errorString.contains('fromJson'))) {
      return ErrorType.parseError;
    } else if (errorString.contains('TimeoutException')) {
      return ErrorType.timeoutError;
    } else {
      return ErrorType.unknownError;
    }
  }

  /// 根据错误类型格式化错误信息
  static String _formatByType(dynamic error, ErrorType errorType) {
    final errorString = error.toString();

    switch (errorType) {
      case ErrorType.parseError:
        return _formatParseError(errorString);

      case ErrorType.networkError:
        return "网络连接错误: 请检查您的网络连接";

      case ErrorType.timeoutError:
        return "请求超时: 服务器响应超时，请稍后再试";

      case ErrorType.serverError:
        return "服务器错误: ${_truncateString(errorString)}";

      case ErrorType.unknownError:
      default:
        return "未知错误: ${_truncateString(errorString)}";
    }
  }

  /// 格式化JSON解析错误
  static String _formatParseError(String errorString) {
    // 从错误信息中提取实体类名和字段信息
    String entityName = "未知实体类";
    String fieldInfo = "未知字段";

    // 尝试提取实体类名
    final entityMatch = RegExp(
      r'_\$([A-Za-z0-9]+)FromJson',
    ).firstMatch(errorString);
    if (entityMatch != null && entityMatch.groupCount >= 1) {
      entityName = entityMatch.group(1) ?? "未知实体类";
    }

    // 尝试提取字段信息
    if (errorString.contains('is not a subtype of type')) {
      final typeMatch = RegExp(
        r"'([^']+)' is not a subtype of type '([^']+)'",
      ).firstMatch(errorString);
      if (typeMatch != null && typeMatch.groupCount >= 2) {
        final actualType = typeMatch.group(1);
        final expectedType = typeMatch.group(2);
        fieldInfo = "预期类型 '$expectedType'，实际类型 '$actualType'";
      }
    }

    return "JSON解析错误: 实体 '$entityName' - $fieldInfo";
  }

  /// 截断过长的字符串
  static String _truncateString(String str, [int maxLength = 100]) {
    if (str.length <= maxLength) return str;
    return '${str.substring(0, maxLength)}...';
  }
}
