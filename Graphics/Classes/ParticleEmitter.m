//
//  ParticleEmitter.m
//  Graphics
//timeToLive
//  Created by Liy on 10-2-2.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "ParticleEmitter.h"


@implementation ParticleEmitter

@synthesize image;
@synthesize startPosition;
@synthesize startPositionVariance;
@synthesize angle;
@synthesize angleVariance;
@synthesize speed;
@synthesize speedVariance;
@synthesize gravity;
@synthesize particleLifespan;
@synthesize particleLifespanVariance;
@synthesize startColor;
@synthesize startColorVariance;
@synthesize endColor;
@synthesize endColorVariance;
@synthesize particleSize;
@synthesize particleSizeVariance;
@synthesize maxParticles;
@synthesize duration;
@synthesize blend;
@synthesize numActiveParticles;
@synthesize emitRate;
@synthesize emitTimer;
@synthesize active;

- (id) initParticleEmitterWithImageNamed:(NSString*)name
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
								   blend:(BOOL)flag{
	if (self = [self init]) {
		image = [[Image alloc] initWithImage:[UIImage imageNamed:name]];
		startPosition = startPos;
		startPositionVariance = startPosVariance;
		speed = aSpeed;
		speedVariance = aSpeedVariance;
		particleLifespan = lifeSpan;
		particleLifespanVariance = lifeSpanVariance;
		angle = aAngle;
		angleVariance = aAngleVariance;
		gravity = aGravity;
		startColor = aStartColor;
		startColorVariance = aStartColorVariance;
		endColor = aEndColor;
		endColorVariance = aEndColorVariance;
		maxParticles = aMaxParticles;
		particleSize = aParticleSize;
		particleSizeVariance = aParticleSizeVariance;
		duration = aDuration;
		blend = flag;
		
		
		numActiveParticles = 0;
		emitRate = maxParticles/particleLifespan;
		emitTimer = 0;
		active = YES;
		
		particleIndex = 0;
		elapsedTime = 0;
		
		particles = calloc(maxParticles, sizeof(Particle));
		vertices = calloc(maxParticles, sizeof(PointSprite));
		colors = calloc(maxParticles, sizeof(Color4f));
		
		if(!(particles && vertices && colors)) {
			NSLog(@"WARNING: ParticleEmitter - Not enough memory");
			if(particles)
				free(particles);
			if(vertices)
				free(vertices);
			if(colors)
				free(colors);
			return nil;
		}
		
		// Generate the video buffer objects. Store vertices array data in the graphics memory.
		glGenBuffers(1, &verticesID);
		glGenBuffers(1, &colorsID);
	}
	return self;
}

- (BOOL) addParticle{
	if (numActiveParticles == maxParticles) {
		return NO;
	}
	
	//get the particle memory space.
	Particle* particle = &particles[numActiveParticles];
	//initialize the particle
	[self initParticle:particle];
	
	//keep track of number of active particles.
	++numActiveParticles;
	
	return YES;
}

- (void) initParticle:(Particle*)particle{
	//init particle position
	particle->position.x = startPosition.x + startPositionVariance.x * RANDOM_MINUS_1_TO_1();
	particle->position.y = startPosition.y + startPositionVariance.y * RANDOM_MINUS_1_TO_1();
	
	particle->size = particleSize + particleSizeVariance * RANDOM_MINUS_1_TO_1();
	
	particle->timeToLive = particleLifespan + particleLifespanVariance * RANDOM_MINUS_1_TO_1();
	
	//calculate the direction vector for the particle.
	float radians = (float)DEGREES_TO_RADIANS(angle + angleVariance * RANDOM_MINUS_1_TO_1());
	Vector2f angleVector = Vector2fMake(cosf(radians), sinf(radians));
	particle->direction = Vector2fMultiply(angleVector, speed + speedVariance * RANDOM_MINUS_1_TO_1());
	
	Color4f sc = {0.0f, 0.0f, 0.0f, 0.0f};
	sc.r = startColor.r + startColorVariance.r * RANDOM_MINUS_1_TO_1();
	sc.g = startColor.g + startColorVariance.g * RANDOM_MINUS_1_TO_1();
	sc.b = startColor.b + startColorVariance.b * RANDOM_MINUS_1_TO_1();
	sc.a = startColor.a + startColorVariance.a * RANDOM_MINUS_1_TO_1();
	particle->color = sc;
	
	Color4f ec = {0.0f, 0.0f, 0.0f, 0.0f};
	ec.r = endColor.r + endColorVariance.r * RANDOM_MINUS_1_TO_1();
	ec.g = endColor.g + endColorVariance.g * RANDOM_MINUS_1_TO_1();
	ec.b = endColor.b + endColorVariance.b * RANDOM_MINUS_1_TO_1();
	ec.a = endColor.a + endColorVariance.a * RANDOM_MINUS_1_TO_1();
	
	//delta color
	particle->deltaColor.r = (ec.r - sc.r)/particle->timeToLive;
	particle->deltaColor.g = (ec.g - sc.g)/particle->timeToLive;
	particle->deltaColor.b = (ec.b - sc.b)/particle->timeToLive;
	particle->deltaColor.a = (ec.a - sc.a)/particle->timeToLive;
}

