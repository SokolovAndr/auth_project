import 'package:auth_project/data/provider/author_provider.dart';
import 'package:auth_project/data/provider/book_provider.dart';
import 'package:auth_project/data/provider/genre_provider.dart';
import 'package:auth_project/data/provider/image_provider.dart';
import 'package:auth_project/data/repository/author_repository.dart';
import 'package:auth_project/data/repository/book_repository.dart';
import 'package:auth_project/data/repository/genre_repository.dart';
import 'package:auth_project/data/repository/image_repository.dart';
import 'package:auth_project/logic/bloc/author_bloc.dart';
import 'package:auth_project/logic/bloc/book_bloc.dart';
import 'package:auth_project/logic/bloc/genre_bloc.dart';
import 'package:auth_project/logic/bloc/image_bloc.dart';
import 'package:auth_project/logic/cubit/navigation_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/account_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/verify_email_screen.dart';
import 'services/firebase_stream.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (context) => AuthorRepository(AuthorProvider())),
        RepositoryProvider(
            create: (context) => GenreRepository(GenreProvider())),
        RepositoryProvider(create: (context) => BookRepository(BookProvider())),
        RepositoryProvider(
            create: (context) => ImageRepository(MyImageProvider())),
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider(
            create: (context) => AuthorBloc(context.read<AuthorRepository>())),
        BlocProvider(
            create: (context) => GenreBloc(context.read<GenreRepository>())),
        BlocProvider(
            create: (context) => BookBloc(context.read<BookRepository>())),
        BlocProvider(
            create: (context) => ImageBloc(context.read<ImageRepository>())),
        BlocProvider(
          lazy: false,
          create: (context) => NavigationCubit(),
        ),
      ], child: const MyApp())));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/',
    );
  }
}
