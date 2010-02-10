//
//  
//	The main game controller process game logic and to handle UIEvent. All the ui touches handlers should be placed here.
//
//  Created by Lyss on 03/11/2009.
//  Copyright 2009 Bangboo. All rights reserved.
//

#import "GameController.h"
#import "ES1Renderer.h"
#import <Foundation/Foundation.h>

@interface GameController()
- (BOOL)point:(CGPoint)point hitArea:(CGRect)rect;
- (void)controlBlock;
@end


@implementation GameController
/**
 *
 */
@synthesize board;

- (id)initWithRender:(id <ESRenderer>)aRenderer{
	if (self = [super init]) {
		renderer = aRenderer;
		[self init];
	}
	return self;
}

/**
 * 
 *
 *
 */
- (id) init{
	if (self = [super init])
	{
		fallRate = 0.3f;
		fallTimer = 0.0f;
		
		currentBlock = [[Block alloc] init];
		[currentBlock loadCubeWithX:0 Y:0 color:RED type:SOLID];
		[currentBlock loadCubeWithX:0 Y:1 color:RED type:SOLID];
		[currentBlock loadCubeWithX:0 Y:2 color:RED type:SOLID];
		[currentBlock loadCubeWithX:1 Y:2 color:RED type:SOLID];
		
		board = [[Board sharedBoard] initWithX:16 Y:24];
		
		board.currentBlock = currentBlock;
		
		fountain = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																startPosition:Vector2fMake(160, 240)
														startPositionVariance:Vector2fMake(5, 10)
																  speedPerSec:300.0
														  speedPerSecVariance:100.0
															 particleLifeSpan:1.0f
													 particleLifespanVariance:1.0f
																		angle:-90.0f
																angleVariance:20.0f
																	  gravity:Vector2fMake(0.0f, 8.0f)
																   startColor:Color4fMake(0.6f, 0.8f, 0.8f, 0.8f)
														   startColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.2f)
																	 endColor:Color4fMake(0.5f, 0.5f, 0.5f, 0.0f)
															 endColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.0f)
																 maxParticles:600
																 particleSize:15.0f
														 particleSizeVariance:5.0f
															  endParticleSize:1.0f
													  endParticleSizeVariance:1.0f
																	 duration:-1.0f
																		blend:YES];
		
		fire = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
															startPosition:Vector2fMake(80, 240)
													startPositionVariance:Vector2fMake(10, 15)
															  speedPerSec:50.0
													  speedPerSecVariance:70.0
														 particleLifeSpan:1.0f
												 particleLifespanVariance:0.5f
																	angle:-90.0f
															angleVariance:10.0f
																  gravity:Vector2fMake(0.0f, 0.0f)
															   startColor:Color4fMake(1.0f, 0.3f, 0.0f, 0.8f)
													   startColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.2f)
																 endColor:Color4fMake(0.9f, 0.1f, 0.0f, 0.0f)
														 endColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.1f)
															 maxParticles:400
															 particleSize:20.0f
													 particleSizeVariance:15.0f
														  endParticleSize:10.0f
												  endParticleSizeVariance:15.0f
																 duration:-1.0f
																	blend:YES];
		
		smoke = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
															 startPosition:Vector2fMake(240, 240)
													 startPositionVariance:Vector2fMake(5, 20)
															   speedPerSec:32.0
													   speedPerSecVariance:30.0
														  particleLifeSpan:1.5f
												  particleLifespanVariance:3.0f
																	 angle:-90.0f
															 angleVariance:20.0f
																   gravity:Vector2fMake(0.2f, 0.0f)
																startColor:Color4fMake(0.5f, 0.5f, 0.5f, 0.3f)
														startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.3f)
																  endColor:Color4fMake(0.5f, 0.5f, 0.5f, 0.0f)
														  endColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
															  maxParticles:100
															  particleSize:30.0f
													  particleSizeVariance:10.0f
														   endParticleSize:50.0f
												   endParticleSizeVariance:40.0f
																  duration:-1.0f
																	 blend:YES];
	}
	return self;
}

- (void) dealloc{
	[board release];
	[super dealloc];
}

