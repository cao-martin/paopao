//
//  FriendViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-3-26.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "FriendViewController.h"
#import "UIImageView+WebCache.h"
@interface FriendViewController ()
{
    UIImageView* imgSearchBg;
}
@end

@implementation FriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor colorWithRed:(43/255.0f) green:(45/255.0f) blue:(52/255.0f) alpha:1.0f];
//    imgBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rearview_bg"]];
//    imgBg.frame=CGRectMake(kDeviceWidth-kFriendPanelWidth, 0, kFriendPanelWidth+1, kDeviceHeight);
//    imgBg.contentMode=UIViewContentModeScaleAspectFill;
//    imgBg.userInteractionEnabled=YES;
//    [self.view addSubview:imgBg];
    [self initSearchBar];
    [self initSegment];
 
//    int left=kDeviceWidth-kFriendPanelWidth;
    
    tbFollow=[[UITableView alloc] initWithFrame:CGRectMake(0, 88, kFriendPanelWidth, kDeviceHeight-154)];
    tbFollow.dataSource=self;
    tbFollow.delegate=self;
    tbFollow.backgroundColor=[UIColor clearColor];
    tbFollow.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbFollow];
    
    tbFollow.hidden = YES;
    tbFan=[[UITableView alloc] initWithFrame:CGRectMake(0, 88, kFriendPanelWidth, kDeviceHeight-154)];
    tbFan.dataSource=self;
    tbFan.delegate=self;
    tbFan.backgroundColor=[UIColor clearColor];
    tbFan.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbFan];
   // tbFan.hidden=YES;
    
    
    tbTuiJian=[[UITableView alloc] initWithFrame:CGRectMake(0, 88, kFriendPanelWidth, kDeviceHeight-154)];
    tbTuiJian.dataSource=self;
    tbTuiJian.delegate=self;
    tbTuiJian.backgroundColor=[UIColor clearColor];
    tbTuiJian.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbTuiJian];
    tbTuiJian.hidden=YES;
    
    tbSearch=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, kFriendPanelWidth, kDeviceHeight-110)];
    
    tbSearch.dataSource=self;
    tbSearch.delegate=self;
    tbSearch.backgroundColor=[UIColor blackColor];
    tbSearch.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbSearch];
    tbSearch.hidden=YES;
    
    UIImageView *topSplit=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, 3)];
    topSplit.image=[UIImage imageNamed:@"view_shadow_poi_top"];
    [self.view addSubview:topSplit];
    
    UIButton* btnAddFriend=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAddFriend.frame=CGRectMake(0, kDeviceHeight-85, 269, 65);
    [btnAddFriend setImage:[UIImage imageNamed:@"friends_bottom_btn"] forState:UIControlStateNormal];
    [btnAddFriend setImage:[UIImage imageNamed:@"friends_bottom_btn_h"] forState:UIControlStateHighlighted];
    [btnAddFriend addTarget:self action:@selector(clickAddFriend) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel* lblAddFriend=[[UILabel alloc] initWithFrame:CGRectMake(16, 32, 100, 20)];
//    lblAddFriend.text=@"添加朋友";
//    lblAddFriend.textColor=[UIColor whiteColor];
//    lblAddFriend.font=[UIFont boldSystemFontOfSize:14.0];
//    lblAddFriend.backgroundColor=[UIColor clearColor];
//    lblAddFriend.userInteractionEnabled=NO;
//    [btnAddFriend addSubview:lblAddFriend];
    [self.view addSubview:btnAddFriend];
    
 
}

-(void)initSearchBar{
	UIView* searchBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kFriendPanelWidth, 44)];
	searchBar.backgroundColor=[UIColor clearColor];
	
	 imgSearchBg=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search_bg_rear"] stretchableImageWithLeftCapWidth:60.0 topCapHeight:0.0 ]];
	imgSearchBg.frame=CGRectMake(10, -5, kFriendPanelWidth-20, 42);
	
	UIImageView* imgSearchIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon_rear"]];
	imgSearchIcon.frame=CGRectMake(8, 13, 17, 17);
    [imgSearchBg addSubview:imgSearchIcon];
	
	tvSearch=[[UISearchBar alloc] initWithFrame:CGRectMake(8, 9, 245, 29)];
    tvSearch.showsCancelButton = NO;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    tvSearch.allowsEditingTextAttributes = YES;
