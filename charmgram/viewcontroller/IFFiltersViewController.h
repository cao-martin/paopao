//
//  IFFiltersViewController.h
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaFilters.h"
#import "UIImage+IF.h"
#import "CircularProgressView.h"

@interface IFFiltersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IFVideoCameraDelegate>
{
	UIButton *backButton;
	UIButton *transparentBackButton;
	UIImageView *backgroundImageView;
	UIImageView *cameraToolBarImageView;
	UIImageView *cameraCaptureBarImageView;
	UIButton *toggleFiltersButton;
	UIButton *photoAlbumButton;
	UIButton *shootButton;
	UIButton *cancelAlbumPhotoButton;
	UIButton *confirmAlbumPhotoButton;
	UITableView *filtersTableView;
	UIView *filterTableViewContainerView;
	UIImageView *blueDotImageView;
	UIImageView *cameraTrayImageView;
	IFVideoCamera *videoCamera;
	UIButton* btnSwitchDevice;
	UIButton* btnSwitchFlash;
    UIButton * recondPhotoButton ;
    NSArray *content;
    BOOL isShowPick;
    UIPickerView *pickData;
    UILabel *recondtext;
}
@property (nonatomic, assign) BOOL shouldLaunchAsAVideoRecorder;
@property (nonatomic, assign) BOOL shouldLaunchAshighQualityVideo;
@property (nonatomic, assign) BOOL isFiltersTableViewVisible; 
@property (nonatomic, assign) IFFilterType currentType;
@property (nonatomic, assign) BOOL isInVideoRecorderMode;
@property (nonatomic, assign) BOOL isHighQualityVideo;
@property (nonatomic, assign) id<UploadImageDelegate> uploadDelegate;
- (void)backButtonPressed:(id)sender;
- (void)toggleFiltersButtonPressed:(id)sender;
- (void)photoAlbumButtonPressed:(id)sender;
- (void)shootButtonPressed:(id)sender;
- (void)shootButtonTouched:(id)sender;
- (void)shootButtonCancelled:(id)sender;
- (void)cancelAlbumPhotoButtonPressed:(id)sender;
- (void)confirmAlbumPhotoButtonPressed:(id)sender;
@end
