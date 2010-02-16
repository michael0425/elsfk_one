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
@synthesize poArray;
@synthesize currentCubeSet;
@synthesize poCubeSet;
@synthesize cubeCounterInLines;

+ (Board*) sharedBoard{
	static Board* instance;
	@synchronized(self){
		if (instance == nil) {
			instance = [Board alloc];
		}
	}
	return instance;
}

-(id)initWithX:(int)gX Y:(int)gY
{
	if (self = [super init]) {
		x = gX;
		y = gY;
		
		unit = maxXCo / gX;
		
		poArray = calloc(y, sizeof(CubeType*));
		/*
		for (size_t i = 0; i < y; ++i)
		{
			poArray[i] = calloc(x, sizeof(CubeType));
			
			for (size_t j = 0; j < x; ++j)
			{
				poArray[i][j] = EMPTY;
			}
		}
		*/
		
		cubeCounterInLines = calloc(y, sizeof(size_t));
		
		for (size_t i = 0; i < y; ++i) {
			cubeCounterInLines[i] = 0;
		}
		
		currentBlock = NULL;
		poCubeSet = [[NSMutableSet alloc] initWithCapacity:x * y];
		currentCubeSet = NULL;
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

	[block retain];
	
	BOOL isValid = NO;
	NSSet *cubeSet = [block getCubeSetToBoard];
	[cubeSet retain];

	// use the new method
	[poCubeSet minusSet:currentCubeSet];
	
	if (block.x >= 0 && 
		block.y >= 0 &&
		block.x + block.maxX < self.x &&
		block.y + block.maxY < self.y) {
		//this means the block is valid, then we need to 
		//find if there are intersections
		if (![self intersectsTotalCubeSetWithBlock:block]){
			isValid = YES;
		}
	}
	
	if (isValid) {
		NSLog(@"%@ is valid.", block);
		self.currentCubeSet = [NSSet setWithSet:cubeSet];
		[poCubeSet unionSet:self.currentCubeSet];		
	}else {
		// if not valid, then we need to set back the previous state.
		// now the self.currentCubeSet is set to NULL, the board status
		// is kept.
		NSLog(@"%@ is invalid.", block);		
		[block moveReset];
		[poCubeSet unionSet:currentCubeSet];
		NSLog(@"Reset block to %@", block);
	}
	
	// end of new method

 
	[cubeSet release];
	[block release];

	return isValid;
}


-(void)setArrayCubeTypeWithX:(int)gX Y:(int)gY type:(CubeType)type
{
	NSLog(@"accessing x:%d y:%d", gX, gY);
	poArray[gY][gX] = type;
}


-(void)landCurrentBlock
{
	// new method
	//[currentCubeSet release];
	
	/// register currentCubeSet
	for (Cube* cube in currentCubeSet) {
		++cubeCounterInLines[cube.y];
	}
	
	[self checkTotalCubeSetForFullLine];
	
	currentBlock = NULL;
	self.currentCubeSet = NULL;
}

-(BOOL)intersectsTotalCubeSetWithBlock:(Block *)block
{
	NSSet* cubeSet = [block getCubeSetToBoard];
	[cubeSet retain];
	NSEnumerator* enumeratorA = [cubeSet objectEnumerator];
	NSEnumerator* enumeratorB;
	
	Cube* cubeA;
	Cube* cubeB;
	while (cubeA = [enumeratorA nextObject]) {
		enumeratorB = [poCubeSet objectEnumerator];
		while (cubeB = [enumeratorB nextObject]) {
			if ([cubeA compareWithCube:cubeB]) {
				[cubeSet release];
				return YES;
			}
		}
	}
	[cubeSet release];
	return NO;
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

-(GLfloat*)getCubeSetVerticesInBoard
{
	size_t size = [poCubeSet count];
	NSLog(@"#Bloard has %d cubes.", size);
	GLfloat *vertices = calloc(size * 8, sizeof(GLfloat));
	
	NSEnumerator *enumerator = [poCubeSet objectEnumerator];
	Cube *aCube;
	
	size_t i = 0;
	
	while (aCube = [enumerator nextObject]) {
		GLfloat *vertex = [self getCubeVertex:aCube];
		memcpy(vertices + i, vertex, 8 * sizeof(GLfloat));
		i += 8;
	}
	
	return vertices;
}

-(NSSet*)checkTotalCubeSetForFullLine
{
	/// get all the full lines
	NSMutableArray* fullLines = [[NSMutableArray alloc] initWithCapacity:y];
	
	for (size_t i = 0; i < y ; ++i) {
		if (cubeCounterInLines[i] >= x) {
			[fullLines addObject:[NSNumber numberWithInt:i]];
		}
	}
	if ((int)[fullLines count] > 0) {
		/// get dead cube set
		NSMutableSet* needToDeleteCubeSet = [[NSMutableSet alloc] initWithCapacity:[poCubeSet count]];
		
		for (Cube* cube in poCubeSet) {
			for (NSNumber* number in fullLines) {
				if ([number intValue] == cube.y) {
					[needToDeleteCubeSet addObject:cube];
				}
			}
		}
		
		/// delete the full line
		[poCubeSet minusSet:needToDeleteCubeSet];
		
		
		///shift line counter and other lines
		for (NSNumber* number in fullLines) {
			for (size_t i = [number intValue]; i > 0; --i) {
				cubeCounterInLines[i] = cubeCounterInLines[i-1];
			}
			
			///shift all the cubes
			[poCubeSet makeObjectsPerformSelector:@selector(shiftDownInBoardAtLine:) 
									   withObject:number];
		}

		return [needToDeleteCubeSet autorelease];
	}

	return 0;
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

-(void)printNewBoard
{
	NSEnumerator *enumerator = [poCubeSet objectEnumerator];
	Cube *aCube;
	
	while (aCube = [enumerator nextObject]) {
		[self setArrayCubeTypeWithX:aCube.x Y:aCube.y type:aCube.type];
	}
	[self printBoard];
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
	[poCubeSet release];
	[currentCubeSet release];
	
	[super dealloc];
}
@end
