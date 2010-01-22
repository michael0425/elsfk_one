//
//  The main game controller to handle UIEvent. All the handlers should be placed here.
//	
//  Created by Lyss on 03/11/2009.
//  Copyright 2009 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Board.h"

@interface GameController : UIViewController {
	Board* board;
	Block* currentBlock;
}

@property (readonly) Board* board;
@property (readonly) Block* currentBlock;

- (void) mainGameLoop;
- (Block*) createBlock;

@end
