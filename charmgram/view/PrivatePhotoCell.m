//
//  PrivatePhotoCell.m
//  charmgram
//
//  Created by Rain on 13-4-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "PrivatePhotoCell.h"


@implementation PrivatePhotoCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		for (int k=0; k<4; k++) {
			UIImageView* imgBase=[[UIImageView alloc] initWithFrame:CGRectMake(78*k+8, 2, 70, 70)];
			imgBase.contentMode=UIViewContentModeScaleAspectFill;
			imgBase.clipsToBounds=YES;
			imgBase.tag=TAGOFFSET_BASE+k;
			imgBase.userInteractionEnabled=YES;
			[self.contentView addSubview:imgBase];
			
			UIButton* btnMask=[UIButton buttonWithType:UIButtonTypeCustom];
			btnMask.frame=CGRectMake(0, 0, 70, 70);
			btnMask.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
			btnMask.tag=TAGOFFSET_MASK+k;
//			UIView* mask=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
//			mask.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
//			mask.tag=TAGOFFSET_MASK+k;
			[btnMask addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
//			UITapGestureRecognizer*tapImg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
//			tapImg.numberOfTapsRequired=1;
//			tapImg.numberOfTouchesRequired=1;
//			[btnMask addGestureRecognizer:tapImg];
			
			UILongPressGestureRecognizer *longGR=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
			longGR.numberOfTouchesRequired=1;
			longGR.minimumPressDuration=0.2;
			[btnMask addGestureRecognizer:longGR];
			
			[imgBase addSubview:btnMask]; 			
			
			UILabel* lblsec=[[UILabel alloc] initWithFrame:CGRectMake(45,5,20,20)];
			lblsec.text=@"10";
			lblsec.font=[UIFont boldSystemFontOfSize:12.0];
			lblsec.textColor=[UIColor whiteColor];
			lblsec.backgroundColor=[UIColor clearColor];
			lblsec.tag=TAGOFFSET_SECOND+k;
			lblsec.shadowColor=SHADOW_COLOR;
			lblsec.shadowOffset=CGSizeMake(1.0, 1.0);
			lblsec.textAlignment=UITextAlignmentCenter;
			lblsec.hidden=YES;
			[imgBase addSubview:lblsec];
			
			UIImageView* imgLock=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locked"]];
			imgLock.contentMode=UIViewContentModeScaleAspectFill;
			imgLock.frame=CGRectMake(45,5,20,20);
			imgLock.tag=TAGOFFSET_LOCK+k;
			[imgBase addSubview:imgLock];
			
			UIImageView* imgTick=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_flag"]];
			imgTick.contentMode=UIViewContentModeScaleAspectFill;
			imgTick.frame=CGRectMake(40,5,27,27);
			imgTick.tag=TAGOFFSET_TICK+k;
			imgTick.hidden=YES;
			[imgBase addSubview:imgTick];
			
			UIActivityIndicatorView* indi=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
			indi.frame=CGRectMake(45,5,20,20);
			[indi stopAnimating];
			indi.hidden=YES;
			indi.tag=TAGOFFSET_INDI+k;
			[imgBase addSubview:indi];
			
			UIImageView* imgLike=[[UIImageView alloc] initWithFrame:CGRectMake(3, 78, 14, 14)];
			imgLike.image=[UIImage imageNamed:@"list_item_like"];
			imgLike.tag=TAGOFFSET_IMGLIKE+k;
			[imgBase addSubview:imgLike];
			
			UILabel* lblLike=[[UILabel alloc] initWithFrame:CGRectMake(18, 78, 40, 13)];
			lblLike.text=@"100";
			lblLike.font=[UIFont boldSystemFontOfSize:10.0];
			lblLike.textColor=[UIColor whiteColor];
			lblLike.backgroundColor=[UIColor clearColor];
			lblLike.tag=TAGOFFSET_LBLLIKE+k;
			[imgBase addSubview:lblLike];
		}
		
		images=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void) removeImages{
	[images removeAllObjects];
}

