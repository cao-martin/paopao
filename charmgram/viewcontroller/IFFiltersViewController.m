//
//  IFFiltersViewController.m
//  InstaFilters
// 
//

#import "IFFiltersViewController.h"
 

#define kFilterImageViewTag 9999
#define kFilterImageViewContainerViewTag 9998
#define kBlueDotImageViewOffset 25.0f
#define kFilterCellHeight 72.0f 
#define kBlueDotAnimationTime 0.2f
#define kFilterTableViewAnimationTime 0.2f
#define kGPUImageViewAnimationOffset 27.0f


@interface IFFiltersViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation IFFiltersViewController
  
@synthesize isFiltersTableViewVisible,currentType,shouldLaunchAsAVideoRecorder,isInVideoRecorderMode,
        shouldLaunchAshighQualityVideo,isHighQualityVideo,uploadDelegate;
 

#pragma mark - Video Camera Delegate
- (void)IFVideoCameraWillStartCaptureStillImage:(IFVideoCamera *)videoCamera {
    
    shootButton.hidden = YES;
    
    if (self.isInVideoRecorderMode == NO) {
        photoAlbumButton.hidden = YES;
    }
    
    [cancelAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraRejectDisabled"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraRejectDisabled" ofType:@"png"]] forState:UIControlStateNormal];
    [confirmAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraAcceptDisabled"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAcceptDisabled" ofType:@"png"]] forState:UIControlStateNormal];
    cancelAlbumPhotoButton.hidden = NO;
    confirmAlbumPhotoButton.hidden = NO;
    recondPhotoButton.hidden = NO;
    recondtext.hidden = NO;

}

- (void)IFVideoCameraDidFinishCaptureStillImage:(IFVideoCamera *)videoCamera {
    [cancelAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraReject"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraReject" ofType:@"png"]] forState:UIControlStateNormal];
    [confirmAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraAccept"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAccept" ofType:@"png"]] forState:UIControlStateNormal];
}

- (void)IFVideoCameraDidSaveStillImage:(IFVideoCamera *)vCamera { 
    if (self.uploadDelegate) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *savedFile = [paths objectAtIndex:0];
        savedFile=[savedFile stringByAppendingPathComponent:@"shared"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:savedFile]){
            [[NSFileManager defaultManager] createDirectoryAtPath:savedFile withIntermediateDirectories:NO attributes:nil error:nil];
        }
        savedFile=[savedFile stringByAppendingFormat:@"/%@.jpg",[AppHelper generateGuid]];
        NSData* imageData = UIImageJPEGRepresentation([[vCamera.filter imageFromCurrentlyProcessedOutput] imageRotatedByDegrees:0], 0.85);
        [imageData writeToFile:savedFile atomically:NO];
        [self.uploadDelegate didUploadPhoto:savedFile];
        [[HomeViewController shared] changeTab:0];
        [[HomeViewController shared] clickMenuFirst];
        [videoCamera gotoSleep];
        [self backButtonPressed:nil];
        return;
    }
    
    [cancelAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraReject"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraReject" ofType:@"png"]] forState:UIControlStateNormal];
    [confirmAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraAccept"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAccept" ofType:@"png"]] forState:UIControlStateNormal];
    cancelAlbumPhotoButton.enabled = YES;
    confirmAlbumPhotoButton.enabled = YES;
    
//    [self cancelAlbumPhotoButtonPressed:nil];
//    [vCamera gotoSleep];
}


- (BOOL)canIFVideoCameraStartRecordingMovie:(IFVideoCamera *)vCamera {
    if (shootButton.hidden == YES) {
        return NO;
    } else if (videoCamera.isRecordingMovie == YES) {
        return NO;
    } else {
        return YES;
    }
}

- (void)IFVideoCameraWillStartProcessingMovie:(IFVideoCamera *)videoCamera {
    NSLog(@" - 1 -");
    [shootButton setTitle:@"Processing" forState:UIControlStateNormal];
    shootButton.enabled = NO;
}

