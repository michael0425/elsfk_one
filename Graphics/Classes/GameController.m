//
//  
//	The main game controller process game logic and to handle UIEvent. All the ui touches handlers should be placed here.
//
//  Created by Lyss on 03/11/2009.
//  Copyright 2009 Bangboo. All rights reserved.
//

#import "GameController.h"

@implementation GameController

/**
 *
 */
@synthesize currentBlock;

/**
 *
 */
@synthesize board;

/**
 * 
 *
 *
 */
- (id) init{
	if (self = [super init])
	{
		board = [[Block alloc] init];
		currentBlock = [self createBlock];
		[currentBlock retain];
	}
	return self;
}

/**
 *
 *
 */
- (void) mainGameLoop{
	
}

- (Block*) createBlock{
	Block* newBlock = [[Block alloc] init];
	//random
	[newBlock loadCubeWithX:0 Y:0 color:RED type:SOLID];
	[newBlock loadCubeWithX:0 Y:1 color:RED type:SOLID];
	[newBlock loadCubeWithX:0 Y:2 color:RED type:SOLID];
	[newBlock loadCubeWithX:1 Y:2 color:RED type:SOLID];
	[newBlock autorelease];
	
	return newBlock;
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
	if(currentBlock.x > pos.x){
		[currentBlock moveLeft];
		NSLog(@"moved left x:%u  y:%u", currentBlock.x, currentBlock.y);
	}
	else{
		[currentBlock moveRight];
		NSLog(@"moved right x:%u  y:%u", currentBlock.x, currentBlock.y);
	}

}

@end
