//
//  Frame.m
//  Graphics
//
//  Created by Liy on 10-1-30.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Frame.h"



@implementation Frame

@synthesize duration;

- (id) initWithImage:(Image*)img forDuration:(float)dur{
	if (self = [super init]) {
		duration = dur;
		image = [img retain];
	}
	return self;
}

- (void) renderTo:(CGPoint)pos centreImage:(BOOL)flag{
	[image renderToPos:pos centreImage:flag];
}

- (void) dealloc{
	[image release];
	[super dealloc];
}

@end