- (BOOL)point:(CGPoint)point hitArea:(CGRect)rect{
	if (point.x < rect.origin.x || point.y < rect.origin.y ||
		point.x > (rect.origin.x + rect.size.width) || point.y > (rect.origin.y + rect.size.height)) {
		return NO;
	}
	return YES;
}

/**
 *
 *
 */
- (void) update:(float)delta{
	//update game logic
	fallTimer += delta;
	if (fallTimer>=fallRate) {
		//NSLog(@"fallTimer: %f    fallRate: %f", fallTimer, fallRate);
		[currentBlock moveDown];
		if (![board validateBlock:currentBlock]) {
			[board landCurrentBlock];
			
			
			currentBlock = [[Block alloc] init];
			[currentBlock loadCubeWithX:0 Y:0 color:RED type:SOLID];
			[currentBlock loadCubeWithX:0 Y:1 color:RED type:SOLID];
			[currentBlock loadCubeWithX:0 Y:2 color:RED type:SOLID];
			[currentBlock loadCubeWithX:1 Y:2 color:RED type:SOLID];
			board.currentBlock = currentBlock;
			
		}
		
		fallTimer -= fallRate;
	}
	//update particle
	[fire update:delta];
	[smoke update:delta];
	[fountain update:delta];
	
	//testing for particle movement
	GLfloat dx = pressPoint.x - fountain.startPosition.x;
	GLfloat dy = pressPoint.y - fountain.startPosition.y;
	//Vector2f fountainNewPos = Vector2fMake(fountain.startPosition.x + dx/10.0f, fountain.startPosition.y + dy/10.0f);
	//fountain.startPosition = fountainNewPos;
	dx = pressPoint.x - fire.startPosition.x;
	dy = pressPoint.y - fire.startPosition.y;
	Vector2f fireNewPos = Vector2fMake(fire.startPosition.x + dx/20.0f, fire.startPosition.y + dy/20.0f);
	fire.startPosition = fireNewPos;
	//dx = pressPoint.x - smoke.startPosition.x;
	//dy = pressPoint.y - smoke.startPosition.y;
	//Vector2f smokeNewPos = Vector2fMake(smoke.startPosition.x + dx/30.0f, smoke.startPosition.y + dy/30.0f);
	//smoke.startPosition = smokeNewPos;
	
	//render
	[renderer startRender];
	[fire renderParticles];
	[smoke renderParticles];
	[fountain renderParticles];
	[renderer drawCubes:board.poCubeSet];
	[renderer endRender];
}

- (void)controlBlock{
	//NSLog(@"position: x:%f y:%f", pos.x, pos.y);
	//NSLog(@"blockRect: x:%f y:%f width:%f height:%f", blockRect.origin.x, blockRect.origin.y, blockRect.size.width, blockRect.size.height);
		
	CGRect blockRect = CGRectMake(currentBlock.x*20.0f, currentBlock.y*20.0f, (currentBlock.maxX+1)*20.0f, (currentBlock.maxY+1)*20.0f);
		
	if(pressPoint.x < blockRect.origin.x) {
		[currentBlock moveLeft];
		[board validateBlock:currentBlock];
	}
	else if(pressPoint.x > (blockRect.origin.x + blockRect.size.width)) {
		[currentBlock moveRight];
		[board validateBlock:currentBlock];
	}
}

/**
 * Handle main game view touch begin events.
 * @param touches The NSSet of touches received.
 * @param event An UIEvent.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//touch begin, check whether the block is touched or empty space is touched.
	UITouch* touch = [touches anyObject];
	pressPoint = [touch locationInView:[self view]];
	CGRect blockRect = CGRectMake(currentBlock.x*20.0f, currentBlock.y*20.0f, (currentBlock.maxX+1)*20.0f, (currentBlock.maxY+1)*20.0f);
	
	if ([self point:pressPoint hitArea:blockRect]) {
		[currentBlock rotate];
		[board validateBlock:currentBlock];
	}
	
	[self controlBlock];
	
	pressTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 10.0) target:self selector:@selector(controlBlock) userInfo:nil repeats:TRUE];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[pressTimer invalidate];
	pressTimer = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = [touches anyObject];
	pressPoint = [touch locationInView:[self view]];
}

@end
