//
//  IFVideoCamera.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "InstaFilters.h"

@interface IFVideoCamera ()


@end

@implementation IFVideoCamera

@synthesize filter;
@synthesize sourcePicture1;
@synthesize sourcePicture2;
@synthesize sourcePicture3;
@synthesize sourcePicture4;
@synthesize sourcePicture5;

@synthesize internalFilter;
@synthesize internalSourcePicture1;
@synthesize internalSourcePicture2;
@synthesize internalSourcePicture3;
@synthesize internalSourcePicture4;
@synthesize internalSourcePicture5;

@synthesize gpuImageView;
@synthesize gpuImageView_HD;
@synthesize rotationFilter;
@synthesize currentFilterType;
@synthesize prepareFilterQueue;
@synthesize rawImage;
@synthesize stillImageSource;

@synthesize stillImageOutput;

@synthesize delegate;

@synthesize movieWriter;
@synthesize isRecordingMovie;
@synthesize soundRecorder;
@synthesize mutableComposition;
@synthesize assetExportSession;

#pragma mark - Switch Device & Flash
- (BOOL)switchDevice{
    [self.captureSession beginConfiguration];
    NSArray *devices=[AVCaptureDevice devices];
    NSArray *inputs=self.captureSession.inputs;
	BOOL hasFlash=NO;
    if ([inputs count] > 0 && [devices count]>1 ) {
		//      curDeviceIndex=0;
        
        if (curDeviceIndex==0) {
            curDeviceIndex=1;
        }
        else{
            curDeviceIndex=0;
        }
        AVCaptureDevice *device =(AVCaptureDevice *)[devices objectAtIndex:curDeviceIndex];
		
        if ([device hasFlash] && [device hasTorch]) {
			hasFlash=YES;
        } 
        NSError *error;
        AVCaptureDeviceInput *newCaptureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!newCaptureInput)
        {
            NSLog(@"Error: %@", error);
        }
        else{
            AVCaptureDeviceInput *captureInput = [self.captureSession.inputs objectAtIndex:0];
            [self.captureSession removeInput:captureInput];
            [self.captureSession addInput:newCaptureInput];
        }
    }
    [self.captureSession commitConfiguration];
	return hasFlash;
}

#pragma mark - Save current image
- (void)saveCurrentStillImage {
    if (self.rawImage == nil) {
        return;
    }
    // If without the rorating 0 degree action, the image will be left hand 90 degrees rorated.
//    UIImageWriteToSavedPhotosAlbum([[self.filter imageFromCurrentlyProcessedOutput] imageRotatedByDegrees:0], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    if ([self.delegate respondsToSelector:@selector(IFVideoCameraDidSaveStillImage:)]) {
        [self.delegate IFVideoCameraDidSaveStillImage:self];
    }
}


#pragma mark - Focus
// Switch to continuous auto focus mode at the specified point
- (void) focusAndLockAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = nil;
    for (AVCaptureInput *anInput in self.captureSession.inputs) {
        if ([anInput isKindOfClass:[AVCaptureDeviceInput class]]) {
            device = [((AVCaptureDeviceInput *)anInput) device];
            break;
        }
    }
    
    if (device == nil) {
        return;
    }
	
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			[device setFocusPointOfInterest:point];
			[device setFocusMode:AVCaptureFocusModeLocked];
			[device unlockForConfiguration];
		} else {
			// do nothing here...
		}
	}
}
- (void) focusAndAutoContinuousFocusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = nil;
    for (AVCaptureInput *anInput in self.captureSession.inputs) {
        if ([anInput isKindOfClass:[AVCaptureDeviceInput class]]) {
            device = [((AVCaptureDeviceInput *)anInput) device];
            break;
        }
    }
    
    if (device == nil) {
        return;
    }
	
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			[device setFocusPointOfInterest:point];
			[device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
			[device unlockForConfiguration];
		} else {
			// do nothing here...
		}
	}
}


#pragma mark - Mixed sound and movie asset url
- (NSURL *)fileURLForFinalMixedAsset {
    static NSURL *tempMixedAssetURL = nil;

    @synchronized(self) {
        if (tempMixedAssetURL == nil) {
            tempMixedAssetURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"tempMix.m4v"]];
        }
    }
    
    return tempMixedAssetURL;
}


