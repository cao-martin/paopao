//
//  SettingViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-4-5.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseViewController.h"
@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
	UITableView* tbInput;
	NSMutableArray* arrCaption;
    BOOL hasAvatarImage;
    UIImageView* img;
}
@property(nonatomic,assign)BOOL isUserMader;
@end
