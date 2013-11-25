//
//  FindFriendViewController.m
//  charmgram
//
//  Created by martin on 13-8-23.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "FindFriendViewController.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "pinyin.h"
#define FINDTAG 200000
#import "TXLCell.h"
@interface FindFriendViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation FindFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
//    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0f];
    imgBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_bg"]];
    imgBg.frame=CGRectMake(0, 0, kDeviceWidth, 44);
    imgBg.contentMode=UIViewContentModeScaleAspectFill;
    imgBg.userInteractionEnabled=YES;
    [self.view addSubview:imgBg];
    
    [self initSegment];
   
    //    int left=kDeviceWidth-kFriendPanelWidth;
    
    count = 0;
    tbFollow=[[UITableView alloc] initWithFrame:CGRectMake(0, 90, kDeviceWidth, kDeviceHeight-64-33)];
    tbFollow.dataSource=self;
    tbFollow.delegate=self;
    tbFollow.backgroundColor=[UIColor whiteColor];
    //tbFollow.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbFollow];
    
    btnWx = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-150)/2, 200, 150, 30)];
    btnWx.hidden = YES;
    [btnWx setTitle:@"邀请微信好友" forState:UIControlStateNormal];
    [btnWx setBackgroundImage:[UIImage imageNamed:@"listbg_blue"] forState:UIControlStateNormal];
    [btnWx addTarget:self action:@selector(goWx) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnWx];
    
    btnYQ=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnYQ setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_off"] forState:UIControlStateNormal];
    [btnYQ setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_on"] forState:UIControlStateHighlighted];
    [btnYQ.titleLabel setFont:[UIFont systemFontOfSize:12]];
    btnYQ.frame=CGRectMake(240, 1, 70,44);
    [btnYQ setTitle:@"邀请" forState:UIControlStateNormal];
    [btnYQ addTarget:self action:@selector(clickYQ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnYQ];

    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 1, 54,44);
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancel];
	
    arrFollow=[[NSMutableArray alloc] initWithCapacity:0];
    arrTotal=[[NSMutableArray alloc] initWithCapacity:0];
//    search = [[UISearchBar alloc] initWithFrame:CGRectZero];
//    search.tintColor = [UIColor blackColor];
//    search.placeholder = @"Search";
//    search.delegate = self;
//    
//    [search sizeToFit];
//    [tbFollow setTableHeaderView:search];

    UIImageView *topSplit=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, 3)];
    topSplit.image=[UIImage imageNamed:@"view_shadow_poi_top"];
    [self.view addSubview:topSplit];
    [self initSearchBar];
    
}

//-(void)initSearchBar{
//	UIView* searchBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
//	searchBar.backgroundColor=[UIColor clearColor];
//	
////	UIImageView* imgSearchBg=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search_bg_rear"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0 ]];
////	imgSearchBg.frame=CGRectMake(10, 1, kDeviceWidth-20, 42);
////	imgSearchBg.userInteractionEnabled = YES;
////	UIImageView* imgSearchIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon_rear"]];
////	imgSearchIcon.frame=CGRectMake(8, 13, 17, 17);
//	
//    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
//    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
//    btnCancel.frame=CGRectMake(8, 1, 54,44);
//    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//    [searchBar addSubview:btnCancel];
//	
//	[self.view addSubview:searchBar];
//    arrFollow=[[NSMutableArray alloc] initWithCapacity:0];
//    arrScetion=[[NSMutableArray alloc] initWithCapacity:0];
//    
//    search = [[UISearchBar alloc] initWithFrame:CGRectZero];
//    search.tintColor = [UIColor blackColor];
//    search.placeholder = @"Search";
//   search.delegate = self;
//    
//    [search sizeToFit];
//    [tbFollow setTableHeaderView:search];
//    UISearchDisplayController *strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:search contentsController:self];
//   strongSearchDisplayController.searchResultsDataSource = self;
//    strongSearchDisplayController.searchResultsDelegate = self;
//    strongSearchDisplayController.delegate = self;
//}
-(void)initSearchBar{
	UIImageView* searchBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kFriendPanelWidth, 44)];
    searchBar.userInteractionEnabled = YES;
    searchBar.image = [UIImage imageNamed:@"frinend_bar"];
	searchBar.backgroundColor=[UIColor clearColor];
	
    imgSearchBg=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search_bg_rear"] stretchableImageWithLeftCapWidth:60.0 topCapHeight:0.0 ]];
	imgSearchBg.frame=CGRectMake(10, -5, kDeviceWidth-40, 42);
	
//	UIImageView* imgSearchIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon_rear"]];
//	imgSearchIcon.frame=CGRectMake(8, 13, 17, 17);
//    [imgSearchBg addSubview:imgSearchIcon];
	
	tvSearch=[[UISearchBar alloc] initWithFrame:CGRectMake(8, 9, 300, 29)];
