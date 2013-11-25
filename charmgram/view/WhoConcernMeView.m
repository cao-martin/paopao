//
//  WhoConcernMeView.m
//  PhotoSharing
//
//  Created by user on 11-12-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhoConcernMeView.h"
//#import "HttpData.h"
#import "UIImageView+WebCache.h"
//#import "DefaultTag.h"

@implementation WhoConcernMeView
@synthesize nameButton,concernMeTV;

- (id)initWithFrame:(CGRect)frame {
	iffresh = NO;
	
	arrCpzQuery = [[NSMutableArray alloc]init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshMessage) name:@"refreshMessage" object:nil];
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self getToMe];
		[self initViews];
    }
    return self;
}

-(void)freshMessage{
	iffresh = YES;
	
	
	[self getToMe];

}


-(void)initViews{
	self.backgroundColor = [UIColor whiteColor];
	concernMeTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kDeviceHeight - 44 -20) style:UITableViewStylePlain];
	//concernMeTV.rowHeight = 80;
	concernMeTV.dataSource = self;
	concernMeTV.delegate = self;
	concernMeTV.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self addSubview:concernMeTV];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if ([arr count] > 0) {
		return [arr count];
	}
	else {
		return 1;
	}

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	//关注1、评论0、赞2
	if ([arr count] > 0) {
		if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue]== 1) {
			return 60;
		}
		else {
			return 120 +15 + (([[arr objectAtIndex:indexPath.row] count] -1)/ 4) *78 +5;
		}
	}
	else {
		return 0;
	}

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//static NSString *cellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
	if (cell == nil) {

		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.userInteractionEnabled = YES;
	
	//NSLog(@"[arr count]=====%d",[arr count]);
	
	if ([arr count] > 0) {
		NSString *strTime = [AppHelper DateString2Display:[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"addtime"] strFormat:StandardDateTimeFormat];
		UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 -2 +10 +20, 60, 15)];
