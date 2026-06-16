final List<String> fancyBetListHeader = [
  'Event Id',
  'Event Start Date',
  'Competition',
  'Event Name',
  'Last Market Start Date',
  'Market Day',
  'Rating',
  'Market List',
  "Sequence",
  'Manager',
];
final List<String> fancyMarketListHeader = [
  'Event Start Date',
  'Event Id',
  'Market Time',
  'Market Id',
  'Market Day',
  'Market Name',
  'Market Type',
  'Sequence',
  'Status',
  "OP",
  "Operating",
  "Remark",
];
final List<String> fancyMarketListHeaderSequence = ['Event Start Date', 'Event Id', 'Market Id', 'Market Name', 'Market Type', 'Sequence', 'Status'];
final List<String> liveFancyBetSettingHeader = ['Setting', 'Description'];
final List<String> runsOddHisTitle = ['Runn NO', 'Runn Yes', 'Odd NO', 'Odd Yes', 'Exposure No', 'Exposure Yes', 'Create Date', 'Creator'];
final List<Map<String, String>> settingsData = [
  {"setting": "/Runs.Yes Odds.No Odds", "description": "Example 35.85.115, this will set run for No = 35, Yes = 35. Odd for No = 115, Odd for Yes = 85"},
  {"setting": "Enter", "description": "For BALL_RUN the market"},
  {"setting": "0", "description": "For SUSPEND the market"},
  {"setting": "00", "description": "For ONLINE the market"},
  for (int i = 1; i <= 60; i++) {"setting": "+$i", "description": "This will set run for No = Number+0, Yes = Number+$i. Odds for both will be 100"},
  {"setting": "+*", "description": "This will set run for No = Number+0, Yes = Number+0. Odds for both will be 100"},
  {"setting": "-*", "description": "This will set run for No = Number+0, Yes = Number+0. Odds for both will be 100"},
  {"setting": "Runs Number.5", "description": "Example 35.5, this will set run for No = 35, Yes = 35. Odd for No = 15, Odd for Yes = 5"},
  {"setting": "Runs Number.10", "description": "Example 35.10, this will set run for No = 35, Yes = 35. Odd for No = 20, Odd for Yes = 10"},
  {"setting": "Runs Number.15", "description": "Example 35.15, this will set run for No = 35, Yes = 35. Odd for No = 25, Odd for Yes = 15"},
  {"setting": "Runs Number.20", "description": "Example 35.20, this will set run for No = 35, Yes = 35. Odd for No = 30, Odd for Yes = 20"},
  {"setting": "Runs Number.25", "description": "Example 35.25, this will set run for No = 35, Yes = 35. Odd for No = 35, Odd for Yes = 25"},
  {"setting": "Runs Number.30", "description": "Example 35.30, this will set run for No = 35, Yes = 35. Odd for No = 40, Odd for Yes = 30"},
  {"setting": "Runs Number.35", "description": "Example 35.35, this will set run for No = 35, Yes = 35. Odd for No = 45, Odd for Yes = 35"},
  {"setting": "Runs Number.70", "description": "Example 35.70, this will set run for No = 35, Yes = 35. Odd for No = 90, Odd for Yes = 70"},
  {"setting": "Runs Number.75", "description": "Example 35.75, this will set run for No = 35, Yes = 35. Odd for No = 125, Odd for Yes = 75"},
  {"setting": "Runs Number.80", "description": "Example 35.80, this will set run for No = 35, Yes = 35. Odd for No = 120, Odd for Yes = 80"},
  {"setting": "Runs Number.85", "description": "Example 35.85, this will set run for No = 35, Yes = 35. Odd for No = 115, Odd for Yes = 85"},
  {"setting": "Runs Number.90", "description": "Example 35.90, this will set run for No = 35, Yes = 35. Odd for No = 110, Odd for Yes = 90"},
  {"setting": "Runs Number.95", "description": "Example 35.95, this will set run for No = 35, Yes = 35. Odd for No = 115, Odd for Yes = 95"},
  {"setting": "Runs Number.99", "description": "Example 35.99, this will set run for No = 35, Yes = 35. Odd for No = 119, Odd for Yes = 99"},
  {"setting": "Runs Number.101", "description": "Example 35.101, this will set run for No = 35, Yes = 35. Odd for No = 120, Odd for Yes = 100"},
  {"setting": "Runs Number.105", "description": "Example 35.105, this will set run for No = 35, Yes = 35. Odd for No = 125, Odd for Yes = 105"},
  {"setting": "Runs Number.110", "description": "Example 35.110, this will set run for No = 35, Yes = 35. Odd for No = 130, Odd for Yes = 110"},
  {"setting": "Runs Number.115", "description": "Example 35.115, this will set run for No = 35, Yes = 35. Odd for No = 140, Odd for Yes = 115"},
  {"setting": "Runs Number.120", "description": "Example 35.120, this will set run for No = 35, Yes = 35. Odd for No = 170, Odd for Yes = 120"},
  {"setting": "Runs Number.125", "description": "Example 35.125, this will set run for No = 35, Yes = 35. Odd for No = 145, Odd for Yes = 125"},
  {"setting": "Runs Number.130", "description": "Example 35.130, this will set run for No = 35, Yes = 35. Odd for No = 150, Odd for Yes = 130"},
  {"setting": "Runs Number.150", "description": "Example 35.150, this will set run for No = 35, Yes = 35. Odd for No = 250, Odd for Yes = 150"},
  {"setting": "Runs Number.160", "description": "Example 35.160, this will set run for No = 35, Yes = 35. Odd for No = 160, Odd for Yes = 120"},
  {"setting": "Runs Number.250", "description": "Example 35.250, this will set run for No = 35, Yes = 35. Odd for No = 400, Odd for Yes = 250"},
];