//     [tvSearch setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    tvSearch.showsCancelButton = NO;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    //tvSearch.allowsEditingTextAttributes = YES;
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
        }
    }
    //3自定义背景
    // UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bg_rear"]];
    [tvSearch insertSubview:imgSearchBg atIndex:0];
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
    [tbFollow setTableHeaderView:searchBar];
}

-(void)initSegment{
    UIImageView* imgSegBg=[[UIImageView alloc] initWithImage:nil];
    imgSegBg.layer.borderWidth = 2;
    imgSegBg.layer.borderColor = [UIColor grayColor].CGColor;
    imgSegBg.frame=CGRectMake((kDeviceWidth-300)/2, 50, 300, 33);
    imgSegBg.userInteractionEnabled=YES;
    UITapGestureRecognizer* tapSeg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSegment)];
    tapSeg.numberOfTouchesRequired=1;
    tapSeg.numberOfTapsRequired=1;
    [imgSegBg addGestureRecognizer:tapSeg];
    
    UIView* imgSegSp=[[UIView alloc] initWithFrame:CGRectMake(149, 1, 1, 33)];
    imgSegSp.backgroundColor=[UIColor colorWithRed:18/255.0 green:20/255.0 blue:27/255.0 alpha:1.0];
  
       
    lblFollow=[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 128, 31)];
    lblFollow.textColor=[UIColor grayColor];
    lblFollow.backgroundColor=[UIColor clearColor];
    lblFollow.font=[UIFont boldSystemFontOfSize:16.0];
    lblFollow.textAlignment=UITextAlignmentCenter;
    lblFollow.text=@"通讯录";
    
    lblFans=[[UILabel alloc] initWithFrame:CGRectMake(168, 1, 128, 31)];
    lblFans.textColor=[UIColor grayColor];
    lblFans.backgroundColor=[UIColor clearColor];
    lblFans.font=[UIFont boldSystemFontOfSize:16.0];
    lblFans.textAlignment=UITextAlignmentCenter;
    lblFans.text=@"微信";
    
    UIImageView *imageTxl = [[UIImageView alloc] initWithFrame:CGRectMake(40, 8, 21, 18)];
    imageTxl.image = [UIImage imageNamed:@"txl"];
     UIImageView *imageWx = [[UIImageView alloc] initWithFrame:CGRectMake(188, 8, 21, 18)];
    imageWx.image = [UIImage imageNamed:@"wx"];
    //    UIView* imgHL=[[UIView alloc] initWithFrame:CGRectMake(1, 1, 116, 31)];
    //    imgHL.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"segmental_rear_btn_h"]];

    
    btnSeg=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSeg setBackgroundImage:[UIImage imageNamed:@"segmental_rear_btn_h"] forState:UIControlStateNormal];
    btnSeg.frame=CGRectMake(1, 1, 148, 31);
    [btnSeg addTarget:self action:@selector(clickSegment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:imgSegBg];
    [imgSegBg addSubview:lblFollow];
    [imgSegBg addSubview:lblFans];
    [imgSegBg addSubview:imageTxl];
    [imgSegBg addSubview:imageWx];
    [imgSegBg addSubview:btnSeg];
    [imgSegBg addSubview:imgSegSp];
    
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
    if (![arrFollow count]) {
         [self ReadPhoneBook];
    }
    
}

