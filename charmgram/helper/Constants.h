//
//  constants.h
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

typedef enum{
	PrivateImageStateNormal=0,
	PrivateImageStateSelected=1,
	PrivateImageStateDownloading=2,
	PrivateImageStateDownloadFailed=3,
	PrivateImageStateDownloaded=4,
	PrivateImageStateViewed=5,
	PrivateImageStateSnapshot=6
}PrivateImageState;

typedef enum{
	UploadImageStateNormal=0,
	UploadImageStateUploading=1,
	UploadImageStateUploadFailed=2,
	UploadImageStateUploadDone=3
}UploadImageState;

typedef enum {
	isLogin,
	isRegist,
	isFindPwd,
}LoginStateType;

#define COLOR_BACKGROUND [UIColor colorWithRed:233/255.0 green:232/255.0 blue:228/255.0 alpha:1.0]

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define StandardDateTimeFormat @"yyyy-MM-dd HH:mm:ss"
#define kMenuPanelWidth 			260.0
#define kFriendPanelWidth 			260.0
#define kPanPanelDistance           70.0
#define kTagMaskOffset 				100
#define kTopbarHeight 				44

#define PLAZA_DONGTAI           100
#define PLAZA_FAXIAN			110
#define PLAZA_FUJIN				120
 

#define METHOD_REGISTER                     	@"register"
#define METHOD_LOGIN                        		@"login"
#define METHOD_UPDATETOKEN                  @"updateToken"
#define METHOD_UPDATEHEADIMG               @"updateHeadimage"
#define METHOD_UPDATEUSERINFO            @"updateUserInfo"
#define METHOD_UPDATEPUSH               @"updatePushStatus"
#define METHOD_SHAREPHOTO                	@"sharePhoto"
#define METHOD_SHAREPHOTO                	@"sharePhoto"
#define METHOD_HOTPHOTO						@"hotPhotoByPage"
#define METHOD_NEARBYPHOTO					@"getNearbyUsers"
#define METHOD_STATUSPHOTO					@"statusQuery"
#define METHOD_STATUSLOOK                      @"userWatched"
#define METHOD_STATUSLOOKUNLOGIN                      @"notloginWatch"
#define METHOD_LIKE								@"inUpdateZCount"
#define METHOD_UNLIKE							@"outUpdateZCount"
#define METHOD_GIFTLIST							@"giftOnOffer"
#define METHOD_MOREGIFTLIST	                @"giftOfPhoto"
#define METHOD_SENDMESSAGE				@"sendMessage"
#define METHOD_MESSAGELIST					@"getNewMessage"
#define METHOD_REPORTIMAGE					@"insertReport"
#define METHOD_FOLLOWUSER					@"insertCare"
#define METHOD_UNFOLLOWUSER				@"cancelCare"
#define METHOD_MYFOLLOW						@"careQuery"


#define METHOD_MYFAN							@"caredQuery"
#define METHOD_ADDBLACK                 @"addBlack"
#define METHOD_DELBLACK                 @"delBlack"
#define METHOD_MYBLACKLIST              @"myBlackList"
#define METHOD_SEARCH                       @"searchUser"
#define METHOD_TUIJIAN                      @"commentUser"
#define METHOD_USERINFO                     @"queryUserInf"
#define METHOD_MYPHOTOLIST					@"photoQuery"
#define METHOD_MYPUSH						@"pushQuery"
#define METHOD_CLEARPUSH					@"clearPush"
#define METHOD_SENDGIFT                     @"sendGift"
#define METHOD_GETSTATUS                    @"getCommentStatus"
#define METHOD_GETUNIQUEID                  @"getUniqueId"
#define METHOD_GETCOLLECT                    @"collectMessage"
#define METHOD_GETMESSAGE                    @"getMessage"
#define METHOD_GETMWSSAGEUSER              @"getNearMessageUser"
#define METHOD_GETUNREADUSER              @"getUnreadUser"
#define METHOD_GETPWd                       @"forgotPassword"
#define METHOD_POSTORDER                   @"saveOrder"
#define METHOD_USER_STATUS						@"userCoinStatus"

