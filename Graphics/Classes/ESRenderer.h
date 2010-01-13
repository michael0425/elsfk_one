//
//  ESRenderer.h
//  Graphics
//
//  Created by Lyss on 20/10/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@protocol ESRenderer <NSObject>

- (void) render: (NSMutableArray*) cubes;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;

@end