///
final List<Map<String, String>> settingsThreeSelectionData = [
  {"setting": "/Runs.Yes Odds.No Odds", "description": "Example 35.85.115 → Run(No)=35, Run(Yes)=35, Odd(No)=115, Odd(Yes)=85"},
  {"setting": "Enter", "description": "For BALL_RUN the market"},
  {"setting": "0", "description": "For SUSPEND the market"},
  {"setting": "00", "description": "For ONLINE the market"},
  {"setting": "Runs Number*A", "description": "Example 50*A → Offers first & third selections; second selection not offered"},
  {"setting": "Runs Number+", "description": "Example +3 → Run(No)=Number+3, Run(Yes)=Number+3, Odds remain 100 or original"},
  {"setting": "Runs Number+3", "description": "Run(No)=Number+0, Run(Yes)=Number+3, Odds=100 for both"},
  {"setting": "Runs Number+4", "description": "Run(No)=Number+0, Run(Yes)=Number+4, Odds=100 for both"},
  {"setting": "+Runs Number", "description": "Example +* → Run(No)=Number, Run(Yes)=Number, Odds=100 for both"},
  {"setting": "-Runs Number", "description": "Example -* → Run(No)=Number, Run(Yes)=Number, Odds=100 for both"},

  // Generic pattern for +6 to +60 (same rule)
  {"setting": "Runs Number+6 to +60", "description": "Run(No)=Number+0, Run(Yes)=Number+X (where X=6…60), Odds=100 for both"},

  // Letter based commands
  {"setting": "Runs Number+A", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=100, Odd(Yes)=85"},
  {"setting": "Runs Number+S", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=115, Odd(Yes)=100"},
  {"setting": "Runs Number+D", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=100, Odd(Yes)=80"},
  {"setting": "Runs Number+F", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=120, Odd(Yes)=100"},
  {"setting": "Runs Number+Z", "description": "NoRun & YesRun averaged → (Number + Number+2)/2, Odd(No)=110, Odd(Yes)=90"},
  {"setting": "Runs Number+X", "description": "NoRun & YesRun averaged → (Number + Number+2)/2, Odd(No)=115, Odd(Yes)=85"},
  {"setting": "Runs Number+C", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=100, Odd(Yes)=90"},
  {"setting": "Runs Number+V", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=110, Odd(Yes)=100"},
  {"setting": "Runs Number+B", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=125, Odd(Yes)=75"},
  {"setting": "Runs Number+N", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=140, Odd(Yes)=90"},
  {"setting": "Runs Number+Q", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=100, Odd(Yes)=75"},
  {"setting": "Runs Number+W", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=125, Odd(Yes)=100"},
  {"setting": "Runs Number+E", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=100, Odd(Yes)=70"},
  {"setting": "Runs Number+R", "description": "Run(No)=Number, Run(Yes)=Number+2, Odd(No)=130, Odd(Yes)=100"},
];
final List<String> minMaxBetList = ['1-500', '1-15000', '1-20000', '1-200', '1-2', '1-100', '1-500', '1-1000', '1-2000', '1-3000', '1-5000', '1-15000', '1-250', '1-50', '1-10000'];
final List<String> fancySettleMarketHeader = ['Event Id', 'Market Open Date', 'Market Name', 'Result Source Default Setting', 'Market Day', 'Event Status'];
final List<String> resultSource = ['Cricbuzz', 'CricInfo', 'ESPNSport'];
final List<String> marketSettlingHeaders = ['Market Id', 'Market Name', 'Runs', "Result Source", "Updator", "Status", "Transaction Count", "Settle/Void", "Operator", "Settle Log"];
final List<String> specialFancyBetlist = ['Event Id', 'Event Start Date', 'Competition', "Event Name", "Lastest Market Start Date", "Market Day", "Market List", "Manager"];
final List<String> bookMakerBetlist = ['Event Id', 'Event Start Date', 'Competition', "Event Name", "OP", "Manager"];
final List<String> tennisBetlist = ['Event Id', 'Event Start Date', 'Competition', "Event Name", 'Market Name', "Selection", "Rating", "OP", "Market List"];
final List<String> kabaddiBetlist = ['Event Id', 'Event Start Date', 'Competition', "Event Name", 'Market Name', "Selection", "Rating", "OP", "Market List"];
final List<String> specialSettleFancy = ['Event Id', 'Market Open Date', 'Market Name', "Event Name", "Result Source Default Setting", "Market Day", "Event Status"];
final List<String> bmSettle = ['Event Id', 'Market Open Date', 'Market Name', "Market Day", "Event Status"];
final List<String> tennisettle = ['Event Id', 'Market Open Date', 'Market Name', "Market Day", "Event Status"];
final List<String> kabaddisettle = ['Event Id', 'Market Open Date', 'Market Name', "Market Day", "Event Status"];
final List<String> resultSourceManagement = ['Result Source', 'URL', 'Type', "Remark", "Function"];
final List<String> electionSettle = ['Event Id', 'Market Open Date', 'Market Name', "Market Day", "Event Status"];
final List<String> fancySettleHis = ['Id', 'Market Id', "Result", "Settle Type", "Create Date", "Settler", "Message"];
