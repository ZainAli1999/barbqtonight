import 'package:barbqtonight/core/common_widgets/error_screen.dart';
import 'package:barbqtonight/core/onboarding/onboarding_page.dart';
import 'package:barbqtonight/core/splash/splash_page.dart';
import 'package:barbqtonight/features/auth/pages/email_verification_page.dart';
import 'package:barbqtonight/features/auth/pages/login_page.dart';
import 'package:barbqtonight/features/auth/pages/sign_up_page.dart';
import 'package:barbqtonight/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteName {
  static const String splashPage = 'splash';
  static const String onboardingPage = 'onboarding';
  static const String loginPage = 'login';
  static const String signupPage = 'sign-up';
  static const String emailVerificationPage = 'email-verification';
  static const String attendancePage = 'attendance';
  static const String homePage = 'home';
  static const String notificationsPage = 'notifications';
  static const String profilePage = 'profile';
  static const String navbar = 'navbar';
  static const String editProfilePage = 'edit-profile';
  static const String changePasswordPage = 'change-password';
  static const String forgotPasswordPage = 'forgot-password';
  static const String notesPage = 'notes';
  static const String addProjectPage = 'add-project';
  static const String podcastPage = 'podcast';
  static const String taskDetailsPage = 'task-details';
  static const String editTaskPage = 'edit-task';
  static const String quizPage = 'quiz';
  static const String ourTeamPage = 'our-team';
  static const String eventsPage = 'events';
  static const String guessPaperPage = 'guess-paper';
  static const String selfExamPage = 'self-exam';
  static const String pastPaperPage = 'past-paper';
  static const String contactUsPage = 'contact-us';
  static const String blogsPage = 'blogs';
  static const String startQuizPage = 'start-quiz';
  static const String attemptQuizPage = 'attempt-quiz';

  GoRouter myrouter = GoRouter(
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: ErrorScreen());
    },
    routes: [
      GoRoute(
        path: '/',
        name: splashPage,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SplashPage());
        },
      ),
      GoRoute(
        path: '/$onboardingPage',
        name: onboardingPage,
        pageBuilder: (context, state) {
          return const MaterialPage(child: OnboardingPage());
        },
      ),
      GoRoute(
        path: '/$loginPage',
        name: loginPage,
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        path: '/$signupPage',
        name: signupPage,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignUpPage());
        },
      ),
      GoRoute(
        path: '/$emailVerificationPage',
        name: emailVerificationPage,
        pageBuilder: (context, state) {
          return const MaterialPage(child: EmailVerificationPage());
        },
      ),
      GoRoute(
        path: '/$homePage',
        name: homePage,
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomePage());
        },
      ),
      // GoRoute(
      //   path: '/$homePage',
      //   name: homePage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: NavBar(
      //         currentIndex: 0,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$ourTeamPage',
      //   name: ourTeamPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: NavBar(
      //         currentIndex: 1,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$notesPage',
      //   name: notesPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: NavBar(
      //         currentIndex: 3,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$podcastPage',
      //   name: podcastPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: NavBar(
      //         currentIndex: 2,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$notificationsPage',
      //   name: notificationsPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: NavBar(
      //         currentIndex: 3,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$quizPage',
      //   name: quizPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: NavBar(
      //         currentIndex: 4,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$eventsPage',
      //   name: eventsPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: EventsPage(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$guessPaperPage',
      //   name: guessPaperPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: GuessPaperPage(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$selfExamPage',
      //   name: selfExamPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: SelfExamPage(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$pastPaperPage',
      //   name: pastPaperPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: PastPaperPage(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$blogsPage',
      //   name: blogsPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: BlogsPage(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$contactUsPage',
      //   name: contactUsPage,
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //       child: ContactUsPage(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$startQuizPage/:id',
      //   name: startQuizPage,
      //   pageBuilder: (context, state) {
      //     return MaterialPage(
      //       child: StartQuizPage(
      //         id: int.parse(
      //           state.pathParameters['id'] ?? '',
      //         ),
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/$attemptQuizPage/:id',
      //   name: attemptQuizPage,
      //   pageBuilder: (context, state) {
      //     return MaterialPage(
      //       child: AttemptQuizPage(
      //         id: int.parse(
      //           state.pathParameters['id'] ?? '',
      //         ),
      //       ),
      //     );
      //   },
      // ),
    ],
  );
}
