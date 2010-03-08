//
//  BlockFactory.m
//  Graphics
//
//  Created by Yanlong Zhang on 24/02/2010.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "BlockFactory.h"

static BlockFactory* instance;

@implementation BlockFactory

@synthesize maxNumOfBlocks;
@synthesize totalNumOfBlocks;

+(BlockFactory*)sharedBlockFactory {
	@synchronized(self) {
		if (instance == nil) {
			instance = [BlockFactory alloc];
		}
	}
	return instance;
}

-(id)init {
	
	totalNumOfBlocks = 10;
	nameArray = 0;
	blockDict = 0;
	
	[self loadBlocks];
	
	maxNumOfBlocks = totalNumOfBlocks;
	
	return self;
}

-(void)loadBlocks {

	NSMutableArray *blockArray = [NSMutableArray arrayWithCapacity:totalNumOfBlocks];
	
	nameArray = [NSArray arrayWithObjects:@"I",@"L",@"J",@"O",@"T",@"P",nil];
	[nameArray retain];
	[blockArray retain];
	
	Block* block;
	
	block = [[Block alloc] init];
	[block loadCubeWithX:0 Y:0 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:2 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:3 color:RED type:SOLID];
	[blockArray addObject:block];
	[block release];
	
	block = [[Block alloc] init];
	[block loadCubeWithX:0 Y:0 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:2 color:RED type:SOLID];
	[block loadCubeWithX:1 Y:2 color:RED type:SOLID];
	[blockArray addObject:block];
	[block release];
	
	block = [[Block alloc] init];
	[block loadCubeWithX:1 Y:0 color:RED type:SOLID];
	[block loadCubeWithX:1 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:1 Y:2 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:2 color:RED type:SOLID];
	[blockArray addObject:block];
	[block release];
	
	block = [[Block alloc] init];
	[block loadCubeWithX:0 Y:0 color:RED type:SOLID];
	[block loadCubeWithX:1 Y:0 color:RED type:SOLID];
	[block loadCubeWithX:1 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:1 color:RED type:SOLID];
	[blockArray addObject:block];
	[block release];
	
	block = [[Block alloc] init];
	[block loadCubeWithX:1 Y:0 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:1 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:2 Y:1 color:RED type:SOLID];
	[blockArray addObject:block];
	[block release];
	
	block = [[Block alloc] init];
	[block loadCubeWithX:1 Y:0 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:1 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:2 color:RED type:SOLID];
	[blockArray addObject:block];
	[block release];
	
	blockDict = [NSDictionary dictionaryWithObjects:blockArray forKeys:nameArray];
	[blockDict retain];
	
	[blockArray release];
}

-(Block*)getBlockWithType:(NSString *)type {
	Block *block = [blockDict objectForKey:type];
	[block retain];
	Block *copyBlock = [[Block alloc] initWithBlock:block];
	[block release];
	return [copyBlock autorelease];
}

-(Block*)getRandomBlock {
	int total = [nameArray count];
	int index = rand() % total;
	NSString* type = [nameArray objectAtIndex:index];
	return [self getBlockWithType:type];
}

-(void)dealloc {
	[nameArray release];
	[blockDict release];
	[super dealloc];
}

@end
