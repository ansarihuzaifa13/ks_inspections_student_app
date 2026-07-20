import 'package:go_router/go_router.dart';
import '../features/charge/pages/charge_detail_page.dart';
import '../features/contest/pages/contest_page.dart';
import '../features/inspection/pages/inspection_detail_page.dart';
import '../features/maintenance/pages/maintenance_hub_page.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const MaintenanceHubPage(),
      ),
      GoRoute(
        path: '/inspection/:id',
        builder: (context, state) =>
            InspectionDetailPage(
              inspectionId: state.pathParameters['id']!,
            ),
      ),
      GoRoute(
        path: '/charge/:id',
        builder: (context, state) =>
            ChargeDetailPage(
              chargeId: state.pathParameters['id']!,
            ),
      ),
      GoRoute(
        path: '/contest/:id',
        builder: (context, state) =>
            ContestPage(
              chargeId: state.pathParameters['id']!,
            ),
      ),
    ],
  );
}