#define TAGOFFSET_BASE 					100
#define TAGOFFSET_LOCK 					110
#define TAGOFFSET_INDI 					120
#define TAGOFFSET_MASK					130
#define TAGOFFSET_IMGLIKE               140
#define TAGOFFSET_LBLLIKE 				150
#define TAGOFFSET_SECOND 				160
#define TAGOFFSET_TICK	 				170
#define TAGOFFSET_PRIVATECELL		1000000
#define TAGOFFSET_BUBBLECELL		1000000


#define SHAREAPPURL @"http://paopaobeauty.com/download.php"
#define AppEvaluateUrl [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=594756080"]
#define ZhifubaoUrl [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id535715926?mt=8"]//[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id333206289?mt=8"]

#define UrlBase @"http://paopaobeauty.com/photoshare/webService.php"

#define UrlRegister		[NSString stringWithFormat:@"%@?method=register", UrlBase]
#define UrlLogin			[NSString stringWithFormat:@"%@?method=login", UrlBase]

#define StatusBarHeight 20

#define SHADOW_COLOR [UIColor colorWithWhite:0.2 alpha:1.0]

#define UrlAliCallBack     @"http://paopaobeauty.com/photoshare/webService.php"// [NSString stringWithFormat:@"%@/!pay-taobao", @"http://www.liangpai.me"]

#define ALIPAYPARTNER @"2088801479085851"
#define ALIPAYSELLER @"2088801479085851"
#define ALIPAYOUT_TRADE_NO @"U00718-130116-2913"

#define ALIPAYPRIVATEKEY @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKzuCh8niVwCLRMDMg1MwUggztYWjCBWIVq/OtIH+F6A4Y1YpZz0b27wmzkiwGqV5rWI53c5b4WUXAZFRVMrr0gPbnBnussBFcXY6gSOtE+L7DlH71Xch6BMdBmxctcS92WvDqSMxwuaZXmBl1Wls/bRx8CUW1RurtyzfOi4nTKdAgMBAAECgYBKgq5dyh1HRbDCNmhEjsPhHjHA0SpDbJkmjqr7gG+l2IZW7tE9FZ1GAen/7ldWFYy4v2psVpUUy13zXbmHIpV9Eygce/U7bO5gOVRij24RyJMAwPianK8WgmmfCgMWRI+BynNha8av79symtCUGifqVoJHQ75lQFxQrdhJAIXdyQJBAOSZ5jq/GoO9G5NHwfvE3MePUbGGU/lBgZUT3CjD4GS80wVi5wkItuW8pBrZWkFRPTqdl7wt4BTwRqp4LkFtijMCQQDBp/5hZ3gd9TPuBDU7FQGHhjbp24xmyPungnWsM70dr44FfyyKwmnAZgO1lfBqdaZd/Xw/5LOWMvtDMas+7x/vAkEA4ZEGPzNwm0tPWV12CNMwsu01RAFy/MFpdstY8xSMZ3p2kpsLs7tYlYo1N5T+3PKngx4bqgBuWtrYL79UjRTkRwJASKlN6yI1kZgFShNOHcL99enIBOsZvR9APVPX7yrilJbgRPO4tL/JiiU80w9VS7ylFbMcwaSANaUfXdDvHgf/BQJBAJ8G48op2R5GiN2WgGfhfZg1p8/sXPH5t/cCTttDkuc6ZSkawzfnt/9Efn8TWmN1+Mvp+up5eEIIudAB81W9Ca8="

#define ALIPAYPUBLICKEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCh6vbH1ufsEvgwOryIZO0Ej0qDHGLJ/GAtQIylyaD9dyUA38sSKNJM2w+Xd11HwaDIZ3bNy6iBaVukQ+Ozglln4fr38ckxObtwfxjQqpFk7Jh4gv8F6fy11/6gnEEr2Q7RdQZkfs64JL80Tusnob6Qwk16Mu5ilKfVWt3BkV1fTQIDAQAB"

#define REQUEST_CODE_SUCCESS        200

#define KEYBOARD_HEIGHT         216
#define KEYBOARD_HEIGHT2        252

#define CHAT_ITEM_MAXWIDTH      208
#define CHAT_ITEM_FONT      [UIFont systemFontOfSize:15.0]

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define IMAGE_TOOLBAR_LIKE 				0
#define IMAGE_TOOLBAR_CHAT              1
#define IMAGE_TOOLBAR_GIFT 				2
#define IMAGE_TOOLBAR_SHARE             3
#define IMAGE_TOOLBAR_MORE              4

