//
//  ESRenderer.h
//  Graphics
//
//  Created by Lyss on 20/10/2009.
//  Copyright Bangboo 2009. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@protocol ESRenderer <NSObject>

- (void)startRender;
- (void)endRender;
- (void) render:(float)delta;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;
- (void) drawCubes:(NSMutableSet*)cubes;

@end
