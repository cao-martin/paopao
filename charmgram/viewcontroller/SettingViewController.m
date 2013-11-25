//
//  SettingViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-4-5.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+UIImageExt.h"
#import "UIImageView+WebCache.h"
#import "NotSetViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
	
    [self initArray];
	tbInput=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-20) style:UITableViewStyleGrouped];
	tbInput.backgroundColor=[UIColor whiteColor];
	tbInput.backgroundView=nil;
	tbInput.dataSource=self;
	tbInput.delegate=self;
	[self.view addSubview:tbInput];
	hasAvatarImage = NO;
    if (_isUserMader) {
        UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
        topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
        [self.view addSubview:topbar];
        
        UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
        lblTitle.textAlignment=UITextAlignmentCenter;
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.textColor=[UIColor whiteColor];
        lblTitle.text=@"设置";
        lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
        [topbar addSubview:lblTitle];
        
        UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
        btnCancel.frame=CGRectMake(8, 0, 54,44);
        [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [topbar addSubview:btnCancel];
        
        UIButton *btnFinish=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnFinish setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_off"] forState:UIControlStateNormal];
        [btnFinish setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_on"] forState:UIControlStateHighlighted];
        [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
        btnFinish.frame=CGRectMake(kDeviceWidth - 62, 0, 54,44);
        [btnFinish addTarget:self action:@selector(finishSet) forControlEvents:UIControlEventTouchUpInside];
        [topbar addSubview:btnFinish];
        
        tbInput.frame = CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-64);
    }
}

-(void)initArray{
	arrCaption=[[NSMutableArray alloc] initWithCapacity:0];
    if (_isUserMader) {
        [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"用户名",@"caption",@"text",@"type", [AppHelper getStringConfig:confUserName], @"value",nil]];
        [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"个人头像",@"caption",@"avatar",@"type",[AppHelper getStringConfig:confUserHeadUrl], @"value", nil]];
       [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"个人签名",@"caption",@"text",@"type", [AppHelper getStringConfig:confUserInfo], @"value",nil]];
    }else{
        [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"购买靓点",@"caption",@"label",@"type", @"", @"value",nil]];
        [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"推送设置",@"caption",@"label",@"type", @"", @"value",nil]];
        [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"黑名单",@"caption",@"label",@"type", @"", @"value",nil]];
        [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"清空兜来的泡泡",@"caption",@"cleardata",@"type", @"", @"value",nil]];
        [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"退出登录",@"caption",@"logout",@"type", @"", @"value",nil]];
    }
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [arrCaption count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* cellId=@"mycell";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
	}
	cell.selectionStyle=UITableViewCellSelectionStyleGray ;
	int row=indexPath.row;
	NSDictionary* dict=(NSDictionary*)[arrCaption objectAtIndex:row];
	cell.textLabel.text=[NSString stringWithFormat:@" %@",  [dict objectForKey:@"caption"]];
	cell.textLabel.textAlignment=UITextAlignmentLeft;
	cell.textLabel.font=[UIFont boldSystemFontOfSize:18.0];
//    if (indexPath.row == 1) {
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    }
	
	NSString* ctype=[dict objectForKey:@"type"];
	NSString* val=[dict objectForKey:@"value"];
	if ([ctype isEqualToString:@"label"]) {
		UILabel * lbl=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 170, 40)];
		lbl.text=val;
		lbl.backgroundColor=[UIColor clearColor];
		lbl.font=[UIFont systemFontOfSize:16.0];
		lbl.textColor=[UIColor colorWithRed:30/255.0 green:83/255.0 blue:126/255.0 alpha:1.0];
		lbl.textAlignment=UITextAlignmentRight;