//		NSString *strTime = [NSString stringWithFormat:@"%@", [Appelper DateString2Display:[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"addtime"]]];
		UIFont *fontTime = [UIFont systemFontOfSize:12.0];
		CGSize sizeTime = CGSizeMake(60, 15);
		CGSize sizedTime = [strTime sizeWithFont:fontTime constrainedToSize:sizeTime lineBreakMode:UILineBreakModeWordWrap];
		if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue] == 1) {
			timeLable.frame = CGRectMake(320 -30 -sizedTime.width, 10 -2 +10 +20, sizedTime.width, sizedTime.height);

		}
		else {
			timeLable.frame = CGRectMake(320 -30 -sizedTime.width, 10 -2 +10 +20 +60 +15 +(([[arr objectAtIndex:indexPath.row] count] -1) /4) * 78 +5 , sizedTime.width, sizedTime.height);

		}
		timeLable.text = strTime;
		[timeLable setTextColor:[UIColor grayColor]];
		timeLable.font = fontTime;
		timeLable.textAlignment = UITextAlignmentRight;
		[cell addSubview:timeLable];
		
		//攻
		UIButton *btnFriName = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 120, 20)];
		btnFriName.tag = [[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"friendid"] intValue];
		[btnFriName addTarget:self action:@selector(noti:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:btnFriName];
		
		NSString *strContent = [NSString stringWithFormat:@"%@", [[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"friendname"]];
		UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0];
		UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
		lblName.numberOfLines = 1;
		CGSize size = CGSizeMake(180, 20);
		CGSize labelsize = [strContent sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
		lblName.frame = CGRectMake(0, 0, labelsize.width, labelsize.height);
		btnFriName.frame = CGRectMake(10, 10 +1, labelsize.width, labelsize.height);
		lblName.font = font;
		[lblName setTextColor:[UIColor colorWithRed:0 green:0 blue:0.30 alpha:1.0]];
		lblName.text = strContent;
		[btnFriName addSubview:lblName];
		
				
		
		UILabel *lblState = [[UILabel alloc]initWithFrame:CGRectMake(btnFriName.frame.size.width +15, btnFriName.frame.size.height, 60, 20)];
		lblState.font = [UIFont systemFontOfSize:15.0];
		lblState.textColor = [UIColor blackColor];
		lblState.numberOfLines = 1;
		if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue]== 1) {
			lblState.text = @"关注了";
						
		}
		else{
						
			if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue]== 2) {
				if ([[arr objectAtIndex:indexPath.row] count] > 1) {
					lblState.text = [NSString stringWithFormat:@"赞了%d张图片",[[arr objectAtIndex:indexPath.row] count]];
					
				}
				else {
					lblState.text = @"赞了";

				}
			}
						
			for (int i = 0; i < [[arr objectAtIndex:indexPath.row] count]; i ++) {
				UIButton *btnPhoto = [[UIButton alloc] initWithFrame:CGRectMake(8 + (i % 4) * 77, 30 +10 + (i /4) *78, 55 +15 +3, 55 +15 +3)];
				btnPhoto.tag = indexPath.row * 10000 + i;
				if ([[[arr objectAtIndex:indexPath.row] objectAtIndex:i] objectForKey:@"photopath_small"] == [NSNull null]) {
					//NSLog(@"图片为空");
				}
				else {
					if ([[[arr objectAtIndex:indexPath.row] objectAtIndex:i] objectForKey:@"photopath_small"] && ![[[[arr objectAtIndex:indexPath.row] objectAtIndex:i] objectForKey:@"photopath_small"]isEqualToString:@""]) {
						NSString *strUrl = [[[arr objectAtIndex:indexPath.row] objectAtIndex:i] objectForKey:@"photopath_small"];
						
						//UIImage *imgPrised = [http loadImageWithUrl:strUrl];
//						[btnPhoto setImage:imgPrised forState:UIControlStateNormal];
//						imgPrised = nil;
						
						[btnPhoto setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"background_1.png"]];
						
						//NSLog(@"图片");
					}
					else {
						//[btnPhoto setBackgroundImage:[UIImage imageNamed:@"Btn_old_bg.png"] forState:UIControlStateNormal];
						//NSLog(@"图片为空");
					}
				}
				btnPhoto.userInteractionEnabled = YES;
				btnPhoto.contentMode = UIViewContentModeScaleAspectFit;
				[btnPhoto addTarget:self action:@selector(btnPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
				[cell addSubview:btnPhoto];
			
				
			}	
								
		}
		NSString *strState = [NSString stringWithFormat:@"%@",lblState.text];
		UIFont *fontState = [UIFont systemFontOfSize:15.0];
		CGSize lblSize = CGSizeMake(55 +30 +30, 20);
		CGSize lbledSize = [strState sizeWithFont:fontState constrainedToSize:lblSize lineBreakMode:UILineBreakModeWordWrap];
		lblState.frame = CGRectMake(btnFriName.frame.size.width +15, 10, lbledSize.width, lbledSize.height);
		lblState.font = fontState;
		[cell addSubview:lblState];
		
		//受
		if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue]== 2) {
			if ([[arr objectAtIndex:indexPath.row] count] > 1) {
				lblState.text = [NSString stringWithFormat:@"赞了%d张图片",[[arr objectAtIndex:indexPath.row] count]];
			}
			else {
				lblState.text = @"赞了";
			}
		}
			
		if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue]== 2 && [[arr objectAtIndex:indexPath.row] count] > 1) {
			//
		}
		else {
			UIButton *btnFriedName = [[UIButton alloc] initWithFrame:CGRectMake(20 + lblState.frame.size.width + btnFriName.frame.size.width , 11, 120, 20)];
			btnFriedName.tag = [[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"userid"] intValue];
			[btnFriedName addTarget:self action:@selector(noti:) forControlEvents:UIControlEventTouchUpInside];
			[cell addSubview:btnFriedName];
			
			NSString *strContented = [NSString stringWithFormat:@"%@", [[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"username"]];
			UILabel *lblNamed = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320 - (20 + lblState.frame.size.width + btnFriName.frame.size.width +10), 20)];
			lblNamed.numberOfLines = 1;
			CGSize labelsized = [strContented sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
			if (labelsized.width > (320 -(20 + lblState.frame.size.width + btnFriName.frame.size.width + 10))) {
				btnFriedName.frame = CGRectMake(20 +lblState.frame.size.width + btnFriName.frame.size.width, 11, 320 -(20 + lblState.frame.size.width + btnFriName.frame.size.width + 10), labelsized.height);
				lblNamed.frame = CGRectMake(0, 0, 320 -(20 + lblState.frame.size.width + btnFriName.frame.size.width + 10), labelsized.height);
			}
			else {
				btnFriedName.frame = CGRectMake(20 +lblState.frame.size.width + btnFriName.frame.size.width, 11, labelsized.width, labelsized.height);
				lblNamed.frame = CGRectMake(0, 0, labelsized.width, labelsized.height);
			}
			lblNamed.font = font;
			[lblNamed setTextColor:[UIColor colorWithRed:0 green:0 blue:0.30 alpha:1.0]];
			lblNamed.text = strContented;
			[lblNamed setLineBreakMode:UILineBreakModeWordWrap];
			[btnFriedName addSubview:lblNamed];
			
			if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue]== 1 && [[arr objectAtIndex:indexPath.row] count] > 1) {
				UILabel *lblMore = [[UILabel alloc] initWithFrame:CGRectMake(5 + btnFriedName.frame.origin.x + btnFriedName.frame.size.width, lblState.frame.origin.y , 100, 20)];
				lblMore.text = [NSString stringWithFormat:@"等其他%d位用户",[[arr objectAtIndex:indexPath.row] count] -1];
				lblMore.textColor = [UIColor blackColor];
				lblMore.backgroundColor = [UIColor clearColor];
				lblMore.font = [UIFont systemFontOfSize:15.0];
				[cell addSubview:lblMore];
				
				if (lblMore.frame.origin.x + lblMore.frame.size.width > 300.0) {
					lblMore.frame = CGRectMake(10, lblMore.frame.origin.y + 20, 150, 20);
				}
			}
			
		}

				
				
		UILabel *lblSap = [[UILabel alloc] init];
		if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue] == 1) {
			lblSap.frame = CGRectMake(0, 55, 320, 5);
		}
		if ([[[[arr objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"message"] intValue] == 2) {
			lblSap.frame = CGRectMake(0, 130 + (([[arr objectAtIndex:indexPath.row] count] -1) /4) * 78 +5, 320, 5);
		}

		lblSap.backgroundColor = [UIColor clearColor];
		lblSap.text = @".................................................................................................................................................";
		lblSap.font = [UIFont systemFontOfSize:9.0];
		lblSap.textColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
		lblSap.textAlignment = UITextAlignmentCenter;
		[cell addSubview:lblSap];
		

	}
	else {
		//UILabel *lblNO = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 44)];
//		lblNO.numberOfLines = 0;
//		lblNO.lineBreakMode = UILineBreakModeWordWrap;
//		lblNO.font = [UIFont systemFontOfSize:13.0];
//		lblNO.text = @"There is no activity to show at the moment";
//		lblNO.textColor = [UIColor blackColor];
//		lblNO.backgroundColor = [UIColor clearColor];
//		lblNO.textAlignment = UITextAlignmentLeft;
//		[cell addSubview:lblNO];
//		[lblNO release];
	}
	

		
	return cell;
}



