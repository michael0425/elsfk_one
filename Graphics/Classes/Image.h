/**
 * Image.h
 * Graphics
 *
 * Image class using Texture2D to load picture into the memory and also Texture2D generate a texture whose
 * size will be always a 2^n.
 *
 * Once the texture is ready to use, Image class will try to render full or part of the texture on to the screen,
 * and the rotation, translation, tint, scale, can be applied as well.
 * 
 * Created by Liy on 10-1-26.
 * Copyright 2010 Bangboo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "Texture2D.h"


@interface Image : NSObject {
	
	//Texture2D to load picture.
	Texture2D* texture;
	
	//Image is the actual picture you want to load into the program.
	//So the imageWidth is the actual picture width.
	NSUInteger imageWidth;
	
	//The actual picture height.
	NSUInteger imageHeight;
	
	//After the picture is loaded using Texture2D class, a texture is generated. The texture width and height
	//will always be 2^n. For example, if the picture
	//is 40*120, the generated texture width and height will be 64*128.
	NSUInteger textureWidth;
	
	//The texture height which is 2^n.
	NSUInteger textureHeight;
	
	//Since the texture width probably will be larger than the actual picture you load. The
	//coordinate system for texture mapping are usually represented using float number from 0.0-1.0.
	//Just like the UV coordinate system. For example, the picture width is 40, the maxTexWidth will
	//be 5/8.
	float maxTexWidth;
	
	//The max valid texture height.
	float maxTexHeight;
	
	//1 texel will represents how many actual pixels in the picture width. will be 1/textureWidth
	float texWidthRatio;
	
	//1/textureHeight
	float texHeightRatio;
	
	//texture offset allows to draw a sub area of the texture, this represents the x offset.
	//Can be also used to look for the actual texture.
	NSUInteger textureOffsetX;
	
	//y offset to draw a sub texture. Can be also used to look for the actual texture
	NSUInteger textureOffsetY;
	
	//The degree to rotate the image.
	float rotation;
	
	//The scale in x direction when draw image.
	float scaleX;
	
	//The scale in y direction when draw image.
	float scaleY;
	
	//The colour filter apply to the image.
	float *colourFilter;
}

@property (nonatomic) NSUInteger imageWidth;
@property (nonatomic) NSUInteger imageHeight;
@property (nonatomic, readonly) NSUInteger textureWidth;
@property (nonatomic, readonly) NSUInteger textureHeight;
@property (nonatomic) NSUInteger textureOffsetX;
@property (nonatomic) NSUInteger textureOffsetY;
@property (nonatomic) float	rotation;
@property (nonatomic) float	scaleX;
@property (nonatomic) float	scaleY;
@property (nonatomic, readonly) float texWidthRatio;
@property (nonatomic, readonly) float texHeightRatio;
@property (nonatomic) float *colourFilter;


- (id) initWithImage: (UIImage*)image;

- (id) initWithTexture: (Texture2D*)tex;

- (Image*) getSubImageAtPoint:(CGPoint)point subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight subScale:(float)scale;

- (void) renderToPos:(CGPoint)pos;

- (void) renderSubImageToPos:(CGPoint)pos offsetPoint:(CGPoint)offset subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight; 

@end
