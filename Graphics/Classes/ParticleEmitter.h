//
//  ParticleEmitter.h
//  Graphics
//
//  Created by Liy on 10-2-2.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Common.h"

@interface ParticleEmitter : NSObject {
	
	//the texture will be bind to the point sprite
	Image* image;
	
	//start from where
	Vector2f startPosition;
	Vector2f startPositionVariance;
	
	//which direction is this particle going
	GLfloat angle;
	GLfloat angleVariance;
	//speed and angle together can form a directed speed vector
	GLfloat speed;
	GLfloat speedVariance;
	
	//gravity can be apply to x or y
	Vector2f gravity;
	
	//how many mini seconds particle will be living
	GLfloat particleLifespan;
	GLfloat particleLifespanVariance;
	
	//start color
	Color4f startColor;
	Color4f startColorVariance;
	
	//end color
	Color4f endColor;
	Color4f endColorVariance;
	
	//TODO start and end size
	//how big is the particle
	GLfloat particleSize;
	GLfloat particleSizeVariance;
	
	GLuint maxParticles;
	
	//number of active particles(which are going to be drawn onto the screen)
	GLuint numActiveParticles;
	
	
	//NOT sure how it works at the moment
	GLfloat emitRate;
	GLfloat emitTimer;
	
	//not sure 
	GLuint verticesID;
	GLuint colorsID;
	
	//holds all the data information of every particles. In MVC, can be seen as a model.
	Particle* particles;
	//The actual vertices need to be rendered, can be seen as a view
	PointSprite* vertices;
	//Contains the color information for every vertices.
	Color4f* colors;
	
	//emit particles or not.
	BOOL active;
	
	//Used to index the particles.
	GLuint particleIndex;
	
	//how many mini seconds has past since the particle is emitted.
	GLfloat elapsedTime;
	//how many mini seconds this emitter should run. -1 forever.
	GLfloat duration;
	
	//use blend or not
	BOOL blend;
}

@property(nonatomic, retain) Image *image;
@property(nonatomic, assign) Vector2f startPosition;
@property(nonatomic, assign) Vector2f startPositionVariance;
@property(nonatomic, assign) GLfloat angle;
@property(nonatomic, assign) GLfloat angleVariance;
@property(nonatomic, assign) GLfloat speed;
@property(nonatomic, assign) GLfloat speedVariance;
@property(nonatomic, assign) Vector2f gravity;
@property(nonatomic, assign) GLfloat particleLifespan;
@property(nonatomic, assign) GLfloat particleLifespanVariance;
@property(nonatomic, assign) Color4f startColor;
@property(nonatomic, assign) Color4f startColorVariance;
@property(nonatomic, assign) Color4f endColor;
@property(nonatomic, assign) Color4f endColorVariance;
@property(nonatomic, assign) GLfloat particleSize;
@property(nonatomic, assign) GLfloat particleSizeVariance;
@property(nonatomic, assign) GLuint maxParticles;
@property(nonatomic, assign) GLuint numActiveParticles;
@property(nonatomic, assign) GLfloat emitRate;
@property(nonatomic, assign) GLfloat emitTimer;
@property(nonatomic, assign) BOOL active;
@property(nonatomic, assign) GLfloat duration;
@property(nonatomic, assign) BOOL blend;

- (id)initParticleEmitterWithImageNamed:(NSString*)name
						  startPosition:(Vector2f)startPos 
				  startPositionVariance:(Vector2f)startPosVariance
								  speed:(GLfloat)aSpeed
						  speedVariance:(GLfloat)aSpeedVariance 
					   particleLifeSpan:(GLfloat)lifeSpan
			   particleLifespanVariance:(GLfloat)lifeSpanVariance 
								  angle:(GLfloat)aAngle 
						  angleVariance:(GLfloat)aAngleVariance 
								gravity:(Vector2f)aGravity
							 startColor:(Color4f)aStartColor 
					 startColorVariance:(Color4f)aStartColorVariance
							   endColor:(Color4f)aEndColor 
					   endColorVariance:(Color4f)aEndColorVariance
						   maxParticles:(GLuint)aMaxParticles 
						   particleSize:(GLfloat)aParticleSize
				   particleSizeVariance:(GLfloat)aParticleSizeVariance
							   duration:(GLfloat)aDuration
								  blend:(BOOL)flag;

- (void)renderParticles;
- (void)update:(GLfloat)delta;
- (BOOL)addParticle;
- (void)initParticle:(Particle*)particle;
- (void)stop;

@end
