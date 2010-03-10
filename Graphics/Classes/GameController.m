//
//  
//	The main game controller process game logic and to handle UIEvent. All the ui touches handlers should be placed here.
//
//  Created by Lyss on 03/11/2009.
//  Copyright 2009 Bangboo. All rights reserved.
//

#import "GameController.h"
#import <Foundation/Foundation.h>
#import "Graphic.h"
#import "Sprite.h"
#import "Animation.h"


@interface GameController()
- (BOOL)point:(CGPoint)point hitArea:(CGRect)rect;
- (void)controlBlock;
@end


@implementation GameController

@synthesize board;
@synthesize currentBlock;

- (void)test{
	Sprite* container = [[Sprite alloc] init];
	[director.currentScene addChild:container];
	
	Graphic* q1 = [[Graphic alloc] initWithFile:@"grey.jpg"];
	q1.pos = CGPointMake(120, 120);
	q1.scaleX = 0.5;
	q1.scaleY = 0.5;
	q1.rotation = 45;
	
	//q1.transform = matrix;
	[container addChild:q1];
	
	
	Graphic* q2 = [[Graphic alloc] initWithFile:@"grey.jpg"];
	[container addChild:q2];
	container.scaleX = 0.5;
	container.scaleY = 0.5;
	container.size = CGSizeMake(90, 90);
	
	
	//NSLog(@"container contentSize width:%.2f height:%.2f", container.contentSize.width, container.contentSize.height);
	
	CGRect box = [container boundingbox];
	//NSLog(@"container bouding box width:%.2f height:%.2f", box.size.width, box.size.height);
	Graphic* walk = [[Graphic alloc] initWithFile:@"walking.png"];
	walk.pos = CGPointMake(box.origin.x+box.size.width, box.origin.y+box.size.height);
	//walk.rect = CGRectMake(0.0, 0.0, 17, 31);
	[director.currentScene addChild:walk];
	
	
	Graphic* indicator = [[Graphic alloc] initWithFile:@"grey.jpg"];
	indicator.size = CGSizeMake(5, 5);
	indicator.pos = CGPointMake(90, 90);
	[director.currentScene addChild:indicator];
	
	Animation* animation = [[Animation alloc] initWithFile:@"walking.png"];
	animation.pos = CGPointMake(160.0f, 240.0f);
	animation.anchor = CGPointMake(0.0, 1.0);
	animation.scaleX = -1.0;
	float trackX = 0.0f;
	for (int i=0; i<3; ++i) {
		[animation addFrame:CGRectMake(trackX, 0.0f, 17.0f, 31.0f) withDelay:0.1];
		trackX+=18.0f;
	}
	[animation play];
	animation.repeat = YES;
	animation.pingpong = YES;
	animation.tlColor = Color4bMake(255, 0, 0, 255);
	[director.currentScene addChild:animation];
}

- (id) init{
	if (self = [super init])
	{
		blockFactory = [[BlockFactory sharedBlockFactory] init];
		self.currentBlock = [blockFactory getRandomBlock];
		
		cubeSize = CGSizeMake(20.0f, 20.0f);
		int numOfCubeInX = 320.0f/cubeSize.width;
		int numOfCubeInY = 480.0f/cubeSize.height;
		board = [[Board sharedBoard] initWithX:numOfCubeInX Y:numOfCubeInY];
		board.currentBlock = currentBlock;
		
		director = [Director sharedDirector];
		//set background color to black
		director.bgColor = Color4bMake(60, 60, 60, 255);
		fallRate = 0.2;
		//Add a timer, every fallRate seconds will trigger the update function, and also pass the delta parameter.
		[[GEScheduler sharedScheduler] addTarget:self sel:@selector(update:) interval:fallRate];
		
		[self test];
		
		//create the display object to draw all the cubes in the board
		DOBoard* doBoard = [[DOBoard alloc] initWithBoard:board withFile:@"grey.jpg"];
		[doBoard setCubeSize:cubeSize];
		//add it onto the current sccene, it will be auto rendered.
		[director.currentScene addChild:doBoard];
	}
	return self;
}

- (void) dealloc{
	[board release];
	[currentBlock release];
	[super dealloc];
}

/**
 * Keep update block postion, make it move down one square every fallRate seconds.
 *
 */
- (void) update:(float)delta{
	//update game logic
	[currentBlock moveDown];
	if (![board validateBlock:currentBlock]) {
		[board landCurrentBlock];
		self.currentBlock = [blockFactory getRandomBlock];
		board.currentBlock = currentBlock;
	}
}

/**
 * Control logic, make block goes left or right.
 */
- (void)controlBlock{
	//define a naive rectangle as a hit area from the current block
	CGRect blockRect = CGRectMake(currentBlock.x*20.0f, currentBlock.y*20.0f, (currentBlock.maxX+1)*20.0f, (currentBlock.maxY+1)*20.0f);
	
	if(pressPoint.x < blockRect.origin.x) {
		[currentBlock moveLeft];
		[board validateBlock:currentBlock];
	}
	else if(pressPoint.x > (blockRect.origin.x + blockRect.size.width)) {
		[currentBlock moveRight];
		[board validateBlock:currentBlock];
	}
}

/**
 * Check whether the point hits the rectangle.
 */
- (BOOL)point:(CGPoint)point hitArea:(CGRect)rect{
	if (point.x < rect.origin.x || point.y < rect.origin.y ||
		point.x > (rect.origin.x + rect.size.width) || point.y > (rect.origin.y + rect.size.height)) {
		return NO;
	}
	return YES;
}

/**
 * Handle main game view touch begin events.
 * @param touches The NSSet of touches received.
 * @param event An UIEvent.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//touch begin, check whether the block is touched or empty space is touched.
	UITouch* touch = [touches anyObject];
	pressPoint = [touch locationInView:[self view]];
	CGRect blockRect = CGRectMake(currentBlock.x*cubeSize.width, currentBlock.y*cubeSize.height, 
								  (currentBlock.maxX+1)*cubeSize.height, (currentBlock.maxY+1)*cubeSize.height);
	
	if ([self point:pressPoint hitArea:blockRect]) {
		[currentBlock rotate];
		[board validateBlock:currentBlock];
	}
	
	[self controlBlock];
	
	pressTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 10.0) target:self selector:@selector(controlBlock) userInfo:nil repeats:TRUE];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[pressTimer invalidate];
	pressTimer = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = [touches anyObject];
	pressPoint = [touch locationInView:[self view]];
}

@end
