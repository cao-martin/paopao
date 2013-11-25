//
//  GiftViewController.m
//  charmgram
//
//  Created by Rain on 13-6-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "GiftViewController.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import "HomeViewController.h"
@interface GiftViewController ()

@end

@implementation GiftViewController
@synthesize curInfo;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.shadowOffset=CGSizeMake(0, 1.0);
    lblTitle.shadowColor=SHADOW_COLOR;
    lblTitle.text=@"选择礼物";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn_h"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 6, 52,32);
    btnCancel.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
   // [btnCancel setTitle:@"  返回" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
    
    tbContent=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
	tbContent.dataSource=self;
	tbContent.delegate=self;
	tbContent.backgroundColor=[UIColor colorWithRed:234/255.0 green:230/255.0 blue:231/255.0 alpha:1.0];
    tbContent.separatorStyle=UITableViewCellSeparatorStyleNone;
    [tbContent setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    
    [self.view addSubview:tbContent];
    [self.view addSubview:topbar];
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"gift" ofType:@"plist"]; 
//    arrItem=[[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    arrItem = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadDataFromWeb];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
	
}

#pragma mark - Load Data
-(void)loadDataFromWeb{
	//[AppHelper showHUD:@"刷新礼物列表..." baseview:self.view];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:METHOD_GIFTLIST forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"]; 
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            [arrItem removeAllObjects];
            
            for (NSDictionary *di in data) { 
                [arrItem addObject:di];
            }
            [tbContent reloadData];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
		[AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
		[AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
	
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return ceil(arrItem.count/3.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        UIImageView *imageBk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 84-4, 320, 17)];
//        imageBk.image = [UIImage imageNamed:@"giftbk"];
//        [cell.contentView addSubview:imageBk];
        
        for (int k=0; k<3; k++) {
            UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(k*100+20, 4, 80, 80)];
            
            img.tag=100+k;
            img.layer.cornerRadius=4.0;
            img.layer.masksToBounds=YES;
            img.userInteractionEnabled=YES;
            UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGift:)];
            tap.numberOfTapsRequired=1;
            tap.numberOfTouchesRequired=1;
            [img addGestureRecognizer:tap];
            
            [cell.contentView addSubview:img];
            
            UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(k*100+10, 88, 100, 30)];
            lbl.backgroundColor=[UIColor clearColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.numberOfLines=0;
            lbl.tag=200+k;
            lbl.font=[UIFont systemFontOfSize:12.0];
            [cell.contentView addSubview:lbl];
            
            UILabel* lbl0=[[UILabel alloc] initWithFrame:CGRectMake(k*100+20, 88, 0, 30)]; 
            lbl0.tag=300+k; 
            lbl0.hidden=YES;
            [cell.contentView addSubview:lbl0];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    int row=indexPath.row;
    int start=row*3;
    int end=start+2;
    if (end>arrItem.count-1) {
        end=arrItem.count-1;
    }
    int index=start;
    for (int k=0; k<3; k++) {
        UIImageView* img=(UIImageView*)[cell.contentView viewWithTag:100+k];
        UILabel* lbl=(UILabel*)[cell.contentView viewWithTag:200+k];
        UILabel* lbl0=(UILabel*)[cell.contentView viewWithTag:300+k];
        if (index>end) {
            img.hidden=YES;
            lbl.hidden=YES;
            continue;
        }
        else{
            img.hidden=NO;
            lbl.hidden=NO;
            
            NSDictionary *dict=arrItem[index];
//            img.image=[UIImage imageNamed:[dict objectForKey:@"imageUrl"]];
			[img setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photo"]]];
			lbl.text=[NSString stringWithFormat:@"%@\n%@",[dict objectForKey:@"name"],[dict objectForKey:@"price"]];
            lbl0.text=[NSString stringWithFormat:@"%d",index];
        }
        index++;
    }
    
    return cell;
}
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     
}

