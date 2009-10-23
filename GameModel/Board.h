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
}

@property(readonly) int x;
@property(readonly) int y;
@property(retain) Block *currentBlock;
@property(readonly) int unit;


-(id)initWithX:(int)gX Y:(int)gY;

//return YES if the block can be shown in the board.
-(BOOL)validateBlock:(Block*)block;
-(BOOL)validateCube:(Cube *)cube;

// make current block solid and remove it out of currenBlock.
// this is used when a block hits the ground.
-(void)landCurrentBlock;

-(void)setBoardWithCubeSet:(NSArray *)cubeSet;
//set viewable status with a block in this board
-(void)setBoardWithBlock:(Block*)block;
-(void)setArrayCubeTypeWithX:(int)gX Y:(int)gY type:(CubeType)type;
-(void)clearBoardWithBlock:(Block*)block;
-(void)clearBoardWithCubeSet:(NSArray*)cubeSet;

-(GLfloat*)getCubeVertex:(Cube*)cube;

-(void)clearCurrentBlock;

-(void)printBoard;

@end