-(void)refreshData{
	if ([AppHelper isValidatedUser]) {
        if (selectedIndex==0) {
        }
		else{
        }
	}
}
-(void)ReadPhoneBook
{
    ABAddressBookRef addressBook = NULL;
    __block BOOL accessGranted = NO;  
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;  
    }
    
    if (accessGranted) {
        // Do whatever you want here.
        [AppHelper showHUD:@"数据加载中" baseview:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ABAddressBookRef addressBook = ABAddressBookCreate();//定义通讯录名字为addressbook
            CFArrayRef contacts = ABAddressBookCopyArrayOfAllPeople(addressBook);//将通讯录中的信息用数组方式读出
            CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);//获取通讯录中联系人
            
            for (int i = 0; i < nPeople; i++)
            {
                
                UserInfo * iphoneContact = [[UserInfo alloc] init];
                
                
                iphoneContact.UserId = i;
                ABRecordRef person = CFArrayGetValueAtIndex(contacts, i);//取出某一个人的信息
                NSInteger lookupforkey =(NSInteger)ABRecordGetRecordID(person);//读取通讯录中联系人的唯一标识
                NSDate * createDate = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonCreationDateProperty);// 读取通讯录中联系人的创建日期
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSString* birthDay = [formatter stringFromDate:createDate];
                
                
                
                NSString *createDate1 = [birthDay stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString *createDate2 = [createDate1 stringByReplacingOccurrencesOfString:@":" withString:@""];
                NSString *createDate3 = [createDate2 stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSLog(@"1111========%@",createDate3);
                NSLog(@"222222========%@",birthDay);
                // iphoneContact.lookUpKey = [createDate3 stringByAppendingString:indexInIphone];
                //上诉操作是将某个联系人的标识号与创建日期进行组合，得到唯一的标识，是为了当时特殊的需要，一般不会有这种变态应用，这是因为ABRecordGetRecordID在一个手机中是唯一的，即使删掉某一个联系人，这个号也不会在被占用。
                
                
                
                //读取联系人姓名属性
                if (ABRecordCopyValue(person, kABPersonLastNameProperty)&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))== nil) {
                    iphoneContact.UserName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
                }else if (ABRecordCopyValue(person, kABPersonLastNameProperty) == nil&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))){
                    iphoneContact.UserName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                }else if (ABRecordCopyValue(person, kABPersonLastNameProperty)&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))){
                    
                    NSString *first =(__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                    NSString *last = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
                    iphoneContact.UserName = [NSString stringWithFormat:@"%@%@",last,first];
                }
                NSLog(@"UserName===%@",iphoneContact.UserName);
                
                
                ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                
                if ((phone != nil)&&ABMultiValueGetCount(phone)>0) {
                    
                    for (int m = 0; m < ABMultiValueGetCount(phone); m++) {
                        NSString * aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, m) ;
                        NSString * aLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phone, m) ;
                        
                        if ([aLabel isEqualToString:@"_$!<Mobile>!$_"]) {
                            iphoneContact.PhoneNum= aPhone;
                            
                        }
                        
                        else if ([aLabel isEqualToString:@"_$!<WorkFAX>!$_"]) {
                            iphoneContact.PhoneNum = aPhone;
                        }
                        
                        else if ([aLabel isEqualToString:@"_$!<Work>!$_"]) {
                            iphoneContact.PhoneNum= aPhone;
                        }
                    }
                }
                
                //读取联系人姓名的第一个汉语拼音，用于排序，调用此方法需要在程序中加载pingyin.h pingyin.c,如有需要请给我联系。
                if ([iphoneContact.UserName length] == 0) {
                    continue;
                }
                iphoneContact.Content =[[NSString stringWithFormat:@"%c",pinyinFirstLetter([iphoneContact.UserName characterAtIndex:0])] uppercaseString];
                [arrTotal addObject:iphoneContact];
                
                //读取联系人公司信息
                
                // iphoneContact.contactCompany = (NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
                
                //读取联系人工作
                // iphoneContact.contactJob = (NSString *)ABRecordCopyValue(person, kABPersonJobTitleProperty);
            }
