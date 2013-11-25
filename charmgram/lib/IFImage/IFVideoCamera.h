//
//  IFVideoCamera.h
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "GPUImage.h"
#import "IFRotationFilter.h"
@class IFVideoCamera;

@protocol IFVideoCameraDelegate <NSObject>

- (void)IFVideoCameraWillStartCaptureStillImage:(IFVideoCamera *)videoCamera;
- (void)IFVideoCameraDidFinishCaptureStillImage:(IFVideoCamera *)videoCamera;
- (void)IFVideoCameraDidSaveStillImage:(IFVideoCamera *)videoCamera;
- (BOOL)canIFVideoCameraStartRecordingMovie:(IFVideoCamera *)videoCamera;
- (void)IFVideoCameraWillStartProcessingMovie:(IFVideoCamera *)videoCamera;
- (void)IFVideoCameraDidFinishProcessingMovie:(IFVideoCamera *)videoCamera;
@end

@interface IFVideoCamera : GPUImageVideoCamera
{
	NSMutableDictionary* dictPath;
	int curDeviceIndex;
}
@property (strong, readwrite) GPUImageView *gpuImageView;
@property (strong, readwrite) GPUImageView *gpuImageView_HD;
@property (nonatomic, strong) UIImage *rawImage;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL isRecordingMovie;
@property (nonatomic, strong) IFImageFilter *filter;
@property (nonatomic, strong) GPUImagePicture *sourcePicture1;
@property (nonatomic, strong) GPUImagePicture *sourcePicture2;
@property (nonatomic, strong) GPUImagePicture *sourcePicture3;
@property (nonatomic, strong) GPUImagePicture *sourcePicture4;
@property (nonatomic, strong) GPUImagePicture *sourcePicture5;

@property (nonatomic, strong) IFImageFilter *internalFilter;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture3;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture4;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture5;
 
@property (nonatomic, strong) IFRotationFilter *rotationFilter;
@property (nonatomic, assign) IFFilterType currentFilterType;

@property (nonatomic, assign) dispatch_queue_t prepareFilterQueue;

@property (nonatomic, strong) GPUImagePicture *stillImageSource;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter; 
@property (nonatomic, strong) AVAudioRecorder *soundRecorder;
@property (nonatomic, strong) AVMutableComposition *mutableComposition;
@property (nonatomic, strong) AVAssetExportSession *assetExportSession;

- (void)switchToNewFilter;
- (void)forceSwitchToNewFilter:(IFFilterType)type;

- (BOOL)canStartRecordingMovie;
- (void)removeFile:(NSURL *)fileURL;
- (NSURL *)fileURLForTempMovie;
- (void)initializeSoundRecorder;
- (NSURL *)fileURLForTempSound;
- (void)startRecordingSound;
- (void)prepareToRecordSound;
- (void)stopRecordingSound;
- (void)combineSoundAndMovie;
- (NSURL *)fileURLForFinalMixedAsset;

- (void)focusAndLockAtPoint:(CGPoint)point;
- (void)focusAndAutoContinuousFocusAtPoint:(CGPoint)point;
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality;
- (void)switchFilter:(IFFilterType)type;
- (BOOL)switchDevice;
- (void)switchFlash;
- (void)cancelAlbumPhotoAndGoBackToNormal;
- (void)gotoSleep;
- (void)takePhoto;
- (void)startRecordingMovie;
- (void)stopRecordingMovie;
- (void)saveCurrentStillImage;

@end
