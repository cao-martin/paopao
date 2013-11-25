//
//  UIImage+UIImageScale.h
//  xiaoxisudi
//
//  Created by 曾 重 on 12-8-9.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)
-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;
@end
