//
//  FleetScene.m
//  Battleship
//
//  Created by Robert Schneidman on 2014-03-25.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "FleetScene.h"

@implementation FleetScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKTexture *textureImage = [SKTexture textureWithImageNamed:@"menu background"];
        SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithTexture:textureImage];
        backgroundSprite = [SKSpriteNode spriteNodeWithTexture:textureImage];
        backgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundSprite.xScale = 0.6;
        backgroundSprite.yScale = 0.6;
        SKSpriteNode *fleetBackground = [SKSpriteNode spriteNodeWithImageNamed:@"black"];
        fleetBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        fleetBackground.xScale = self.frame.size.width *24/fleetBackground.frame.size.width/30;
        fleetBackground.yScale = self.frame.size.height * 10/fleetBackground.frame.size.height/30;
        [self addChild:backgroundSprite];
        [self addChild:fleetBackground];
        NSMutableSet *coralCoords = [self initializeCoral];
        for (Coordinate *c in coralCoords) {
            SKSpriteNode *coral = [SKSpriteNode spriteNodeWithImageNamed:@"corals"];
            coral.xScale = fleetBackground.frame.size.width/24/coral.frame.size.width;
            coral.yScale = fleetBackground.frame.size.height/10/coral.frame.size.height;
            coral.position = CGPointMake(CGRectGetMinX(fleetBackground.frame) + coral.frame.size.width/2 + c.xCoord * fleetBackground.frame.size.width/24, CGRectGetMinY(fleetBackground.frame) + coral.frame.size.height/2 + c.yCoord * fleetBackground.frame.size.height/10);
            [self addChild:coral];
        }
        SKSpriteNode *base = [SKSpriteNode spriteNodeWithImageNamed:@"NormalArmour"];
        base.xScale = fleetBackground.frame.size.width/24/base.frame.size.width * 10;
        base.yScale = fleetBackground.frame.size.height/10/base.frame.size.height;
        base.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + base.frame.size.height/2);
        [self addChild:base];
    }
    
    return self;
}

-(NSMutableSet*) initializeCoral {
    NSMutableSet *coralPositions = [[NSMutableSet alloc] init];
    while ([coralPositions count] < 24)    {
        int yCoord = arc4random_uniform(10);
        int xCoord = arc4random_uniform(24);
        int breakFlag = 0;
        Coordinate *c = [[Coordinate alloc]initWithXCoordinate:xCoord YCoordinate:yCoord initiallyFacing:NONE];
        for (Coordinate *contained in coralPositions) {
            if (contained.xCoord == c.xCoord && contained.yCoord == c.yCoord) {
                breakFlag = 1;
                continue;
            }
        }
        if (breakFlag == 1) {
            continue;
        }
        [coralPositions addObject:c];
    }
    return coralPositions;
}
@end