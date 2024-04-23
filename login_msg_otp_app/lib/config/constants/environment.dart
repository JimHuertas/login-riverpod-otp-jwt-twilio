import 'package:flutter_dotenv/flutter_dotenv.dart';



class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  

  static String apiAuth = dotenv.env['API_AUTH'] ?? 'No está configurado el API_URL';

}