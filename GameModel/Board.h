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

enum CurrentBlockStatus {
	CONTINUE,
	STOP
};

@interface Board : NSObject {
	int x;
	int y;
	CubeType **poArray;
	Block *currentBlock;
	int unit;
	NSMutableSet *poCubeSet;
	NSSet *currentCubeSet;
	/// used to count how many cubes are there in all lines
	size_t* cubeCounterInLines;
}

@property(readonly) int x;
@property(readonly) int y;
@property(retain) Block *currentBlock;
@property(readonly) int unit;
@property(readonly) CubeType **poArray;
@property(retain) NSSet *currentCubeSet;
@property(readonly) NSMutableSet *poCubeSet;
@property(readonly) size_t* cubeCounterInLines;

/**
 * Singleton class.
 * Get a board instance for the game. Note that the return instance has not been initialized.
 * @return A Board instance which is not initialized.
 */
+ (Board*)sharedBoard;

/**
 * 
 */
-(id)initWithX:(int)gX Y:(int)gY;

/**
 * After every move, the block has to be validated by this method.
 * It compares against 4 edges and existing blocks.
 * Return YES if the block can be shown in the board.
 */
-(BOOL)validateBlock:(Block*)block;

// make current block solid and remove it out of currenBlock.
// this is used when a block hits the ground.
-(void)landCurrentBlock;


-(GLfloat*)getCubeVertex:(Cube*)cube;
-(GLfloat*)getCubeSetVerticesInBoard;

/**
 * Check if the block has any cube which ocupies
 * same position in the board that is already been 
 * taken.
 */
-(BOOL)intersectsTotalCubeSetWithBlock:(Block*)block;

/**
 * Check CubeSet for any full lines
 */
-(NSSet*)checkTotalCubeSetForFullLine;


-(void)setArrayCubeTypeWithX:(int)gX Y:(int)gY type:(CubeType)type;
-(void)printBoard;
-(void)printNewBoard;

@end
