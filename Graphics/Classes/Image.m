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
@synthesize colourFilter;

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
		colourFilter = malloc(sizeof(GLfloat) * 4);
		colourFilter[0] = 1.0f;
		colourFilter[1] = 1.0f;
		colourFilter[2] = 1.0f;
		colourFilter[3] = 1.0f;
	}
	return self;
}

- (id) initWithImage:(UIImage *)image{
	if(self = [super init]){
		texture = [[Texture2D alloc] initWithImage:image];
		scaleX = 1.0f;
		scaleY = 1.0f;
		[self extraInit];
	}
	return self;
}

- (id) initWithTexture:(Texture2D *)tex{
	if(self = [super init]){
		texture = tex;
		scaleX = 1.0f;
		scaleY = 1.0f;
		[self extraInit];
	}
	return self;
}

- (id) initWithTexture:(Texture2D *)tex scaleX:(GLfloat)sx scaleY:(GLfloat)sy{
	if(self = [super init]){
		texture = tex;
		scaleX = 1.0f;
		scaleY = 1.0f;
		[self extraInit];
	}
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

- (void) renderToPos:(CGPoint)pos{
	[self renderSubImageToPos:pos offsetPoint:CGPointMake(0.0, 0.0) subImageWidth:imageWidth subImageHeight:imageHeight];
}

- (void) renderSubImageToPos:(CGPoint)pos offsetPoint:(CGPoint)offset subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight{
	
	//============
	//Note that opengl 0,0 point is at bottom left hand side corner.
	//probably is because of hand writing is normally from left to right, and text field registration point is at bottom left
	//is easier to manage.
	//============
	
	
	/*
	GLfloat	textureCoords[] = {
		texWidthRatio*offset.x, texHeightRatio*offset.y,
		texWidthRatio*subImgWidth + texWidthRatio*offset.x, texHeightRatio*offset.y,
		texWidthRatio*offset.x,	texHeightRatio*offset.y + texHeightRatio*subImgHeight,
		texWidthRatio*offset.x + texWidthRatio*subImgWidth,	texHeightRatio*subImgHeight + texHeightRatio*offset.y
	};
	
	
	// Calculate the width and the height of the quad using the current image scale and the width and height
	// of the image we are going to render
	GLfloat quadWidth = subImgWidth*scaleX;
	GLfloat quadHeight = subImgHeight*scaleY;
	
	// Define the vertices for each corner of the quad which is going to contain our image.
	// We calculate the size of the quad to match the size of the subimage which has been defined.
	// If center is true, then make sure the point provided is in the center of the image else it will be
	// the bottom left hand corner of the image
	GLfloat vertices[8];
	vertices[0] = 0;
	vertices[1] = 0;
	vertices[2] = quadWidth;
	vertices[3] = 0;
	vertices[4] = 0;
	vertices[5] = quadHeight;
	vertices[6] = quadWidth;
	vertices[7] = quadHeight;
	*/
	
	
	//The texCoords are all from 0.0f-1.0f.
	GLfloat	textureCoords[] = {
		texWidthRatio*subImgWidth + texWidthRatio*offset.x, texHeightRatio*offset.y,
		texWidthRatio*subImgWidth + texWidthRatio*offset.x, texHeightRatio*subImgHeight + texHeightRatio*offset.y,
		texWidthRatio*offset.x,	texHeightRatio*offset.y,
		texWidthRatio*offset.x,	texHeightRatio*subImgHeight + texHeightRatio*offset.y
	};
	
	// Calculate the width and the height of the quad using the current image scale and the width and height
	// of the image we are going to render
	GLfloat quadWidth = subImgWidth*scaleX;
	GLfloat quadHeight = subImgHeight*scaleY;
	
	// Define the vertices for each corner of the quad which is going to contain our image.
	// We calculate the size of the quad to match the size of the subimage which has been defined.
	// If center is true, then make sure the point provided is in the center of the image else it will be
	// the bottom left hand corner of the image
	GLfloat vertices[8];
	vertices[0] = quadWidth;
	vertices[1] = quadHeight;
	vertices[2] = quadWidth;
	vertices[3] = 0;
	vertices[4] = 0;
	vertices[5] = quadHeight;
	vertices[6] = 0;
	vertices[7] = 0;
	
	
	
	[self renderFrom:textureCoords toVertices:vertices toPos:pos];
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
	colourFilter = malloc(sizeof(GLfloat) * 4);
	colourFilter[0] = 1.0f;
	colourFilter[1] = 1.0f;
	colourFilter[2] = 1.0f;
	colourFilter[3] = 1.0f;
}

@end
