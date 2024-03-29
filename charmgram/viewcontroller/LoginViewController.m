//
//  LoginViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-4-2.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+UIImageExt.h"
 
#define kTagTextFieldPadding  100
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.text=@"账号登录";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 0, 54,44);
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
	
    UIButton *btnDone=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_off"] forState:UIControlStateNormal];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_on"] forState:UIControlStateHighlighted];
    [btnDone setTitle:@"完成" forState:UIControlStateNormal];
	[btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnDone.frame=CGRectMake(kDeviceWidth-70, 0, 62,44);
    [btnDone addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnDone];
	
	tbInput=[[UITableView alloc] initWithFrame:CGRectMake(0, kTopbarHeight, kDeviceWidth, kDeviceHeight-kTopbarHeight-20) style:UITableViewStyleGrouped];
	tbInput.backgroundColor=[UIColor whiteColor];
	tbInput.backgroundView=nil;
	tbInput.dataSource=self;
	tbInput.delegate=self;
  	
	arrCaption=[[NSMutableArray alloc] initWithCapacity:0];
	dictInput=[[NSMutableDictionary alloc] initWithCapacity:0];
    hasAvatarImage=NO;
    
	[self.view addSubview:tbInput];
    [self.view addSubview:topbar];
    [self initObservers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

-(void)initViews:(LoginStateType)isForRegister{
	[arrCaption removeAllObjects];
	isType=isForRegister;
	if (isType == isRegist) {
		lblTitle.text=@"创建新账号";
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"email",@"key",@"电子邮件",@"caption",@"email",@"type",@"",@"minlen", nil]];
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"username",@"key",@"用户名",@"caption",@"",@"type",@"3",@"minlen", nil]];
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"avatar",@"key",@"  个人头像",@"caption",@"avatar",@"type",@"",@"minlen", nil]];
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"password",@"key",@"登录密码",@"caption",@"password",@"type",@"6",@"minlen", nil]];
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"password2",@"key",@"密码确认",@"caption",@"password",@"type",@"6",@"minlen", nil]];

	}
	else if(isType == isLogin){
		lblTitle.text=@"账号登录";
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"email",@"key",@"电子邮件",@"caption",@"email",@"type",@"",@"minlen", nil]];
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"password",@"key",@"登录密码",@"caption",@"password",@"type",@"6",@"minlen", nil]];
	}else{
        lblTitle.text=@"找回密码";
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"email",@"key",@"电子邮件",@"caption",@"email",@"type",@"",@"minlen", nil]];
		[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"username",@"key",@"用户昵称",@"caption",@"username",@"type",@"",@"minlen", nil]];
    }
	[tbInput reloadData];
}

