//
//  ChatViewController.m
//  charmgram
//
//  Created by Rain on 13-6-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatInfo.h"

#import "UIImageView+WebCache.h"
#define ANIMATED_DURATION 0.15

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize strUserName,PeerId;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor colorWithRed:234/255.0 green:230/255.0 blue:231/255.0 alpha:1.0];
    
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(65, 10, kDeviceWidth-130, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.shadowOffset=CGSizeMake(0, 1.0);
    lblTitle.shadowColor=SHADOW_COLOR;
//    lblTitle.text=@"选择礼物";
    lblTitle.font=[UIFont boldSystemFontOfSize:18.0];
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
    
    UIButton *btnDone=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_off"] forState:UIControlStateNormal];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_on"] forState:UIControlStateHighlighted];
    [btnDone setTitle:@"拉黑" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    btnDone.frame=CGRectMake(kDeviceWidth-64, 0, 52,44);
    [btnDone addTarget:self action:@selector(clickBlackList) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnDone];
    
    tbExpression=[[UITableView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-20, kDeviceWidth, kDeviceHeight-236)
                                           style:UITableViewStylePlain];
	tbExpression.dataSource=self;
	tbExpression.delegate=self;
	tbExpression.backgroundColor=[UIColor colorWithRed:234/255.0 green:230/255.0 blue:231/255.0 alpha:1.0];
    tbExpression.separatorStyle=UITableViewCellSeparatorStyleNone;
    [tbExpression setContentInset:UIEdgeInsetsMake(2, 0, 6, 0)];
    
    tbChat=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-108)
                                           style:UITableViewStylePlain];
	tbChat.dataSource=self;
	tbChat.delegate=self;
	tbChat.backgroundColor=[UIColor colorWithRed:234/255.0 green:230/255.0 blue:231/255.0 alpha:1.0];
    tbChat.separatorStyle=UITableViewCellSeparatorStyleNone;
    [tbChat setContentInset:UIEdgeInsetsMake(2, 0, 6, 0)];
    
    lblDetector=[[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth+20, 0, CHAT_ITEM_MAXWIDTH , 20)];
    lblDetector.hidden=YES;
    lblDetector.font=CHAT_ITEM_FONT; 
    lblDetector.numberOfLines=0;
    lblDetector.lineBreakMode=NSLineBreakByWordWrapping;
    [self.view addSubview:lblDetector];
    
    [self.view addSubview:tbChat];
    [self.view addSubview:tbExpression];
    [self.view addSubview:topbar];
    
    [self initToolbar];
    [self initObservers];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"chat" ofType:@"plist"];
    arrExpression=[[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    arrChat=[[NSMutableArray alloc] initWithCapacity:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    lblTitle.text=self.strUserName;
	[self loadDataFromWeb];
}

-(void)initToolbar{
    toolbar=[[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-64, kDeviceWidth, 44)];
    toolbar.backgroundColor=[UIColor clearColor];
    toolbar.image=[[UIImage imageNamed:@"feeddetail_toolbar_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:25];
    toolbar.userInteractionEnabled=YES;
    
    tvCommentBg=[[UIImageView alloc] initWithFrame:CGRectMake(48, 5, 252, 35)];
    tvCommentBg.image=[[UIImage imageNamed:@"feeddetail_toolbar_text_bg"] stretchableImageWithLeftCapWidth:17 topCapHeight:15];
    
    tvComment=[[UITextView alloc] initWithFrame:CGRectMake(58, 6, 232, 31)];
    tvComment.backgroundColor=[UIColor clearColor];
    tvComment.font=CHAT_ITEM_FONT;
    tvComment.returnKeyType=UIReturnKeySend;
	tvComment.delegate=self;
	tvComment.editable=YES;
    tvComment.scrollEnabled=YES; 
       
    UIButton* btnChat=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnChat setImage:[UIImage imageNamed:@"chat_quick_msg_n"] forState:UIControlStateNormal];
    [btnChat setImage:[UIImage imageNamed:@"chat_quick_msg_c"] forState:UIControlStateHighlighted];
    btnChat.frame=CGRectMake(7, 6, 34, 34);
    [btnChat addTarget:self action:@selector(clickChat) forControlEvents:UIControlEventTouchUpInside];
	
	commentMask=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    commentMask.backgroundColor=[UIColor clearColor];
    commentMask.hidden=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentMask:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [commentMask addGestureRecognizer:tap];
	
    [self.view addSubview:commentMask];
	[toolbar addSubview:tvCommentBg];
	[toolbar addSubview:tvComment];
	[toolbar addSubview:btnChat];
	[self.view addSubview:toolbar];
}

-(void)initObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Load Data
-(void)loadDataFromWeb{
  
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:METHOD_MESSAGELIST forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",self.PeerId] forKey:@"senderid"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",maxMessageId] forKey:@"messageid"];
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
			
            [arrChat removeAllObjects];
            
            for (NSDictionary *di in data) {
                ChatInfo* item=[[ChatInfo alloc] initWithDict:di];
                [arrChat addObject:item]; 
            }
            [tbChat reloadData];
            [[AppDelegate App] getMessage];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
 
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
	
}

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification {
    if ([tvComment isFirstResponder]) {
        NSDictionary *info = [notification userInfo];
        CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardTop = kbFrame.origin.y;
        keyboardHeight=kbFrame.size.height;
        int barHeight=toolbar.frame.size.height;
		int newH= keyboardTop - barHeight - StatusBarHeight ;
		DLog(@"%d; keyboardHeight: %d",newH, keyboardHeight);
        [UIView animateWithDuration:0.25 animations:^{
            toolbar.frame = CGRectMake(0, newH, kDeviceWidth, barHeight);
        }];
        commentMask.hidden=NO;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if ([tvComment isFirstResponder]) {
        NSDictionary *info = [notification userInfo];
        CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardTop = kbFrame.origin.y;
        int barHeight=44;
        [UIView animateWithDuration:0.25 animations:^{
            toolbar.frame = CGRectMake(0, kDeviceHeight - barHeight -StatusBarHeight , kDeviceWidth, 44);
            tvComment.frame=CGRectMake(58, 6, 232, 31);
            tvCommentBg.frame=CGRectMake(48, 5, 252, 35);
        }];
        commentMask.hidden=YES;
    }
    
    CGRect tbframe=tbExpression.frame;
    tbframe.size.height=KEYBOARD_HEIGHT;
    tbframe.origin.y=kDeviceHeight-20;
    tbExpression.frame=tbframe;
}

-(void)tapCommentMask:(UITapGestureRecognizer*)gesture{
    [AppHelper hideKeyWindow];
}
 

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==tbExpression) {
        return 41.0;
    }
    int row=indexPath.row;
    ChatInfo* info=arrChat[row];
    CGSize size=[self detectSize:info.Text];
    int newheight=size.height+22;
    return (newheight<64?64:newheight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tbExpression) {
        return arrExpression.count;
    }
    return arrChat.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row; 
    static NSString *CellIdentifier0 = @"Cell0";
    static NSString *CellIdentifier1 = @"Cell1";
    UITableViewCell *cell=nil;
    if (tableView==tbExpression) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0];
            UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 39)];
            lbl.backgroundColor=[UIColor clearColor];
            lbl.numberOfLines=0;
            lbl.tag=100;
            lbl.font=CHAT_ITEM_FONT;
            [cell.contentView addSubview:lbl];
            
            UIImageView* imgLine=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_quick_seperator"]];
            imgLine.frame=CGRectMake(0, 40, kDeviceWidth, 1.5);
            [cell.contentView addSubview:imgLine];
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        UILabel* lbl=(UILabel*)[cell.contentView viewWithTag:100]; 
        lbl.text=arrExpression[row];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            UIButton* imgBg=[UIButton buttonWithType:UIButtonTypeCustom];
            [imgBg setBackgroundImage:[[UIImage imageNamed:@"chat_send_bg"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:30] forState:UIControlStateNormal] ;
            [imgBg setBackgroundImage:[[UIImage imageNamed:@"chat_send_bg_h"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:30] forState:UIControlStateHighlighted] ;
//            UIImageView* imgBg=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"chat_send_bg"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:30 ]
//                                                 highlightedImage:[[UIImage imageNamed:@"chat_send_bg_h"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:30]];
            imgBg.frame=CGRectMake(0, 4, 140, 64);
            imgBg.tag=99; 
            [cell.contentView addSubview:imgBg];
            
            UILabel* tv=[[UILabel alloc] initWithFrame:CGRectMake(16, 6, 110, 42)];
            tv.backgroundColor=[UIColor clearColor];
            tv.tag=100;
			tv.numberOfLines=0;
            tv.font=CHAT_ITEM_FONT;
            [imgBg addSubview:tv];
            
            UIImageView* imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 32, 32)];
            imgAvatar.tag=101;
			imgAvatar.layer.cornerRadius=3.0;
			imgAvatar.layer.masksToBounds=YES;
            [cell.contentView addSubview:imgAvatar];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        ChatInfo* info=(ChatInfo*)arrChat[row];
        UILabel* tv=(UILabel*)[cell.contentView viewWithTag:100];
        tv.text=info.Text;
        UIImageView* imgAvatar=(UIImageView*)[cell.contentView viewWithTag:101];
		if ([info.AvatarUrl hasPrefix:@"http"]) {
			 [imgAvatar setImageWithURL:[NSURL URLWithString:info.AvatarUrl]] ;
		}
		else{
			imgAvatar.image=[UIImage imageNamed:info.AvatarUrl];
		} 
        UIButton* imgBg=(UIButton*)[cell.contentView viewWithTag:99];
		CGRect avframe=imgAvatar.frame;
		CGRect tvframe=tv.frame;
		CGRect bgframe=imgBg.frame;
        CGSize newsize=[self detectSize:info.Text];
        
        if (info.IsMyTalk) {
            [imgBg setBackgroundImage:[[UIImage imageNamed:@"chat_send_bg"] stretchableImageWithLeftCapWidth:14.0 topCapHeight:30 ] forState:UIControlStateNormal] ;
            [imgBg setBackgroundImage:[[UIImage imageNamed:@"chat_send_bg_h"] stretchableImageWithLeftCapWidth:14.0 topCapHeight:30 ] forState:UIControlStateHighlighted] ;
//            imgBg.image=[[UIImage imageNamed:@"chat_send_bg"] stretchableImageWithLeftCapWidth:14.0 topCapHeight:30 ];
//            imgBg.highlightedImage=[[UIImage imageNamed:@"chat_send_bg_h"] stretchableImageWithLeftCapWidth:14.0 topCapHeight:30 ];
			avframe.origin.x=kDeviceWidth-42;
			imgAvatar.frame=avframe;
            bgframe.size.width=newsize.width+36;
			bgframe.origin.x=kDeviceWidth-(newsize.width+84);
            bgframe.size.height=(newsize.height+22>64?newsize.height+22:64);
			imgBg.frame=bgframe;
			tvframe.origin.x=15;
            tvframe.size.width=newsize.width;
            tvframe.size.height=(newsize.height>42?newsize.height:42);
			tv.frame=tvframe;
        }
        else{
            
            [imgBg setBackgroundImage:[[UIImage imageNamed:@"chat_receive_bg"] stretchableImageWithLeftCapWidth:22 topCapHeight:30 ] forState:UIControlStateNormal] ;
            [imgBg setBackgroundImage:[[UIImage imageNamed:@"chat_receive_bg_h"] stretchableImageWithLeftCapWidth:22 topCapHeight:30 ] forState:UIControlStateHighlighted] ;
//            imgBg.image=[[UIImage imageNamed:@"chat_receive_bg"] stretchableImageWithLeftCapWidth:22.0 topCapHeight:30 ];
//            imgBg.highlightedImage=[[UIImage imageNamed:@"chat_receive_bg_h"] stretchableImageWithLeftCapWidth:22.0 topCapHeight:30 ];
			avframe.origin.x=10;
			imgAvatar.frame=avframe;
			bgframe.origin.x=48;
            bgframe.size.width=newsize.width+36;
            bgframe.size.height=(newsize.height+22>64?newsize.height+22:64);
			imgBg.frame=bgframe;
			tvframe.origin.x=21;
            tvframe.size.width=newsize.width;
            tvframe.size.height=(newsize.height>42?newsize.height:42);
			tv.frame=tvframe;
        }
    }

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row=indexPath.row;
	if (tableView==tbExpression) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self clickSend:arrExpression[row]];
		[self clickChat];
	}
}

