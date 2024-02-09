import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'core/utils/routes_config/app_router.dart';
import 'package:opi_se/core/utils/socket_service.dart';
import 'package:opi_se/core/utils/service_locator.dart';
import 'package:opi_se/core/functions/setup_hive_db.dart';
import 'package:opi_se/features/auth/domain/use_cases/register_use_case.dart';
import 'package:opi_se/features/auth/domain/use_cases/upload_national_id_use_case.dart';
import 'package:opi_se/features/auth/presentation/cubits/register_cubit/register_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ScreenUtil.ensureScreenSize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await setupHiveDB();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupServiceLocator();
  SocketService.connect();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => RegisterCubit(
          getIt.get<RegisterUseCase>(),
          getIt.get<UploadNationalIdUseCase>(),
        ),
      ),
    ],
    child: const OpiSe(),
  ));
}

class OpiSe extends StatelessWidget {
  const OpiSe({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          title: 'OpiSe',
          theme: ThemeData(useMaterial3: true),
        );
      },
    );
  }
}
