//
//  BlockFactory.h
//  Graphics
//
//  Created by Yanlong Zhang on 24/02/2010.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cube.h"
#import "Block.h"

/**
 * A singlton class to 
 */
@interface BlockFactory : NSObject {
	
	/// stores the name and sample block in the array
	/// for each block
	NSDictionary *blockDict;
	NSArray *nameArray;
	
	int totalNumOfBlocks;
	
	/// restrict how many types can be used
	int maxNumOfBlocks;
	
	
}

@property(assign) int maxNumOfBlocks;
@property(readonly) int totalNumOfBlocks;

/// Singleton instance
+(BlockFactory*)sharedBlockFactory;

-(id)init;

-(void)loadBlocks;

-(Block*)getBlockWithType:(NSString*)type;

-(Block*)getRandomBlock;

@end
