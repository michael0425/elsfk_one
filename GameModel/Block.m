//
//  Block.m
//  GameModel
//
//  Created by Yanlong Zhang on 13/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Block.h"


@implementation Block

@synthesize x;
@synthesize y;
@synthesize cubeSet;
@synthesize maxX;
@synthesize maxY;

-(id)initWithX:(int)x_ Y:(int)y_ capacity:(int)cap_;
{
	if (self = [super init])
	{
		x = x_;
		y = y_;
		cubeSet = [[NSMutableSet alloc] initWithCapacity:cap_];
		maxX = 0;
		maxY = 0;
		preX = 0;
		preY = 0;
	}
	return self;
}

-(id)initWithX:(int)x_ Y:(int)y_
{
	return [self initWithX:x_ Y:y_ capacity:maxX * maxY];
}

-(id)init
{
	return [self initWithX:0 Y:0];
}

// clone a block.
// note this cloned block doesn't have 
// preXY and maxXY.
-(id)initWithBlock:(Block *)block_
{
	[self init];
	x = block_.x;
	y = block_.y;
	
	for (Cube* cube in block_.cubeSet) {
		Cube *tmp = [[Cube alloc] initWithCube:cube];
		[cubeSet addObject:tmp];
		[tmp release];
	}
	return self;
}

-(void)loadCubeWithX:(int)x_ Y:(int)y_ color:(CubeColor)color_ type:(CubeType)type_
{
	Cube * aCube = [[Cube alloc] initWithX:x_ Y:y_ color:color_ type:type_];
	NSLog(@"Loading cube: %@",aCube);
	[cubeSet addObject:aCube];
	[aCube release];
	
	//update max value
	if (maxX < x_) {
		maxX = x_;
	}
	if (maxY < y_) {
		maxY = y_;
	}
}

-(void)rotate
{
	//NSLog(@"Rotating block with maxX:%d maxY:%d", maxX, maxY);
	NSEnumerator *setEnumerator = [cubeSet objectEnumerator];
	Cube *anCube;
	
	while (anCube = (Cube*)[setEnumerator nextObject]) {
		int newY = maxX - anCube.x;
		anCube.x = anCube.y;
		anCube.y = newY;
	}
	
	//swich maxX and maxY
	int tmp = maxY;
	maxY = maxX;
	maxX = tmp;
}



-(void)printBlock
{
	// an 2D array of NO
	BOOL array[4][4];
	for (int i = 0; i < 4; i++)
	{
		for(int j = 0; j < 4; j++)
		{
			array[i][j] = NO;
		}
	}
	
	NSEnumerator *setEnumerator = [cubeSet objectEnumerator];
	id anCube;
	NSMutableString *str = [NSMutableString stringWithString:@"\n"];
	
	while (anCube = [setEnumerator nextObject]) {
		NSLog(@"Got %@", anCube);
		array[((Cube*)anCube).y][((Cube*)anCube).x] = YES;
	}
	
	for (int i = 0; i < 4; i++)
	{
		for(int j = 0; j < 4; j++)
		{
			if (array[i][j]) {
				[str appendString:@"0"];
			}
			else {
				[str appendString:@"-"];
			}
		}
		[str appendString:@"\n"];
	}
	
	NSLog(@"%@", str);
}

/*
 * get the cube set with coordination against board.
 */
-(NSMutableSet*)getCubeSetToBoard
{
	//NSLog(@"getCubeSetToBoard was called from %@", self);
	NSMutableSet *newSet = [[NSMutableSet alloc] initWithCapacity:[cubeSet count]];
	
	NSEnumerator *setEnumerator = [cubeSet objectEnumerator];
	Cube *aCube;
	while (aCube = (Cube*)[setEnumerator nextObject]) {
		Cube *newCube = [[Cube alloc] initWithCube:aCube];
		// calculate the board position
		newCube.x += self.x;
		newCube.y += self.y;
		[newSet addObject:newCube];
		[newCube release];
	}
	[newSet	autorelease];
	return newSet;
}

-(void)moveLeft
{
	preX = x;
	preY = y;
	--x;
	//NSLog(@"Move Left, New %@", self);
}
-(void)moveRight
{
	preX = x;
	preY = y;
	++x;
	//NSLog(@"Move Right, New %@", self);
}
-(void)moveDown
{
	preX = x;
	preY = y;
	++y;
	//NSLog(@"Move Down, New %@", self);
}
-(void)moveReset
{
	x = preX;
	y = preY;
	//NSLog(@"Move Reset, New %@", self);
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"Block X:%1.1f Y:%1.1f", x,y];
}

-(void)dealloc
{
	NSLog(@"####Deallocing %@", self);
	
	//dealloc cubeSet
	//[Cube releaseCubeSet:cubeSet];
	[cubeSet release];
	
	[super dealloc];
}


@end
