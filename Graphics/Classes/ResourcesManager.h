//
//  ResourcesManager.h
//  Graphics
//
//  Created by Liy on 10-2-5.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"

// Tell comiler not to report error, since class Texture2D must be already been imported it could be somewhere else
@class Texture2D;

@interface ResourcesManager : NSObject {
	GLuint boundedTexture;
	NSMutableDictionary* texturesCache;
}

//The currently bounded texture in the OpenGL.
@property (nonatomic, assign) GLuint boundedTexture;

/**
 *Get the ResroucesManager for this game.
 *@return A ResourcesManager instance.
 */
+ (ResourcesManager*)sharedResourcesManager;

/**
 * Get the Texture2D object using the exact file name of the image. 
 * If the Texture2D is not in the ResourcesManager, create a new one and return it.
 * @param fileName The file name of the image for Texture2D to load.
 * @return A Texture2D object managed by this ResourcesManager.
 */
- (Texture2D*)getTexture2D:(NSString*)fileName;

/**
 * Remove the Texture2D specified by file name from this ResourcesManager.
 * @param fileName The file name, the key to remove the Texture2D object.
 * @return A Texture2D object if it is sucessfully removed, or nil fail to remove.
 */
- (Texture2D*)removeTexture2D:(NSString*)fileName;

/**
 * Clear all the Texture2D objects managed by this ResourcesManager.
 */
- (void)clear;

@end
