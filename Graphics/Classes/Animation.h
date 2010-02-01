//
//  Animation.h
//  Graphics
//
//  Created by Liy on 10-1-30.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Frame.h"
#import "Image.h"

enum {
	ani_forward = 1,
	ani_backword = -1
};

@interface Animation : NSObject {
	
	uint currentFrameIndex;
	
	NSMutableArray* frames;
	
	BOOL pingpong;
	
	BOOL repeat;
	
	BOOL running;
	
	int direction;
	
	float defaultDuration;
	
	float frameTimer;
	
	BOOL firstRound;
}

- (Frame*) addFrameWithImage:(Image *)img;

- (Frame*) addFrameWithImage:(Image*)img withDuration:(float)duration;

//- (BOOL) replaceFrameWithImage:(Image*)image on:(uint)frameNum;

//- (BOOL) addFrame:(Frame*)frame;

//- (Frame*) replaceFrame:(Frame *)frame on:(uint)frameNum;

//- (Frame*) removeFrameOn:(uint)frameNum;

//- (Frame*) removeFrame:(Frame*)frame;

- (void) update:(float)delta;

- (void) renderTo:(CGPoint)pos centreImage:(BOOL)flag;

- (void) gotoAndStop:(uint)frameNum;

- (void) gotoAndPlay:(uint)frameNum;

- (void) clear;

- (void) stop;

- (void) play;

- (void) reset;

- (void) clear;

- (Frame*) getCurrentFrame;

@property (nonatomic, readonly) uint currentFrameIndex;
@property (nonatomic, readonly) BOOL running;
@property (nonatomic) int direction;
@property (nonatomic) BOOL pingpong;
@property (nonatomic) BOOL repeat;
@property (nonatomic) float defaultDuration;
@property (nonatomic) float frameTimer;


@end
