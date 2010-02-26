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
#import "ESRenderer.h"
#import "ParticleEmitter.h"

@interface GameController : UIViewController {
	id <ESRenderer> renderer;
	Block* currentBlock;
	Board* board;
	BlockFactory* blockFactory;
	
	GLfloat fallRate;
	GLfloat fallTimer;
	
	NSTimer *pressTimer;
	
	CGPoint pressPoint;
	
	ParticleEmitter* fountain;
	ParticleEmitter* fire;
	ParticleEmitter* smoke;
}

@property (readonly) Board* board;
@property (nonatomic, retain) Block* currentBlock;

- (id)initWithRender:(id <ESRenderer>)aRenderer;
- (void) update: (float)delta;


@end
