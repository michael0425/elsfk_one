//
//  Animation.m
//  Graphics
//
//  Created by Liy on 10-1-30.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Animation.h"


@implementation Animation

@synthesize currentFrameIndex;
@synthesize pingpong;
@synthesize repeat;
@synthesize running;
@synthesize direction;
@synthesize defaultDuration;
@synthesize frameTimer;

- (id) init{
	if (self=([super init])) {
		frames = [[NSMutableArray alloc] init];
		
		currentFrameIndex = 0;
		
		pingpong = NO;
		
		repeat = NO;
		
		running = NO;
		
		direction = ani_forward;
		
		frameTimer = 0;
		
		defaultDuration = 1.0/2.0;
		
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
		
		if (frameTimer > [[frames objectAtIndex:currentFrameIndex] duration]) {
			//go to next frame
			currentFrameIndex+=direction;
			frameTimer = 0;
			
			//frame number is exceed limit
			if (currentFrameIndex>([frames count]-1) || currentFrameIndex<0) {
				//keep repeat and pingpong, never stop
				if(pingpong && repeat){
					direction*=-1;
					currentFrameIndex+=direction;
				}
				//only pingpong once.
				else if(pingpong && !repeat){
					direction*=-1;
					if (firstRound) {
						firstRound = NO;
						currentFrameIndex+=direction;
					}
					else {
						firstRound = YES;
						running = NO;
						currentFrameIndex = 0;
					}
				}
				//go back to first frame
				else if(!pingpong && repeat){
					currentFrameIndex = 0;
				}
				//stop
				else {
					running = NO;
					currentFrameIndex = 0;
				}
			}
			NSLog(@"next frame %u",currentFrameIndex);
		}
	}
}

- (void) renderTo:(CGPoint)pos centreImage:(BOOL)flag{
	[[frames objectAtIndex:(currentFrameIndex)] renderTo:pos centreImage:flag];
}

- (void) stop{
	running = NO;
}

- (void) play{
	//already running.
	running = YES;
}

- (void) reset{
	currentFrameIndex = 0;
	running = NO;
}

- (void) gotoAndPlay:(uint)frameNum{
	if (frameNum>[frames count]) {
		return;
	}
	running = YES;
	currentFrameIndex = frameNum;
}

- (void) gotoAndStop:(uint)frameNum{
	if (frameNum>[frames count]) {
		return;
	}
	running = NO;
	currentFrameIndex = frameNum;
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
	return [frames objectAtIndex:currentFrameIndex];
}

- (void) dealloc{
	[frames release];
	[super dealloc];
}

@end
