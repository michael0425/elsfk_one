//
//  Image.m
//  Graphics
//
//  Created by Liy on 10-1-26.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "Image.h"

//private methods
@interface Image()

//init extra vars.
- (void) extraInit;

//render the texture specified by texel coordinates to target vertices, to the position. 
- (void) renderFrom:(GLfloat[])texCoords toVertices:(GLfloat[])vertices toPos:(CGPoint)pos;
@end


@implementation Image

@synthesize	imageWidth;
@synthesize imageHeight;
@synthesize textureWidth;
@synthesize textureHeight;
@synthesize texWidthRatio;
@synthesize texHeightRatio;
@synthesize textureOffsetX;
@synthesize textureOffsetY;
@synthesize rotation;
@synthesize scaleX;
@synthesize scaleY;

- (id) init{
	if(self = [super init]){
		imageWidth = 0;
		imageHeight = 0;
		textureWidth = 0;
		textureHeight = 0;
		texWidthRatio = 0.0f;
		texHeightRatio = 0.0f;
		textureOffsetX = 0;
		textureOffsetY = 0;
		rotation = 0.0f;
		scaleX = 1.0f;
		scaleY = 1.0f;
		colourFilter[0] = 1.0f;
		colourFilter[1] = 1.0f;
		colourFilter[2] = 1.0f;
		colourFilter[3] = 1.0f;
	}
	return self;
}

- (id) initWithImage:(UIImage *)image{
	texture = [[Texture2D alloc] initWithImage:image];
	scaleX = 1.0f;
	scaleY = 1.0f;
	[self extraInit];
	return self;
}

- (id) initWithTexture:(Texture2D *)tex{
	texture = tex;
	scaleX = 1.0f;
	scaleY = 1.0f;
	[self extraInit];
	return self;
}

- (Image*) getSubImageAtPoint:(CGPoint)point subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight subScale:(float)scale{
	Image* subImage = [[Image alloc] initWithTexture:texture];
	subImage.textureOffsetX = point.x;
	subImage.textureOffsetY = point.y;
	subImage.imageWidth = subImgWidth;
	subImage.imageHeight = subImgHeight;
	subImage.scaleX = scale;
	subImage.scaleY = scale;
	subImage.rotation = rotation;
	return subImage;
}

- (void) renderSubImageToPos:(CGPoint)pos offsetPoint:(CGPoint)offset subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight{
	
	//The texCoords are all from 0.0f-1.0f. offset is also a float from 0.0f-1.0f
	//This texCoords are in the Z shape.
	GLfloat texCoords[] = {
		offset.x*texWidthRatio, offset.y*texHeightRatio,
		offset.x*texWidthRatio + subImgWidth, offset.y*texHeightRatio,
		offset.x*texWidthRatio, offset.y*texHeightRatio + subImgHeight,
		offset.x*texWidthRatio + subImgWidth, offset.y*texHeightRatio + subImgHeight
	};
	
	
	GLfloat quadWidth = subImgWidth * scaleX;
	GLfloat quadHeight = subImgHeight * scaleY;
	//to vertices, which are in Z shape
	GLfloat vertices[] = {
		0.0f, 0.0f,
		quadWidth, 0.0f,
		0.0f, quadHeight,
		quadWidth, quadHeight
	};
	
	[self renderFrom:texCoords toVertices:vertices toPos:pos];
}

- (void) renderFrom:(GLfloat[])texCoords toVertices:(GLfloat[])vertices toPos:(CGPoint)pos{
	//save the current matrix
	glPushMatrix();
	
	//translate the render target vertices to the position.
	glTranslatef(pos.x, pos.y, 0.0f);
	
	//rotate around z axis
	glRotatef(rotation, 0.0f, 0.0f, 1.0f);
	
	//apply tint.
	glColor4f(colourFilter[0], colourFilter[1], colourFilter[2], colourFilter[3]);
	
	//enable to use coords array as a source texture
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//enable texture 2d
	glEnable(GL_TEXTURE_2D);
	
	//bind the texture.
	//The texture we are using here is loaded using Texture2D, which is texture size always be n^2.
	glBindTexture(GL_TEXTURE_2D, [texture name]);
	
	//set the texture coordinates we what to render from. (positions on the Texture2D generated image)
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	
	//set the target vertices which define the area we what to draw the texture.
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	
	//enable blend
	glEnable(GL_BLEND);
	
	//draw the image
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	//disable
	glDisable(GL_BLEND);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glPopMatrix();
	
}

- (void) extraInit{
	imageWidth = texture.contentSize.width;
	imageHeight = texture.contentSize.height;
	textureWidth = texture.pixelsWide;
	textureHeight = texture.pixelsHigh;
	maxTexWidth = imageWidth / (float)textureWidth;
	maxTexHeight = imageHeight / (float)textureHeight;
	texWidthRatio = 1.0f / (float)textureWidth;
	texHeightRatio = 1.0f / (float)textureHeight;
	textureOffsetX = 0;
	textureOffsetY = 0;
	rotation = 0.0f;
	colourFilter[0] = 1.0f;
	colourFilter[1] = 1.0f;
	colourFilter[2] = 1.0f;
	colourFilter[3] = 1.0f;
}

@end
