/// Centralized route path constants for the entire app.
/// Replaces the old string-based page names ("Fancy Bet List", etc.).
abstract class RoutePaths {
  // ── Home ──
  static const home = '/';

  // ── Auth ──
  static const login = '/login';

  // ── Alpha Dashboard ──
  static const alphaRoot = '/alpha';
  static const alphaEventsManagement = '/alpha/events-management';
  static const alphaFancyBetList = '/alpha/fancy-bet-list';
  static const alphaSpecialFancyList = '/alpha/special-fancy-list';
  static const alphaBookmakerList = '/alpha/bookmaker-list';
  static const alphaTennisBookmakerList = '/alpha/tennis-bookmaker-list';
  static const alphaKabaddiBookmakerList = '/alpha/kabaddi-bookmaker-list';
  static const alphaElectionBookmakerList = '/alpha/election-bookmaker-list';
  static const alphaSettleMarket = '/alpha/settle-market';
  static const alphaSpecialSettleMarket = '/alpha/special-settle-market';
  static const alphaFancyMinMaxRuns = '/alpha/fancy-min-max-runs';
  static const alphaBookmakerSettleMarket = '/alpha/bookmaker-settle-market';
  static const alphaBookmakerMinMaxRuns = '/alpha/bookmaker-min-max-runs';
  static const alphaTennisSettleMarket = '/alpha/tennis-settle-market';
  static const alphaKabaddiSettleMarket = '/alpha/kabaddi-settle-market';
  static const alphaResultSourceManagement = '/alpha/result-source-management';
  static const alphaElectionSettleMarket = '/alpha/election-settle-market';
  static const alphaCreateAdmin = '/alpha/create-admin';
  static const alphaManageWlAdmin = '/alpha/manage-wl-admin';
  static const alphaManageRbAdmin = '/alpha/manage-rb-admin';
  static const alphaWlReports = '/alpha/wl-reports';
  static const alphaNetAggregatedReport = '/alpha/net-aggregated-report';
  static const alphaCreateLabel = '/alpha/create-label';
  static const alphaWhiteLabelManagement = '/alpha/white-label-management';
  static const alphaAccount = '/alpha/account';
  static const alphaManageFund = '/alpha/manage-fund';
  static const alphaChangePassword = '/alpha/change-password';

  // ── Fancy Dashboard ──
  static const fancyRoot = '/fancy';
  static const fancyFancyBetList = '/fancy/fancy-bet-list';
  static const fancySpecialFancyList = '/fancy/special-fancy-list';
  static const fancyBookmakerList = '/fancy/bookmaker-list';
  static const fancyTennisBookmakerList = '/fancy/tennis-bookmaker-list';
  static const fancyKabaddiBookmakerList = '/fancy/kabaddi-bookmaker-list';
  static const fancyElectionBookmakerList = '/fancy/election-bookmaker-list';
  static const fancySettleMarket = '/fancy/settle-market';
  static const fancySpecialSettleMarket = '/fancy/special-settle-market';
  static const fancyFancyMinMaxRuns = '/fancy/fancy-min-max-runs';
  static const fancyBookmakerSettleMarket = '/fancy/bookmaker-settle-market';
  static const fancyBookmakerMinMaxRuns = '/fancy/bookmaker-min-max-runs';
  static const fancyTennisSettleMarket = '/fancy/tennis-settle-market';
  static const fancyKabaddiSettleMarket = '/fancy/kabaddi-settle-market';
  static const fancyResultSourceManagement = '/fancy/result-source-management';
  static const fancyElectionSettleMarket = '/fancy/election-settle-market';
  static const fancyChangePassword = '/fancy/change-password';

  // ── Balance Dashboard ──
  static const balanceRoot = '/balance';
  static const balanceWlAdminDetails = '/balance/wl-admin-details';
  static const balanceSettlementDetails = '/balance/settlement-details';
  static const balanceAccounts = '/balance/accounts';
  static const balanceUserActivityLog = '/balance/user-activity-log';
  static const balanceChangePassword = '/balance/change-password';

  // ── Events Dashboard ──
  static const eventsRoot = '/events';
  static const eventsManagement = '/events/events-management';

  // ── Helpers ──

  /// Default page for a given role.
  static String defaultForRole(String role) {
    switch (role.toLowerCase()) {
      case 'alphaadmin':
        return alphaRoot;
      case 'fancymanager':
        return fancyRoot;
      case 'balancemanager':
        return balanceRoot;
      case 'eventsmanager':
        return eventsRoot;
      default:
        return login;
    }
  }

  /// Role prefix from a path (e.g., '/alpha/fancy-bet-list' → 'alpha').
  static String? rolePrefixFromPath(String path) {
    if (path.startsWith('/alpha')) return 'alpha';
    if (path.startsWith('/fancy')) return 'fancy';
    if (path.startsWith('/balance')) return 'balance';
    if (path.startsWith('/events')) return 'events';
    return null;
  }

  /// Check if the role is allowed for the given path prefix.
  static bool isRoleAllowedForPath(String role, String path) {
    final prefix = rolePrefixFromPath(path);
    if (prefix == null) return true; // Non-prefixed paths (login, etc.)
    switch (role.toLowerCase()) {
      case 'alphaadmin':
        return prefix == 'alpha';
      case 'fancymanager':
        return prefix == 'fancy';
      case 'balancemanager':
        return prefix == 'balance';
      case 'eventsmanager':
        return prefix == 'events';
      default:
        return false;
    }
  }

  /// Build a fancy drilldown path (markets list for an event).
  static String fancyMarkets(String rolePrefix, String basePath, String eventId, {String? marketType}) {
    final path = '/$rolePrefix/${_stripPrefix(basePath)}/$eventId/markets';
    if (marketType != null) return '$path?marketType=$marketType';
    return path;
  }

  /// Build a fancy drilldown path (manage specific market).
  static String fancyMarketManage(String rolePrefix, String basePath, String eventId, String marketId) {
    return '/$rolePrefix/${_stripPrefix(basePath)}/$eventId/markets/$marketId';
  }

  /// Build a fancy manager path.
  static String fancyManager(String rolePrefix, String basePath, String eventId) {
    return '/$rolePrefix/${_stripPrefix(basePath)}/$eventId/manage';
  }

  static String sequenceManager(String rolePrefix, String basePath, String eventId) {
    return '/$rolePrefix/${_stripPrefix(basePath)}/$eventId/sequence';
  }

  static String _stripPrefix(String path) {
    // '/alpha/fancy-bet-list' → 'fancy-bet-list'
    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    return parts.length > 1 ? parts.sublist(1).join('/') : parts.join('/');
  }
}
