//
//  Block.h
//  GameModel
//
//  Created by Yanlong Zhang on 13/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cube.h"


@interface Block : NSObject {
	// this x and y is used to indicate the position of this block in the bigger board
	// all he cubes contained in this block will need thses values to calculate the real
	// location in the board.
	int x;
	int y;
	NSMutableArray *cubeSet;
	
	@private
	int maxX;
	int maxY;
	int preX;
	int preY;
	BOOL cubeSetToBoardEnabled;
	BOOL cubeSetNextStatusEnabled;
}


-(id)initWithX:(int)x_ Y:(int)y_ capacity:(int)cap_;
-(id)initWithX:(int)x_ Y:(int)y_;
-(id)initWithBlock:(Block*)block_;


-(void)loadCubeWithX:(int)x_ Y:(int)y_ color:(CubeColor)color_ type:(CubeType)type_;

-(void)rotate;

-(NSMutableArray*)getCubeSetToBoard;

// navigation
-(void)moveLeft;
-(void)moveRight;
-(void)moveDown;
-(void)moveReset;

// for testing display
-(void)printBlock;


@property(assign) int x;
@property(assign) int y;
@property(retain) NSMutableArray *cubeSet;

@end