#pragma mark - Combine sound and movie
- (void)combineSoundAndMovie {
    self.mutableComposition = [AVMutableComposition composition];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], AVURLAssetPreferPreciseDurationAndTimingKey, nil];
    
    AVURLAsset *movieURLAsset = [[AVURLAsset alloc] initWithURL:[self fileURLForTempMovie] options:options];
    AVURLAsset *soundURLAsset = [[AVURLAsset alloc] initWithURL:[self fileURLForTempSound] options:options];
    
    NSError *soundError = nil;
    AVMutableCompositionTrack *soundTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    BOOL soundResult = [soundTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, soundURLAsset.duration) ofTrack:[[soundURLAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&soundError];
    
    if (soundError != nil) {
        NSLog(@" - sound track error...");
    }
    
    if (soundResult == NO) {
        NSLog(@" - sound result = NO...");
    }
    
    NSError *movieError = nil;
    AVMutableCompositionTrack *movieTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    BOOL movieResult = [movieTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, movieURLAsset.duration) ofTrack:[[movieURLAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:&movieError];
    
    if (movieError != nil) {
        NSLog(@" - movie track error...");
    }
    
    if (movieResult == NO) {
        NSLog(@" - movie result = NO...");
    }

    self.assetExportSession = [[AVAssetExportSession alloc] initWithAsset:self.mutableComposition presetName:AVAssetExportPresetPassthrough];
    
    [self removeFile:[self fileURLForFinalMixedAsset]];

    self.assetExportSession.outputURL = [self fileURLForFinalMixedAsset];
    self.assetExportSession.outputFileType = AVFileTypeAppleM4V;
        
    [self.assetExportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (self.assetExportSession.status) {
            case AVAssetExportSessionStatusFailed: {
                NSLog(@" - Export failed...");
                break;
            }
            case AVAssetExportSessionStatusCompleted: {
                NSLog(@" - Export ok...");
                NSString *path = [NSString stringWithString:[self.assetExportSession.outputURL path]];
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (path)) {
                    UISaveVideoAtPathToSavedPhotosAlbum (path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);

                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Was trying to save the movie but failed." delegate:nil cancelButtonTitle:@"Oh ok" otherButtonTitles:nil];
                    [alertView show];
                    if ([self.delegate respondsToSelector:@selector(IFVideoCameraDidFinishProcessingMovie:)]) {
                        [self.delegate IFVideoCameraDidFinishProcessingMovie:self];
                    }
                    [self startCameraCapture];
                    [self focusAndAutoContinuousFocusAtPoint:CGPointMake(.5f, .5f)];
                }

                break;
            }
            default: {
                break;
            }
        };

    }];

}

#pragma mark - Movie & image did saved callback
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"The video was saved in Camera Roll." delegate:nil cancelButtonTitle:@"Sweet" otherButtonTitles:nil];
    [alertView show];
    if ([self.delegate respondsToSelector:@selector(IFVideoCameraDidFinishProcessingMovie:)]) {
        [self.delegate IFVideoCameraDidFinishProcessingMovie:self];
    }
    [self startCameraCapture];
    [self focusAndAutoContinuousFocusAtPoint:CGPointMake(.5f, .5f)];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if ([self.delegate respondsToSelector:@selector(IFVideoCameraDidSaveStillImage:)]) {
        [self.delegate IFVideoCameraDidSaveStillImage:self];
    }
}


#pragma mark - Sound Writing methods
- (void)initializeSoundRecorder {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //audioSession.delegate = self;
    [audioSession setActive: YES error: nil];
    
}
- (NSURL *)fileURLForTempSound {
    static NSURL *tempSoundURL = nil;
    
    @synchronized(self) {
        if (tempSoundURL == nil) {
            tempSoundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"tempSound.caf"]];
        }
    }
    
    return tempSoundURL;
}
- (void)startRecordingSound {

    [soundRecorder record];

}
- (void)prepareToRecordSound {
    [self removeFile:[self fileURLForTempSound]];
    
    [self initializeSoundRecorder];
    
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryRecord
     error: nil];
    
    NSDictionary *recordSettings =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
     [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
     [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
     [NSNumber numberWithInt: AVAudioQualityMax],
     AVEncoderAudioQualityKey,
     nil];
    
    AVAudioRecorder *newRecorder =
    [[AVAudioRecorder alloc] initWithURL: [self fileURLForTempSound]
                                settings: recordSettings
                                   error: nil];
    
    self.soundRecorder = newRecorder;
    
    //soundRecorder.delegate = self;
    [soundRecorder prepareToRecord];
}

