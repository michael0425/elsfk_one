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
@synthesize scaleX;
@synthesize scaleY;
@synthesize rotation;

- (id) initWithImage:(Image *)img spriteWidth:(GLfloat)width spriteHeight:(GLfloat)height spacing:(GLfloat)space{
	if (self = [super init]) {
		image = [img retain];
		spriteWidth = width;
		spriteHeight = height;
		spacing = space;
		scaleX = 1.0f;
		scaleY = 1.0f;
		rotation = 0.0f;
		
	}
	return self;
}

- (id) initWithImageNamed:(NSString *)imageName spriteWidth:(GLfloat)width spriteHeight:(GLfloat)height spacing:(GLfloat)space{
	if (self = [super init]) {
		image = [[Image alloc] initWithName:imageName];
		spriteWidth = width;
		spriteHeight = height;
		spacing = space;
		scaleX = 1.0f;
		scaleY = 1.0f;
		rotation = 0.0f;
	}
	return self;
}

- (Image*) getSpriteAtRow:(GLuint)row column:(GLuint)column{
	Image* img = [image getSubImageAtPoint:CGPointMake((column-1)*spriteWidth, (row-1)*spriteHeight) subImageWidth:spriteWidth subImageHeight:spriteHeight];
	img.scaleX = scaleX;
	img.scaleY = scaleY;
	img.rotation = rotation;
	return img;
}

- (void) renderSpriteToPos:(CGPoint)pos AtRow:(GLuint)row column:(GLuint)column centreImage:(BOOL)flag{
	CGPoint offset = CGPointMake((column-1)*spriteWidth, (row-1)*spriteHeight);
	image.scaleX = scaleX;
	image.scaleY = scaleY;
	image.rotation = rotation;
	[image renderSubImageTo:pos offsetPoint:offset subImageWidth:spriteWidth subImageHeight:spriteHeight centreImage:flag];
}

- (void) dealloc{
	[image release];
	[super dealloc];
}

@end
