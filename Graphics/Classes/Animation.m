//
//  Animation.m
//  Graphics
//
//  Created by Liy on 10-1-30.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Animation.h"


@implementation Animation

@synthesize currentFrameNum;
@synthesize pingpong;
@synthesize repeat;
@synthesize running;
@synthesize direction;
@synthesize defaultDuration;
@synthesize frameTimer;

- (id) init{
	if (self=([super init])) {
		frames = [[NSMutableArray alloc] init];
		
		currentFrameNum = 0;
		
		pingpong = NO;
		
		repeat = NO;
		
		running = NO;
		
		direction = ani_forward;
		
		frameTimer = 0;
		
		defaultDuration = 1;
		
		firstRound = YES;
	}
	return self;
}

- (Frame*) addFrameWithImage:(Image *)img{
	return [self addFrameWithImage:img withDuration:defaultDuration];
}

- (Frame*) addFrameWithImage:(Image *)img withDuration:(float)duration{
	Frame* frame = [[Frame alloc] initWithImage:img forDuration:duration];
	[frames addObject:frame];
	return frame;
}

- (void) update:(float)delta{
	if (!running) {
		return;
	}
	else {
		frameTimer += delta;
		if (frameTimer < [[frames objectAtIndex:currentFrameNum] duration]) {
			//go to next frame
			currentFrameNum+=direction;
			frameTimer = 0;
			
			//frame number is exceed limit
			if (currentFrameNum>([frames count]-1) || currentFrameNum<0) {
				//keep repeat and pingpong, never stop
				if(pingpong && repeat){
					direction*=-1;
					currentFrameNum+=direction;
				}
				//only pingpong once.
				else if(pingpong && !repeat){
					direction*=-1;
					if (firstRound) {
						firstRound = NO;
						currentFrameNum+=direction;
					}
					else {
						firstRound = YES;
						running = NO;
						currentFrameNum = 0;
					}
				}
				//stop
				else {
					running = NO;
					currentFrameNum = 0;
				}
			}
		}
	}
}

- (void) renderTo:(CGPoint)pos centreImage:(BOOL)flag{
	[[frames objectAtIndex:currentFrameNum] renderTo:pos centreImage:flag];
}

- (void) stop{
	running = NO;
}

- (void) play{
	//already running.
	running = YES;
}

- (void) reset{
	currentFrameNum = 0;
	running = NO;
}

- (void) gotoAndPlay:(uint)frameNum{
	if (frameNum>[frames count]) {
		return;
	}
	running = YES;
	currentFrameNum = frameNum;
}

- (void) gotoAndStop:(uint)frameNum{
	if (frameNum>[frames count]) {
		return;
	}
	running = NO;
	currentFrameNum = frameNum;
}

- (void) clear{
	[self reset];
	[frames removeAllObjects];
	pingpong = NO;
	repeat = NO;
	direction = ani_forward;
	defaultDuration = 0;
}

- (Frame*) getCurrentFrame{
	return [frames objectAtIndex:currentFrameNum];
}

- (void) dealloc{
	[frames release];
	[super dealloc];
}

@end
