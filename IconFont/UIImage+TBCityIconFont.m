//
//  UIImage+TBCityIconFont.m
//  iCoupon
//
//  Created by John Wong on 10/12/14.
//  Copyright (c) 2014 Taodiandian. All rights reserved.
//

#import "UIImage+TBCityIconFont.h"
#import "TBCityIconFont.h"
#import <CoreText/CoreText.h>

@implementation UIImage (TBCityIconFont)

+ (UIImage *)iconWithInfo:(TBCityIconInfo *)info
{
    BOOL hasTitle = info.title.length > 0 && [info.title respondsToSelector:@selector(drawAtPoint:withAttributes:)];
    CGFloat w1 = info.size - info.imageInsets.left - info.imageInsets.right;
    CGFloat w2 = info.size - info.imageInsets.top - info.imageInsets.bottom;
    CGFloat size = MIN(w1, w2);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat realSize = size * scale;
    CGFloat imageSize = info.size * scale;
    UIFont *font = info.fontName ?
        [TBCityIconFont fontWithSize:realSize withFontName:info.fontName] :
        [TBCityIconFont fontWithSize:realSize];
    CGFloat tOffset = 8.0;
    CGFloat tTitleSize = info.size+8.0;
    CGRect tBounds = CGRectMake(0.0, 0.0, imageSize, imageSize);
    UIFont *titleFont = [UIFont boldSystemFontOfSize:tTitleSize];
    if (hasTitle) {
        tBounds = CGRectMake(0.0, 0.0, imageSize, imageSize+tTitleSize+tOffset+2.0);
    }
    UIGraphicsBeginImageContext(tBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (info.backgroundColor) {
        [info.backgroundColor set];
        UIRectFill(tBounds); //fill the background
    }
    CGPoint point = CGPointMake(info.imageInsets.left*scale, info.imageInsets.top*scale);
 
    if ([info.text respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        /**
         * 如果这里抛出异常，请打开断点列表，右击All Exceptions -> Edit Breakpoint -> All修改为Objective-C
         * See: http://stackoverflow.com/questions/1163981/how-to-add-a-breakpoint-to-objc-exception-throw/14767076#14767076
         */
        [info.text drawAtPoint:point withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: info.color}];
    } else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, info.color.CGColor);
        [info.text drawAtPoint:point withFont:font];
#pragma clang pop
    }
    
    if (hasTitle) {
        CGSize titleSize = [info.title boundingRectWithSize:tBounds.size options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : titleFont} context:nil].size;
        [info.title drawInRect:(CGRect){(imageSize-titleSize.width)*0.5, imageSize+tOffset, titleSize} withAttributes:@{NSFontAttributeName:titleFont, NSForegroundColorAttributeName: info.color}];
    }
    
    UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}


@end
