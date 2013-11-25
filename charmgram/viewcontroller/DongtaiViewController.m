//
//  DongtaiViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "DongtaiViewController.h"

@interface DongtaiViewController ()

@end

@implementation DongtaiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
	UILabel* lblTest=[[UILabel alloc] initWithFrame:CGRectMake(0, 100, kDeviceWidth, 30)];
    lblTest.font=[UIFont systemFontOfSize:24.0];
    lblTest.text=@"   动态，建设中。。。";
    [self.view addSubview:lblTest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData{
}
@end
