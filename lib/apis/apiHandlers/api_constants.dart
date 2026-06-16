const String baseDomain = "dmxchge.com";
const String api = "api";

class AuthApiConstants {
  static const String baseUrlApi = 'https://abcuser.dmxchge.com/api/';
  static const String baseUrl = 'https://abcuser.dmxchge.com/api/Auth/';
  static const String register = 'register';
  static const String login = '${baseUrl}login';
  static const String activityLog = 'activityLog';
  static const String toggleEvents = 'https://abcuser.dmxchge.com/api/toggleEvents';
  static const String wlnet = '${baseUrlApi}wlnet';
  static const String twofactor = 'twofactor';
  static const String enableTotp = 'enableTotp';
  static const String isTotpenable = 'isTotpenable';
  static const String varifyToken = '${baseUrl}varifyToken/';
  static const String changePassword = 'change-password';
  static const String resetPassword = '${baseUrl}change-password-1';
  static const String ip = 'https://api.ipify.org?format=json';
  static const String isp = 'https://ipapi.co/json/';
  static const String checkUserName = '${baseUrl}validateName?name=';
}

class AccountApiConstants {
  static const String baseUrl = 'https://abcuser.dmxchge.com/api/';
  static const String account = 'Account';
  static const String mainUrl = '$baseUrl$account';
  static const String mappedUser = '$mainUrl/mappedUser';
  static const String depositWithdrawal = '$mainUrl/depositWithdrawal';
  static const String creditRequest = '$account/creditRequest';
  static const String creditResponse = '$account/creditResponse';
  static const String depositWithdraw = '$account/depositWithdraw';
  static const String getUsers = '$account/getUsers';
  static const String resetPassword = '$account/resetPassword';
  static const String directdDepositWithdraw = '$account/directdDepositWithdraw';
  static const String selttlement = '$account/selttlement';
  static const String activityLog = '$account/activityLog';
}

class OrdersApiConstants {
  static const String baseUrl = 'https://abcorder.dmxchge.com/';
  static const String wlpnlReport = 'wlpnlReport';
  static const String listener = '${baseUrl}listener';
}

class SportsApiConstants {
  static const String baseUrl = 'https://abcdata.$baseDomain/$api/';
  static const String eventTypes = '${baseUrl}eventTypes';
  static const String sportsEvents = '${baseUrl}sportsEvents';
  static const String bookmaker = '${baseUrl}bookmaker';
  static const String odds = '${baseUrl}odds';
  static const String fancy = '${baseUrl}fancy';
  static const String competition = '${baseUrl}competition';
  static const String bmSignalRUrl = 'https://abcdata.dmxchge.com/broadcast';
}

class WlApiConstants {
  static const String baseUrl = 'https://abcuser.dmxchge.com/api/';
  static const String wl = 'WL/';
  static const String add = '${wl}add';
  static const String wlnet = '${baseUrl}wlnet';
  static const String getAll = '${wl}getAll';
  static const String update = '${wl}update';
  static const String wlfullReport = 'wlfullReport';
}

class EventManagementApiConstants {
  static const String baseUrl = 'https://abcmanager.dmxchge.com/api/EM/';
  static const String eventTypes = 'eventType';
  static const String events = 'events';
  static const String competitions = 'competitions';
  static const String markets = 'markets';
  static const String toggleEvents = 'toggleEvents';
  static const String setResult = 'setResult';
  static const String voidCatalouge = 'voidCatalouge';
  static const String toogleFancy = 'toogleFancy';
  static const String newFancy = 'newFancy';
  static const String fancydata = 'fancydata';
  static const String betExposure = 'betExposure';
  static const String allMarketAction = 'allMarketAction';
  static const String settleMarket = 'settle';
  static const String parseFormula = 'parseFormula';
  static const String updateMarketCondition = 'updateMarketCondition';
  static const String updateSort = 'updateSort';
  static const String eventFancyBet = 'eventFancyBet';
  static const String catalougesMarketType = 'catalouges-marketType';
  static const String setPremium = 'setPremium';
}

class ManageMarketResult {
  static const String baseUrl = 'https://abcmanager.dmxchge.com/';
  static const String save = 'save';
  static const String getCustomMarket = 'getCustomMarket';
  static const String settle = 'settle';
  static const String getSettleHistory = 'getSettleHistory';
}
