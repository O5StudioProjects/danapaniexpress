import '../../../config/flavor_config.dart';

const CONTENT_TYPE = 'Content-Type';
const APP_JSON = 'application/json';

const ERROR = 'error';
const SUCCESS = 'success';
const TOKEN = 'token';
const MESSAGE = 'message';

Map<String, String>? apiHeaders = {
  CONTENT_TYPE: APP_JSON,
  AppConfig.apiKeyHeader: AppConfig.apiKey
};