#pragma mark - Click Event
-(void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickBlackList{
    [AppHelper showAlertMessage:@"拉黑后，你将不再收到对方的消息，\n确定要拉黑吗？" title:nil lbtnTitle:@"取消" lbtnBlock:nil rbtnTitle:@"确定" rbtnBlock:^{
            
    }];
}

-(void)clickChat{
    CGRect toolframe=toolbar.frame;
    CGRect tbframe=tbExpression.frame;
    if (tbframe.origin.y>=kDeviceHeight-20) {
        tbframe.size.height=KEYBOARD_HEIGHT;
        tbframe.origin.y=kDeviceHeight-KEYBOARD_HEIGHT-20;
        toolframe.origin.y=kDeviceHeight-KEYBOARD_HEIGHT-toolframe.size.height-20;

    }
    else if(![tvComment isFirstResponder]){
        tbframe.size.height=KEYBOARD_HEIGHT;
        tbframe.origin.y=kDeviceHeight-20;
        toolframe.origin.y=kDeviceHeight-toolframe.size.height-20;
    }
    else{
        return;
    }
    [UIView animateWithDuration:ANIMATED_DURATION animations:^{
        tbExpression.frame=tbframe;
        toolbar.frame=toolframe;
    }];
}

-(void)clickSend:(NSString*)txt{
	
	
    ChatInfo* info=[[ChatInfo alloc] init];
    info.IsMyTalk=YES;
    info.Text=txt;
    info.PeerId=self.PeerId;
    info.AvatarUrl=[AppHelper getStringConfig:confUserHeadUrl];
    [arrChat addObject:info];
	[info sendMessage];
	
	/*
	ChatInfo* info2=[[ChatInfo alloc] init]; 
    info2.Text=@"你好，嘻嘻！我有事不在，请给我留言吧。";
    info2.PeerId=self.iUserID;
	info2.NickName=self.strUserName;
    info2.AvatarUrl=@"avatar5.jpg";
    [arrChat addObject:info2]; 
    */
	
    [tbChat reloadData];
	tvComment.text=@"";
	[tvComment resignFirstResponder];
//    tvComment.frame=CGRectMake(58, 6, 232, 31);
//	[tbChat setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
	[self performSelector:@selector(chatScroll2Bottom) withObject:nil afterDelay:0.22];
}

-(CGSize)detectSize:(NSString*)txt{
    lblDetector.frame=CGRectMake(kDeviceWidth+20, 0, CHAT_ITEM_MAXWIDTH, 20);
    lblDetector.text=txt;
    [lblDetector sizeToFit];
//    DLog(@"lblDetector frame is: %@", NSStringFromCGRect(lblDetector.frame));
    return lblDetector.frame.size;
}

-(void)chatScroll2Bottom{ 
	CGRect chatframe=tbChat.frame;
	if (tbChat.contentSize.height>chatframe.size.height) {
		 CGPoint offset = CGPointMake(0, tbChat.contentSize.height - tbChat.frame.size.height+6.0);
		 [tbChat setContentOffset:offset animated:YES];
	} 
}

#pragma mark - UITextView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self clickSend:textView.text];
		[AppHelper hideKeyWindow];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
	//    CGFloat fontHeight = (textView.font.ascender - textView.font.descender) + 1;
    CGFloat contentHeight=textView.contentSize.height;
    int newHeight=contentHeight;
    if (contentHeight >= MaxTextViewHeight)
    {
        /* Enable vertical scrolling */
        if(!textView.scrollEnabled)
        {
            textView.scrollEnabled = YES;
            [textView flashScrollIndicators];
        }
		[textView scrollRectToVisible:CGRectMake(0, textView.contentSize.height-MaxTextViewHeight, 232, MaxTextViewHeight) animated:YES];
        newHeight=MaxTextViewHeight;
    }
    else
    {
        textView.scrollEnabled = NO;
    }
    int barHeight=newHeight + 11;
    DLog(@"keyboardTop - %d ; barHeight- %d ",keyboardTop,barHeight);
    CGRect txtframe=textView.frame;
    txtframe.size.height=newHeight;
    CGRect txtBgFrame=tvCommentBg.frame;
    txtBgFrame.size.height=newHeight;
    
    [UIView animateWithDuration:ANIMATED_DURATION animations:^{
        toolbar.frame = CGRectMake(0, keyboardTop - barHeight - StatusBarHeight , kDeviceWidth, barHeight);
        textView.frame = txtframe;
        tvCommentBg.frame=txtBgFrame;
    } ];
}
@end
