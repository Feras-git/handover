import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:handover/config/simple_bloc_observer.dart';
import 'package:handover/core/constants.dart';
import 'package:handover/features/auth/login/presentation/login_screen.dart';
import 'package:handover/features/auth/user_data/user_data_cubit.dart';
import 'package:handover/features/home_gate/presentation/home_gate.dart';
import 'package:handover/repositories/auth_repository/auth_repository.dart';
import 'package:handover/repositories/orders_repository/src/orders_repository.dart';
import 'package:handover/repositories/user_data_repository/user_data_repository.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:handover/features/auth/auth/auth_bloc.dart';
import 'features/auth/logout/cubit/logout_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository(),
          ),
          RepositoryProvider<UserDataRepository>(
            create: (context) => UserDataRepository(),
          ),
          RepositoryProvider<OrdersRepository>(
            create: (context) => OrdersRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (BuildContext context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
              )..add(AppStarted()),
            ),
            BlocProvider(
              create: (BuildContext context) => UserDataCubit(
                authBloc: context.read<AuthBloc>(),
                userDataRepository: context.read<UserDataRepository>(),
              ),
            ),
            BlocProvider(
              create: (BuildContext context) => LogoutCubit(
                  authRepository: context.read<AuthRepository>(),
                  authBloc: context.read<AuthBloc>(),
                  userDataRepository: context.read<UserDataRepository>()),
            ),
          ],
          child: MyApp(),
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Handover',
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: kMainColor,
            ),
          ),
          builder: EasyLoading.init(),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              switch (state.status) {
                case AuthStatus.authenticated:
                  return HomeGate();

                case AuthStatus.unauthenticated:
                  return LoginScreen();

                default:
                  //TODO replace with splash screen
                  return LoginScreen();
              }
            },
          ),
        );
      },
    );
  }
}
