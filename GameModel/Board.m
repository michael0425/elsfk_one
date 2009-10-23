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


-(id)initWithX:(int)gX Y:(int)gY
{
	if (self = [super init]) {
		x = gX;
		y = gY;
		
		unit = maxXCo / gX;
		
		poArray = calloc(y, sizeof(CubeType*));
		for (size_t i = 0; i < y; ++i)
		{
			poArray[i] = calloc(x, sizeof(CubeType));
			
			for (size_t j = 0; j < x; ++j)
			{
				poArray[i][j] = EMPTY;
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
-(BOOL)validateBlock:(Block*)block
{
//	NSArray *keepCurrentCubeSet = self.currentCubeSet;
//	[keepCurrentCubeSet retain];
//	
//	[self clearCurrentCubeSet];
	[block retain];
	
	Block *keepCurrentBlock = self.currentBlock;
	[keepCurrentBlock retain];
	
	[self clearCurrentBlock];
	
	BOOL isValid = YES;
	NSArray *cubeSet = [block getCubeSetToBoard];
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
		NSLog(@"%@ is valid.", block);
		[self setBoardWithCubeSet:cubeSet];
		self.currentBlock = [[Block alloc] initWithBlock:block];
		[self.currentBlock release];
	}else {
		// if not valid, then we need to set back the previous state.
		// now the self.currentCubeSet is set to NULL, the board status
		// is kept.
		NSLog(@"%@ is invalid.", block);
		[self setBoardWithBlock:keepCurrentBlock];
		self.currentBlock = keepCurrentBlock;
		[block moveReset];
		NSLog(@"Reset block to %@", block);
	}

	[keepCurrentBlock release];
	[cubeSet release];
	[block release];
	return isValid;
}

// set currentCubeSet to NULL
// make sure the previous moving block is cleared
-(void)clearCurrentBlock
{
	if (self.currentBlock) {
		[self clearBoardWithBlock:self.currentBlock];
		self.currentBlock = NULL;
	}
}

-(void)clearBoardWithBlock:(Block *)block
{
	[block retain];
	NSArray *cubeSet = [block getCubeSetToBoard];
	[self clearBoardWithCubeSet:cubeSet];
	[block release];
}

-(void)clearBoardWithCubeSet:(NSArray*)cubeSet
{
	[cubeSet retain];
	NSEnumerator *enumerator = [cubeSet objectEnumerator];
	Cube *aCube;
	
	while (aCube = (Cube*)[enumerator nextObject]) {
		[self setArrayCubeTypeWithX:aCube.x Y:aCube.y type:EMPTY];
	}
	
	[cubeSet release];
}

-(void)setBoardWithBlock:(Block*)block
{
	[block retain];
	NSArray *cubeSet = [block getCubeSetToBoard];
	[self setBoardWithCubeSet:cubeSet];
	[block release];
}

-(void)setBoardWithCubeSet:(NSArray*)cubeSet
{
	[cubeSet retain];
	NSEnumerator *enumerator = [cubeSet objectEnumerator];
	Cube *aCube;
	
	while (aCube = (Cube*)[enumerator nextObject]) {
		[self setArrayCubeTypeWithX:aCube.x Y:aCube.y type:aCube.type];
	}
	
	[cubeSet release];
}

-(void)setArrayCubeTypeWithX:(int)gX Y:(int)gY type:(CubeType)type
{
	poArray[gY][gX] = type;
}
/*
 * YES = ok to continue
 * NO = needs to revert back to the last status
 */
-(BOOL)validateCube:(Cube*)cube
{
	[cube retain];
	int cX = cube.x;
	int cY = cube.y;
	
	if (cX >= 0 && cY >= 0 && cX < self.x && cY < self.y) {
		// then it is valid in the board, then check
		// if the location is taken
		// TODO all the logic related to cube ocupation should go here. 
		if (poArray[cY][cX] == EMPTY) {
			return YES;
		}else {
			return NO;
		}
	}else {
		return NO;
	}
	[cube release];
}

-(void)landCurrentBlock
{
	[self setBoardWithBlock:currentBlock];
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
			if (poArray[i][j] == SOLID)
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
