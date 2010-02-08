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
@synthesize speedPerSec;
@synthesize speedPerSecVariance;
@synthesize gravity;
@synthesize particleLifespan;
@synthesize particleLifespanVariance;
@synthesize startColor;
@synthesize startColorVariance;
@synthesize endColor;
@synthesize endColorVariance;
@synthesize particleSize;
@synthesize particleSizeVariance;
@synthesize endParticleSize;
@synthesize endParticleSizeVariance;
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
							 speedPerSec:(GLfloat)aSpeedPerSec
					 speedPerSecVariance:(GLfloat)aSpeedPerSecVariance 
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
						 endParticleSize:(GLfloat)aEndParticleSize
				 endParticleSizeVariance:(GLfloat)aEndParticleSizeVariance
								duration:(GLfloat)aDuration
								   blend:(BOOL)flag{
	if (self = [self init]) {
		resourcesManager = [ResourcesManager sharedResourcesManager];
		
		image = [[Image alloc] initWithName:name];
		startPosition = startPos;
		startPositionVariance = startPosVariance;
		speedPerSec = aSpeedPerSec;
		speedPerSecVariance = aSpeedPerSecVariance;
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
		endParticleSize = aEndParticleSize;
		endParticleSizeVariance = aEndParticleSizeVariance;
		duration = aDuration;
		blend = flag;
		
		
		numActiveParticles = 0;
		//emitRate = maxParticles/particleLifespan;
		emitRate = particleLifespan/maxParticles;
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
	particle->endSize = endParticleSize + endParticleSizeVariance * RANDOM_MINUS_1_TO_1();
	
	particle->timeToLive = particleLifespan + particleLifespanVariance * RANDOM_MINUS_1_TO_1();
	
	//calculate the direction vector for the particle.
	float radians = (float)DEGREES_TO_RADIANS(angle + angleVariance * RANDOM_MINUS_1_TO_1());
	Vector2f angleVector = Vector2fMake(cosf(radians), sinf(radians));
	particle->velocity = Vector2fMultiply(angleVector, speedPerSec + speedPerSecVariance * RANDOM_MINUS_1_TO_1());
	
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
	particle->endColor = ec;
}

- (void) update:(GLfloat)delta{
	//if the emitter is not active, do not add any more active particles.
	//but the remaining active particle will continue be updated.
	if(active) {
		//keep track of time for next emit particle time point
		emitTimer += delta;
		//if not exceed maximun allowrance, and
		//The emitTimer has go over or equal emitRate(How many second emit one particle).
		//Emitter will emit one particle.
		while(numActiveParticles < maxParticles && emitTimer >= emitRate) {
			[self addParticle];
			//After emit one particle, we need to reset the emitTimer in order to track next emit time point.
			//We can not simply reset it to 0, since it will lose some of the time. This is because when this
			//update function is called, the emitTimer may already go past emitRate, for example: 1 second emit one
			//particle, but when update function is called, emitTimer is already 1.5 second. If we reset to
			//0, we will lose 0.5 second so next emit time point will be late for 0.5 second. This will cause the
			//Number of active particle will never reach the max particle allowrance.
			//FIXME: Because of the rounding float number problem, the emitTimer seem like will keep increasing.
			//may cause some problem in the future.
			emitTimer-= emitRate;
		}
		
		elapsedTime += delta;
		if(duration != -1 && duration < elapsedTime)
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
			particle->velocity = Vector2fAdd(particle->velocity, gravity);
			//update position using velocity vector. delta is used to calculate corret velocity vector, since update method
			//will not always be call accurately in every second.
			particle->position = Vector2fAdd(particle->position, Vector2fMultiply(particle->velocity, delta));
			
			//update the vertices array with updated particle position
			vertices[particleIndex].x = particle->position.x;
			vertices[particleIndex].y = particle->position.y;
			
			//update the vertices size with current particle size, make sure it is corrected using delta time
			particle->size += (particle->endSize-particle->size)/particle->timeToLive * delta;
			vertices[particleIndex].size = particle->size;
			
			//Update particles color, make sure it is corrected using delta time
			particle->color.r += (particle->endColor.r - particle->color.r)/particle->timeToLive * delta;
			particle->color.g += (particle->endColor.g - particle->color.g)/particle->timeToLive * delta;
			particle->color.b += (particle->endColor.b - particle->color.b)/particle->timeToLive * delta;
			particle->color.a += (particle->endColor.a - particle->color.a)/particle->timeToLive * delta;
			
			//Update the color of the current particle with the color array
			colors[particleIndex] = particle->color;
			
			//deduct the time past.
			particle->timeToLive -= delta;
			
			//get ready to scan next particle
			++particleIndex;
		}
		else {
			//Keep all the active particle in the front part of the whole particle array.
			//So we only scan the active particles all the time.
			//If a particle is dead, simply replace it with the last active particle, then deduct
			//the number of active particle. If the dead particle is the last one, directly reduce
			//the number of active particle by one.
			if(particleIndex != numActiveParticles-1)
				particles[particleIndex] = particles[numActiveParticles-1];
			--numActiveParticles;
		}
	}
	
	//Update the VBOs with the arrays we have just updated
	glBindBuffer(GL_ARRAY_BUFFER, verticesID);
	//FIXME: using maxParticles or just the actived number of particles???
	//From my point of view, since we only render actived particles, then we do not need to
	//allocate video buffer for maximun number of particles. It is clearly a waste of memory.
	glBufferData(GL_ARRAY_BUFFER, sizeof(PointSprite)*numActiveParticles, vertices, GL_DYNAMIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, colorsID);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Color4f)*numActiveParticles, colors, GL_DYNAMIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void) renderParticles{
	//enable texture
	glEnable(GL_TEXTURE_2D);
	
	//bind texture
	if ([[image texture] name] != resourcesManager.boundedTexture) {
		glBindTexture(GL_TEXTURE_2D, [[image texture] name]);
		resourcesManager.boundedTexture = [[image texture] name];
	}
	else {
		//NSLog(@"Already binded");
	}


	
	//enable blend
	glEnable(GL_BLEND);
	if (blend) {
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	}
	else {
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}
	
	//enable configure point sprite
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
	
	//enable vertices array and bind video object buffer for vertices
	glEnableClientState(GL_VERTEX_ARRAY);
	//the bind vertices buffer object is used by both glVertexPointer and glPointSizePointerOES.
	glBindBuffer(GL_ARRAY_BUFFER, verticesID);
	//configure the position vertices array. 
	//2 means only have x and y, no z. GL_FLOAT, define the data type which vertex array is using.
	//Since vertex array are represented in PointSprite type, so scan through the binded buffer array for every sizeOf(PointSprite) bytes 
	//you will find two GLfloat X and Y. And since they are all at first two element of PointSprite, there will no need for an offset,
	//so it is set to 0.
	glVertexPointer(2, GL_FLOAT, sizeof(PointSprite), 0);
	
	//render point size array, no need to bind the buffer since the buffer is already binded.
	glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
	//Similar to vertex array, the only difference is that, we only need the size information.
	//However the size is at the third field in PointSprite struct. Before size field, we have GLfloat typed x and y.
	//In order to find the size value in every PointSprite sized memory bytes, we have to set a offset for 2*sizeof(GLfloat).
	glPointSizePointerOES(GL_FLOAT, sizeof(PointSprite), (GLvoid*)(sizeof(GLfloat)*2));
	
	//enable color array
	glEnableClientState(GL_COLOR_ARRAY);
	glBindBuffer(GL_ARRAY_BUFFER, colorsID);
	//Color information is represented using Color4f which have continuesly 4 GLfloat value(rgba).
	//the third 0 means, every color is continuesly connected. (I think if set to sizeof(Color4f) will also work)
	//no offset needed neither.
	glColorPointer(4, GL_FLOAT, 0, 0);
	
	//now draw!!!
	glDrawArrays(GL_POINTS, 0, numActiveParticles);
	
	//unbind the buffer object
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	
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
