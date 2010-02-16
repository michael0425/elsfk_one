//
//  Cube.m
//  GameModel
//
//  Created by Yanlong Zhang on 13/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Cube.h"


@implementation Cube

@synthesize x;
@synthesize y;
@synthesize color;
@synthesize type;

-(id)init;
{
	return [self initWithX:0 Y:0];
}
-(id)initWithX:(int)gX Y:(int)gY
{
	return [self initWithX:gX Y:gY color:RED type:SOLID];
}
-(id)initWithX:(int)gX Y:(int)gY color:(CubeColor)gColor type:(CubeType)gType
{
	if (self = [super init]) {
		self.x = gX;
		self.y = gY;
		self.color = gColor;
		self.type = gType;
	}
	
	//NSLog(@"Created %@",self);
	return self;
}

-(id)initWithCube:(Cube*)cube_
{
	return [self initWithX:cube_.x Y:cube_.y color:cube_.color type:cube_.type];
}

-(GLfloat*)getCubeVertexWithUnit:(int)unit;
{
	GLfloat *vertex;
	vertex = calloc(8, sizeof(GLfloat));
	vertex[0] = x;
	vertex[1] = y;
	vertex[2] = x + unit;
	vertex[3] = y;
	vertex[4] = x + unit;
	vertex[5] = y - unit;
	vertex[6] = x;
	vertex[7] = y - unit;
	
	return vertex;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"Cube with X:%d Y:%d Color:%d Type:%d", 
			self.x, self.y, self.color, self.color];
}

-(BOOL)compareWithCube:(Cube *)cube
{
	if (self.x == cube.x && self.y == cube.y) {
		return YES;
	}
	return NO;
}

-(void)shiftDownInBoardAtLine:(NSNumber*)line;
{
	if (y < [line intValue]) {
		y++;
	}
}

-(void)dealloc
{
	//NSLog(@"####Deallocing %@", self);
	[super dealloc];
}


@end
