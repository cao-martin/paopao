//
//  LoginViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-4-2.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,
	UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
	UILabel* lblTitle;
	LoginStateType  isType;
	UITableView* tbInput;
	NSMutableArray* arrCaption;
	NSMutableDictionary* dictInput;
	UIImageView* imgAvatar;
    BOOL hasAvatarImage;
    int keyboardTop;
    int curTextFieldTag;
} 
-(void)initViews:(LoginStateType)isForRegister;
@end
