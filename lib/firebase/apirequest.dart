import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/models/notification.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'apirequest.g.dart';

@RestApi(baseUrl: CLOUD_MESSAGING_URI, parser: Parser.FlutterCompute)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @Headers(<String, dynamic>{
    'Authorization': 'key=$SER_KEY',
    'Content-Type': 'application/json',
  })
  @POST(SEND_FCM)
  Future<void> postNotification(@Body() PushNotification notification);
}