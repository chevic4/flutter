import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_module.dart';
import 'app_widget.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}