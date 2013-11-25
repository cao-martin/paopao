//
//  FujinViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "FujinViewController.h"

@interface FujinViewController ()

@end

@implementation FujinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
	
	tbContent=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-98) style:UITableViewStylePlain];
	tbContent.backgroundColor=[UIColor whiteColor];
	tbContent.backgroundView=nil;
	tbContent.dataSource=self;
	tbContent.delegate=self;
	tbContent.separatorStyle=UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tbContent];
	[tbContent setContentInset:UIEdgeInsetsMake(8, 0, 0, 0)];
 	[tbContent setScrollIndicatorInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
	
	arrImage =[[NSMutableArray alloc] initWithCapacity:0];
	
	for (int k=4; k<43; k++) {
		ImageInfo* item=[[ImageInfo alloc] init];
		item.URL=[NSString stringWithFormat:@"example10%d.jpg",k%9];
 
		item.Distance=arc4random() % 5000+11;
 		item.AvatarURL=[NSString stringWithFormat:@"avatar%d.jpg", k%6 ];
		[arrImage addObject:item];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData{
	
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 155.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return ceil(arrImage.count/2.0) ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* cellId=@"mycell";
	FujinCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell=[[FujinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
	}
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	int row=indexPath.row;
	int start=row*2;
	int end=start+1;
	if (end>arrImage.count-1) {
		end=arrImage.count-1;
	}
	[cell removeImages];
	for (int k=start; k<=end; k++) {
		ImageInfo* item=[arrImage objectAtIndex:k];
		[cell addImage:item];
	}
	[cell refreshData];
	return cell;
}

@end
