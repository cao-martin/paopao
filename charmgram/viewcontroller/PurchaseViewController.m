//
//  PurchaseViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-5-12.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "PurchaseViewController.h"
#import "CoinListViewController.h"
@interface PurchaseViewController ()<SKProductsRequestDelegate>

@end

@implementation PurchaseViewController
 
- (void)viewDidLoad
{
    [super viewDidLoad];
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    [self.view addSubview:topbar];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.text=@"购买靓点";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
	
	UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 0, 54,44);
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
    UIButton *btnList=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnList setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_off"] forState:UIControlStateNormal];
    [btnList setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_on"] forState:UIControlStateHighlighted];
    [btnList.titleLabel setFont:[UIFont systemFontOfSize:12]];
    btnList.frame=CGRectMake(240, 1, 70,44);
    [btnList setTitle:@"靓点记录" forState:UIControlStateNormal];
    [btnList addTarget:self action:@selector(showCoinList) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnList];
    
	tbMain=[[UITableView alloc] initWithFrame:CGRectMake(0, kTopbarHeight, kDeviceWidth, kDeviceHeight-kTopbarHeight-20) style:UITableViewStyleGrouped];
	tbMain.backgroundColor=[UIColor whiteColor];
	tbMain.backgroundView=nil;
	tbMain.dataSource=self;
	tbMain.delegate=self;
	[self.view addSubview:tbMain];
	
	[self initArray];
}

-(void)initArray{
    [self gotoPayPage];
	arrItem=[[NSMutableArray alloc] initWithCapacity:0];
//	[arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"600靓点",@"title",@"6.00", @"price",@"beauty_point_600",@"liangidid",nil]];
//	[arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1200靓点",@"title",@"12.00", @"price",@"beauty_point_1200",@"liangidid",nil]];
//	[arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1800靓点",@"title",@"18.00", @"price",@"beauty_point_1800",@"liangidid",nil]];
//	[arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2500靓点",@"title",@"25.00", @"price",@"beauty_point_2500",@"liangidid",nil]];
//	[arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"3000靓点",@"title",@"30.00", @"price",@"beauty_point_3000",@"liangidid",nil]];
//	[arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"5000(含500赠送)靓点",@"title",@"45.00", @"price",@"beauty_point_5000",@"liangidid",nil]];
//    [arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"7000(含1000赠送)靓点",@"title",@"60.00", @"price",@"beauty_point_7000",@"liangidid",nil]];
//     [arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"10000(含1200赠送)靓点",@"title",@"88.00", @"price",@"beauty_point_10000",@"liangidid",nil]];
//	[arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"7000靓点(赠1000)",@"title",@"60.00", @"price",nil]];
//	[arrItem addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"10000靓点(赠1200)",@"title",@"88.00", @"price",nil]]; 
}

-(void)gotoPayPage
{
    if ([self canPurchase]) {
		
		[self requestProductData];
	}
    
}

#pragma mark -----------------------------------------------
#pragma mark 购买靓点相关

//是否可以进行交易
- (BOOL)canPurchase{
	if ([SKPaymentQueue canMakePayments]) {
		//可以交易
		return YES;
	}
	else {
		//
		return NO;
	}
	return NO;
}


- (void)requestProductData{
	[AppHelper showHUD:@"产品获取中..." baseview:self.view];
	//[self showWaitingAlert_rightBar:@"产品获取中，请稍候..."];
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:@"beauty_point_600",@"beauty_point_600",@"beauty_point_1200",@"beauty_point_1800",@"beauty_point_2500",@"beauty_point_3000",@"beauty_point_5000",@"beauty_point_7000",@"beauty_point_10000",nil]];
	
	request.delegate = self;
	[request start];
    
}

#pragma mark SKProductsRequest delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
	
    [AppHelper hideHUD:self.view];
    //
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:response.products]; ;
	
	NSLog(@"array==========%@",array);
    //
    NSArray *arrMutable =  [self getTurnedArray:array];
	for(SKProduct *product in arrMutable){
        [arrItem addObject:product];
//        NSString *pid = [product productIdentifier];
//        NSString *plocal = [product localizedDescription];
//       NSString *pTitle = [product localizedTitle];
//   
//      float price =   [[product price] floatValue];
//        
//        
//        NSLog(@"pid====%@===%@===%@===%f",pid,plocal,pTitle,price);
    }
    [tbMain reloadData];
}
//根据产品title的靓点大小进行排序
- (NSArray *)getTurnedArray:(NSMutableArray *)array{
	
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
	return sortedArray;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

#pragma mark - Click Event
-(void)clickBack{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)showCoinList{
    CoinListViewController *conlist = [[CoinListViewController alloc] init];
    [self.navigationController  pushViewController:conlist animated:YES];
}
#pragma mark - Tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 54.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [arrItem count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* cellId=@"mycell";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
   
	cell.selectionStyle=UITableViewCellSelectionStyleGray ;
	int row=indexPath.row;
     SKProduct *product = arrItem[row];
	cell.textLabel.text= product.localizedTitle;//[NSString stringWithFormat:@" %@",  [dict objectForKey:@"title"]];
	cell.textLabel.textAlignment=UITextAlignmentLeft;
	cell.textLabel.font=[UIFont systemFontOfSize:16.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[product priceLocale]];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
	cell.detailTextLabel.text=formattedString;
	cell.detailTextLabel.textAlignment=UITextAlignmentLeft;
	cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0];
	cell.detailTextLabel.textColor=[UIColor colorWithWhite:0.35 alpha:1.0];
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	 
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	int row=indexPath.row;
	

    [self orderIdMake:row];
	//    [self presentViewController:controller animated:YES completion:nil];
//    [self performSelector:@selector(gotoDone) withObject:nil afterDelay:1.0];
 
}
-(void )orderIdMake:(int)index{
     SKProduct *product = arrItem[index];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[product priceLocale]];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    PaymentViewController *controller = [[PaymentViewController alloc] init];
    
    //    controller.curPray=prayitem;
    controller._strPayName= product.localizedTitle;
    controller._strMoney = formattedString;
    controller._strDay = @"";
    controller._strAddress = @"";
    controller._strNongli = @"";
    controller.sProduct = product;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller] ;
    [self presentModalViewController:navController animated:YES];

}
@end