#endif
    [[tvSearch.subviews objectAtIndex:0]removeFromSuperview];
    //2.
    tvSearch.backgroundColor = [UIColor clearColor];
    for (UIView *subview in tvSearch.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
     UITextField* searchField = nil;
    for (UIView *subview in tvSearch.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchField = (UITextField*)subview;
            
            //searchField.leftView=nil;
            searchField.textColor = [UIColor whiteColor];
            [searchField setBackground:nil];
            // [searchField setBackgroundColor:[UIColor clearColor]];
            
            [searchField setBorderStyle:UITextBorderStyleNone];
            
            break;
            break;
        }
    }
    //3自定义背景
   // UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bg_rear"]];
    [tvSearch insertSubview:imgSearchBg atIndex:1];
    tvSearch.delegate = self;
	tvSearch.backgroundColor=[UIColor clearColor];
	//tvSearch.font=[UIFont systemFontOfSize:14.0];
	//tvSearch.textColor=[UIColor whiteColor];
	tvSearch.autocorrectionType=UITextAutocorrectionTypeNo;
	//tvSearch.returnKeyType=UIReturnKeyDone;
	tvSearch.placeholder=@"搜索用户";
	//tvSearch.clearButtonMode=UITextFieldViewModeWhileEditing;
	//tvSearch.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
	
	//[imgSearchBg addSubview:imgSearchIcon];
	//[searchBar addSubview:imgSearchBg];
	[searchBar addSubview:tvSearch];
	[self.view addSubview:searchBar];
    arrFollow=[[NSMutableArray alloc] initWithCapacity:0];
    arrFan=[[NSMutableArray alloc] initWithCapacity:0];
     arrSearch=[[NSMutableArray alloc] initWithCapacity:0];
     arrTuiJian=[[NSMutableArray alloc] initWithCapacity:0];
}

-(void)initSegment{
    UIImageView* imgSegBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segmental_rear_bg"]];
    imgSegBg.frame=CGRectMake((kFriendPanelWidth-235)/2, 49, 235, 33);
    imgSegBg.userInteractionEnabled=YES;
//    UITapGestureRecognizer* tapSeg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSegment)];
//    tapSeg.numberOfTouchesRequired=1;
//    tapSeg.numberOfTapsRequired=1;
//    [imgSegBg addGestureRecognizer:tapSeg];

    UIView* imgSegSp1=[[UIView alloc] initWithFrame:CGRectMake(78, 1, 1, 31)];
    imgSegSp1.backgroundColor=[UIColor colorWithRed:18/255.0 green:20/255.0 blue:27/255.0 alpha:1.0];
    
    UIView* imgSegSp2=[[UIView alloc] initWithFrame:CGRectMake(78*2, 1, 1, 31)];
    imgSegSp2.backgroundColor=[UIColor colorWithRed:18/255.0 green:20/255.0 blue:27/255.0 alpha:1.0];
    
    lblFollow=[[UILabel alloc] initWithFrame:CGRectMake(1, 1, 77, 31)];
    lblFollow.textColor=[UIColor whiteColor];
    lblFollow.backgroundColor=[UIColor clearColor];
    lblFollow.font=[UIFont boldSystemFontOfSize:16.0];
    lblFollow.textAlignment=UITextAlignmentCenter;
    lblFollow.text=@"关注";
    
    lblFans=[[UILabel alloc] initWithFrame:CGRectMake(78, 1, 77, 31)];
    lblFans.textColor=[UIColor whiteColor];
    lblFans.backgroundColor=[UIColor clearColor];
    lblFans.font=[UIFont boldSystemFontOfSize:16.0];
    lblFans.textAlignment=UITextAlignmentCenter;
    lblFans.text=@"粉丝";
    
    
    lblTuiJian=[[UILabel alloc] initWithFrame:CGRectMake(78*2, 1, 77, 31)];
    lblTuiJian.textColor=[UIColor whiteColor];
    lblTuiJian.backgroundColor=[UIColor clearColor];
    lblTuiJian.font=[UIFont boldSystemFontOfSize:16.0];
    lblTuiJian.textAlignment=UITextAlignmentCenter;
    lblTuiJian.text=@"推荐";
//    UIView* imgHL=[[UIView alloc] initWithFrame:CGRectMake(1, 1, 116, 31)];
//    imgHL.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"segmental_rear_btn_h"]];
    
    imgSeg=[[UIImageView alloc] init];
    [imgSeg setImage:[UIImage imageNamed:@"segmental_rear_btn_h"]];
    imgSeg.frame=CGRectMake(1, 1, 77, 31);
    imgSeg.userInteractionEnabled = YES;
  
    
    [self.view addSubview:imgSegBg];
    [imgSegBg addSubview:lblFollow];
    [imgSegBg addSubview:lblFans];
    [imgSegBg addSubview:lblTuiJian];
    [imgSegBg addSubview:imgSeg];
    [imgSegBg addSubview:imgSegSp1];
    [imgSegBg addSubview:imgSegSp2];
    UITapGestureRecognizer* tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSegment:)];
    tapGesture1.numberOfTapsRequired=1;
    tapGesture1.numberOfTouchesRequired=1;
    [imgSegBg addGestureRecognizer:tapGesture1];
    /**
	for (int k=0; k<40; k++) {
        UserInfo *item=[[UserInfo alloc] init];
        item.UserId=1000+k;
        item.UserName=[NSString stringWithFormat:@"用户名%d",item.UserId];
        item.AvatarURL=[NSString stringWithFormat:@"avatar%d.jpg",item.UserId%12];
        [arrUser addObject:item];
    }
	 */
}

