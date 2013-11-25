//
//  BubbleCell.m
//  charmgram
//
//  Created by Rui Wei on 13-5-19.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "BubbleCell.h"

@implementation BubbleCell
@synthesize delegate,curInfo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgBg=[[UIImageView alloc] initWithFrame:CGRectMake(20, 3, 225, 44)];
		imgBg.image=[UIImage imageNamed:@"listbg_blue"];
		imgBg.userInteractionEnabled=YES;
        imgBg.tag=TAGOFFSET_BASE;
		[self.contentView addSubview:imgBg];
        
        UILongPressGestureRecognizer *longGR=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
        longGR.numberOfTouchesRequired=1;
        longGR.minimumPressDuration=0.2;
        [imgBg addGestureRecognizer:longGR];
		
		imgBubble=[[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 30, 31)];
		imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"];
		imgBubble.userInteractionEnabled=YES;
		[self.contentView addSubview:imgBubble];
		
		indi=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(195, 3, 44, 44)];
		indi.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
		[indi stopAnimating];
		indi.hidden=YES;
		[self.contentView addSubview:indi];
		
		lblTimer=[[UILabel alloc] initWithFrame:CGRectMake(195, 3, 44, 44)];
		lblTimer.backgroundColor=[UIColor clearColor];
		lblTimer.font=[UIFont boldSystemFontOfSize:15.0];
		lblTimer.textColor=[UIColor whiteColor];
		lblTimer.textAlignment=UITextAlignmentCenter;
		lblTimer.hidden=YES;
        lblTimer.tag=TAGOFFSET_SECOND;
		[self.contentView addSubview:lblTimer];
    }
    return self;
}

-(void)refreshData{ 
    switch (self.curInfo.State) {
        case PrivateImageStateDownloading:
        {
            imgBg.image=[UIImage imageNamed:@"listbg_blue"];
            imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"]; 
            [self downloadImage];
        }
            break;
            
        case PrivateImageStateDownloaded:
        {
            imgBg.image=[UIImage imageNamed:@"listbg_blue"];
            imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"];
            lblTimer.hidden=NO;
            lblTimer.text=[NSString stringWithFormat:@"%d秒",self.curInfo.Second];
            indi.hidden=YES;
            [indi stopAnimating];
        }
            break;
        case PrivateImageStateViewed:
        {
            imgBg.image=[UIImage imageNamed:@"listbg_gray"];
            imgBubble.image=[UIImage imageNamed:@"status_opened_ico_gray"];
            lblTimer.hidden=NO;
            lblTimer.text=@"已阅";
            indi.hidden=YES;
            [indi stopAnimating];
        }
            break;
        default:
            break;
    }
    
//	imgBg.image=[UIImage imageNamed:(info.State!=PrivateImageStateViewed?@"listbg_blue": @"listbg_gray")];
//	imgBubble.image=[UIImage imageNamed:(info.State!=PrivateImageStateViewed?@"status_paopao_ico": @"status_opened_ico_gray")];
//	if (info.State!=PrivateImageStateViewed) {
////		lblTimer.hidden=NO;
//		lblTimer.text=[NSString stringWithFormat:@"%d秒",info.Second];
//	}
//	else{
//		lblTimer.hidden=YES;
//	}
    
}

-(void)downloadImage 
{
    indi.hidden=NO;
    [indi startAnimating];
    lblTimer.hidden=YES;
    
    self.curInfo.State=PrivateImageStateDownloading;
//    [self performSelector:@selector(downloadDone) withObject:nil afterDelay:2.0]; 
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_current_queue(), ^(void){
        indi.hidden=YES;
        [indi stopAnimating];
        lblTimer.hidden=NO;
        self.curInfo.State=PrivateImageStateDownloaded;
        self.curInfo.Second=arc4random()%8+2;
        lblTimer.text=[NSString stringWithFormat:@"%d秒",self.curInfo.Second];
    });
}
 

#pragma mark - Action Events
-(void)longPressCell:(UILongPressGestureRecognizer*)gesture{
    //	DLog(@"longPressCell");
	int itag=gesture.view.tag;
	int k=itag-TAGOFFSET_MASK;
//	UILabel* lblsec=(UILabel*)[self.contentView viewWithTag:TAGOFFSET_SECOND];
//	UIImageView* imgLock=(UIImageView*)[self.contentView viewWithTag:TAGOFFSET_LOCK+k];
    if (self.curInfo.State!=PrivateImageStateDownloaded) {
        return;
    }
	int second=[lblTimer.text integerValue];
	if (second<=0) {
		lblTimer.text=@"0";
		lblTimer.hidden=YES;
		return;
	}
	if (self.delegate && [self.delegate conformsToProtocol:@protocol(BubbleCellDelegate) ]) {
        
		NSString* imgpath= [[NSBundle mainBundle] pathForResource:@"preview01" ofType:@"jpg"];
		NSDictionary * dict=[NSDictionary dictionaryWithObjectsAndKeys:
							 imgpath,@"url",
							 lblTimer.text,@"second",
							 [NSString stringWithFormat:@"%d",self.tag],@"tag",
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
