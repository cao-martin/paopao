//
//  BottomTabBar.h
//  woqifu
//
//  Created by Rain on 13-1-23.
//  Copyright (c) 2013年 woqifu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTabTagWall     100
#define kTabTagToday    101
#define kTabTagPray     102
#define kTabTagMine     103
#define kTabTagSetting  104


@interface BottomTabBar : UIView
{
    NSArray* arrNormal;
    NSArray* arrHighLighted;
    UIImageView* imgBg;
    int preSelectIndex; 
}
@property (nonatomic,assign)id delegate;
-(void)resetBar:(BOOL)hasLogined;
-(void)selectItemAtIndex:(NSInteger)index;
-(void)setBadgeIcon:(NSInteger)index isOn:(BOOL)isOn;
@end