-(void)addImage:(PrivateImage*)info{
	[images addObject:info];
}

-(void)refreshData{
	for (int k=0; k<4; k++) {
		UIImageView* img=(UIImageView*)[self.contentView viewWithTag:TAGOFFSET_BASE+k];
		UIImageView* imgLike=(UIImageView*)[img viewWithTag:TAGOFFSET_IMGLIKE+k];
		UILabel* lblLike=(UILabel*)[img viewWithTag:TAGOFFSET_LBLLIKE+k];
        UIView* mask=[img viewWithTag:TAGOFFSET_MASK+k];
		UILabel* lblsec=(UILabel*)[self.contentView viewWithTag:TAGOFFSET_SECOND+k];
		
		UIImageView* imgLock=(UIImageView*)[self.contentView viewWithTag:TAGOFFSET_LOCK+k];
		UIImageView* imgTick=(UIImageView*)[self.contentView viewWithTag:TAGOFFSET_TICK+k];
		UIActivityIndicatorView* indi=(UIActivityIndicatorView*)[self.contentView viewWithTag:TAGOFFSET_INDI+k];
 
		if (k>images.count-1) {
			[img setHidden:YES];
			continue;
		}
        PrivateImage* item=[images objectAtIndex:k];
		switch (item.State) {
			case PrivateImageStateNormal:
			{
				imgLock.hidden=NO;
				imgTick.hidden=YES;
				indi.hidden=YES;
				lblsec.hidden=YES;
			}
				break;
			case PrivateImageStateSelected:
			{
				imgLock.hidden=YES;
				imgTick.hidden=NO;
				indi.hidden=YES;
				lblsec.hidden=YES;
			}
				break;
			case PrivateImageStateDownloading:
			{
				imgLock.hidden=YES;
				imgTick.hidden=YES;
				indi.hidden=NO;
				[indi startAnimating]; 
				lblsec.hidden=YES;
				[self performSelector:@selector(downLoadImage:) withObject:[NSString stringWithFormat:@"%d", k] afterDelay:2.0];
			}
				break;
			case PrivateImageStateDownloaded:
			{
				imgLock.hidden=YES;
				imgTick.hidden=YES;
				indi.hidden=YES;
				lblsec.hidden=NO;
			}
				break;
            default:
                break;
		} 
 		
		
		lblsec.text=[NSString stringWithFormat:@"%d",arc4random() % 8+3];
        if (k>=images.count) {
            [img setHidden:YES];
            [imgLike setHidden:YES];
            [lblLike setHidden:YES];
            [mask setHidden:YES];
            continue;
        }
        else{
            [img setHidden:NO];
            [imgLike setHidden:NO];
            [lblLike setHidden:NO];
            [mask setHidden:NO];
        }
		if (item.ThumbUrl.length==0) {
			continue;
		}
//		UIImageView* imgComment=(UIImageView*)[img viewWithTag:400+k];
//		UILabel* lblComment=(UILabel*)[img viewWithTag:450+k];
		if ([item.ThumbUrl hasPrefix:@"http"]) {
			
		}
		else{
			[img setImage:[UIImage imageNamed:item.ThumbUrl]];
		}
//		if (item.LikeCount>0) {
//			[imgLike setHidden:NO];
//			[lblLike setHidden:NO];
//			lblLike.text=[NSString stringWithFormat:@"%d",item.LikeCount];
//		}
//		else{
//			[imgLike setHidden:YES];
//			[lblLike setHidden:YES];
//		} 
	}
}

