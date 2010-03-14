//
//  The main game controller to handle UIEvent. All the handlers should be placed here.
//	
//  Created by Lyss on 03/11/2009.
//  Copyright 2009 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Board.h"
#import "BlockFactory.h"
#import "GEDirector.h"
#import "DOBoard.h"

@interface GameController : UIViewController {
	Block* currentBlock;
	Board* board;
	BlockFactory* blockFactory;
	
	CGSize cubeSize;
	
	GLfloat fallRate;
	
	NSTimer *pressTimer;
	
	CGPoint pressPoint;
	
	//engine
	GEDirector* director;
}

@property (readonly) Board* board;
@property (nonatomic, retain) Block* currentBlock;

- (void) update: (float)delta;


@end
