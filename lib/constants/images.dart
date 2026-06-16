import 'package:flutter/foundation.dart';

class AssetsConstants {
  static const String base = 'assets/images';
  static const String svgBase = 'assets/svg';

  //login screen
  static const String lineBg = '$base/line.png';
  static const String sports = '$base/sports.png';
  static const String award = '$svgBase/award.svg';
  static const String loginBg = '$base/bg_login.png';
  static const String nodata = '$base/nodata.png';
  static const String loginBg2 = '$base/bg-login.jpg';
  static const String favicon = '$base/favicon.png';
  static const String losses = '$svgBase/losses.svg';
  static const String insta = '$svgBase/insta.svg';
  static const String telegram = '$svgBase/telegram.svg';
  static const String logout = '$svgBase/logout.svg';
  static const String skyp = '$svgBase/skyp.svg';
  static const String support = '$svgBase/support.svg';
  static const String whatsapp = '$svgBase/whatsapp.svg';
  static const String winnings = '$base/winnings.png';
  static const String logo512 = '$base/logo512.png';
  static const String sponsor = '$svgBase/sponsor.svg';
  static const String commodity = '$base/commodity.png';
  static const String appLogo = '$svgBase/Group 815.svg';
  static const String netPosMgt = '$svgBase/net pos.svg';
  static const String subMaster = '$base/sub_master.png';
  static const String logincard = '$base/logincard.png';
  static const String commission = '$base/commission.png';
  static const String imagePlaceholder = '$base/image.png';
  static const String withdrawal = '$base/withdrawal.png';
  static const String netBalance = '$base/net_balance.png';
  static const String superMaster = '$base/super_master.png';
  static const String totalClient = '$base/total_clients.png';
  static const String notVerified = '$base/not-verified.png';
  static const String iconBrowser = '$base/icon-browser-W.png';
  static const String acSummary = '$svgBase/account-summary.svg';
  static const String sportsResult = '$svgBase/sports_result.svg';
  static const String sportsConfig = '$svgBase/sports_config.svg';
  static const String adminDashboard = '$base/admin_dashboard.png';
  static const String userManagement = '$base/user_management.png';
  static const String allocatedFunds = '$base/allocated_funds.png';
  static const String orderManagement = '$base/order_management.png';
  static const String declarationDetails = '$svgBase/decleration.svg';
  static const String richTextEditor = '$svgBase/rich_text_editor.svg';
  static const String gamingPartners = '$svgBase/gaming_partners.svg';
  static const String oneByOneBanner = '$svgBase/one_by_one_banner.svg';
  static const String commodityConfig = '$svgBase/commodity_config.svg';
  static const String hierarchyIcon = '$svgBase/hierarchy-optimized.svg';
  static const String contentMgt = '$svgBase/menu_content_management.svg';
  static const String requestsManagement = '$svgBase/pendingRequests.svg';
  static const String totalDeposit = '$svgBase/total_deposit-optimized.svg';

  ///used in firebase_user_model.dart , chat_room_view.dart
  static const String photoUrl = "https://img.icons8.com/?size=512&id=13042&format=png";
}

const String imagePlaceholder = kReleaseMode ? "assets/${AssetsConstants.imagePlaceholder}" : AssetsConstants.imagePlaceholder;
