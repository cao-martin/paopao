//
//  GiftViewController.h
//  charmgram
//
//  Created by Rain on 13-6-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* arrItem;
    UITableView* tbContent;
    NSDictionary *dictA;
}
@property(nonatomic,assign)int row;
@property(nonatomic,assign)PrivateImage* curInfo;
@end
