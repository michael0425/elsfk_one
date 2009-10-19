//
//  Board.h
//  GameModel
//
//  Created by Yanlong Zhang on 14/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block.h"


@interface Board : NSObject {
	int x;
	int y;
	BOOL **poArray;
	Block *currentBlock;
}

@property(readonly) int x;
@property(readonly) int y;
@property(retain) Block *currentBlock;


-(id)initWithX:(int)x_ Y:(int)y_;

//return YES if the block can be shown in the board.
-(BOOL)validateBlock:(Block*)block_;
-(BOOL)validateCube:(Cube *)cube_;

// make current block solid and remove it out of currenBlock.
// this is used when a block hits the ground.
-(void)landCurrentBlock;

-(void)setBoardWithCubeSet:(NSSet *)cubeSet status:(BOOL)status_;
//set viewable status with a block in this board
-(void)setBoardWithBlock:(Block*)block_ status:(BOOL)status_;
-(void)setArrayCubeStatusWithX:(int)x_ Y:(int)y_ status:(BOOL)status_;

-(void)clearCurrentBlock;

-(void)printBoard;

@end
