import '../../../config/flavor_config.dart';

const CONTENT_TYPE = 'Content-Type';
const APP_JSON = 'application/json';

Map<String, String>? apiHeaders = {
  CONTENT_TYPE: APP_JSON,
  AppConfig.apiKeyHeader: AppConfig.apiKey
};


Map<String, String> tokenHeaders(String token) {
  return {
    'Content-Type': 'application/json',
    AppConfig.apiKeyHeader: AppConfig.apiKey,
    'Authorization': 'Bearer $token',
  };
}