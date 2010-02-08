//
//  
//	The main game controller process game logic and to handle UIEvent. All the ui touches handlers should be placed here.
//
//  Created by Lyss on 03/11/2009.
//  Copyright 2009 Bangboo. All rights reserved.
//

#import "GameController.h"
#import "ES1Renderer.h"

@implementation GameController

/**
 *
 */
@synthesize board;

- (id)initWithRender:(id <ESRenderer>)aRenderer{
	if (self = [super init]) {
		renderer = aRenderer;
		[self init];
	}
	return self;
}

/**
 * 
 *
 *
 */
- (id) init{
	if (self = [super init])
	{
		fallRate = 10.0f/20.0f;
		fallTimer = 0.0f;
		
		currentBlock = [[Block alloc] init];
		[currentBlock loadCubeWithX:0 Y:0 color:RED type:SOLID];
		[currentBlock loadCubeWithX:0 Y:1 color:RED type:SOLID];
		[currentBlock loadCubeWithX:0 Y:2 color:RED type:SOLID];
		[currentBlock loadCubeWithX:1 Y:2 color:RED type:SOLID];
		
		board = [[Board sharedBoard] initWithX:16 Y:24];
		
		board.currentBlock = currentBlock;
	}
	return self;
}

- (void) dealloc{
	[board release];
	[super dealloc];
}

/**
 *
 *
 */
- (void) update:(float)delta{
	//update game logic
	fallTimer += delta;
	if (fallTimer>=fallRate) {
		NSLog(@"fallTimer: %f    fallRate: %f", fallTimer, fallRate);
		[currentBlock moveDown];
		if (![board validateBlock:currentBlock]) {
			[board landCurrentBlock];
			
			/*
			currentBlock = [[Block alloc] init];
			[currentBlock loadCubeWithX:0 Y:0 color:RED type:SOLID];
			[currentBlock loadCubeWithX:0 Y:1 color:RED type:SOLID];
			[currentBlock loadCubeWithX:0 Y:2 color:RED type:SOLID];
			[currentBlock loadCubeWithX:1 Y:2 color:RED type:SOLID];
			board.currentBlock = currentBlock;
			 */
		}
		
		fallTimer -= fallRate;
	}
	
	//render
	[renderer startRender];
	[renderer render:delta];
	[renderer drawCubes:[currentBlock getCubeSetToBoard]];
	[renderer endRender];
}

/**
 * Handle main game view touch begin events.
 * @param touches The NSSet of touches received.
 * @param event An UIEvent.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//touch begin, check whether the block is touched or empty space is touched.
	UITouch* touch = [touches anyObject];
	CGPoint pos = [touch locationInView:[self view]];
	
	
	float centreX = (currentBlock.x + (currentBlock.maxX+1)/2) * 20;
	float dis = pos.x - centreX;
	NSLog(@"centreX: %f", centreX);
	
	if(dis < -20){
		[currentBlock moveLeft];
		[board validateBlock:currentBlock];
		//NSLog(@"moved left x:%u y:%u", currentBlock.x, currentBlock.y);
	}
	else if(dis > 20){
		[currentBlock moveRight];
		[board validateBlock:currentBlock];
		//NSLog(@"moved right x:%u y:%u", currentBlock.x, currentBlock.y);
	}
	else{
		[currentBlock rotate];
		[board validateBlock:currentBlock];
	}
}

@end