-(void)initObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Click Events
-(void)clickBack{
    [AppHelper hideKeyWindow];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)clickDone{
	BOOL ret=[self verifyInputs];
	if (ret) { 
		//// verify the account or register a new account by webservice
        [AppHelper hideKeyWindow];
        //[AppHelper showHUD:@"正在提交..." baseview:self.view];
		if (isType == isRegist) {
            [self doRegister];
		}
		else if(isType == isLogin){
            [self doLogin];
        }else{
            [self doFindPwd];
        }
	}
}
-(void)doFindPwd{
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    [asirequest setPostValue:METHOD_GETPWd forKey:@"method"];
    [asirequest setPostValue:[dictInput objectForKey:@"email"] forKey:@"email"];
    [asirequest setPostValue:[dictInput objectForKey:@"username"] forKey:@"username"];
    NSLog(@"%@==%@",[dictInput objectForKey:@"email"],[dictInput objectForKey:@"username"]);
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        NSLog(@"respString==%@",respString);
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            NSLog(@"data====%@",data);
           
            
			[[HomeViewController shared] changeTab:1];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        [AppHelper showAlertMessage:msg];
    
        [AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];

}
-(void)doLogin{
     [AppHelper showHUD:@"正在登录..." baseview:self.view];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    DLog(@"%@",dictInput);
    [asirequest setPostValue:METHOD_LOGIN forKey:@"method"]; 
    [asirequest setPostValue:[dictInput objectForKey:@"email"] forKey:@"email"];
    [asirequest setPostValue:[dictInput objectForKey:@"password"] forKey:@"password"];     
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            NSLog(@"data====%@",data);
            if ([data isKindOfClass:[NSArray class]] && [data count]>0) {
                NSDictionary* dict=(NSDictionary*)data[0];  
                [AppHelper setIntConfig:confUserId val:[AppHelper getIntFromDictionary:dict key:@"userid"]];
                [AppHelper setStringConfig:confUserToken val:[AppHelper getStringFromDictionary:dict key:@"token"]];
                [AppHelper setIntConfig:confUserCoin val:[AppHelper getIntFromDictionary:dict key:@"prettyCoin"]];
                [AppHelper setStringConfig:confUserName val:[AppHelper getStringFromDictionary:dict key:@"username"]];
                NSString *introduction = [AppHelper getStringFromDictionary:dict key:@"introduction"];
                [AppHelper setStringConfig:confUserInfo val:introduction];
                [AppHelper setStringConfig:confUserSex val:[AppHelper getStringFromDictionary:dict key:@"sex"]];
                [AppHelper setStringConfig:confUserHeadUrl val:[AppHelper getStringFromDictionary:dict key:@"headimage"]];
                [AppHelper setStringConfig:confZanNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_zan"]];
                [AppHelper setStringConfig:confGuanZhuNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_care"]];
                [AppHelper setStringConfig:confLiWuNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_gift"]];
                [AppHelper setStringConfig:confShiXinNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_message"]];
//                "notice_care" = 0;
//                "notice_gift" = 0;
//                "notice_message" = 0;
//                "notice_zan" = 0;
                
                [self updateToken];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
            }
        }
        else{
            [AppHelper showAlertMessage:msg];
             [AppHelper hideHUD:self.view];
        }
       
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
-(void)updateToken{
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    DLog(@"%@",dictInput);
    NSLog(@"%@",[AppHelper getStringConfig:confNotData]);
    [asirequest setPostValue:METHOD_UPDATETOKEN forKey:@"method"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d",[AppHelper getIntConfig:confUserId]] forKey:@"userid"];
    [asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setPostValue:[AppHelper getStringConfig:confNotData] forKey:@"devicetoken"];
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            NSLog(@"data====%@",data);
           // [AppHelper showAlertMessage:respString];
             [[AppDelegate App] loadLocationWeb];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
        [AppHelper hideHUD:self.view];
        [[HomeViewController shared] changeTab:1];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
        [[HomeViewController shared] changeTab:1];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }];
    [asirequest startAsynchronous];
}
-(void)doRegister{
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    DLog(@"%@",dictInput);
    [asirequest setPostValue:METHOD_REGISTER forKey:@"method"];
    [asirequest setPostValue:[dictInput objectForKey:@"email"] forKey:@"email"];
    [asirequest setPostValue:[dictInput objectForKey:@"username"] forKey:@"username"];
    [asirequest setPostValue:[dictInput objectForKey:@"password"] forKey:@"password"];
    [asirequest setPostValue:@"" forKey:@"mobile"];
    if (hasAvatarImage) {
        [asirequest setFile:[AppHelper AvatarPath] withFileName:@"pic.jpg" andContentType:@"image/jpeg" forKey:@"upfile"];
    }
    
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        [AppHelper hideHUD:self.view];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]] && [data count]>0) {
                NSDictionary* dict=(NSDictionary*)data[0];
                int userid=[AppHelper getIntFromDictionary:dict key:@"userid"];
                NSString* username=[AppHelper getStringFromDictionary:dict key:@"username"];
                NSString* headimage=[AppHelper getStringFromDictionary:dict key:@"headimage"];
                [AppHelper setStringConfig:confUserToken val:[AppHelper getStringFromDictionary:dict key:@"token"]];
                [AppHelper setIntConfig:confUserId val:userid];
                [AppHelper setIntConfig:confUserCoin val:[AppHelper getIntFromDictionary:dict key:@"prettyCoin"]];
                [AppHelper setStringConfig:confUserName val:username];
                [AppHelper setStringConfig:confUserHeadUrl val:headimage];
                NSString *introduction = [AppHelper getStringFromDictionary:dict key:@"introduction"];
                [AppHelper setStringConfig:confUserInfo val:introduction];
                [AppHelper setStringConfig:confZanNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_zan"]];
                [AppHelper setStringConfig:confGuanZhuNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_care"]];
                [AppHelper setStringConfig:confLiWuNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_gift"]];
                [AppHelper setStringConfig:confShiXinNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_message"]];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
			[[HomeViewController shared] changeTab:1];
            [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void)clickReturn:(UITextField*)txt{
	int itag=txt.tag - kTagTextFieldPadding;
	if (itag<arrCaption.count-1) {
		UITextField* nextField=(UITextField*)[tbInput viewWithTag:itag+kTagTextFieldPadding+1];
		if (nextField) {
			[nextField becomeFirstResponder];
		}
	}
	else{
		[self clickDone];
	}
}

-(BOOL)verifyInputs{
	[dictInput removeAllObjects];
	for (int k=0, len=arrCaption.count; k<len;k++) {
		NSDictionary* dict=(NSDictionary*)[arrCaption objectAtIndex:k];
		NSString* inputType=[dict objectForKey:@"type"];
		NSString* minLen=[dict objectForKey:@"minlen"];
		NSString* key=[dict objectForKey:@"key"];
		NSString* caption=[dict objectForKey:@"caption"];
		UITextField* txt=(UITextField*)[tbInput viewWithTag:kTagTextFieldPadding+k];
		if (!txt) {
			continue;
		} 
		if ([inputType isEqualToString:@"email"]) {
 			if (![AppHelper NSStringIsValidEmail:txt.text]) {
				[AppHelper showAlertMessage:@"请输入正确的电子邮件" title:@""];
				[txt becomeFirstResponder];
				return NO;
			}
		}
		if (minLen.length>0) {
			if (txt.text.length< [minLen integerValue]) {
				[AppHelper showAlertMessage:[NSString stringWithFormat:@"%@需要输入%@位以上的字符",caption,minLen] title:@""];
				[txt becomeFirstResponder];
				return NO;
			}
		}
		if (![inputType isEqualToString:@"password"]) {
			NSString* val= [AppHelper TrimString:txt.text];
			[dictInput setObject:val forKey:key];
		}
		else{
			[dictInput setObject:txt.text forKey:key];
		}
	}
	return YES;
}

#pragma mark - Tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return arrCaption.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* cellId=@"mycell";
	UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
	}
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	int row=indexPath.row;
	NSDictionary* dict=(NSDictionary*)[arrCaption objectAtIndex:row]; 
	cell.textLabel.text=[NSString stringWithFormat:@"%@:",[dict objectForKey:@"caption"]];
	cell.textLabel.textAlignment=UITextAlignmentRight;
	cell.textLabel.font=[UIFont boldSystemFontOfSize:14.0];
	
	NSString* ctype=[dict objectForKey:@"type"];
	if ([ctype isEqualToString:@"avatar"]) { 
		imgAvatar=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_noimage"]];
		imgAvatar.frame=CGRectMake(160, 4, 36, 36);
		imgAvatar.layer.cornerRadius=2.0;
 		imgAvatar.layer.masksToBounds = YES;
		imgAvatar.contentMode=UIViewContentModeScaleToFill;
		[cell.contentView addSubview:imgAvatar];
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator; 
		cell.textLabel.textAlignment=UITextAlignmentLeft;
		cell.selectionStyle=UITableViewCellSelectionStyleGray;
	}
	else{
		UITextField* tf=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 213, 44)];
		tf.backgroundColor=[UIColor clearColor];
		tf.autocorrectionType=UITextAutocorrectionTypeNo;
		tf.font=[UIFont systemFontOfSize:14.0];
		tf.textColor=[UIColor colorWithRed:30/255.0 green:83/255.0 blue:126/255.0 alpha:1.0];
		tf.tag=kTagTextFieldPadding+row;
		if ([ctype isEqualToString:@"password"]) {
			tf.secureTextEntry=YES;
		}
		if ([ctype isEqualToString:@"email"]) {
			tf.placeholder=@"example@example.com";
		}
		if (row==arrCaption.count-1) {
			tf.returnKeyType=UIReturnKeyDone;
		}
		else{
			tf.returnKeyType=UIReturnKeyNext;
		}
		
		[tf addTarget:self action:@selector(clickReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
		tf.delegate=self;
		tf.clearButtonMode=UITextFieldViewModeWhileEditing;
		tf.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
		cell.accessoryView=tf;
	}
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	int row=indexPath.row;
	NSDictionary* dict=(NSDictionary*)[arrCaption objectAtIndex:row];
	NSString* ctype=[dict objectForKey:@"type"];
	if ([ctype isEqualToString:@"avatar"]) {
		[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
		UIActionSheet *sheet = [[UIActionSheet alloc]
								initWithTitle:@"选择头像"
									delegate:self
												 cancelButtonTitle:@"取消"
								destructiveButtonTitle:nil
								otherButtonTitles:@"拍照",@"从相册中选取",nil];
		[sheet showInView:self.view];
	}
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	curTextFieldTag=textField.tag- kTagTextFieldPadding;
    [self reframeInputTable];
	return YES;
}

#pragma mark - Click Action Sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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

#pragma mark - UIImagePickerController delegate

- (void)saveImage:(UIImage *)vimage{
	NSString* savedPath=[AppHelper AvatarPath];
	UIImage* scalImage2 = [vimage imageByScalingAndCroppingForSize:CGSizeMake(120, 120)];
	[UIImageJPEGRepresentation(scalImage2, 0.9f) writeToFile:savedPath atomically:YES];
	[imgAvatar setImage:[UIImage imageWithContentsOfFile:savedPath]];
    hasAvatarImage=YES;
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

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardTop = kbFrame.origin.y;
    DLog(@"%d",keyboardTop);
    [self reframeInputTable];
}


- (void)keyboardWillHide:(NSNotification *)notification {
  
    NSDictionary *info = [notification userInfo];
    CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardTop = kbFrame.origin.y;
    if (tbInput.frame.origin.y<=kTopbarHeight) {
        [UIView animateWithDuration:0.25 animations:^{
            tbInput.frame=CGRectMake(0, kTopbarHeight, kDeviceWidth, kDeviceHeight-kTopbarHeight-20);
        }];
    }
  
}

-(void)reframeInputTable{
    if (keyboardTop>0) {
		UITextField* txt=(UITextField*)[tbInput viewWithTag:kTagTextFieldPadding+curTextFieldTag];
        CGRect originRect = [txt.superview convertRect:txt.frame toView:tbInput];
        
        int newY=kTopbarHeight;
        if (originRect.origin.y+originRect.size.height+kTopbarHeight+6>keyboardTop) {
            newY+=keyboardTop-(originRect.origin.y+originRect.size.height+kTopbarHeight+26);
            [UIView animateWithDuration:0.25 animations:^{
                tbInput.frame=CGRectMake(0, newY, kDeviceWidth, kDeviceHeight-kTopbarHeight-20);
            }];
            return;
        }
        if (tbInput.frame.origin.y<=kTopbarHeight) {
            [UIView animateWithDuration:0.25 animations:^{
                tbInput.frame=CGRectMake(0, kTopbarHeight, kDeviceWidth, kDeviceHeight-kTopbarHeight-20);
            }];
        }
    }
}
@end