- (void)IFVideoCameraDidFinishProcessingMovie:(IFVideoCamera *)videoCamera {
    NSLog(@" - 2 -");

    shootButton.enabled = YES;
    [shootButton setTitle:@"Record" forState:UIControlStateNormal];

}

#pragma mark - Process Album Photo from Image Pick
- (UIImage *)processAlbumPhoto:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    float original_width = originalImage.size.width;
    float original_height = originalImage.size.height;
    
    if ([info objectForKey:UIImagePickerControllerCropRect] == nil) {
        if (original_width < original_height) {
            /*
             UIGraphicsBeginImageContext(mask.size);
             [ori drawAtPoint:CGPointMake(0,0)];
             [mask drawAtPoint:CGPointMake(0,0)];
             
             UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             return newImage;
             */
            return nil;
        } else {
            return nil;
        }
    } else {
        CGRect crop_rect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        float crop_width = crop_rect.size.width;
        float crop_height = crop_rect.size.height;
        float crop_x = crop_rect.origin.x;
        float crop_y = crop_rect.origin.y;
        float remaining_width = original_width - crop_x;
        float remaining_height = original_height - crop_y;
        
        // due to a bug in iOS
        if ( (crop_x + crop_width) > original_width) {
            NSLog(@" - a bug in x direction occurred! now we fix it!");
            crop_width = original_width - crop_x;
        }
        if ( (crop_y + crop_height) > original_height) {
            NSLog(@" - a bug in y direction occurred! now we fix it!");
            
            crop_height = original_height - crop_y;
        }
        
        float crop_longer_side = 0.0f;
        
        if (crop_width > crop_height) {
            crop_longer_side = crop_width;
        } else {
            crop_longer_side = crop_height;
        }
        //NSLog(@" - ow = %g, oh = %g", original_width, original_height);
        //NSLog(@" - cx = %g, cy = %g, cw = %g, ch = %g", crop_x, crop_y, crop_width, crop_height);
        //NSLog(@" - cls=%g, rw = %g, rh = %g", crop_longer_side, remaining_width, remaining_height);
        if ( (crop_longer_side <= remaining_width) && (crop_longer_side <= remaining_height) ) {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, crop_longer_side, crop_longer_side)];
            
            return tmpImage;
        } else if ( (crop_longer_side <= remaining_width) && (crop_longer_side > remaining_height) ) {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, crop_longer_side, remaining_height)];
            
            float new_y = (crop_longer_side - remaining_height) / 2.0f;
            //UIGraphicsBeginImageContext(CGSizeMake(crop_longer_side, crop_longer_side));
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(crop_longer_side, crop_longer_side), YES, 1.0f);
            [tmpImage drawAtPoint:CGPointMake(0.0f,new_y)];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        } else if ( (crop_longer_side > remaining_width) && (crop_longer_side <= remaining_height) ) {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, remaining_width, crop_longer_side)];
            
            float new_x = (crop_longer_side - remaining_width) / 2.0f;
            //UIGraphicsBeginImageContext(CGSizeMake(crop_longer_side, crop_longer_side));
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(crop_longer_side, crop_longer_side), YES, 1.0f);
            [tmpImage drawAtPoint:CGPointMake(new_x,0.0f)];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        } else {
            return nil;
        }
        
    }
}