- (void)stopRecordingSound {
    [self.soundRecorder stop];
    self.soundRecorder = nil;

    [[AVAudioSession sharedInstance] setActive: NO error: nil];
    
}

#pragma mark - Movie Writing methods
- (BOOL)canStartRecordingMovie {
    
    if ([self.delegate respondsToSelector:@selector(canIFVideoCameraStartRecordingMovie:)]) {
        return [self.delegate canIFVideoCameraStartRecordingMovie:self];
    } else {
        return NO;
    }
}
- (void)startRecordingMovie {
    if ([self canStartRecordingMovie] == NO) {
        return;
    }
    if (self.isRecordingMovie == YES) {
        return;
    }
    self.isRecordingMovie = YES;
    [self focusAndLockAtPoint:CGPointMake(.5f, .5f)];
    [self removeFile:[self fileURLForTempMovie]];
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self fileURLForTempMovie] size:CGSizeMake(480.0f, 480.0f)];
    [self.filter addTarget:movieWriter];
    [self prepareToRecordSound];
    [self.movieWriter startRecording];
    [self startRecordingSound];
}
- (void)stopRecordingMovie {
    if ([self.delegate respondsToSelector:@selector(IFVideoCameraWillStartProcessingMovie:)]) {
        [self.delegate IFVideoCameraWillStartProcessingMovie:self];
    }
    [self.filter removeTarget:self.movieWriter];
    [self.movieWriter finishRecording];
    [self stopRecordingSound];
    [self stopCameraCapture];
    [self combineSoundAndMovie];
    self.isRecordingMovie = NO;
}
- (void)removeFile:(NSURL *)fileURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [fileURL path];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
		if (!success) {
            NSLog(@" - Remove file failed...");
        }
    }
}
- (NSURL *)fileURLForTempMovie {
    static NSURL *tempMoviewURL = nil;
    
    @synchronized(self) {
        if (tempMoviewURL == nil) {
            tempMoviewURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"temp.m4v"]];
        }
    }
    
    return tempMoviewURL;
}


#pragma mark - Proper Size For Resizing Large Image
- (CGSize)properSizeForResizingLargeImage:(UIImage *)originaUIImage {
    float originalWidth = originaUIImage.size.width;
    float originalHeight = originaUIImage.size.height;
    float smallerSide = 0.0f;
    float scalingFactor = 0.0f;
    
    if (originalWidth < originalHeight) {
        smallerSide = originalWidth;
        scalingFactor = 640.0f / smallerSide;
        return CGSizeMake(640.0f, originalHeight*scalingFactor);
    } else {
        smallerSide = originalHeight;
        scalingFactor = 640.0f / smallerSide;
        return CGSizeMake(originalWidth*scalingFactor, 640.0f);    
    }
}

#pragma mark - Take photo
- (void)takePhoto {
    AVCaptureConnection *videoConnection;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(IFVideoCameraWillStartCaptureStillImage:)]) {
        [self.delegate IFVideoCameraWillStartCaptureStillImage:self];
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
 

        
        @autoreleasepool {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            image = [image resizedImage:[self properSizeForResizingLargeImage:image] interpolationQuality:kCGInterpolationHigh];
            image = [image imageRotatedByDegrees:90.0f];            
            image = [image cropImageWithBounds:CGRectMake(0, 0, 640, 640)];
            
            self.rawImage = image;
            [self switchFilter:currentFilterType];
            
            /*
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:[image CGImage]
                                      orientation:(ALAssetOrientation)[image imageOrientation]
                                  completionBlock:^(NSURL *assetURL, NSError *error){
                                      if (error) {
                                          NSLog(@" save but error...");
                                          
                                          id delegate = [self delegate];
                                          if ([delegate respondsToSelector:@selector(captureStillImageFailedWithError:)]) {
                                              [delegate captureStillImageFailedWithError:error];
                                          }                                                                                               
                                      } else {
                                          NSLog(@" save without error...");
                                      }
                                  }];
            [library release];
            [image release];
             */

        }  
        
        if ([self.delegate respondsToSelector:@selector(IFVideoCameraDidFinishCaptureStillImage:)]) {
            [self.delegate IFVideoCameraDidFinishCaptureStillImage:self];
        }

        
    }];

}


