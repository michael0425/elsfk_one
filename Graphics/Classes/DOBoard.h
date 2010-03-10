//
//  DOBoard.h
//  Graphics
//
//  Created by Liy on 10-3-5.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeafNode.h"
#import "TextureManager.h"
#import "Common.h"
#import "Board.h"

/**
 * This class extends the LeafNode, it actually draws all the cubes directly onto the screen.
 */
@interface DOBoard:LeafNode{
	TVCQuad* quads;
	
	int numOfCubes;
	GLushort* indices;
	Board* board;
	
	TextureManager* texManager;
	Texture2D* texRef;
	
	CGSize cubeSize;
}

- (id)initWithBoard:(Board*)aBoard withFile:(NSString*)aName;

- (void)setCubeSize:(CGSize)aSize;

@end