#pragma mark - Click Event
-(void)tapGift:(UITapGestureRecognizer*)gesture{
    
  
    int itag=gesture.view.tag-100;
    UILabel* lbl0=(UILabel*)[gesture.view.superview viewWithTag:300+itag ];
    dictA=arrItem[[lbl0.text intValue]];

  
    NSString * strMsg = [NSString stringWithFormat:@"赠送%@礼物'%@',将消耗您%@靓点,%@获得%.1f靓点", self.curInfo.UserName,[dictA objectForKey:@"name"],[dictA objectForKey:@"price"],self.curInfo.UserName,[[dictA objectForKey:@"price"] intValue]*0.6];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:strMsg
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"赠送",nil];
    alertView.tag = 200;
    [alertView show];
   
}

-(void)clickBack{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Send Gift
-(void)sendGift:(int)giftid giftname:(NSString*)giftname giftimage:(NSString*)giftimage{
	[AppHelper showHUD:@"正在提交..." baseview:self.view];
	int userid=[AppHelper getIntConfig:confUserId];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:METHOD_SENDGIFT forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", userid] forKey:@"userid"];
    [asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", self.curInfo.UserId] forKey:@"accepterid"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", giftid] forKey:@"giftid"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", self.curInfo.ImageId] forKey:@"photoid"];
    NSLog(@"%d===%d",userid,self.curInfo.UserId);
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);

    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        NSLog(@"JSON====%@",JSON);
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            NSLog(@"data====%@",data);
            int rootCoin=[AppHelper getIntFromDictionary:data key:@"rootCoin"];
            int needCoin=[AppHelper getIntFromDictionary:data key:@"needCoin"];
            int remainCoin=[AppHelper getIntFromDictionary:data key:@"remainCoin"];
            [AppHelper setIntConfig:confUserCoin val:remainCoin];
            NSDictionary* newgift=[[NSDictionary alloc] initWithObjectsAndKeys:
                                   [AppHelper getStringConfig:confUserName],@"username",
                                   [AppHelper getStringConfig:confUserHeadUrl],@"headimage",
                                   [NSNumber numberWithInt:userid],@"userid",
                                   [NSNumber numberWithInt:giftid],@"gid",
                                   giftname,@"name",
                                   giftimage,@"photo",
                                   nil];
            [self.curInfo.arrGift insertObject:newgift atIndex:0];
            if (_row) {
                int userid = [AppHelper getIntConfig:confUserId];
                if (userid) {
                    NSString *strKey = [NSString stringWithFormat:@"paopaoData%d",userid];
                    NSMutableArray *arrPaoPao = [NSMutableArray arrayWithArray:[AppHelper getArrayConfig:strKey]];
                    NSLog(@"arrPaoPao===%@",arrPaoPao);
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[arrPaoPao objectAtIndex:_row-1] ];
                    //[arrPaoPao insertObject:data atIndex:0];
                    NSMutableArray *arr =[NSMutableArray arrayWithArray: [dic objectForKey:@"giftlist"]];
                    NSLog(@"arrfirst====%@",arr);
                
                    if ([arr count]==3) {
                        [arr removeLastObject];
                    }
                    [arr insertObject:newgift atIndex:0];
                    NSLog(@"arr===%@",arr);
                    [dic setValue:arr forKey:@"giftlist"];
                    
                    NSLog(@",dic---%@",dic);
                    [arrPaoPao replaceObjectAtIndex:_row-1 withObject:dic];
                    NSLog(@"arrPaoPao===%@",arrPaoPao);
                    
                    [AppHelper setArrayConfig:strKey val:arrPaoPao];
                    NSLog(@"%@",[AppHelper getArrayConfig:strKey]);
                }

            }
            
            NSDictionary* dictInfo=@{NOTIFICATION_KEYNAME:[NSString stringWithFormat:@"%d",NOTIFICATION_ID_SENTGIFT]};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:dictInfo];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            if (code ==205) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:msg 
																	delegate:self
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
                [alertView show];

            }else
              [AppHelper showAlertMessage:msg];
        }
		[AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
		[AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==200) {
        int giftid=[[dictA objectForKey:@"gid"] intValue];
        [self sendGift:giftid giftname:[dictA objectForKey:@"name"] giftimage:[dictA objectForKey:@"photo"]];
    }else{
        [self clickBack];
        [[HomeViewController shared] ApliyView];
    }

}
@end