-(void)noti:(UIButton *)sender{

	[[NSNotificationCenter defaultCenter]postNotificationName:@"ifClickName" object:[NSString stringWithFormat:@"%d",sender.tag]];
}

-(void)btnPhotoClick:(UIButton *)sender{
	[[NSNotificationCenter defaultCenter]postNotificationName:@"ifClickPhoto" object:[[[arr objectAtIndex:sender.tag /10000] objectAtIndex:sender.tag % 10000 ] objectForKey:@"photoid"]];
}


#pragma mark -
#pragma mark      getToMe

-(void)getToMe
{
	concernMeTV.tableHeaderView = nil;
	[AppHelper showHUD:@"没有私信" baseview:self];
	//[self addActiveAlert];
	
//	HttpData *httpData = [[HttpData alloc]init];
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	[httpData carerQuery:[defaults objectForKey:@"userid"]];
//	httpData.delegate =self;
//	httpData.didFinished = @selector(didFinished:);
//	httpData.didFinishedError = @selector(didFinishedError:);
//	[httpData release];
}

-(void)didFinished:(id)data{
//	data = [data JSONValue];
//	
//
//	
//	if ([[data objectForKey:@"code"] intValue] == 200) {
//		
//		if (iffresh) {
//			if (arrCpzQuery) {
//				[arrCpzQuery removeAllObjects];
//			}
//			if (arr) {
//				[arr removeAllObjects];
//			}
//		}
//		
//		if ([[data objectForKey:@"data"] count] > 0) {
//			[arrCpzQuery addObjectsFromArray:[data objectForKey:@"data"]];
//			
//			
//			//过滤调评论
//			for (NSInteger tableRow = 0; tableRow < [arrCpzQuery count];) {
//				if ([[[arrCpzQuery objectAtIndex:tableRow] objectForKey:@"message"] intValue] == 0) {
//					[arrCpzQuery removeObjectAtIndex:tableRow];
//				}
//				else {
//					tableRow ++;
//				}
//			}
//			//过滤掉别人对自己的操作
//			for (NSInteger tableRow = 0; tableRow < [arrCpzQuery count];) {
//				NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//				NSString *strLoginId = [NSString stringWithFormat:@"%@",[def objectForKey:@"userid"]];
//				if ([[NSString stringWithFormat:@"%@", [[arrCpzQuery objectAtIndex:tableRow] objectForKey:@"userid"]] isEqualToString:strLoginId]) {
//					[arrCpzQuery removeObjectAtIndex:tableRow];
//				}
//				else {
//					tableRow ++;
//				}
//			}
//			
//			//过滤图片路径为空的图片
//			for (NSInteger tableRow = 0; tableRow < [arrCpzQuery count]; ) {
//				if ([[arrCpzQuery objectAtIndex:tableRow] objectForKey:@"photopath_small"] == [NSNull null] && [[[arrCpzQuery objectAtIndex:tableRow] objectForKey:@"message"] intValue] == 2) {
//					[arrCpzQuery removeObjectAtIndex:tableRow];
//				}
//				else {
//					tableRow ++;
//				}
//
//			}
//			//过滤掉请求关注
//			for (NSInteger tableRow = 0; tableRow < [arrCpzQuery count];) {
//				if ([[[arrCpzQuery objectAtIndex:tableRow] objectForKey:@"message"] intValue] == 3) {
//					[arrCpzQuery removeObjectAtIndex:tableRow];
//				}
//				else {
//					tableRow ++;
//				}
//
//			}
//			
//			//NSLog(@"arrCCCCCCC===%@",arrCpzQuery);
//			
//			NSString *friendname;
//			int messageNum;
//			
//			friendname = [NSString stringWithFormat:@"%@",[[arrCpzQuery objectAtIndex:0] objectForKey:@"friendname"]];
//			messageNum = [[[arrCpzQuery objectAtIndex:0] objectForKey:@"message"] intValue];
//			NSLog(@"messageNum====%d",messageNum);	  
//			
//			arr = [NSMutableArray arrayWithObject:[NSMutableArray arrayWithObject:[arrCpzQuery objectAtIndex:0]]];
//			
//			[arr retain];
//			
//			for (int i = 1; i<[arrCpzQuery count]; i++) {
//				
//				//NSLog(@"friendname====%@",[[[data objectForKey:@"data"] objectAtIndex:i] objectForKey:@"friendname"]);
//				if ([friendname isEqualToString:[[arrCpzQuery objectAtIndex:i] objectForKey:@"friendname"]]&&messageNum ==[[[arrCpzQuery objectAtIndex:i] objectForKey:@"message"] intValue]) {
//					
//					[[arr lastObject] addObject:[arrCpzQuery objectAtIndex:i]];
//					
//			    }else {
//					
//					friendname = [[arrCpzQuery objectAtIndex:i] objectForKey:@"friendname"];
//					messageNum = [[[arrCpzQuery objectAtIndex:i] objectForKey:@"message"] intValue];
//					
//					[arr addObject:[NSMutableArray arrayWithObject:[arrCpzQuery objectAtIndex:i]]];
//				}
//			}
//			
//			//NSLog(@"arrCpz====%@",arrCpzQuery);
//			//NSLog(@"arr=====%@",arr);
//			
//		}
//		[concernMeTV reloadData];
//	
//	}
//	else {
//		UIAlertView *alertErrorCode = [[UIAlertView alloc]initWithTitle:@"错误" message:[data objectForKey:@"message"] delegate:nil cancelButtonTitle:@"撤销" otherButtonTitles:nil];
//		[alertErrorCode show];
//		[alertErrorCode release];
//	}
//	
//	if (iffresh) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"showRefreshBarWCM" object:nil];
//	}
//	
//	if ([arr count] < 1) {
//		UILabel *lblNO = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 44)];
//		lblNO.numberOfLines = 0;
//		lblNO.lineBreakMode = UILineBreakModeWordWrap;
//		lblNO.font = [UIFont systemFontOfSize:13.0];
//		lblNO.text = @" 当前没有消息";
//		lblNO.textColor = [UIColor blackColor];
//		lblNO.backgroundColor = [UIColor clearColor];
//		lblNO.textAlignment = UITextAlignmentLeft;
//		
//		concernMeTV.tableHeaderView = lblNO;
//		[lblNO release];
//	}
//	
//	if (acView && [acView isKindOfClass:[UIActivityIndicatorView class]]) {
//		[acView stopAnimating];
//	}
//	if (alertPage && [alertPage isKindOfClass:[UIAlertView class]]) {
//		[alertPage dismissWithClickedButtonIndex:0 animated:YES];
//	}
}

-(void)didFinishedError:(id)data{
	
//	//UIAlertView *alertError = [[UIAlertView alloc]initWithTitle:@"错误" message:@"网络错误" delegate:nil cancelButtonTitle:@"撤销" otherButtonTitles:nil];
////	[alertError show];
////	[alertError release];
//	
//	iToast * toast = [iToast makeText:@"由于网络原因，数据获取失败"];
//	[toast setDuration:2500];
//	[toast show];
//	
//	if (iffresh) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"showRefreshBarWCM" object:nil];
//	}
//	
//	if (acView && [acView isKindOfClass:[UIActivityIndicatorView class]]) {
//		[acView stopAnimating];
//	}
//	if (alertPage && [alertPage isKindOfClass:[UIAlertView class]]) {
//		[alertPage dismissWithClickedButtonIndex:0 animated:YES];
//	}
	
}


- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshMessage" object:nil];

}

@end
