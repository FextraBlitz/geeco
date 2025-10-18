import 'package:envied/envied.dart';

part 'env_bax_end.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: "CLAUDE_API_KEY", obfuscate: true)
  static String apiKey = _Env.apiKey;
  @EnviedField(varName: "CLAUDE_URL", obfuscate: true)
  static String url = _Env.url;
}