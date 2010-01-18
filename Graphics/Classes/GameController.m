//
//  GameController.m
//  Graphics
//
//  Created by Lyss on 03/11/2009.
//  Copyright 2009 Bangboo. All rights reserved.
//

#import "GameController.h"


@implementation GameController
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	printf("controller handled touch");
	[[[self view] getBlock] moveRight];
}
@end
