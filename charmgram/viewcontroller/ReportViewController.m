//
//  ReportViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-6-30.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "ReportViewController.h"
#define INPUT_MAX_NUMBER			60
@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize curImageId;
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=COLOR_BACKGROUND;
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.shadowOffset=CGSizeMake(0, 1.0);
    lblTitle.shadowColor=SHADOW_COLOR;
    lblTitle.text=@"审核举报";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn_h"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 6, 52,32);
    btnCancel.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    //[btnCancel setTitle:@"  返回" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
	
	UIButton *btnDone=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_off"] forState:UIControlStateNormal];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_on"] forState:UIControlStateHighlighted];
    [btnDone setTitle:@"完成" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    btnDone.frame=CGRectMake(kDeviceWidth-64, 0, 52,44);
    [btnDone addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnDone];
 
	
	tvInput =[[UITextView alloc] initWithFrame:CGRectMake(10, kTopbarHeight+10 , kDeviceWidth-20, 130)];
    tvInput.textColor=[UIColor blackColor];
    tvInput.backgroundColor=[UIColor whiteColor];
    tvInput.font=[UIFont systemFontOfSize:15.0];
//    tvInput.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
    tvInput.dataDetectorTypes=UIDataDetectorTypeNone;
    tvInput.returnKeyType=UIReturnKeyDefault;
    tvInput.delegate = self;
	
	lblCounter=[[UILabelCounter alloc] initWithFrame:CGRectMake(280, kTopbarHeight+140, 40, 20)];
    lblCounter.backgroundColor=[UIColor clearColor];
	//    lblCounter.text=[NSString stringWithFormat:@"%d/%d",7,INPUT_MAX_NUMBER];
    lblCounter.textColor=[UIColor grayColor];
    lblCounter.font=[UIFont systemFontOfSize:10.0];
    lblCounter.maxCount=INPUT_MAX_NUMBER;
    lblCounter.typeCount=0;
    lblCounter.seperator=@"/";
	
    [self.view addSubview:tvInput];
    [self.view addSubview:lblCounter];
    [self.view addSubview:topbar];
	
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[tvInput becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

#pragma mark - Click Event
-(void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickDone{
    NSString* ctext=tvInput.text;
    ctext= [ctext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (ctext.length==0) {
        [AppHelper showAlertMessage:@"举报内容不能为空。"];
		[tvInput becomeFirstResponder];
        return;
    }
    if (ctext.length>INPUT_MAX_NUMBER) {
        
        [AppHelper showAlertMessage:[NSString stringWithFormat:@"您的输入已经超过字数限制%d。",INPUT_MAX_NUMBER]];
        return;
    }
    
    [AppHelper showHUD:@"正在提交..." baseview:self.view];
    [self submitText:ctext];
	[AppHelper hideKeyWindow];
}

-(void)submitText:(NSString*)txt{
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
	[asirequest setPostValue:METHOD_REPORTIMAGE forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:txt forKey:@"content"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",self.curImageId] forKey:@"sid"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
//			[AppHelper showAlertMessage:@"感谢你的审核举报，\n我们将会尽快审核处理！" title:nil];
			[AppHelper showAlertMessage:@"感谢你的审核举报，\n我们将会尽快审核处理！" title:nil lbtnTitle:@"确定" lbtnBlock:^{
				[self clickBack];
			} rbtnTitle:nil rbtnBlock:nil];
        }
		else{
			DLog(@"%@",msg);
		}
		[AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
		DLog(@"sendMessage - failure");
		[AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}

#pragma mark - TextView Delegate
- (void)textViewDidChange:(UITextView *)textView{
	//    lblCounter.text=[NSString stringWithFormat:@"%d/%d",textView.text.length,INPUT_MAX_NUMBER];
    lblCounter.typeCount=textView.text.length;
    [lblCounter setNeedsDisplay];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
//    viewMask.hidden=NO;
}
@end