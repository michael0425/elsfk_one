//
//  Cube.h
//  GameModel
//
//  Created by Yanlong Zhang on 13/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


typedef enum cType {
	EMPTY,
	SOLID
}CubeType;

typedef enum cColor {
	RED 
}CubeColor;

@interface Cube : NSObject {
	int x;
	int y;
	CubeColor color;
	CubeType type;
}

-(id)init;
-(id)initWithX:(int)gX Y:(int)gY;
-(id)initWithX:(int)gX Y:(int)gY color:(CubeColor)gColor type:(CubeType)gType;
-(id)initWithCube:(Cube*)cube_;

-(GLfloat*)getCubeVertexWithUnit:(int)unit;

/**
 * When comparing cubes, only need to compare x & y
 */
-(BOOL)compareWithCube:(Cube*)cube;

/**
 * Used to shift down cubes, with boarder checking. 
 * Only move when the after state is valid
 */
-(void)shiftDownInBoardAtLine:(NSNumber*)line;

@property(assign) int x;
@property(assign) int y;
@property(assign) CubeColor color;
@property(assign) CubeType type;

@end

