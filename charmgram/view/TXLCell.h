//
//  TXLCell.h
//  charmgram
//
//  Created by martin on 13-9-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCheckBox.h"
@interface TXLCell : UITableViewCell
{
    UILabel* lblName;
    UIView *topLine;
    UIView *topLine2;
    QCheckBox *_check1;
}
-(void)loadData:(UserInfo*)user;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSel:(id)sel;
@end
