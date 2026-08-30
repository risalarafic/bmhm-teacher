enum Environment { dev, qa, uat, production }

Environment env = Environment.uat;

class AppConfig {
  AppConfig._();

  static String get baseUrl {
    switch (env) {
      case Environment.dev:
        return 'https://bmhm-qa.org/backend_parent/api/';
      case Environment.qa:
        return 'https://bmhm-qa.org/backend_parent/api/';
      case Environment.uat:
        return 'https://bmhm-qa.org/backend_parent/api/';
      case Environment.production:
        return 'https://bmhm-qa.org/backend_parent/api/';
    }
  }

  static String get filesBaseUrl => 'https://bmhm-qa.org/';

  static String get appToken {
    switch (env) {
      case Environment.dev:
        return '';
      case Environment.qa:
        return '';
      case Environment.uat:
        return '';
      case Environment.production:
        return '';
    }
  }
}
