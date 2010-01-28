//
//  SpriteSheet.m
//  Graphics
//
//  Created by Liy on 10-1-28.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "SpriteSheet.h"


@implementation SpriteSheet

@synthesize spriteWidth;
@synthesize spriteHeight;
@synthesize image;
@synthesize spacing;

- (id) initWithImage:(Image *)img spriteWidth:(GLfloat)width spriteHeight:(GLfloat)height spacing:(GLfloat)space{
	if (self = [super init]) {
		image = [img retain];
		spriteWidth = width;
		spriteHeight = height;
		spacing = space;
		
	}
	return self;
}

- (id) initWithImageNamed:(NSString *)imageName spriteWidth:(GLfloat)width spriteHeight:(GLfloat)height spacing:(GLfloat)space{
	if (self = [super init]) {
		image = [[Image alloc] initWithImage:[UIImage imageNamed:imageName]];
		spriteWidth = width;
		spriteHeight = height;
		spacing = space;
	}
	return self;
}

- (Image*) getSpriteAtRow:(GLuint)row column:(GLuint)column{
	image.textureOffsetX = (column-1)*spriteWidth;
	image.textureOffsetY = (row-1)*spriteHeight;
	image.imageWidth = spriteWidth;
	image.imageHeight = spriteHeight;
	return image;
}

- (void) dealloc{
	[image release];
	[super dealloc];
}

@end
