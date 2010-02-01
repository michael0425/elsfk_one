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
 * WRAPPER CLASS for Texture2D.
 * 
 * Created by Liy on 10-1-26.
 * Copyright 2010 Bangboo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "Texture2D.h"


typedef struct _Quad2 {
	float tl_x, tl_y;
	float tr_x, tr_y;
	float bl_x, bl_y;
	float br_x, br_y;
} Quad2;

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


/**
 * Initialize using UIImage.
 */
- (id) initWithImage: (UIImage*)image;

/**
 * Initialize using Texture2D.
 */
- (id) initWithTexture: (Texture2D*)tex;

/**
 * Get a sub image from the full image. The loaded image will not be changed, only the new sub Image instance's imageWidth and imageHeight will be changed.
 * The underlying Texture2D will not be changed as well.
 * If using this method to render, since it returns a newly create Image instance(which has the same Texture2D reference in the original Image), 
 * compare to directly render a sub-image, this method will be slower. So this method should not be used heavily.
 */
- (Image*) getSubImageAtPoint:(CGPoint)point subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight;

/**
 * Render the whole image to a position. If centreImage is set to YES, the registration point will be the centre of the image.
 */
- (void) renderToPos:(CGPoint)pos centreImage:(BOOL)flag;

/**
 * Directly render a sub image onto the screen. If centreImage is set to YES, the registration point will be the central point of the image.
 */
- (void) renderSubImageToPos:(CGPoint)pos offsetPoint:(CGPoint)offset subImageWidth:(GLfloat)subImgWidth subImageHeight:(GLfloat)subImgHeight centreImage:(BOOL)flag; 

@end