#define HEADER_MINHEIGHT           10

#define MaxTextViewHeight   90

#define ChineseFontRedColor     [UIColor colorWithRed:167/255.0 green:59/255.0 blue:46/255.0 alpha:1.0]
#define ChineseFontGoldColor    [UIColor colorWithRed:110.0/255 green:74.0/255 blue:31.0/255 alpha:1.0]

#define NOTIFICATION_KEYNAME            @"NOTIFICATION_KEYNAME"
#define NOTIFICATION_TO_TRENDS          @"NOTIFICATION_FOR_TRENDS"

#define NOTIFICATION_ID_SENTGIFT        101



////内购
//
//#define SPLASH_SCREEN_TIME 1
//
////Image folder
//#define ANIMATION_FOLDER @"MANGA"
//
////clock 12/24 hours
//#define HOURS_12 12
//#define HOURS_24 24
//
////set animation time in sec
//#define ANIMATION_TIME 5.0f * 60.0f
//
////display type for device
//#define DEVICE_IPHONE_P 0
//#define DEVICE_IPHONE_L 1
//#define DEVICE_IPAD_P 2
//#define DEVICE_IPAD_L 3
////#define STORE_TEST  foremulator
////dodaii server detail
//
//#define DODAII_URL @"http://122.255.83.148"
//// for store
//#ifdef STORE_TEST
//// prepare
////#define APPLICATION_ID @"74e8404dde41d746ca0c3c3584def203"
////#define APPLICATION_ID @"02181f4fdd304ba98b1c664631595a0a"
//#define APPLICATION_ID @"b0391175eb7c4a2281fe9dde03d83dd1"
//
//#define GROUPLISTURL @"/if/get_group_list.php?token="
////#define LISTURL @"/if/get_item_list.php?token="
//#define LISTURL @"/if/get_product_list.php?groupid=%@&&token="
//#define RELATIONURL @"/if/get_relation_item.php?token=%@&identifier=%@"
//#define REPSTR @"\"http://kk-pollyanna.com/sm/1_00_credit.jpg\""
//#else
//#define APPLICATION_ID @"74e8404dde41d746ca0c3c3584def203"
//#define GROUPLISTURL @"/if/get_group_list.php?token="
////#define LISTURL @"/if/get_item_list.php?token="
//#define LISTURL @"/if/get_product_list.php?groupid=%@&&token="
//#define RELATIONURL @"/if/get_relation_item.php?token=%@&identifier=%@"
//#define REPSTR @"\"\""
//#endif
//
//#define D_EMAIL         @""
#define D_PASSWORD      @"1234"

#define GotPdfData @"GotPdfData"
#define FinishData @"FinishData"
#define ErrorInGetPdfData @"ErrorInGetPdfData"
#define StartDownloadData @"StartDownloadData"
#define CheckCurrentDownload @"CheckCurrentDownload"

//Free or Paid App
#define KEY_PAID_APP @"Paid Application"

@class PrivateImage;

@protocol UploadImageDelegate <NSObject>

@optional
-(void)didUploadPhoto:(NSString*)imgFile;

@end

@protocol BubbleCellDelegate <NSObject>
-(void)CellAddDownItem:(PrivateImage *)img;
-(void)CellStateChanged:(NSDictionary*)dict;
-(void)CellLongPressBegan:(NSDictionary*)dict;
-(void)CellLongPressEnded:(NSDictionary*)dict;
-(void)CellLongPressCancelled:(NSDictionary*)dict;
@end

@protocol ImageToolbarDelegate <NSObject>

@optional
-(void)clickImageToolbar:(PrivateImage*)info itag:(int)itag;

@end

@protocol BottomTabBarDelegate <NSObject>

@optional
-(void)clickBottomTabBar:(int)index;

@end

@protocol TabItemDelegate <NSObject>

-(void)refreshData;
-(void)clearData;

@end

@protocol MenuDelegate <NSObject>

@optional
-(void)clickMenuUser;
-(void)clickMenuFirst;
-(void)clickMenuSetting:(BOOL)isuser;
-(void)clickMenuNew;
@end