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
- (void) renderTo:(CGPoint)pos;
@end


@implementation Image

@synthesize texture;
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
		
		//One Quad2f to represent a area of texture to draw from
		texCoords = calloc(1, sizeof(Quad2f));
		//Just one Quad2f to represent a area to draw
		vertices = calloc(1, sizeof(Quad2f));
		//6 GLubyte number to index the two triangles(6 vertices)
		indices = calloc(6, sizeof(GLubyte));
		indices[0] = 0;
		indices[1] = 1;
		indices[2] = 2;
		indices[3] = 1;
		indices[4] = 2;
		indices[5] = 3;
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

- (Image*) getSubImageAtPoint:(CGPoint)point subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight{
	Image* subImage = [[Image alloc] initWithTexture:texture];
	subImage.textureOffsetX = point.x;
	subImage.textureOffsetY = point.y;
	subImage.imageWidth = subImgWidth;
	subImage.imageHeight = subImgHeight;
	subImage.rotation = rotation;
	
	NSLog(@"offsetX: %u  offsetY: %u width: %u   height: %u", subImage.textureOffsetX, subImage.textureOffsetY, subImage.imageWidth, subImage.imageHeight);
	
	
	[subImage autorelease];
	
	return subImage;
}


- (void) genVerticesTo:(CGPoint)pos subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight centreImage:(BOOL)flag{
	// Calculate the width and the height of the quad using the current image scale and the width and height
	// of the image we are going to render
	if (flag) {
		GLfloat offsetX = subImgWidth*scaleX/2.0;
		GLfloat offsetY = subImgHeight*scaleY/2.0;
		
		vertices[0].bl_x = pos.x - offsetX;
		vertices[0].bl_y = pos.y - offsetY;
		
		vertices[0].br_x = pos.x + offsetX;
		vertices[0].br_y = pos.y - offsetY;
		
		vertices[0].tl_x = pos.x - offsetX;
		vertices[0].tl_y = pos.y + offsetY;
		
		vertices[0].tr_x = pos.x + offsetX;
		vertices[0].tr_y = pos.y + offsetY;
	}
	else {
		GLfloat quadWidth = subImgWidth*scaleX;
		GLfloat quadHeight = subImgHeight*scaleY;
		
		vertices[0].bl_x = pos.x;
		vertices[0].bl_y = pos.y;
		
		vertices[0].br_x = pos.x + quadWidth;
		vertices[0].br_y = pos.y;
		
		vertices[0].tl_x = pos.x;
		vertices[0].tl_y = pos.y + quadHeight;
		
		vertices[0].tr_x = pos.x + quadWidth;
		vertices[0].tr_y = pos.y + quadHeight;
	}
}

- (void) genTexCoordsAt:(CGPoint)offset subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight{
	GLfloat subTexWidth = texWidthRatio*subImgWidth;
	GLfloat subTexHeight = texHeightRatio*subImgHeight;
	GLfloat offsetX = texWidthRatio*offset.x;
	GLfloat offsetY = texHeightRatio*offset.y;
	
	texCoords[0].bl_x = offsetX;
	texCoords[0].bl_y = offsetY;
	
	texCoords[0].br_x = offsetX + subTexWidth;
	texCoords[0].br_y = offsetY;
	
	texCoords[0].tl_x = offsetX;
	texCoords[0].tl_y = offsetY + subTexHeight;
	
	texCoords[0].tr_x = offsetX + subTexWidth;
	texCoords[0].tr_y = offsetY + subTexHeight;
	 
}

- (void) renderTo:(CGPoint)pos centreImage:(BOOL)flag{
	
	[self genTexCoordsAt:CGPointMake(textureOffsetX, textureOffsetY) subImageWidth:imageWidth subImageHeight:imageHeight];
	[self genVerticesTo:pos subImageWidth:imageWidth subImageHeight:imageHeight centreImage:flag];
	
	[self renderTo:pos];
}

- (void) renderSubImageTo:(CGPoint)pos offsetPoint:(CGPoint)offset subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight centreImage:(BOOL)flag{
	
	[self genTexCoordsAt:offset subImageWidth:subImgWidth subImageHeight:subImgWidth];
	[self genVerticesTo:pos subImageWidth:subImgWidth subImageHeight:subImgWidth centreImage:flag];
	
	
	[self renderTo:pos];
}

- (void) renderTo:(CGPoint)pos{
	//save the current matrix
	glPushMatrix();
	
	glTranslatef(pos.x, pos.y, 0);
	glRotatef(-rotation, 0.0f, 0.0f, 1.0f);
	glTranslatef(-pos.x, -pos.y, 0);
	
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
	
	//One Quad2f to represent a area of texture to draw from
	texCoords = calloc(1, sizeof(Quad2f));
	//Just one Quad2f to represent a area to draw
	vertices = calloc(1, sizeof(Quad2f));
	//6 GLubyte number to index the two triangles(6 vertices)
	indices = calloc(6, sizeof(GLubyte));
	
	indices[0] = 0;
	indices[1] = 1;
	indices[2] = 2;
	indices[3] = 1;
	indices[4] = 2;
	indices[5] = 3;
}

@end
