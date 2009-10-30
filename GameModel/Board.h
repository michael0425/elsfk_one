//
//  Board.h
//  GameModel
//
//  Created by Yanlong Zhang on 14/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Cube.h"


@interface Board : NSObject {
	int x;
	int y;
	CubeType **poArray;
	Block *currentBlock;
	int unit;
	NSMutableSet *poCubeSet;
	NSSet *currentCubeSet;
}

@property(readonly) int x;
@property(readonly) int y;
@property(retain) Block *currentBlock;
@property(readonly) int unit;
@property(readonly) CubeType **poArray;
@property(retain) NSSet *currentCubeSet;


-(id)initWithX:(int)gX Y:(int)gY;

//return YES if the block can be shown in the board.
-(BOOL)validateBlock:(Block*)block;

// make current block solid and remove it out of currenBlock.
// this is used when a block hits the ground.
-(void)landCurrentBlock;


-(GLfloat*)getCubeVertex:(Cube*)cube;
-(GLfloat*)getCubeSetVerticesInBoard;


-(void)setArrayCubeTypeWithX:(int)gX Y:(int)gY type:(CubeType)type;
-(void)printBoard;
-(void)printNewBoard;

@end
