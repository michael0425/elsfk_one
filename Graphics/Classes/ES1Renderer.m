//
//  ES1Renderer.m
//  Graphics
//
//  Created by Lyss on 20/10/2009.
//  Copyright Bangboo 2009. All rights reserved.
//

#import "ES1Renderer.h"


@implementation ES1Renderer

@synthesize controller;

- (id) initWithGameController: (GameController*) _controller{
	if (self = [self init]){
		controller = _controller;
		[controller retain];
	}
	return self;
}

// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            [self release];
            return nil;
        }
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		
		
		screenBounds = [[UIScreen mainScreen] bounds];
		
		
		//clear colour
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		//disable depth test, 2D only
		glDisable(GL_DEPTH_TEST);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
		glEnableClientState(GL_VERTEX_ARRAY);
		//setup projection
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof(0.0f, screenBounds.size.width, 0.0f, screenBounds.size.height, -1.0f, 1.0f);
		
		
		
		//create a cube texture
		NSLog(@"initialized");
		cubeTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"grey.jpg"]];
		imageTexture = [[Image alloc] initWithTexture:cubeTexture];
	}
	
	return self;
}

- (void) render
{	
	// This application only creates a single context which is already set current at this point.
	// This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
    
	// This application only creates a single default framebuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	
	
	
	
	
    // Define the viewport.  Changing the settings for the viewport can allow you to scale the viewport
	// as well as the dimensions etc and so I'm setting it for each frame in case we want to change it
	glViewport(0, 0, screenBounds.size.width , screenBounds.size.height);
	
	// Clear the screen.  If we are going to draw a background image then this clear is not necessary
	// as drawing the background image will destroy the previous image
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Setup how the images are to be blended when rendered.  This could be changed at different points during your
	// render process if you wanted to apply different effects
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	
	
	[self drawCubes];

	
	// This application only creates a single color renderbuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void) drawCubes{
	static GLfloat ty = 0.0f;
	
	//draw a square using texture class
	//glEnable(GL_TEXTURE_2D);
	//glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	//NSLog(@"       controller.currentBlock x:%u  y:%u", controller.currentBlock.x, controller.currentBlock.y);
	
	NSMutableSet* cubes = [controller.currentBlock getCubeSetToBoard];
	
	[cubes retain];
	NSEnumerator* enumerator = [cubes objectEnumerator];
	Cube *aCube = nil;
	while (aCube = (Cube*)[enumerator nextObject]) {
		[aCube retain];
		//NSLog(@"       cube x:%u  y:%u", aCube.x, aCube.y);
		[aCube getCubeVertexWithUnit:20];
		
		
		//[cubeTexture drawInRect:CGRectMake(aCube.x * 20, aCube.y * 20, 20, 20)];
		imageTexture.scaleX = 20/(float)imageTexture.imageWidth;
		imageTexture.scaleY = 20/(float)imageTexture.imageHeight;
		GLfloat filter[] = {1.0f, 0.0f,0.0f,1.0f};
		imageTexture.colourFilter = filter;
		[imageTexture renderToPos:CGPointMake(aCube.x * 20, 480-aCube.y * 20)];
		
	}
	[cubes release];
	
	//glDisableClientState(GL_VERTEX_ARRAY);
	//glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	//glDisable(GL_TEXTURE_2D);
	
	ty+=2.0f;
	if(ty>=420)
		ty = 0.0f;
	
}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void) dealloc
{
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}

	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
	
	[super dealloc];
}

@end