#pragma mark - Cancel album photo and go back to normal
- (void)cancelAlbumPhotoAndGoBackToNormal {
    
    /*
    [self.filter removeTarget:self.gpuImageView_HD];
    [self.filter addTarget:self.gpuImageView];
    [self.stillImageSource removeTarget:self.filter];
    */

    [self.rotationFilter addTarget:self.filter];

    self.stillImageSource = nil;
    self.rawImage = nil;  
    self.gpuImageView_HD.hidden = YES;

    [self forceSwitchToNewFilter:currentFilterType];
    [self startCameraCapture];

}

-(void)gotoSleep{ 
    
    self.stillImageSource = nil;
    self.rawImage = nil;
    self.gpuImageView_HD.hidden = YES;
     
    [self stopCameraCapture];
}

#pragma mark - Switch Filter
- (void)switchToNewFilter {

    if (self.stillImageSource == nil) {
        [self.rotationFilter removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.rotationFilter addTarget:self.filter];
    } else {
        [self.stillImageSource removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.stillImageSource addTarget:self.filter];
    }

    switch (currentFilterType) {
        case IF_AMARO_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;

            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];

            break;
        }
            
        case IF_RISE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case IF_HUDSON_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case IF_XPROII_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case IF_SIERRA_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case IF_LOMOFI_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case IF_EARLYBIRD_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_SUTRO_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_TOASTER_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_BRANNAN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_INKWELL_FILTER: {
            
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];

            break;
        }
            
        case IF_WALDEN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
        
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];

            break;
        }
            
        case IF_HEFE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_VALENCIA_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;

            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
 
            break;
        }
            
        case IF_NASHVILLE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case IF_1977_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case IF_LORDKELVIN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case IF_NORMAL_FILTER: {
            break;
        }
            
        default: {
            break;
        }
    }
    

    if (self.stillImageSource != nil) {
        self.gpuImageView_HD.hidden = NO;
        [self.filter addTarget:self.gpuImageView_HD];
        [self.stillImageSource processImage];

    } else {
        [self.filter addTarget:self.gpuImageView];

    }
}
- (void)forceSwitchToNewFilter:(IFFilterType)type {
    
    currentFilterType = type;
    
    dispatch_async(prepareFilterQueue, ^{
        switch (type) {
            case IF_AMARO_FILTER: {
                self.internalFilter = [[IFAmaroFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"blackboard1024"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"overlayMap"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"amaroMap"]]];
                break;
            }
                
            case IF_NORMAL_FILTER: {
                self.internalFilter = [[IFNormalFilter alloc] init];
                break;
            }
                
            case IF_RISE_FILTER: {
                self.internalFilter = [[IFRiseFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"blackboard1024"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"overlayMap"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"riseMap"]]];
                
                break;
            }
                
            case IF_HUDSON_FILTER: {
                self.internalFilter = [[IFHudsonFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"hudsonBackground"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"overlayMap"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"hudsonMap"]]];
                
                break;
            }
                
            case IF_XPROII_FILTER: {
                self.internalFilter = [[IFXproIIFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"xproMap"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"vignetteMap"]]];
                
                break;
            }
                
            case IF_SIERRA_FILTER: {
                self.internalFilter = [[IFSierraFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"sierraVignette"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"overlayMap"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"sierraMap"]]];
                
                
                break;
            }
                
            case IF_LOMOFI_FILTER: {
                self.internalFilter = [[IFLomofiFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"lomoMap"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"vignetteMap"]]];                
                
                break;
            }
                
            case IF_EARLYBIRD_FILTER: {
                self.internalFilter = [[IFEarlybirdFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"earlyBirdCurves"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"earlybirdOverlayMap"]]];                
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"vignetteMap"]]]; 
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"earlybirdBlowout"]]];                
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"earlybirdMap"]]];                
                
                
                break;
            }
                
            case IF_SUTRO_FILTER: {
                self.internalFilter = [[IFSutroFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"vignetteMap"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"sutroMetal"]]];                
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"softLight"]]]; 
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"sutroEdgeBurn"]]];                
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"sutroCurves"]]];                
                
                
                break;
            }
                
            case IF_TOASTER_FILTER: {
                self.internalFilter = [[IFToasterFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"toasterMetal"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"toasterSoftLight"]]];                
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"toasterCurves"]]]; 
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"toasterOverlayMapWarm"]]];                
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"toasterColorShift"]]];                
                
                
                break;
            }
                
            case IF_BRANNAN_FILTER: {
                self.internalFilter = [[IFBrannanFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"brannanProcess"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"brannanBlowout"]]];                
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"brannanContrast"]]]; 
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"brannanLuma"]]];                
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"brannanScreen"]]];                
                
                
                break;
            }
                
            case IF_INKWELL_FILTER: {
                self.internalFilter = [[IFInkwellFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"inkwellMap"]]];
                
                break;
            }
                
            case IF_WALDEN_FILTER: {
                self.internalFilter = [[IFWaldenFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"waldenMap"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"vignetteMap"]]];            
                
                break;
            }
                
            case IF_HEFE_FILTER: {
                self.internalFilter = [[IFHefeFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"edgeBurn"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"hefeMap"]]];                
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"hefeGradientMap"]]]; 
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"hefeSoftLight"]]];                
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"hefeMetal"]]];                
                
                
                break;
            }
                
            case IF_VALENCIA_FILTER: {
                self.internalFilter = [[IFValenciaFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"valenciaMap"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"valenciaGradientMap"]]];                
                
                break;
            }
                
            case IF_NASHVILLE_FILTER: {
                self.internalFilter = [[IFNashvilleFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"nashvilleMap"]]];
                
                break;
            }
                
            case IF_1977_FILTER: {
                self.internalFilter = [[IF1977Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"1977map"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"1977blowout"]]];                
                
                break;
            }
                
            case IF_LORDKELVIN_FILTER: {
                self.internalFilter = [[IFLordKelvinFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[dictPath objectForKey:@"kelvinMap"]]];
                
                break;
            }
                
            default:
                break;
        }
        
        [self performSelectorOnMainThread:@selector(switchToNewFilter) withObject:nil waitUntilDone:NO];
        
    });
}

