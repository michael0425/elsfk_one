//
//  ResourcesManager.m
//  Graphics
//
//  Created by Liy on 10-2-5.
//  Copyright 2010 Bangboo. All rights reserved.
//

#import "ResourcesManager.h"


@implementation ResourcesManager

@synthesize boundedTexture;

static ResourcesManager* instance;

+ (ResourcesManager*)sharedResourcesManager{
	//lock
	@synchronized(self){
		if (instance == nil) {
			instance = [ResourcesManager alloc];
		}
	}
	
	return instance;
}

- (id) init{
	if (self = [super init]) {
		texturesCache = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	return self;
}

- (Texture2D*)getTexture2D:(NSString *)fileName{
	Texture2D* texture = [texturesCache objectForKey:fileName];
	if (texture == nil) {
		texture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:fileName]];
		[texturesCache setObject:texture forKey:fileName];
	}
	return [texture autorelease];
}

- (Texture2D*)removeTexture2D:(NSString*)fileName{
	Texture2D* texture = [texturesCache objectForKey:fileName];
	if (texture != nil) {
		//ensure the retain count is not 0
		[texture retain];
		[texturesCache removeObjectForKey:fileName];
	}
	return [texture autorelease];
}

- (void)clear{
	[texturesCache removeAllObjects];
}

@end
