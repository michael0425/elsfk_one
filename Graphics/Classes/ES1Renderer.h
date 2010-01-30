//
//  ES1Renderer.h
//  Graphics
//
//  Created by Lyss on 20/10/2009.
//  Copyright Bangboo 2009. All rights reserved.
//

#import "ESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Texture2D.h"
#import "Cube.h"
#import "GameController.h"
#import "Image.h"
#import "SpriteSheet.h"
#import "Animation.h"

@interface ES1Renderer : NSObject <ESRenderer>
{
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
	
	CGRect screenBounds;
	
	Texture2D* cubeTexture;
	
	GameController* controller;
	
	Image* imageTexture;
	
	SpriteSheet* spriteSheet;
	
	Animation* animation;
}

@property (readonly) GameController* controller;

- (void) render;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;
- (id) initWithGameController: (GameController*) controller;
- (void) drawCubes;

@end
