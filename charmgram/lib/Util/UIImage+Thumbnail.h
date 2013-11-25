//
//  UIImage+Thumbnail.h
//
//  Created by Cory on 11/04/07.
//  Copyright 2011 Cory R. Leach. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Thumbnail)

- (UIImage*) imageWithThumbnailWidth:(CGFloat)thumbnailWidth;
//- (UIImage*) imageWithThumbnailWidth:(CGSize)newSize;
- (UIImage*) imageWithThumbnailWidth:(CGFloat)width height:(CGFloat)height;
@end
