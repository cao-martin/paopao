//
//  ConcernMessageView.m
//  PhotoSharing
//
//  Created by user on 11-12-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConcernMessageView.h"
//#import "DefaultTag.h"
@implementation ConcernMessageView


- (id)initWithFrame:(CGRect)frame {
	iffresh = NO;
	arrCpzQuery = [[NSMutableArray alloc]init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshMessage) name:@"refreshMessage" object:nil];
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self getFromMe];
		[self initViews];
    }
    return self;
}

-(void)initViews{
	self.backgroundColor = [UIColor blackColor];
	TVConfig = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kDeviceHeight - 45 -20) ];
	TVConfig.dataSource = self;
	TVConfig.rowHeight = 80 -25;
	TVConfig.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self addSubview:TVConfig];
	
}

-(void)freshMessage{
	
	iffresh = YES;
	[self getFromMe];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([arrCpzQuery count] > 0) {
		return [arrCpzQuery count];
	}
	else {
		return 1;
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
	
	if ([arrCpzQuery count] > 0) {
		UIButton *nameButton = [[UIButton alloc]initWithFrame:CGRectMake(5 +50, 3+5, 120, 20)];
		nameButton.tag = indexPath.row;
		[nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[nameButton addTarget:self action:@selector(noti:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:nameButton];
		
		NSString *strContent = [NSString stringWithFormat:@"%@",[[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"username"]];
		UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0];
		UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
		lblName.numberOfLines = 1;
		CGSize size = CGSizeMake(200, 20);
		CGSize labelsize = [strContent sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
		lblName.frame = CGRectMake(0, 0, labelsize.width, labelsize.height);
		nameButton.frame = CGRectMake(5 +50, 3 +5, labelsize.width, labelsize.height);
		lblName.font = font;
		[lblName setTextColor:[UIColor colorWithRed:0 green:0 blue:0.30 alpha:1.0]];
		lblName.text = strContent;//获取数据
		lblName.textAlignment = UITextAlignmentLeft;
		[nameButton addSubview:lblName];

		

		UIButton *ivHead = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
		ivHead.tag = indexPath.row + 100000;
		if ([[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"headimage"] && ![[[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"headimage"]isEqualToString:@""]) {
			
			NSString *strUrl = [[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"headimage"];
			//UIImage *imgHead = [http loadImageWithUrl:strUrl];
//			[ivHead setImage:imgHead forState:UIControlStateNormal];
//			imgHead = nil;
			
			[ivHead setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"Photo_bg.png"]];
			
		}
		else {
			[ivHead setBackgroundImage:[UIImage imageNamed:@"Photo_bg.png"] forState:UIControlStateNormal];
		}
		[ivHead addTarget:self action:@selector(noti:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:ivHead];
		
		UILabel *cellLable = [[UILabel alloc]initWithFrame:CGRectMake(10 +nameButton.frame.size.width +50, 3 +4, 320 -nameButton.frame.size.width -20 -50, 20)];
		[cellLable setFont:[UIFont systemFontOfSize:15.0]];
		if ([[[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"message"] intValue]== 0) {
			cellLable.text = @"评论了您的照片";
			//cellLable.textColor = [UIColor colorWithRed:0.15 green:0.32 blue:0.49 alpha:1.0];
		}
		if ([[[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"message"] intValue]== 1) {
			cellLable.text = @"已开始关注您";
			//cellLable.textColor = [UIColor colorWithRed:0 green:0 blue:0.30 alpha:1.0];
		}
		if ([[[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"message"] intValue]== 2) {
			cellLable.text = @"赞了您的照片";
			//cellLable.textColor = [UIColor colorWithRed:0.34 green:0.40 blue:0.78 alpha:1.0];
		}
		if ([[[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"message"] intValue] == 3) {
			cellLable.text = @"想要关注您";
		}
		cellLable.textColor = [UIColor blackColor];
		[cell addSubview:cellLable];
		
		
		UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(55 +5, 50 +5 -25, 60, 15)];
		[timeLable setTextColor:[UIColor grayColor]];
		timeLable.text = [AppHelper DateString2Display:[[arrCpzQuery objectAtIndex:indexPath.row] objectForKey:@"addtime"] strFormat:StandardDateTimeFormat];
		timeLable.font = [UIFont systemFontOfSize:12.0];
		[cell addSubview:timeLable];
		
		

		UILabel *lblSap = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 5)];
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
//		
	}
		
	return cell;
}



-(void)noti:(UIButton *)sender{
	NSMutableArray *arrUserID = [[NSMutableArray alloc]init];
	for (int i = 0; i < [arrCpzQuery count]; i ++) {
		[arrUserID addObject:[[arrCpzQuery objectAtIndex:i] objectForKey:@"id"]];
	}
	int btnTag;
	if (sender.tag < 100000) {
		btnTag = sender.tag;
	}
	else {
		btnTag = sender.tag - 100000;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ifClickName" object:[arrUserID objectAtIndex:btnTag]];
}

#pragma mark -
#pragma mark    getFromMe

-(void)getFromMe
{
    [AppHelper showHUD:@"没有消息" baseview:self];
	TVConfig.tableHeaderView = nil;
	
//	HttpData *httpData = [[HttpData alloc]init];
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	[httpData getFromMeInfo:[defaults objectForKey:@"userid"]];
//	httpData.delegate =self;
//	httpData.didFinished = @selector(didFinished:);
//	httpData.didFinishedError = @selector(didFinishedError:);
//	[httpData release];
}

-(void)didFinished:(id)data{
//	data = [data JSONValue];
//	//NSLog(@"data===1111111==%@",data);
//	if ([[data objectForKey:@"code"] intValue] == 200) {
//		[arrCpzQuery removeAllObjects];
//		if ([[data objectForKey:@"data"] count] > 0) {
//			[arrCpzQuery addObjectsFromArray:[data objectForKey:@"data"]];
//			//NSLog(@"arrCpzQueryFromMe前===%@",arrCpzQuery);
//			
//		}
//		else {
//			UILabel *lblNO = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 44)];
//			lblNO.numberOfLines = 0;
//			lblNO.lineBreakMode = UILineBreakModeWordWrap;
//			lblNO.font = [UIFont systemFontOfSize:13.0];
//			lblNO.text = @"      当前没有消息";
//			lblNO.textColor = [UIColor blackColor];
//			lblNO.backgroundColor = [UIColor clearColor];
//			lblNO.textAlignment = UITextAlignmentLeft;
//			
//			TVConfig.tableHeaderView = lblNO;
//			[lblNO release];
//		}
//					
//		[TVConfig reloadData];
//	}
//	else {
//		UIAlertView *alertErrorCode = [[UIAlertView alloc]initWithTitle:@"错误" message:[data objectForKey:@"message"] delegate:nil cancelButtonTitle:@"撤销" otherButtonTitles:nil];
//		[alertErrorCode show];
//		[alertErrorCode release];
//	}
//	
//	if (iffresh) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"showRefreshBarCMV" object:nil];
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
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"showRefreshBarCMV" object:nil];
//	}
	
}



- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshMessage" object:nil];

}


@end
