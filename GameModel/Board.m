//
//  Board.m
//  GameModel
//
//  Created by Yanlong Zhang on 14/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Board.h"

static int maxXCo = 320;
static int maxYCo = 420;

@implementation Board


@synthesize x;
@synthesize y;
@synthesize currentBlock;
@synthesize unit;


-(id)initWithX:(int)x_ Y:(int)y_
{
	if (self = [super init]) {
		x = x_;
		y = y_;
		
		unit = maxXCo / x_;
		
		poArray = calloc(y, sizeof(BOOL*));
		for (size_t i = 0; i < y; ++i)
		{
			poArray[i] = calloc(x, sizeof(BOOL));
			
			for (size_t j = 0; j < x; ++j)
			{
				poArray[i][j] = NO;
			}
		}
		
		currentBlock = NULL;
	}
	return self;
}

// default setting for Board is 10 * 14
-(id)init
{
	return [self initWithX:10 Y:14];
}

/*
 * YES = ok to continue
 * NO = needs to revert back to the last status
 */
-(BOOL)validateBlock:(Block*)block_
{
//	NSArray *keepCurrentCubeSet = self.currentCubeSet;
//	[keepCurrentCubeSet retain];
//	
//	[self clearCurrentCubeSet];
	[block_ retain];
	
	Block *keepCurrentBlock = self.currentBlock;
	[keepCurrentBlock retain];
	
	[self clearCurrentBlock];
	
	BOOL isValid = YES;
	NSArray *cubeSet = [block_ getCubeSetToBoard];
	[cubeSet retain];
	
	NSEnumerator *enumberator = [cubeSet objectEnumerator];
	Cube *aCube;
	
	while (aCube = (Cube*)[enumberator nextObject]) {
		if (![self validateCube:aCube]) {
			isValid = NO;
			break;
		}
	}
	
	if (isValid) {
		NSLog(@"%@ is valid.", block_);
		[self setBoardWithCubeSet:cubeSet status:YES];
		self.currentBlock = [[Block alloc] initWithBlock:block_];
		[self.currentBlock release];
	}else {
		// if not valid, then we need to set back the previous state.
		// now the self.currentCubeSet is set to NULL, the board status
		// is kept.
		NSLog(@"%@ is invalid.", block_);
		[self setBoardWithBlock:keepCurrentBlock status:YES];
		self.currentBlock = keepCurrentBlock;
		[block_ moveReset];
		NSLog(@"Reset block to %@", block_);
	}

	[keepCurrentBlock release];
	[cubeSet release];
	[block_ release];
	return isValid;
}

// set currentCubeSet to NULL
// make sure the previous moving block is cleared
-(void)clearCurrentBlock
{
	if (self.currentBlock) {
		[self setBoardWithBlock:self.currentBlock status:NO];
		self.currentBlock = NULL;
	}
}

-(void)setBoardWithBlock:(Block*)block_ status:(BOOL)status_
{
	[block_ retain];
	NSArray *cubeSet = [block_ getCubeSetToBoard];
	[self setBoardWithCubeSet:cubeSet status:status_];
	[block_ release];
}

-(void)setBoardWithCubeSet:(NSArray*)cubeSet status:(BOOL)status_
{
	[cubeSet retain];
	NSEnumerator *enumerator = [cubeSet objectEnumerator];
	Cube *aCube;
	
	while (aCube = (Cube*)[enumerator nextObject]) {
		[self setArrayCubeStatusWithX:aCube.x Y:aCube.y status:status_];
	}
	
	[cubeSet release];
}

-(void)setArrayCubeStatusWithX:(int)x_ Y:(int)y_ status:(BOOL)status_
{
	poArray[y_][x_] = status_;
}
/*
 * YES = ok to continue
 * NO = needs to revert back to the last status
 */
-(BOOL)validateCube:(Cube*)cube_
{
	[cube_ retain];
	int cX = cube_.x;
	int cY = cube_.y;
	
	if (cX >= 0 && cY >= 0 && cX < self.x && cY < self.y) {
		// then it is valid in the board, then check
		// if the location is taken
		if (!poArray[cY][cX]) {
			return YES;
		}else {
			return NO;
		}
	}else {
		return NO;
	}
	[cube_ release];
}

-(void)landCurrentBlock
{
	[self setBoardWithBlock:currentBlock status:YES];
	[currentBlock release];
	currentBlock = NULL;
}

// used to provide real vertex to draw cubes in openGL
-(GLfloat*)getCubeVertex:(Cube*)cube
{
	Cube *tmpCube = [[Cube alloc]initWithCube:cube];
	tmpCube.x = tmpCube.x * unit;
	tmpCube.y = maxYCo - tmpCube.y * unit;
	NSLog(@"Getting Vertex from %@", tmpCube);
	GLfloat *vertex = [tmpCube getCubeVertexWithUnit:unit];
	[tmpCube release];
	return vertex;
}

-(void)printBoard
{
	NSMutableString *str = [NSMutableString stringWithString:@"\n"];
	
	for (size_t i = 0; i < self.y; ++i)
	{
		for (size_t j = 0; j < self.x; ++j)
		{
			if (poArray[i][j])
			{
//				NSLog(@"Has value %d", poArray[i][j]);
				[str appendString:@"0"];
			}
			else 
			{
				[str appendString:@"-"];
			}
		}
		[str appendString:@"\n"];
	}
	
	NSLog(@"%@", str);
}

-(void)dealloc
{
	NSLog(@"#####Deallocing Board.");
	for (int i = 0; i < self.y; ++i)
	{
		free(poArray[i]);
	}
	free(poArray);
	
	
	[currentBlock release];
	
	[super dealloc];
}
@end