//    	lbl.layer.shadowOffset = CGSizeMake(1, 0);
//    	lbl.layer.shadowColor = [UIColor blackColor].CGColor;
//    	lbl.layer.shadowOpacity = 1.0;
		[cell.contentView addSubview:lbl];
	}
    if ([ctype isEqualToString:@"text"]) {
		UITextField * lbl=[[UITextField alloc] initWithFrame:CGRectMake(100, 5, 170, 30)];
		lbl.text=val;
        lbl.tag = 100+indexPath.row;
		lbl.backgroundColor=[UIColor clearColor];
		lbl.font=[UIFont systemFontOfSize:16.0];
		lbl.textColor=[UIColor colorWithRed:30/255.0 green:83/255.0 blue:126/255.0 alpha:1.0];
		lbl.textAlignment=UITextAlignmentRight;
        //    	lbl.layer.shadowOffset = CGSizeMake(1, 0);
        //    	lbl.layer.shadowColor = [UIColor blackColor].CGColor;
        //    	lbl.layer.shadowOpacity = 1.0;
		[cell.contentView addSubview:lbl];
	}
	if ([ctype isEqualToString:@"avatar"]) {
		 img=[[UIImageView alloc] init];
		img.frame=CGRectMake(234, 4, 36, 36);
		img.layer.cornerRadius=2.0;
 		img.layer.masksToBounds = YES;
		img.contentMode=UIViewContentModeScaleToFill;
		if (val.length>0) {
			if ([val hasPrefix:@"/"]) {
				//img.image=[UIImage imageWithContentsOfFile:val];
                [img setImageWithURL:[NSURL URLWithString:val] placeholderImage:[UIImage imageNamed:@"user_noimage"]];
			}
			else{
				//img.image=[UIImage imageNamed:val];
                [img setImageWithURL:[NSURL URLWithString:val] placeholderImage:[UIImage imageNamed:@"user_noimage"]];
			}
		}
		
		[cell.contentView addSubview:img];
	}
//    if ([ctype isEqualToString:@"uiswich"]) {
//		UISwitch *notSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 7, 70, 30)];
//        notSwitch.on = [[AppHelper getStringConfig:confNotOn] boolValue];
//        [cell.contentView addSubview:notSwitch];
//	}
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	int row=indexPath.row;
	NSDictionary* dict=(NSDictionary*)[arrCaption objectAtIndex:row];
	NSString* ctype=[dict objectForKey:@"type"];
    if (_isUserMader) {
        switch (row) {
            case 1:
            {
                UIActionSheet *sheet = [[UIActionSheet alloc]
                                        initWithTitle:@"选择头像"
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:@"拍照",@"从相册中选取",nil];
                sheet.tag = 102;
                [sheet showInView:[UIApplication sharedApplication].keyWindow];
                
                
                
            }
                break;
         
                
 
                
                
            default:
                break;
        }

    }
    else{
        switch (row) {
            case 0:
            {
               
                [[HomeViewController shared] ApliyView];
            }
                break;
            case 1:
            {
                [[HomeViewController shared] notView];
            }
                break;
                
            case 2:
            {
                [[HomeViewController shared] blackList];
            }
                break;
            default:
                break;
        }

    }
    if ([ctype isEqualToString:@"logout"]) {
		[self clickLogout];
	}
    if ([ctype isEqualToString:@"cleardata"]) {
		[self clearData];
	}
}

#pragma mark - Click Events
-(void)clickLogout{
	UIActionSheet *sheet = [[UIActionSheet alloc]
							initWithTitle:@"你确定要退出登录吗？"
							delegate:self
							cancelButtonTitle:@"取消"
							destructiveButtonTitle:@"退出登录"
							otherButtonTitles:nil];
    sheet.tag = 100;
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
}
-(void)clearData{
	UIActionSheet *sheet = [[UIActionSheet alloc]
							initWithTitle:@"确认要清空吗？"
							delegate:self
							cancelButtonTitle:@"取消"
							destructiveButtonTitle:@"确认"
							otherButtonTitles:nil];
    sheet.tag = 101;
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark - Click Action Sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:
            {
                [self loginOut];
             
               // [self clickBack];
            }
                break;
                
            default:
                break;
        }
    } else if (actionSheet.tag == 101) {
        switch (buttonIndex) {
            case 0:
            {
                
                [[HomeViewController shared] clearPaoPaoData];
                // [self clickBack];
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
                
            case 0:
            {
                //拍摄照片
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = sourceType;
                    [self presentModalViewController:picker animated:NO];
                }
                else {
                    [AppHelper showAlertMessage:@"你的设备没有相机" title:@"提示"];
                }
            }
                break;
            case 1:
            {
                //从图片库中选择
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self presentModalViewController:picker animated:NO];
            }
                break;
            default:
                break;
        }
    }
 
}
#pragma mark - UIImagePickerController delegate

