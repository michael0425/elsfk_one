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
	NSLog(@"Created %@",self);
	return self;
}

-(id)initWithCube:(Cube*)cube_
{
	return [self initWithX:cube_.x Y:cube_.y color:cube_.color type:cube_.type];
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"Cube with X:%d Y:%d Color:%d Type:%d", 
			self.x, self.y, self.color, self.color];
}

-(void)dealloc
{
	NSLog(@"####Deallocing %@", self);
	[super dealloc];
}


@end
