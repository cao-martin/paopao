//
//  ChatViewController.h
//  charmgram
//
//  Created by Rain on 13-6-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSMutableArray* arrExpression;
    NSMutableArray* arrChat;
    
    UITableView* tbChat;
    UITableView* tbExpression;
    UILabel* lblTitle;
    
	UITextView* tvComment;
	UIImageView* toolbar;
	UIView *commentMask;
	UIImageView* tvCommentBg;
    UILabel* lblDetector;
	int keyboardTop;
    int keyboardHeight;
	int maxMessageId;
    BOOL isShowChat;
}
@property(nonatomic,retain)NSString* strUserName;
@property(nonatomic,assign)int PeerId;
@end
