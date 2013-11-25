//
//  PlazaViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-6-2.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "PlazaViewController.h"
#define MAX_LOCATED_COUNT		6

@interface PlazaViewController ()

@end

@implementation PlazaViewController
@synthesize PlazaType;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		//		self.tableView.backgroundColor=[UIColor clearColor];
		self.tableView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
//		[self.tableView setContentInset:UIEdgeInsetsMake(18, 0, 0, 0)];
		[self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
		
		refreshHeader = [[RefreshTableHeader alloc] initWithFrame:CGRectMake(0.0f, -242.0f, self.tableView.bounds.size.width, 120.0f)];
		refreshHeader.delegate = self;
        refreshHeader.tag=102+self.PlazaType;
		[self.tableView addSubview:refreshHeader];
		
		refreshFooter = [[RefreshTableFooter alloc] initWithFrame:CGRectMake(0.0f, -10.0f, self.tableView.bounds.size.width, 40.0f)];
		refreshFooter.delegate = self;
		[refreshFooter setHidden:YES];
        refreshFooter.tag=102+self.PlazaType;
		[self.tableView setTableFooterView:refreshFooter];
        needRefreshData=YES;
        
        UIView* headerUpload=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, HEADER_MINHEIGHT)];
        headerUpload.backgroundColor=[UIColor clearColor];
        [self.tableView setTableHeaderView:headerUpload];
		
		pageIndex=1;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style plazatype:(int)plazatype
{
	arrImage=[[NSMutableArray alloc] initWithCapacity:0];
	self.PlazaType=plazatype;
	switch (self.PlazaType) {
		case PLAZA_FAXIAN:
		{ 
		}
			break;
			
		case PLAZA_DONGTAI:
		{
			
		}
			break;
		case PLAZA_FUJIN:
		{ 
		}
			break;
	}

    return [self initWithStyle:style];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

#pragma mark - Load Data
-(void)refreshData{
    if (needRefreshData) {
        [refreshHeader ManualDragScrollViewToRefresh:self.tableView];
        needRefreshData=NO;
    }
    else{
        [self.tableView reloadData];
    
    }
}

-(void)clearData{
	[arrImage removeAllObjects];
	[self.tableView reloadData];
	needRefreshData=YES;
}

#pragma mark - Table view data source 

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (self.PlazaType) {
		case PLAZA_FAXIAN:
		case PLAZA_FUJIN:
			return 155.0 ;
		default:
			return 0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (self.PlazaType) {
		case PLAZA_FAXIAN:
		case PLAZA_FUJIN:
			return ceil(arrImage.count/2.0) ;			
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell0";
//    static NSString *CellIdentifier1 = @"Cell1";
//    static NSString *CellIdentifier2 = @"Cell2";
	switch (self.PlazaType) {
		case PLAZA_FAXIAN:
		{
			FaxianCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (!cell) {
				cell=[[FaxianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
				PrivateImage* item=[arrImage objectAtIndex:k];
				[cell addImage:item];
			}
			[cell loadData];
			return cell;
		} 
			break;
		case PLAZA_FUJIN:
		{
			FujinCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (!cell) {
				cell=[[FujinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
				PrivateImage* item=[arrImage objectAtIndex:k];
				[cell addImage:item];
			}
			[cell loadData];
			return cell;
		}
			break;
	}
	return nil;
}
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

#pragma mark - Load Data
-(void)loadFaxianWebData{
    if (loadingData) {
        if (loadingLobbyHeader) {
            loadingLobbyHeader = NO;
            [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        if (loadingLobbyFooter) {
            loadingLobbyFooter=NO;
            [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        return;
    }
    loadingData=YES;
    
    int pageCount=10;
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	NSDictionary* dict=@{
					  	@"method":METHOD_HOTPHOTO,
	   					@"userid":userid,
	   					@"token":[AppHelper getStringConfig:confUserToken],
	   					@"page":[NSString stringWithFormat:@"%d",pageIndex],
	   					@"pageCount":[NSString stringWithFormat:@"%d",pageCount]
	   };
    NSString *prams = @"aa=0";
    for (id keys in dict) {
		prams = [prams stringByAppendingFormat:@"&%@=%@",keys,[dict objectForKey:keys]] ;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",UrlBase,prams];
    ASIHTTPRequest* asirequest=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    //    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90; 
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			if (pageIndex<2) {
				[arrImage removeAllObjects];
			}
            
            for (NSDictionary *di in data) { 
                PrivateImage* item=[[PrivateImage alloc] initWithDict:di];
                [arrImage addObject:item];
            }
            [self.tableView reloadData];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
        [refreshFooter setHidden:!(arrImage.count>3)];
        if (loadingLobbyHeader) {
            loadingLobbyHeader = NO;
            [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        if (loadingLobbyFooter) {
            loadingLobbyFooter=NO;
            [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        loadingData=NO;
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
 
}

-(void)loadFujinWebData{
	if (![CLLocationManager locationServicesEnabled]) {
		[AppHelper showAlertMessage:@"您还没有开启定位服务，请到设置中开启。"];
		return;
	}
	CLLocation* loc=[[AppDelegate App] getCheckinLocation];
	if (!loc) {
		[AppHelper showHUD:@"正在定位..." baseview:self.view];
		locatedCount=0;
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getLocation) userInfo:nil repeats:NO];
		return;
	}
	[AppHelper hideHUD:self.view];
	NSString* lat=[NSString stringWithFormat:@"%f",loc.coordinate.latitude];
	NSString* lng=[NSString stringWithFormat:@"%f",loc.coordinate.longitude];
	NSLog(@"%@=====%@",lat,lng);
	if (loadingData) {
        if (loadingLobbyHeader) {
            loadingLobbyHeader = NO;
            [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        if (loadingLobbyFooter) {
            loadingLobbyFooter=NO;
            [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        return;
    }
    loadingData=YES;
	int userid=[AppHelper getIntConfig:confUserId];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
	[asirequest setPostValue:METHOD_NEARBYPHOTO forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",userid] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:lat forKey:@"latitude"];
	[asirequest setPostValue:lng forKey:@"longitude"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",10] forKey:@"pageCount"];
 
    asirequest.timeOutSeconds=30;
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            NSLog(@"respString===%@",respString);
            id data=[JSON objectForKey:@"data"];
            NSLog(@"data====%@",data);
			if (pageIndex<2) {
				[arrImage removeAllObjects];
			}
            
            for (NSDictionary *di in data) {
                PrivateImage* item=[[PrivateImage alloc] initWithDict:di];
                [arrImage addObject:item];
            }
            [self.tableView reloadData];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
        [refreshFooter setHidden:!(arrImage.count>3)];
        if (loadingLobbyHeader) {
            loadingLobbyHeader = NO;
            [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        if (loadingLobbyFooter) {
            loadingLobbyFooter=NO;
            [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        loadingData=NO;
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
		if (loadingLobbyHeader) {
            loadingLobbyHeader = NO;
            [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        if (loadingLobbyFooter) {
            loadingLobbyFooter=NO;
            [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        loadingData=NO;
    }];
    [asirequest startAsynchronous];
	/*
    if (loadingData) {
        return;
    }
    loadingData=YES;
	double delayInSeconds = 1.5;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		
		[refreshFooter setHidden:!(arrImage.count>3)];
		loadingLobbyHeader = NO;
        [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        loadingLobbyFooter=NO;
        [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        loadingData=NO;
	});
	 */
}

-(void)getLocation{
	CLLocation* loc=[[AppDelegate App] getCheckinLocation];
	
	if (!loc) {
		if (locatedCount>MAX_LOCATED_COUNT) {
			[AppHelper hideHUD:self.view];
			[AppHelper showAlertMessage:@"获取地理位置失败。"];
			return;
		}
		locatedCount++;
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getLocation) userInfo:nil repeats:NO];
	}
 	else{
		[self loadFujinWebData];
	}
}

- (void)reloadHeaderDataSource{
    if (loadingLobbyHeader) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        return;
    }
	loadingLobbyHeader = YES;
	pageIndex=1;
    if (self.PlazaType==PLAZA_FAXIAN) {
        [self loadFaxianWebData ];
    }
    else{
        [self loadFujinWebData];
    }
}

- (void)reloadFooterDataSource{
	loadingLobbyFooter = YES;
	pageIndex++;
    if (self.PlazaType==PLAZA_FAXIAN) {
        [self loadFaxianWebData ];
    }
    else{
        [self loadFujinWebData];
    }
}

#pragma mark - RefreshTableHeader Delegate
- (void)RefreshTableHeaderDidTriggerRefresh:(RefreshTableHeader*)view{
	
	[self reloadHeaderDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:30.0];
	
}

- (BOOL)RefreshTableHeaderDataSourceIsLoading:(RefreshTableHeader*)view{
	
	return loadingLobbyHeader; // should return if data source model is reloading
	
}

- (NSDate*)RefreshTableHeaderDataSourceLastUpdated:(RefreshTableHeader*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - RefreshTableFooterDelegate Methods
- (void)RefreshTableFooterDidTriggerRefresh:(RefreshTableFooter*)view{
	if (view == refreshFooter) {
        [self reloadFooterDataSource];
    }
}

- (BOOL)RefreshTableFooterDataSourceIsLoading:(RefreshTableFooter*)view{
    return loadingLobbyFooter;
}

- (NSDate*)RefreshTableFooterDataSourceLastUpdated:(RefreshTableFooter*)view{
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView==self.tableView) {
        [refreshHeader RefreshScrollViewDidScroll:self.tableView];
        [refreshFooter RefreshScrollViewDidScroll:self.tableView];
    }
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 	if (scrollView==self.tableView) {
        [refreshHeader RefreshScrollViewDidEndDragging:self.tableView];
        [refreshFooter RefreshScrollViewDidEndDragging:self.tableView];
	}
}
@end