-(void)viewDidAppear:(BOOL)animated{

	DLog(@"");
	[super viewDidAppear:animated];
}

-(void)refreshData{
	if ([AppHelper isValidatedUser]) {
        if (selectedIndex==0) {
           [self loadFanFromWeb];
        }
		else if(selectedIndex==1){
             [self loadFollowFromWeb];
            
        }else{
            [self loadTuiJianFromWeb];
        }
	}
}

-(void)clearData{
    [arrFan removeAllObjects];
    [tbFan reloadData];
    [arrFollow removeAllObjects];
    [tbFollow reloadData];
    lblFans.text=@"粉丝";
    lblFollow.text=@"关注";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

#pragma mark - Click Events
-(void)hideKeyWin
{
    tvSearch.showsCancelButton = NO;
     tbSearch.hidden = YES;
    imgSearchBg.frame=CGRectMake(10, -5, kFriendPanelWidth-40, 42);

	[tvSearch resignFirstResponder];
	[AppHelper hideKeyWindow];
}

-(void)clickAddFriend{
    [self hideKeyWin];
    [[HomeViewController shared] gotoFriendView:selectedIndex];
}

-(void)clickSegment:(UITapGestureRecognizer*)gesture{
    float x = [gesture  locationInView:gesture.view].x;
   NSLog(@"%f", [gesture  locationInView:gesture.view].x);
    if (selectedIndex == x/77) {
        return;
    }else{
        selectedIndex = x/77;
    } ;
    [self hideKeyWin];
    CGFloat duration=0.10;
    if (selectedIndex==1) {
        [UIView animateWithDuration:duration animations:^{
            imgSeg.frame=CGRectMake(78, 1, 77, 31);
        }];
        tbTuiJian.hidden = YES;
        tbFollow.hidden=NO;
        tbFan.hidden=YES;
        [self loadFollowFromWeb];
        //if (arrFan.count==0) {
           
        //}
    } else if (selectedIndex==2) {
        [UIView animateWithDuration:duration animations:^{
            imgSeg.frame=CGRectMake(78*2, 1, 77, 31);
        }];
        tbTuiJian.hidden = NO;
        tbFollow.hidden=YES;
        tbFan.hidden=YES;
       // if (arrTuiJian.count==0) {
            [self loadTuiJianFromWeb];
       // }

    }
    else{
        [UIView animateWithDuration:duration animations:^{
            imgSeg.frame=CGRectMake(1, 1, 77, 31);
        }];
        tbTuiJian.hidden = YES;
        tbFollow.hidden=YES;
        tbFan.hidden=NO;
         [self loadFanFromWeb];
       // if (arrFollow.count==0) {
            
       // }
    }
}
#pragma mark - UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [tvSearch resignFirstResponder];
    if (!arrSearch.count) {
        tbSearch.hidden  = YES;
        [tvSearch setShowsCancelButton:NO];
        imgSearchBg.frame=CGRectMake(10, -5, kFriendPanelWidth-40, 42);

    }
}
#pragma mark - TableView 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tbFan==tableView) {
        return arrFan.count;
    }else if(tbFollow == tableView){
        return arrFollow.count;
    }else if(tbTuiJian == tableView){
        return arrTuiJian.count;
    }else{
        NSLog(@"count ==%d",arrSearch.count);
        return arrSearch.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString* cellID=@"mycell";
    static NSString* cellID2=@"friend2";
    static NSString* cellID3=@"friend3";
    static NSString* cellID4=@"friend4";
    static NSString* cellID5=@"friend5";
    if (tbFan==tableView) {
        UserCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell) {
            cell=[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        int row=indexPath.row;
        UserInfo* item=[arrFan objectAtIndex:row];
        [cell loadData:item];
        return cell;
    }
    else if(tbFollow ==tableView){
        UserCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID3];
        if (!cell) {
            cell=[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
        }
        int row=indexPath.row;
        UserInfo* item=[arrFollow objectAtIndex:row];
        [cell loadData:item];
        return cell;
    }else if(tbTuiJian ==tableView){
        UserCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID4];
        if (!cell) {
            cell=[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4];
        }
        int row=indexPath.row;
        UserInfo* item=[arrTuiJian objectAtIndex:row];
        [cell loadData:item];
        return cell;
    }else {
        UserCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID5];
        if (!cell) {
            cell=[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID5];
        }
        int row=indexPath.row;
        UserInfo* item=[arrSearch objectAtIndex:row];
        [cell loadData:item];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	int row=indexPath.row;
    if (tableView==tbFan) {
        UserInfo* item=[arrFan objectAtIndex:row];
        [[HomeViewController shared] gotoUserView:item];
    }
    else if(tableView == tbFollow){
        UserInfo* item=[arrFollow objectAtIndex:row];
        [[HomeViewController shared] gotoUserView:item];
    }  else if (tableView==tbTuiJian) {
        UserInfo* item=[arrTuiJian objectAtIndex:row];
        [[HomeViewController shared] gotoUserView:item];
    }
    else{
        UserInfo* item=[arrSearch objectAtIndex:row];
        [[HomeViewController shared] gotoUserView:item];
    }
}
#pragma mark -UISearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    imgSearchBg.frame=CGRectMake(10, -5, kFriendPanelWidth-80, 42);
    tvSearch.showsCancelButton = YES;
    tbSearch.hidden = NO;
    [self.view bringSubviewToFront:tbSearch];
    searchBar.showsCancelButton = YES;
    return YES;
}                   // return NO to not become first responder



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *strField = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([strField length]== 0) {
        [AppHelper showAlertMessage:@"请输入用户昵称"];
    }else{
        [self loadSearchFromWeb];
        //[tvSearch resignFirstResponder];
    }
}                   // called when keyboard search button pressed

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self hideKeyWin];
}                 // called when cancel button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2){
    
} // called when search results button pressed

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    tbSearch.hidden = NO;
//    [self.view bringSubviewToFront:tbSearch];
//    return YES;
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//   
//    return YES;
//}
//- (BOOL)textFieldShouldClear:(UITextField *)textField{
//   
//    return YES;
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSString *strField = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([strField length]== 0) {
//        [AppHelper showAlertMessage:@"请输入用户昵称"];
//        return NO;
//    }else{
//        [self loadSearchFromWeb];
//        [tvSearch resignFirstResponder];
//    }
//    
//    return YES;
//}

#pragma mark - Load Data
-(void)loadFollowFromWeb{
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_MYFOLLOW forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:userid forKey:@"ownerid"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			
            [arrFollow removeAllObjects];
            
            for (NSDictionary *di in data) {
				UserInfo* item=[[UserInfo alloc] initWithDict:di];
                [arrFollow addObject:item];
            }
            [tbFollow reloadData];
			//lblFollow.text=[NSString stringWithFormat:@"粉丝 %d",arrFollow.count];
        }
        else{
            [AppHelper showAlertMessage:msg];
        } 
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
	
}

