//
//  The main game controller to handle UIEvent. All the handlers should be placed here.
//	
//  Created by Lyss on 03/11/2009.
//  Copyright 2009 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Board.h"
#import "ESRenderer.h"

@interface GameController : UIViewController {
	id <ESRenderer> renderer;
	Block* currentBlock;
	Board* board;
	
	GLfloat fallRate;
	GLfloat fallTimer;
}

@property (readonly) Board* board;

- (id)initWithRender:(id <ESRenderer>)aRenderer;
- (void) update: (float)delta;

@end