//            UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
//            
//            NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
//            for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
//                [unsortedSections addObject:[NSMutableArray array]];
//            }
//            for (UserInfo *info in arrFollow) {
//                NSInteger index = [collation sectionForObject:info.Content collationStringSelector:@selector(description)];
//                [[unsortedSections objectAtIndex:index] addObject:info];
//            }
//            
//            NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
//            for (NSMutableArray *section in unsortedSections) {
//                [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
//            }
//            arrScetion = sortedSections;
            arrFollow = arrTotal;
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppHelper hideHUD:self.view];
                [tbFollow reloadData];
            });
        });
        

    }
       
}
-(void)clearData{
    [arrScetion removeAllObjects];
    [arrFollow removeAllObjects];
    [tbFollow reloadData];
    lblFans.text=@"私信";
    lblFollow.text=@"消息";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Click Events
-(void)hideKeyWin
{

    tvSearch.showsCancelButton = NO;
    imgSearchBg.frame=CGRectMake(10, -5, kDeviceWidth-40, 42);
    [tvSearch resignFirstResponder];
	[AppHelper hideKeyWindow];
    arrFollow = arrTotal;
    [tbFollow reloadData];
    
}


-(void)clickBack{
    [AppHelper hideKeyWindow];
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)clickYQ{
    NSMutableArray *arrYQ = [[NSMutableArray alloc] initWithCapacity:0];
   // for (NSArray *arr in arrScetion) {
        for (UserInfo *item in arrFollow) {
            if (item.isSelectde) {
                [arrYQ addObject:item.PhoneNum];
            }
        }
   // }
    NSString *strsms = [NSString stringWithFormat:@"我在玩泡泡，超好玩的，赶紧一起来吧 \n%@",SHAREAPPURL];
    [self sendSMS:strsms withPhoneNum:arrYQ];

}
-(void)clickSegment{
    [self hideKeyWin];
    CGFloat duration=0.10;
    if (selectedIndex==0) {
        [UIView animateWithDuration:duration animations:^{
            btnSeg.frame=CGRectMake(149, 1, 148, 31);
        }];
        selectedIndex=1;
        tbFollow.hidden=YES;
        btnWx.hidden = NO;
       
    }
    else{
        [UIView animateWithDuration:duration animations:^{
            btnSeg.frame=CGRectMake(1, 1, 148, 31);
        }];
        selectedIndex=0;
        tbFollow.hidden=NO;
        btnWx.hidden = YES;
        if (arrFollow.count==0) {
        }
    }
}
#pragma mark -UISearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    imgSearchBg.frame=CGRectMake(10, -5, kDeviceWidth-90, 42);
    tvSearch.showsCancelButton = YES;
    searchBar.showsCancelButton = YES;
    return YES;
}                   // return NO to not become first responder



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *strField = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([strField length]== 0) {
        [AppHelper showAlertMessage:@"请输入用户昵称"];
    }else{
        
        //[tvSearch resignFirstResponder];
        NSString *predicateText = @"UserName CONTAINS[cd] %@";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateText, strField];
        
        NSArray *temp = [arrTotal filteredArrayUsingPredicate:predicate];
        NSLog(@"temp==%d",[temp count]);
        arrFollow = [NSMutableArray arrayWithArray:temp];
        [tbFollow reloadData];
    }
}                   // called when keyboard search button pressed

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self hideKeyWin];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    imgSearchBg.frame=CGRectMake(10, -5, kDeviceWidth-40, 42);
    tvSearch.showsCancelButton = NO;
     [tvSearch resignFirstResponder];
}//
#pragma mark - TableView
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (tableView == tbFollow ) {
//        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
//    } else {
//        return nil;
//    }
//}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//        if ([[arrScetion objectAtIndex:section] count] > 0) {
//            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
//        } else {
//            return nil;
//        }
//  
//    
//}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//    return arrScetion.count;
//   
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arrFollow count];// [[arrScetion objectAtIndex:section] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"mycell";
 
    TXLCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[TXLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withSel:self];
 
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    int row=indexPath.row;
    UserInfo* item=[arrFollow objectAtIndex:row];//[[arrScetion objectAtIndex:indexPath.section] objectAtIndex:row];
     cell.tag = FINDTAG +item.UserId;
    [cell loadData:item];
   
    return cell;
    
}
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    
    TXLCell *cell =(TXLCell *) [tbFollow viewWithTag:checkbox.tag];
    NSIndexPath * indexPath = [tbFollow indexPathForCell:cell];
    NSLog(@"%d----%d",indexPath.row,indexPath.section);
   // NSLog(@"%d-----%d",[arrScetion count],[[arrScetion objectAtIndex:indexPath.section]count ]);
   // NSMutableArray *arr =[[NSMutableArray alloc] initWithArray: [arrScetion objectAtIndex:indexPath.section]];
    UserInfo *item = [arrFollow objectAtIndex:indexPath.row];
    item.isSelectde = checked;
    [arrFollow replaceObjectAtIndex:indexPath.row withObject:item];
    //[arrScetion replaceObjectAtIndex:indexPath.section withObject:arr];
    
    if (checked) {
        count ++;
    }else{
        count --;
    }
    if (!count) {
        [btnYQ setTitle:[NSString stringWithFormat:@"邀请"] forState:UIControlStateNormal];
    }else
        [btnYQ setTitle:[NSString stringWithFormat:@"邀请（%d）",count] forState:UIControlStateNormal];
   // [[arrScetion objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:item];
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//	int row=indexPath.row;
//   
//         UserInfo* item=[arrFollow objectAtIndex:row];
//        [self sendSMS:@"我在玩泡泡，超好玩的，赶紧一起来吧" withPhoneNum:item.PhoneNum];
//
//}
-(void)goWx{
      NSString *strsms = [NSString stringWithFormat:@"我在玩泡泡，超好玩的，赶紧一起来吧 \n%@",SHAREAPPURL];
    [[AppDelegate App]sendAppContent:WXSceneSession withTitle:strsms withContent:@"http://"];
}
-(void)sendSMS:(NSString *)content withPhoneNum:(NSArray *)arr{
    NSLog(@"num====%@",arr);
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc]init];
    if([MFMessageComposeViewController canSendText])        {
        //controller.recipients = [NSArrayarrayWithObjects:self.friendLabel.text,nil];
         controller.recipients =arr;
        controller.body =content;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{}];
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"短信发送成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
            NSLog(@"Result: SMS sent");
        }
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"短信发送失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [search resignFirstResponder];
}
- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [tbFollow scrollRectToVisible:search.frame animated:animated];
}
@end