- (void)switchFilter:(IFFilterType)type {

    if ((self.rawImage != nil) && (self.stillImageSource == nil)) {

        // This is the state when we just switched from live view to album photo view
        [self.rotationFilter removeTarget:self.filter];
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:self.rawImage];
        [self.stillImageSource addTarget:self.filter];
    } else {

        if (currentFilterType == type) {
            return;
        }
    }

    [self forceSwitchToNewFilter:type];
}


#pragma mark - init
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality {
	if (!(self = [super initWithSessionPreset:sessionPreset cameraPosition:cameraPosition]))
    {
		return nil;
    } 
	NSBundle *bundle=[NSBundle mainBundle];
    dictPath=[[NSMutableDictionary alloc] initWithObjectsAndKeys:
			  [bundle pathForResource:@"blackboard1024" ofType:@"png"],@"blackboard1024",
			  [bundle pathForResource:@"overlayMap" ofType:@"png"],@"overlayMap",
			  [bundle pathForResource:@"amaroMap" ofType:@"png"],@"amaroMap",
			  [bundle pathForResource:@"riseMap" ofType:@"png"],@"riseMap",
			  [bundle pathForResource:@"hudsonBackground" ofType:@"png"],@"hudsonBackground",
			  [bundle pathForResource:@"hudsonMap" ofType:@"png"],@"hudsonMap",
			  [bundle pathForResource:@"xproMap" ofType:@"png"],@"xproMap",
			  [bundle pathForResource:@"vignetteMap" ofType:@"png"],@"vignetteMap",
			  [bundle pathForResource:@"sierraVignette" ofType:@"png"],@"sierraVignette",
			  [bundle pathForResource:@"sierraMap" ofType:@"png"],@"sierraMap",
			  [bundle pathForResource:@"lomoMap" ofType:@"png"],@"lomoMap",
			  [bundle pathForResource:@"earlyBirdCurves" ofType:@"png"],@"earlyBirdCurves",
			  [bundle pathForResource:@"earlybirdOverlayMap" ofType:@"png"],@"earlybirdOverlayMap",
			  [bundle pathForResource:@"earlybirdBlowout" ofType:@"png"],@"earlybirdBlowout",
			  [bundle pathForResource:@"earlybirdMap" ofType:@"png"],@"earlybirdMap",
			  [bundle pathForResource:@"sutroMetal" ofType:@"png"],@"sutroMetal",
			  [bundle pathForResource:@"softLight" ofType:@"png"],@"softLight",
			  [bundle pathForResource:@"sutroEdgeBurn" ofType:@"png"],@"sutroEdgeBurn",
			  [bundle pathForResource:@"sutroCurves" ofType:@"png"],@"sutroCurves",
			  [bundle pathForResource:@"toasterMetal" ofType:@"png"],@"toasterMetal",
			  [bundle pathForResource:@"toasterSoftLight" ofType:@"png"],@"toasterSoftLight",
			  [bundle pathForResource:@"toasterCurves" ofType:@"png"],@"toasterCurves",
			  [bundle pathForResource:@"toasterOverlayMapWarm" ofType:@"png"],@"toasterOverlayMapWarm",
			  [bundle pathForResource:@"toasterColorShift" ofType:@"png"],@"toasterColorShift",
			  [bundle pathForResource:@"brannanProcess" ofType:@"png"],@"brannanProcess",
			  [bundle pathForResource:@"brannanBlowout" ofType:@"png"],@"brannanBlowout",
			  [bundle pathForResource:@"brannanContrast" ofType:@"png"],@"brannanContrast",
			  [bundle pathForResource:@"brannanLuma" ofType:@"png"],@"brannanLuma",
			  [bundle pathForResource:@"brannanScreen" ofType:@"png"],@"brannanScreen",
			  [bundle pathForResource:@"inkwellMap" ofType:@"png"],@"inkwellMap",
			  [bundle pathForResource:@"waldenMap" ofType:@"png"],@"waldenMap",
			  [bundle pathForResource:@"edgeBurn" ofType:@"png"],@"edgeBurn",
			  [bundle pathForResource:@"hefeMap" ofType:@"png"],@"hefeMap",
			  [bundle pathForResource:@"hefeGradientMap" ofType:@"png"],@"hefeGradientMap",
			  [bundle pathForResource:@"hefeSoftLight" ofType:@"png"],@"hefeSoftLight",
			  [bundle pathForResource:@"hefeMetal" ofType:@"png"],@"hefeMetal",
			  [bundle pathForResource:@"valenciaMap" ofType:@"png"],@"valenciaMap",
			  [bundle pathForResource:@"valenciaGradientMap" ofType:@"png"],@"valenciaGradientMap",
			  [bundle pathForResource:@"nashvilleMap" ofType:@"png"],@"nashvilleMap",
			  [bundle pathForResource:@"1977map" ofType:@"png"],@"1977map",
			  [bundle pathForResource:@"1977blowout" ofType:@"png"],@"1977blowout",
			  [bundle pathForResource:@"kelvinMap" ofType:@"png"],@"kelvinMap",
			  nil];
	
//	NSLog(@"dictPath -- %@",[dictPath objectForKey:@"kelvinMap"]);
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.captureSession addOutput:stillImageOutput];
    
    prepareFilterQueue = dispatch_queue_create("com.diwublog.prepareFilterQueue", NULL);
    
    rotationFilter = [[IFRotationFilter alloc] initWithRotation:kGPUImageRotateRight];
    [self addTarget:rotationFilter];
    
    self.filter = [[IFNormalFilter alloc] init];
    self.internalFilter = self.filter;

    [rotationFilter addTarget:filter];
    
    gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    if (isHighQuality == YES) {
        gpuImageView.layer.contentsScale = 2.0f;
    } else {
        gpuImageView.layer.contentsScale = 1.0f;
    }
    [filter addTarget:gpuImageView];

    gpuImageView_HD = [[GPUImageView alloc] initWithFrame:[gpuImageView bounds]];
    gpuImageView_HD.hidden = YES;
    [gpuImageView addSubview:gpuImageView_HD];
    
    return self;
}


@end
