import 'package:api_request/api_request.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends ApiInterceptor {
  final String _tag = 'token';
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await getToken();
    print("configAuth token $token");
    if (token != null) {
      options.headers.addAll(
          {"Authorization": "${ApiRequestOptions.instance?.tokenType}$token"});
    }
    super.onRequest(options, handler);
  }

  Future<String?> getToken() async {
    if (ApiRequestOptions.instance?.token != null) {
      return ApiRequestOptions.instance?.token;
    }
    if (ApiRequestOptions.instance?.getToken != null) {
      return ApiRequestOptions.instance?.getToken!();
    }
    if (ApiRequestOptions.instance?.getAsyncToken != null) {
      return await ApiRequestOptions.instance?.getAsyncToken!();
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenInterceptor &&
          runtimeType == other.runtimeType &&
          _tag == other._tag;

  @override
  int get hashCode => _tag.hashCode;
}
