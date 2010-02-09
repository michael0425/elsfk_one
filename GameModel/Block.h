//
//  Block.h
//  GameModel
//
//  Created by Yanlong Zhang on 13/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cube.h"

/** 
 * This wraps Cubes and controls all the movements and rotation.
 */
@interface Block : NSObject {
	/** this x and y is used to indicate the position of this block in the bigger board
	 * all he cubes contained in this block will need thses values to calculate the real
	 * location in the board.
	 */
	float x;
	float y;
	NSMutableSet *cubeSet;
	
	/// maxX and maxY shows the right bottom corner. It is used for rotation
	int maxX;
	int maxY;
	
	/// preX and preY are used to store the location before any movement
	int preX;
	int preY;
	
	BOOL cubeSetToBoardEnabled;
	BOOL cubeSetNextStatusEnabled;
}

/// This contructor can specify maximum cubes in a block
-(id)initWithX:(int)x_ Y:(int)y_ capacity:(int)cap_;
/// Common use constructor, define the position of the block which has nothing to 
/// do with the cubes. It is relative to the board
-(id)initWithX:(int)x_ Y:(int)y_;
/// copy constructor
-(id)initWithBlock:(Block*)block_;

/// add a cube in the block. xy represents the local position within the block. 
/// they are only relative to the block
-(void)loadCubeWithX:(int)x_ Y:(int)y_ color:(CubeColor)color_ type:(CubeType)type_;

/// rotate block
-(void)rotate;

/// return a set of cubes whose position are relative to the board
-(NSMutableSet*)getCubeSetToBoard;

/** 
 * Navigation. These operations simply perform the movement without border checking
 * all border checkings should be done after a movement.
 */

-(void)moveLeft;
-(void)moveRight;
-(void)moveDown;
-(void)moveReset;

/// for testing display
-(void)printBlock;


@property(assign) float x;
@property(assign) float y;
@property(retain) NSMutableSet *cubeSet;
@property(readonly) int maxX;
@property(readonly) int maxY;

@end
