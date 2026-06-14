import 'package:go_router/go_router.dart';

// Views
import 'screens/landing/landing_view.dart';
import 'screens/onboarding/onboarding_view.dart';
import 'screens/home/home_view.dart';
import 'screens/food_log/food_log_view.dart';
import 'screens/add_meal/add_meal_view.dart';
import 'screens/ai_recipes/ai_recipes_view.dart';
import 'screens/saved_recipes/saved_recipes_view.dart';
import 'screens/food_info/food_info_view.dart';
import 'screens/profile/profile_view.dart';
import 'screens/about_us/about_us_view.dart';


GoRouter createRouter(bool isFirstLaunch) {
  return GoRouter(
    // If it's the first launch, start at the root ('/'). Otherwise, skip to '/home'.
    initialLocation: isFirstLaunch ? '/' : '/home',

    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingView()),
      GoRoute(path: '/landing', builder: (context, state) => const LandingView()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeView()),
      GoRoute(
        path: '/food_log',
        builder: (context, state) => const FoodLogView(),
      ),
      GoRoute(
        path: '/add_meal',
        builder: (context, state) => const AddMealView(),
      ),
      GoRoute(
        path: '/ai_recipes',
        builder: (context, state) => const AiRecipesView(),
      ),
      GoRoute(
        path: '/saved_recipes',
        builder: (context, state) => const SavedRecipesView(),
      ),
      GoRoute(
        path: '/food_info',
        builder: (context, state) => const FoodInfoView(),
      ),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileView()),
      GoRoute(path: '/about_us', builder: (context, state) => AboutUsView()),
    ],
  );
}