-(void)loadFanFromWeb{
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_MYFAN forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:userid forKey:@"ownerid"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        NSLog(@",respString===%@",respString);
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			
            [arrFan removeAllObjects];
            
            for (NSDictionary *di in data) {
				UserInfo* item=[[UserInfo alloc] initWithDict:di];
                [arrFan addObject:item];
            }
            [tbFan reloadData];
			//lblFans.text=[NSString stringWithFormat:@"关注 %d",arrFan.count];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
	
}
-(void)loadTuiJianFromWeb{
    NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_TUIJIAN forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        NSLog(@"JSON-===%@",JSON);
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			
            [arrTuiJian removeAllObjects];
            
            for (NSDictionary *di in data) {
				UserInfo* item=[[UserInfo alloc] initWithDict:di];
                [arrTuiJian addObject:item];
            }
            [tbTuiJian reloadData];
			//lblTuiJian.text=[NSString stringWithFormat:@"粉丝 %d",arrFan.count];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
-(void)loadSearchFromWeb{
    NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_SEARCH forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:tvSearch.text forKey:@"username"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        NSLog(@"JSON===%@",JSON);
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			
            [arrSearch removeAllObjects];
            
            for (NSDictionary *di in data) {
				UserInfo* item=[[UserInfo alloc] initWithDict:di];
                [arrSearch addObject:item];
            }
            [tbSearch reloadData];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
@end
