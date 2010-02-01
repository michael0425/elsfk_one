//
//  Frame.h
//  Graphics
//
//  Created by Liy on 10-1-30.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"


@interface Frame : NSObject {
	float duration;
	Image* image;
}

- (id) initWithImage:(Image*)img forDuration:(float)dur;

- (void) renderTo:(CGPoint)pos centreImage:(BOOL)flag;

@property (nonatomic) float duration;
@property (nonatomic, readonly) Image* image;

@end