- (void) update:(GLfloat)delta{
	//if the emitter is not active, do not add any more active particles.
	//but the remaining active particle will continue be updated.
	if (active) {
		uint howmanyToEmit = emitRate * delta;
		while (numActiveParticles<maxParticles && howmanyToEmit>0) {
			[self addParticle];
			--howmanyToEmit;
		}
		
		//update the elapsed time of this emitter
		elapsedTime += delta;
		//has passed this emitter's life time, and the duration life time is not set to -1(play forever)
		if(elapsedTime>duration && duration != -1)
			[self stop];
	}
	
	
	//index into the active particles, used for scanning them.
	particleIndex = 0;
	//continue update the remaining active particles.
	while (particleIndex < numActiveParticles) {
		//get the particle, get ready to update.
		Particle* particle = &particles[particleIndex];
		
		//if the particle still has time to live.
		if(particle->timeToLive > 0){
			//update direction vector
			particle->direction = Vector2fAdd(particle->direction, gravity);
			//update position using direction vector. delta is used to calculate corret direction vector, since update method
			//will not always be call accurately in every mini-second.
			//particle->position = Vector2fAdd(particle->position, Vector2fMultiply(particle->direction, delta));
			particle->position = Vector2fAdd(particle->position, particle->direction);
			
			//update the vertices array with updated particle position
			vertices[particleIndex].x = particle->position.x;
			vertices[particleIndex].y = particle->position.y;
			
			//update the vertices size with current particle size
			//TODO: update particle size.
			vertices[particleIndex].size = particle->size;
			
			//Update particles color
			particle->color.r += (particle->deltaColor.r * delta);
			particle->color.g += (particle->deltaColor.g * delta);
			particle->color.b += (particle->deltaColor.b * delta);
			particle->color.a += (particle->deltaColor.a * delta);
			
			//Update the color of the current particle with the color array
			colors[particleIndex] = particle->color;
			
			//deduct the time past.
			particle->timeToLive -= delta;
			
			//get ready to scan next particle
			++particleIndex;
		}
		else {
			if(particleIndex != numActiveParticles-1)
				particles[particleIndex] = particles[numActiveParticles-1];
			--numActiveParticles;
		}
	}
	
	//Now we have updated all the particles, update the VBOs with the arrays we have just updated
	glBindBuffer(GL_ARRAY_BUFFER, verticesID);
	//FIXME: using maxParticles or just the actived number of particles??????????????????????????????????????????????????????????
	glBufferData(GL_ARRAY_BUFFER, sizeof(PointSprite)*maxParticles, vertices, GL_DYNAMIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, colorsID);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Color4f)*maxParticles, colors, GL_DYNAMIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void) renderParticles{
	//re-enable 
	glEnable(GL_TEXTURE_2D);
	
	// Enable texturing and bind the texture to be used as the point sprite
	glBindTexture(GL_TEXTURE_2D, [[image texture] name]);
	
	// Enable and configure blending
	glEnable(GL_BLEND);
	
	// Change the blend function used if blendAdditive has been set
	if(blend) {
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	} else {
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}
	
	// Enable and configure point sprites which we are going to use for our particles
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvi( GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE );
	
	// Enable vertex arrays and bind to the vertices VBO which has been created
	glEnableClientState(GL_VERTEX_ARRAY);
	glBindBuffer(GL_ARRAY_BUFFER, verticesID);
	
	// Configure the vertex pointer which will use the vertices VBO
	glVertexPointer(2, GL_FLOAT, sizeof(PointSprite), 0);
	
	// Enable the point size array
	glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
	
	// Configure the point size pointer which will use the currently bound VBO.  PointSprite contains
	// both the location of the point as well as its size, so the config below tells the point size
	// pointer where in the currently bound VBO it can find the size for each point
	glPointSizePointerOES(GL_FLOAT,sizeof(PointSprite),(GLvoid*) (sizeof(GL_FLOAT)*2));
	
	// Enable the use of the color array
	glEnableClientState(GL_COLOR_ARRAY);
	
	// Bind to the color VBO which has been created
	glBindBuffer(GL_ARRAY_BUFFER, colorsID);
	
	// Configure the color pointer specifying how many values there are for each color and their type
	glColorPointer(4,GL_FLOAT,0,0);
	
	// Now that all of the VBOs have been used to configure the vertices, pointer size and color
	// use glDrawArrays to draw the points
	glDrawArrays(GL_POINTS, 0, particleIndex);
	
	// Unbind the current VBO
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	
	// Disable the client states which have been used incase the next draw function does 
	// not need or use them
	glDisableClientState(GL_POINT_SPRITE_OES);
	glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_POINT_SPRITE_OES);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void) stop{
	active = NO;
	elapsedTime = 0;
	emitTimer = 0;
}

- (void) dealloc{
	free(vertices);
	free(colors);
	free(particles);
	
	glDeleteBuffers(1, &verticesID);
	glDeleteBuffers(1, &colorsID);
	
	if (image != nil)
		[image release];
	
	[super dealloc];
}

@end