-(void)clickImage:(UIView*)sender{
//	DLog(@"clickImage");
	int itag=sender.tag;
	int k=itag-TAGOFFSET_MASK;
	UIImageView* imgLock=(UIImageView*)[self.contentView viewWithTag:TAGOFFSET_LOCK+k];
	UIImageView* imgTick=(UIImageView*)[self.contentView viewWithTag:TAGOFFSET_TICK+k];
//	UIActivityIndicatorView* indi=(UIActivityIndicatorView*)[self.contentView viewWithTag:TAGOFFSET_INDI+k];
//	UILabel* lblsec=(UILabel*)[self.contentView viewWithTag:TAGOFFSET_SECOND+k];
	if (!imgLock.hidden) {
		imgLock.hidden=YES;
		imgTick.hidden=NO;
		if (self.delegate && [self.delegate conformsToProtocol:@protocol(PrivateCellDelegate) ]) {
			NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:
								[NSString stringWithFormat:@"%d",(self.contentView.tag-TAGOFFSET_PRIVATECELL)*4+k],@"index",
								@"1",@"state",
								nil];
			[self.delegate CellStateChanged:dict];
		}
		return;
	}
	
	if(!imgTick.hidden)
	{
		imgLock.hidden=NO;
		imgTick.hidden=YES;
		if (self.delegate && [self.delegate conformsToProtocol:@protocol(PrivateCellDelegate) ]) {
			NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:
								[NSString stringWithFormat:@"%d",(self.contentView.tag-TAGOFFSET_PRIVATECELL)*4+k],@"index",
								@"0",@"state",
								nil];
			[self.delegate CellStateChanged:dict];
		}
		return;
	}
	
//	if (!imgLock || imgLock.hidden || !lblsec.hidden) {
//		return;
//	}
//	imgLock.hidden=YES;
//	indi.hidden=NO;
//	[indi startAnimating]; 
// 	[self performSelector:@selector(downLoadImage:) withObject:[NSString stringWithFormat:@"%d", k] afterDelay:2.0];
}

-(void)downLoadImage:(NSString*)strIndex{
	int k=[strIndex integerValue];
	UIActivityIndicatorView* indi=(UIActivityIndicatorView*)[self.contentView viewWithTag:TAGOFFSET_INDI+k];
	UILabel* lblsec=(UILabel*)[self.contentView viewWithTag:TAGOFFSET_SECOND+k];
	[indi stopAnimating];
	indi.hidden=YES;
	if ([lblsec.text isEqualToString:@"0"]) {
		lblsec.text=[NSString stringWithFormat:@"%d",arc4random() % 8+3];
	}
	lblsec.hidden=NO;
	NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:
						[NSString stringWithFormat:@"%d",(self.contentView.tag-TAGOFFSET_PRIVATECELL)*4+k],@"index",
						@"3",@"state",
						nil];
	[self.delegate CellStateChanged:dict];
}

-(void)longPressCell:(UILongPressGestureRecognizer*)gesture{
//	DLog(@"longPressCell");
	int itag=gesture.view.tag;
	int k=itag-TAGOFFSET_MASK;
	UILabel* lblsec=(UILabel*)[self.contentView viewWithTag:TAGOFFSET_SECOND+k];
	UIImageView* imgLock=(UIImageView*)[self.contentView viewWithTag:TAGOFFSET_LOCK+k];
	if (!imgLock.hidden) {
		return;
	}
	int second=[lblsec.text integerValue];
	if (second<=0) {
		lblsec.text=@"0";
		imgLock.hidden=NO;
		return;
	}
	if (self.delegate && [self.delegate conformsToProtocol:@protocol(PrivateCellDelegate) ]) {

		NSString* imgpath= [[NSBundle mainBundle] pathForResource:@"preview01" ofType:@"jpg"];
		NSDictionary * dict=[NSDictionary dictionaryWithObjectsAndKeys:
							 imgpath,@"url",
							 lblsec.text,@"second",
							 [NSString stringWithFormat:@"%d",self.contentView.tag],@"tag",
							 [NSString stringWithFormat:@"%d",k],@"col",
							 nil];
		switch (gesture.state) {
			case UIGestureRecognizerStateBegan:
				[self.delegate CellLongPressBegan:dict];
				break;
			case UIGestureRecognizerStateEnded: 
				[self.delegate CellLongPressEnded:dict];
				break;
			case UIGestureRecognizerStateCancelled:
				[self.delegate CellLongPressCancelled:dict];
				break;
			default:
				break;
		}
	}

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

