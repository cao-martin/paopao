//
//  PrivatePhotoCell.h
//  charmgram
//
//  Created by Rain on 13-4-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "PrivateImage.h"

@protocol PrivateCellDelegate <NSObject>
	-(void)CellStateChanged:(NSDictionary*)dict;
	-(void)CellLongPressBegan:(NSDictionary*)dict;
	-(void)CellLongPressEnded:(NSDictionary*)dict;
	-(void)CellLongPressCancelled:(NSDictionary*)dict;
@end

@interface PrivatePhotoCell : UITableViewCell
{
    NSMutableArray *images;
	
}
@property(nonatomic,assign)id delegate; 
-(void)removeImages;
-(void)refreshData;
-(void)addImage:(PrivateImage*)info;
@end