#pragma mark - UIImagePicker Delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    videoCamera.rawImage = [self processAlbumPhoto:info];
    [videoCamera switchFilter:currentType];
    shootButton.hidden = YES;
    if (self.isInVideoRecorderMode == NO) {
        photoAlbumButton.hidden = YES;
    }
    cancelAlbumPhotoButton.hidden = NO;
    confirmAlbumPhotoButton.hidden = NO;
    recondPhotoButton.hidden = NO;
    recondtext.hidden = NO;
    if (isFiltersTableViewVisible == YES) {
        [self toggleFiltersButtonPressed:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:^(){
        if (isFiltersTableViewVisible == NO) {
            [self toggleFiltersButtonPressed:nil];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    [self dismissViewControllerAnimated:YES completion:^(){

        [videoCamera startCameraCapture];
        
    }];
}

#pragma mark - Filters TableView Delegate & Datasource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFilterCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentType = [indexPath row];
    
    [videoCamera switchFilter:[indexPath row]];
    
    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    CGRect tempRect = blueDotImageView.frame;
    tempRect.origin.y = cellRect.origin.y + kBlueDotImageViewOffset;
    
    [UIView animateWithDuration:kBlueDotAnimationTime animations:^() {
        blueDotImageView.frame = tempRect;
    }completion:^(BOOL finished){
        // do nothing
    }];
    
    if (([indexPath row] != [[[tableView indexPathsForVisibleRows] objectAtIndex:0] row]) && ([indexPath row] != [[[tableView indexPathsForVisibleRows] lastObject] row])) {
        
        return;
    }
    
    if ([indexPath row] == [[[tableView indexPathsForVisibleRows] objectAtIndex:0] row]) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *filtersTableViewCellIdentifier = @"filtersTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: filtersTableViewCellIdentifier];
    UIImageView *filterImageView;
    UIView *filterImageViewContainerView;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:filtersTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, -7.5, 57, 72)];
        filterImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        filterImageView.tag = kFilterImageViewTag;
        
        filterImageViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 57, 72)];
        filterImageViewContainerView.tag = kFilterImageViewContainerViewTag;
        [filterImageViewContainerView addSubview:filterImageView];
        
        [cell.contentView addSubview:filterImageViewContainerView];
    } else {
        filterImageView = (UIImageView *)[cell.contentView viewWithTag:kFilterImageViewTag];
    }
    
    switch ([indexPath row]) {
        case 0: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];

            break;
        }
        case 1: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileAmaro" ofType:@"png"]];
            
            break;
        }
        case 2: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileRise" ofType:@"png"]];
            
            break;
        }
        case 3: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHudson" ofType:@"png"]];
            
            break;
        }
        case 4: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileXpro2" ofType:@"png"]];
            
            break;
        }
        case 5: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSierra" ofType:@"png"]];
            
            break;
        }
        case 6: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLomoFi" ofType:@"png"]];
            
            break;
        }
        case 7: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileEarlybird" ofType:@"png"]];
            
            break;
        }
        case 8: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSutro" ofType:@"png"]];
            
            break;
        }
        case 9: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileToaster" ofType:@"png"]];
            
            break;
        }
        case 10: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileBrannan" ofType:@"png"]];
            
            break;
        }
        case 11: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileInkwell" ofType:@"png"]];
            
            break;
        }
        case 12: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileWalden" ofType:@"png"]];
            
            break;
        }
        case 13: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHefe" ofType:@"png"]];
            
            break;
        }
        case 14: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileValencia" ofType:@"png"]];
            
            break;
        }
        case 15: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNashville" ofType:@"png"]];
            
            break;
        }
        case 16: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTile1977" ofType:@"png"]];
            
            break;
        }
        case 17: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLordKelvin" ofType:@"png"]];
            break;
        }
            
        default: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];

            break;
        }
    }
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 18;
}


#pragma mark - UI Setup

