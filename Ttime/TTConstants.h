
// This is our public api key used to interact with the MBTA
#define TT_MBTA_API_KEY @"MQMcpRbPNkusVWUGofSMIA"

// Google Analytics ID
#define TT_GOOGLE_ANALYTICS_ID @"UA-45023775-1"

// In app purchase
#define TT_IN_APP_PURCHASE_SECRET @"b8e9931df12e4b8aa8aa0a648f226306"

//---------------------------------------- SYSTEM VERSIONS

// Use these sparingly. Always better to test for the existence of a class or selector when possible.
#define TT_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define TT_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define TT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define TT_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define TT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define TT_IS_IOS7() (TT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))

#define TT_IS_IOS6() (TT_SYSTEM_VERSION_LESS_THAN(@"7.0"))
