//
//  DOBoard.m
//  Graphics
//
//  Created by Liy on 10-3-5.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "DOBoard.h"
#import "Cube.h"

@implementation DOBoard

@class Texture2D;

- (id)initWithBoard:(Board*)aBoard withFile:(NSString*)aName{
	if (self = [super init]) {
		board = aBoard;
		
		texManager = [GETexManager sharedTextureManager];
		texRef = [texManager getTexture2D:aName];
		
		cubeSize = CGSizeMake(20.0f, 20.0f);
	}
	return self;
}

/**
 * Get all the cube information in the board, and translate it to the array of TVCQuad ready to draw the array onto the screen.
 */
- (void)updateTVCQuads{
	NSMutableSet* cubes = [board.poCubeSet retain];
	numOfCubes = [cubes count];
	
	//free previous cubes information, assign new doCubes to store the new information for draw method to use.
	free(quads);
	quads = calloc(numOfCubes, sizeof(TVCQuad));
	
	//free indices, and create new indices
	free(indices);
	//since we are going to use GL_TRIANGLES, that is 2 triangles to form a square.
	//then we will have 6 vertices to describe a square, the total number of vertices will be: number of squares*6
	indices = calloc(numOfCubes*6, sizeof(GLshort));
	
	//scan through the cube set
	NSEnumerator* enumerator = [cubes objectEnumerator];
	//this is for tracking purpose and creating indices
	int i = 0;
	Cube* cube = nil;
	while (cube = (Cube*)[enumerator nextObject]) {
		[cube retain];
		
		//TODO: Get the rect size from cube data class.
		GLfloat texWidthRatio = 1.0f/(GLfloat)texRef.pixelsWide;
		GLfloat texHeightRatio = 1.0f/(GLfloat)texRef.pixelsHigh;
		GLfloat texWidth = texWidthRatio * texRef.contentSize.width;
		GLfloat texHeight = texHeightRatio * texRef.contentSize.height;
		GLfloat offsetX = 0;
		GLfloat offsetY = 0;
		
		//assign texture coordinate
		quads[i].tl.texCoords.u = offsetX;
		quads[i].tl.texCoords.v = offsetY + texHeight;
		quads[i].bl.texCoords.u = offsetX;
		quads[i].bl.texCoords.v = offsetY;
		quads[i].tr.texCoords.u = offsetX + texWidth;
		quads[i].tr.texCoords.v = offsetY + texHeight;
		quads[i].br.texCoords.u = offsetX + texWidth;
		quads[i].br.texCoords.v = offsetY;
		
		quads[i].bl.vertices.x = cube.x*cubeSize.width;
		quads[i].bl.vertices.y = cube.y*cubeSize.height;
		quads[i].tl.vertices.x = cube.x*cubeSize.width;
		quads[i].tl.vertices.y = cube.y*cubeSize.height + cubeSize.height;
		quads[i].br.vertices.x = cube.x*cubeSize.width + cubeSize.width;
		quads[i].br.vertices.y = cube.y*cubeSize.height;
		quads[i].tr.vertices.x = cube.x*cubeSize.width + cubeSize.width;
		quads[i].tr.vertices.y = cube.y*cubeSize.height + cubeSize.height;
		
		//color
		//quads[i].tl.color = Color4bMake(255, 255, 255, 255);
		//quads[i].bl.color = Color4bMake(255, 255, 255, 255);
		//quads[i].tr.color = Color4bMake(255, 255, 255, 255);
		//quads[i].br.color = Color4bMake(255, 255, 255, 255);
		quads[i].tl.color = Color4bMake(255, 0, 0, 255);
		quads[i].bl.color = Color4bMake(255, 0, 0, 255);
		quads[i].tr.color = Color4bMake(255, 0, 0, 255);
		quads[i].br.color = Color4bMake(255, 0, 0, 255);
		
		indices[i*6+0] = i*4+0;
		indices[i*6+1] = i*4+1;
		indices[i*6+2] = i*4+2;
		
		indices[i*6+3] = i*4+1;
		indices[i*6+4] = i*4+2;
		indices[i*6+5] = i*4+3;
		
		 ++i;
		[cube release];
	}
	[cubes release];
}

- (void)traverse{
	//update TVCQuad from cubes' information
	[self updateTVCQuads];
	
	//check whether to draw.
	[super traverse];
}

- (void)draw{
	//decide whether to process draw function
	[super draw];
	
	//save the current matrix
	glPushMatrix();
	
	//enable to use coords array as a source texture
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	//enable texture 2d
	glEnable(GL_TEXTURE_2D);
	
	//bind the texture.
	//The texture we are using here is loaded using Texture2D, which is texture size always be n^2.
	if ([GETexManager sharedTextureManager].boundedTex != [texRef name]) {
		glBindTexture(GL_TEXTURE_2D, [texRef name]);
		[GETexManager sharedTextureManager].boundedTex = [texRef name];
	}
	else {
		//NSLog(@"Image already binded");
	}
	
	//get the start memory address for the tvcQuad struct.
	//Note that tvcQuad is defined as array, we need to access the actual tvcQuad memory address using normal square bracket.
	int addr = (int)&quads[0];
	//calculate the memory location offset, should be 0. Since there is nothing before texCoords property of TVCQuad.
	int offset = offsetof(TVCPoint, texCoords);
	//set the texture coordinates we what to render from. (positions on the Texture2D generated image)
	glTexCoordPointer(2, GL_FLOAT, sizeof(TVCPoint), (void*) (addr));
	
	//memory offset to define the start of vertices. Should be sizeof(texCoords) which is 8 bytes(2 GLfloat each for 4 bytes).
	offset = offsetof(TVCPoint, vertices);
	//set the target vertices which define the area we what to draw the texture.
	glVertexPointer(2, GL_FLOAT, sizeof(TVCPoint), (void*) (addr + offset));
	
	//offset to define the start of color array. Before this property we have texCoords(u & v GLfloat) 
	//and vertices(x & y GLfloat) which are 16 bytes.
	offset = offsetof(TVCPoint, color);
	//set the color tint array for the texture.
	glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(TVCPoint), (void*)(addr + offset));
	
	//enable blend
	glEnable(GL_BLEND);
	
	//draw the image
	//type of the element, how many vertices, indices element type, indices
	glDrawElements(GL_TRIANGLES, numOfCubes*6, GL_UNSIGNED_SHORT, indices);
	
	//disable
	glDisable(GL_BLEND);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glPopMatrix();
}

- (void)setCubeSize:(CGSize)aSize{
	cubeSize = aSize;
}

@end