- (void)loadView
{
    isShowPick = NO;
    content = [[NSArray alloc] initWithObjects:@"1s",@"2s",@"3s",@"4s",@"5s",@"6s",@"7s",@"8s",@"9s",@"10s", nil];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    
    self.isInVideoRecorderMode = self.shouldLaunchAsAVideoRecorder;
    self.isHighQualityVideo = self.shouldLaunchAshighQualityVideo;
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraBackground" ofType:@"png"]];
    
    cameraToolBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    cameraToolBarImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraToolbar" ofType:@"png"]];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(285, 10, 20, 20);
    [backButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraIconCancel" ofType:@"png"]] forState:UIControlStateNormal];
    backButton.adjustsImageWhenHighlighted = NO;
    backButton.showsTouchWhenHighlighted = YES;
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    transparentBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    transparentBackButton.frame = CGRectMake(270, 0, 50, 50);
    transparentBackButton.showsTouchWhenHighlighted = YES;
    [transparentBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    cameraCaptureBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-32-20, 320, kDeviceHeight - 74)];
    cameraCaptureBarImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureBar" ofType:@"png"]];
    
    toggleFiltersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleFiltersButton.frame = CGRectMake(270, kDeviceHeight-32-20 +7, 40, 40);
    [toggleFiltersButton setImage:[UIImage imageNamed:@"glCameraHideFilters"] forState:UIControlStateNormal];
    toggleFiltersButton.adjustsImageWhenHighlighted = NO;
    toggleFiltersButton.showsTouchWhenHighlighted = YES;
    [toggleFiltersButton addTarget:self action:@selector(toggleFiltersButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isInVideoRecorderMode == NO) {
        photoAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        photoAlbumButton.frame = CGRectMake(10, kDeviceHeight-32-20 +7, 40, 40);
        [photoAlbumButton setImage:[UIImage imageNamed:@"glCameraLibrary"] forState:UIControlStateNormal];// ContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraLibrary" ofType:@"png"]] forState:UIControlStateNormal];
        photoAlbumButton.adjustsImageWhenHighlighted = NO;
        photoAlbumButton.showsTouchWhenHighlighted = YES;
        [photoAlbumButton addTarget:self action:@selector(photoAlbumButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.isInVideoRecorderMode == NO) {
        shootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shootButton.frame = CGRectMake(110, kDeviceHeight-32-20 +7, 100, 40);
        [shootButton setImage:[UIImage imageNamed:@"glCameraCaptureButton"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButton" ofType:@"png"]] forState:UIControlStateNormal];
        shootButton.adjustsImageWhenHighlighted = NO;
        [shootButton addTarget:self action:@selector(shootButtonTouched:) forControlEvents:UIControlEventTouchDown];
        [shootButton addTarget:self action:@selector(shootButtonCancelled:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchDragOutside];
        [shootButton addTarget:self action:@selector(shootButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        shootButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shootButton.frame = CGRectMake(110, kDeviceHeight-32-20 +7, 100, 40);
        //[self.shootButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButton" ofType:@"png"]] forState:UIControlStateNormal];
        //self.shootButton.adjustsImageWhenHighlighted = NO;
        [shootButton setTitle:@"Record" forState:UIControlStateNormal];
        [shootButton addTarget:self action:@selector(shootButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
 
    recondPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recondPhotoButton.frame = CGRectMake(10, kDeviceHeight-32-20-3 , 50, 53);
    [recondPhotoButton setImage:[UIImage imageNamed:@"Camera_Timer"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraReject" ofType:@"png"]] forState:UIControlStateNormal];
    recondPhotoButton.adjustsImageWhenHighlighted = NO;
    recondPhotoButton.showsTouchWhenHighlighted = YES;
    recondPhotoButton.hidden = YES;
    recondtext.hidden = NO;
    [recondPhotoButton addTarget:self action:@selector(showPickData) forControlEvents:UIControlEventTouchUpInside];
    
    
    recondtext = [[UILabel alloc] initWithFrame:CGRectMake(60, kDeviceHeight-32-20-3, 50, 52)];
    recondtext.backgroundColor = [UIColor clearColor];
    recondtext.font = [UIFont systemFontOfSize:16];
    recondtext.text = @"10s";
    recondtext.textColor = [UIColor blackColor];
    recondtext.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setValue:@"10" forKey:@"second_post"];
    confirmAlbumPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmAlbumPhotoButton.frame = CGRectMake(170, kDeviceHeight-32-20 +7, 40, 40);
    [confirmAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraAccept"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAccept" ofType:@"png"]] forState:UIControlStateNormal];
    confirmAlbumPhotoButton.adjustsImageWhenHighlighted = NO;
    confirmAlbumPhotoButton.showsTouchWhenHighlighted = YES;
    confirmAlbumPhotoButton.hidden = YES;
    [confirmAlbumPhotoButton addTarget:self action:@selector(confirmAlbumPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelAlbumPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelAlbumPhotoButton.frame = CGRectMake(115, kDeviceHeight-32-20 +7, 40, 40);
    [cancelAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraReject"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraReject" ofType:@"png"]] forState:UIControlStateNormal];
    cancelAlbumPhotoButton.adjustsImageWhenHighlighted = NO;
    cancelAlbumPhotoButton.showsTouchWhenHighlighted = YES;
    cancelAlbumPhotoButton.hidden = YES;
    [cancelAlbumPhotoButton addTarget:self action:@selector(cancelAlbumPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    confirmAlbumPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmAlbumPhotoButton.frame = CGRectMake(170, kDeviceHeight-32-20 +7, 40, 40);
    [confirmAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraAccept"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAccept" ofType:@"png"]] forState:UIControlStateNormal];
    confirmAlbumPhotoButton.adjustsImageWhenHighlighted = NO;
    confirmAlbumPhotoButton.showsTouchWhenHighlighted = YES;
    confirmAlbumPhotoButton.hidden = YES;
    [confirmAlbumPhotoButton addTarget:self action:@selector(confirmAlbumPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.isFiltersTableViewVisible = YES;
    filterTableViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 354+kDeviceHeight -480, 320, 72)];
    filterTableViewContainerView.backgroundColor = [UIColor clearColor];
    
    filtersTableView = [[UITableView alloc] initWithFrame:CGRectMake(124, -124, 72, 320) style:UITableViewStylePlain];
    filtersTableView.backgroundColor = [UIColor clearColor];
    filtersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filtersTableView.showsVerticalScrollIndicator = NO;
    filtersTableView.delegate = self;
    filtersTableView.dataSource = self;
    filtersTableView.transform	= CGAffineTransformMakeRotation(-M_PI/2);
    
    blueDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-3, kBlueDotImageViewOffset + 4, 21, 11)];
    blueDotImageView.image = [UIImage imageNamed:@"glCameraSelectedFilter"];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraSelectedFilter" ofType:@"png"]];
    blueDotImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [filtersTableView addSubview:blueDotImageView];
    
    cameraTrayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 29)];
    cameraTrayImageView.image = [UIImage imageNamed:@"glCameraTray"] ;//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraTray" ofType:@"png"]];
    
    [filterTableViewContainerView addSubview:cameraTrayImageView];
    [filterTableViewContainerView addSubview:filtersTableView];
    
    videoCamera = [[IFVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack highVideoQuality:self.isHighQualityVideo];
    videoCamera.delegate = self;
    
    [self.view addSubview:backgroundImageView];
    [self.view addSubview:transparentBackButton];
    //[self.view addSubview:cameraToolBarImageView];
   // [self.view addSubview:backButton];
    [self.view addSubview:videoCamera.gpuImageView];
    [self.view addSubview:filterTableViewContainerView];
    [self.view addSubview:cameraCaptureBarImageView];
    [self.view addSubview:photoAlbumButton];
    [self.view addSubview:shootButton];
    [self.view addSubview:cancelAlbumPhotoButton];
    [self.view addSubview:confirmAlbumPhotoButton];
    [self.view addSubview:recondPhotoButton];
    [self.view addSubview:recondtext];
    [self.view addSubview:toggleFiltersButton];
	
	[self initSwitchButton];
}

-(void)initSwitchButton{
	btnSwitchDevice=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSwitchDevice setImage:[UIImage imageNamed:@"camera-glyph-cameratoggle"] forState:UIControlStateNormal];
	btnSwitchDevice.frame=CGRectMake(kDeviceWidth-63, 10, 43, 43);
	[btnSwitchDevice addTarget:self action:@selector(clickSwitchDevice) forControlEvents:UIControlEventTouchUpInside];
	
	btnSwitchFlash=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSwitchFlash setImage:[UIImage imageNamed:@"camera-glyph-flash-auto"] forState:UIControlStateNormal];
	btnSwitchFlash.frame=CGRectMake(kDeviceWidth-120, 10, 43, 43);
	[btnSwitchFlash addTarget:self action:@selector(clickSwitchFlash) forControlEvents:UIControlEventTouchUpInside];
	
    
    UIButton *btnSwitchBack=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnSwitchBack setImage:[UIImage imageNamed:@"glCameraIconCancel@2x"] forState:UIControlStateNormal];
	btnSwitchBack.frame=CGRectMake(20, 10, 43, 43);
	[btnSwitchBack addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	//[videoCamera.gpuImageView addSubview:btnSwitchFlash];
	[videoCamera.gpuImageView addSubview:btnSwitchDevice];
    [videoCamera.gpuImageView addSubview:btnSwitchBack];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 

}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [videoCamera startCameraCapture];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button methods

-(void)clickSwitchDevice{
	BOOL hasFlash=[videoCamera switchDevice];
	btnSwitchFlash.hidden=!hasFlash;
}

-(void)clickSwitchFlash{
	
}
-(void)showPickData{
    isShowPick = !isShowPick;
    if (pickData) {
        if (isShowPick) {
            pickData.hidden = NO;
        }else{
            pickData.hidden = YES;
        }
    }else{
        pickData = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-200-40, 320, 200)];
        pickData.delegate = self;
        
        pickData.showsSelectionIndicator = YES;
        
        [self.view addSubview:pickData];
    }
   
}
#pragma mark -

#pragma mark 处理方法

// 返回显示的列数

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView

{
    
    return 1;
    
}

// 返回当前列显示的行数

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    
    return [content count];
    
}

// 设置当前行的内容，若果行没有显示则自动释放

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    
    return [content objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
    //NSString *result = [pickerView pickerView:pickerView titleForRow:row forComponent:component];
    
    NSString  *result = nil;
    
    result = [content objectAtIndex:row];
    
    NSLog(@"result: %@",result);
    recondtext.text = result;
    [[NSUserDefaults standardUserDefaults] setValue:result forKey:@"second_post"];
    
}




- (void)cancelAlbumPhotoButtonPressed:(id)sender {
    recondtext.hidden = YES;
    recondPhotoButton.hidden = YES;
    cancelAlbumPhotoButton.hidden = YES;
    confirmAlbumPhotoButton.hidden = YES;
    shootButton.hidden = NO;
    if (self.isInVideoRecorderMode == NO) {
        photoAlbumButton.hidden = NO;
    }
    [videoCamera cancelAlbumPhotoAndGoBackToNormal];
}

- (void)confirmAlbumPhotoButtonPressed:(id)sender {
    [cancelAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraRejectDisabled"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraRejectDisabled" ofType:@"png"]] forState:UIControlStateNormal];
    [confirmAlbumPhotoButton setImage:[UIImage imageNamed:@"glCameraAcceptDisabled"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAcceptDisabled" ofType:@"png"]] forState:UIControlStateNormal];
    cancelAlbumPhotoButton.enabled = NO;
    confirmAlbumPhotoButton.enabled = NO;
    
    [videoCamera saveCurrentStillImage];
}

- (void)shootButtonTouched:(id)sender {
    [shootButton setImage:[UIImage imageNamed:@"glCameraCaptureButtonPressed"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButtonPressed" ofType:@"png"]] forState:UIControlStateNormal];

}
- (void)shootButtonCancelled:(id)sender {
    [shootButton setImage:[UIImage imageNamed:@"glCameraCaptureButton"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButton" ofType:@"png"]] forState:UIControlStateNormal];

}
- (void)photoAlbumButtonPressed:(id)sender {
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:^(){
        // do nothing
        picker = nil;
    }];
}
- (void)shootButtonPressed:(id)sender {
    
    if (self.isInVideoRecorderMode == YES) {
        if (videoCamera.isRecordingMovie == NO) {
            NSLog(@" - starts...");
            
            [shootButton setTitle:@"STOP" forState:UIControlStateNormal];
            
            toggleFiltersButton.enabled = NO;
            filtersTableView.userInteractionEnabled = NO;
            if (self.isFiltersTableViewVisible == YES) {
                [self toggleFiltersButtonPressed:nil];
            }
            
            [videoCamera startRecordingMovie];
        } else {
            NSLog(@" - stops...");
            [videoCamera stopRecordingMovie];
            toggleFiltersButton.enabled = YES;
            filtersTableView.userInteractionEnabled = YES;
            
        }
    } else {
         [shootButton setImage:[UIImage imageNamed:@"glCameraCaptureButton"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButton" ofType:@"png"]] forState:UIControlStateNormal];
         [videoCamera takePhoto];
    }
    

}
- (void)backButtonPressed:(id)sender {
    
    if (videoCamera.isRecordingMovie == YES) {
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^() {
        // do nothing
    }];
}

- (void)toggleFiltersButtonPressed:(id)sender {
    
    BOOL originalEnabledValue = toggleFiltersButton.enabled;
    
    toggleFiltersButton.enabled = NO;
    
    if (isFiltersTableViewVisible == YES) {
        
        [toggleFiltersButton setImage:[UIImage imageNamed:@"glCameraHideFilters"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraHideFilters" ofType:@"png"]] forState:UIControlStateNormal];
        self.isFiltersTableViewVisible = NO;
        
        CGRect tempRect = filterTableViewContainerView.frame;
        tempRect.origin.y = tempRect.origin.y + kFilterCellHeight;
        
        CGRect tempRectForGPUImageView = videoCamera.gpuImageView.frame;
        tempRectForGPUImageView.origin.y = tempRectForGPUImageView.origin.y + kGPUImageViewAnimationOffset;

        [UIView animateWithDuration:kFilterTableViewAnimationTime animations:^(){
            filterTableViewContainerView.frame = tempRect;
            videoCamera.gpuImageView.frame = tempRectForGPUImageView;
        }completion:^(BOOL finished) {
            toggleFiltersButton.enabled = originalEnabledValue;
        }];
        

    } else {
        
        [toggleFiltersButton setImage:[UIImage imageNamed:@"glCameraHideFilters"] forState:UIControlStateNormal];//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraHideFilters" ofType:@"png"]] forState:UIControlStateNormal];
        self.isFiltersTableViewVisible = YES;
        
        CGRect tempRect = filterTableViewContainerView.frame;
        tempRect.origin.y = tempRect.origin.y - kFilterCellHeight;
        
        CGRect tempRectForGPUImageView = videoCamera.gpuImageView.frame;
        tempRectForGPUImageView.origin.y = tempRectForGPUImageView.origin.y - kGPUImageViewAnimationOffset;
        
        [UIView animateWithDuration:kFilterTableViewAnimationTime animations:^(){
            filterTableViewContainerView.frame = tempRect;
            videoCamera.gpuImageView.frame = tempRectForGPUImageView;
        }completion:^(BOOL finished) {
            toggleFiltersButton.enabled = originalEnabledValue;
        }];
        

    }
}


#pragma mark - View Will/Did Appear/Disappear
- (void)viewWillAppear:(BOOL)animated {
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    if ([videoCamera isRecordingMovie] == YES) {
        [videoCamera stopRecordingMovie];
    }
    
    [videoCamera stopCameraCapture];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}


@end