- (void)saveImage:(UIImage *)vimage{
	NSString* savedPath=[AppHelper AvatarPath];
	UIImage* scalImage2 = [vimage imageByScalingAndCroppingForSize:CGSizeMake(120, 120)];
	[UIImageJPEGRepresentation(scalImage2, 0.9f) writeToFile:savedPath atomically:YES];
    [img setImage:[UIImage imageWithContentsOfFile:savedPath]];
    hasAvatarImage = YES;
    [self uploadImageHead:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
    [picker dismissModalViewControllerAnimated:NO];
    
}
-(void)loginOut{
    [AppHelper showHUD:@"退出" baseview:self.view];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    [asirequest setPostValue:@"userOffLine" forKey:@"method"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
   
    
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        NSLog(@"JSON====%@",JSON);
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        [AppHelper hideHUD:self.view];
        if (code==REQUEST_CODE_SUCCESS) {
            //[AppHelper setStringConfig:confUserHeadUrl val:]
            // [self.navigationController popToRootViewControllerAnimated:YES];
            //[AppHelper showAlertMessage:@"头像修改成功"];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
        [AppHelper setStringConfig:confUserName val:@""];
        [AppHelper setStringConfig:confUserEmail val:@""];
        [AppDelegate App].watchCount = 0;
        NSString* savedPath=[AppHelper AvatarPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:savedPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:savedPath error:nil];
        }
        [[HomeViewController shared] resetMe:NO];
        [[HomeViewController shared] didLogout];
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
-(void)uploadImageHead:(UIImage *)headImg{
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    [asirequest setPostValue:METHOD_UPDATEHEADIMG forKey:@"method"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setPostValue:@"" forKey:@"mobile"];
    if (hasAvatarImage) {
        [asirequest setFile:[AppHelper AvatarPath] withFileName:@"pic.jpg" andContentType:@"image/jpeg" forKey:@"upfile"];
    }
    
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        NSLog(@"JSON====%@",JSON);
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        [AppHelper hideHUD:self.view];
        if (code==REQUEST_CODE_SUCCESS) {
             NSString* data=[AppHelper getStringFromDictionary:JSON key:@"data"];
            [AppHelper setStringConfig:confUserHeadUrl val:data];
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
           // [self.navigationController popToRootViewControllerAnimated:YES];
            //[AppHelper showAlertMessage:@"头像修改成功"];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
    
}
-(void)finishSet{
    UITextField *textName =(UITextField *)[self.view viewWithTag:100];
     UITextField *textInfo =(UITextField *)[self.view viewWithTag:102];
    if ([textName.text length]==0) {
        [AppHelper showAlertMessage:@"用户名不能空"];
    }
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    [asirequest setPostValue:METHOD_UPDATEUSERINFO forKey:@"method"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setPostValue:textName.text forKey:@"username"];
    [asirequest setPostValue:textInfo.text forKey:@"introduction"];
  
    
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        NSLog(@"JSON====%@",JSON);
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        NSString* name=[AppHelper getStringFromDictionary:JSON key:@"data"];
        [AppHelper hideHUD:self.view];
        if (code==REQUEST_CODE_SUCCESS) {
            [AppHelper setStringConfig:confUserInfo val:textInfo.text];
            [AppHelper setStringConfig:confUserName val:name];
            [self.navigationController popToRootViewControllerAnimated:YES];
            //[AppHelper showAlertMessage:@"头像修改成功"];
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
-(void)clickBack{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
