import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';
import 'bloc/bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<MedicineCubit>(
          create: (context) => MedicineCubit()..loadMedicines(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit()..loadCart(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => FavoritesCubit(),
        ),
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider<CategoriesCubit>(
          create: (context) => CategoriesCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: AppColors.primary,
            onPrimary: AppColors.textOnPrimary,
            secondary: AppColors.secondary,
            onSecondary: AppColors.textOnPrimary,
            tertiary: AppColors.accent,
            onTertiary: AppColors.textPrimary,
            error: AppColors.error,
            onError: AppColors.textOnPrimary,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
            surfaceContainerHighest: AppColors.surfaceVariant,
            onSurfaceVariant: AppColors.textSecondary,
            outline: AppColors.borderMedium,
            outlineVariant: AppColors.borderLight,
          ),
          scaffoldBackgroundColor: AppColors.background,
          cardColor: AppColors.surface,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.textPrimary),
            bodyMedium: TextStyle(color: AppColors.textSecondary),
            bodySmall: TextStyle(color: AppColors.textTertiary),
            headlineLarge: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            titleLarge: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            titleMedium: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            labelLarge: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            centerTitle: false,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: AppColors.borderLight,
            thickness: 1,
          ),
          useMaterial3: true,
        ),
        // Start with splash screen
        home: const SplashScreen(),
      ),
    );
  }
}
