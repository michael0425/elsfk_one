//
//  SpriteSheet.h
//  Graphics
//
//  Created by Liy on 10-1-28.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface SpriteSheet : NSObject {

	Image* image;
	
	GLfloat spriteWidth;
	
	GLfloat spriteHeight;
	
	GLfloat spacing;
}

@property (nonatomic, readonly) Image* image;
@property (nonatomic) GLfloat spriteWidth;
@property (nonatomic) GLfloat spriteHeight;
@property (nonatomic) GLfloat spacing;

- (id) initWithImage:(Image*)img spriteWidth:(GLfloat)width spriteHeight:(GLfloat)height spacing:(GLfloat)space;

- (id) initWithImageNamed:(NSString*)imageName spriteWidth:(GLfloat)width spriteHeight:(GLfloat)height spacing:(GLfloat)space;

- (Image*) getSpriteAtRow:(GLuint) row column:(GLuint)column;


@end
