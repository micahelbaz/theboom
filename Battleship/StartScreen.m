//
//  StartScreen.m
//  Battleship
//
//  Created by Robert Schneidman on 2/28/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "StartScreen.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation StartScreen
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKTexture *textureImage = [SKTexture textureWithImageNamed:@"background"];
        SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithTexture:textureImage];
        backgroundSprite = [SKSpriteNode spriteNodeWithTexture:textureImage];
        backgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundSprite.xScale = 0.6;
        backgroundSprite.yScale = 0.6;
        SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"Find Match Button"];
        startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)/2.8);
        [startButton setZPosition:1];
        [backgroundSprite setZPosition:0];
        [self addChild:startButton];
        [self addChild:backgroundSprite];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    SKScene * scene = [MatchScreen sceneWithSize:self.scene.view.bounds.size];
    [self.scene.view presentScene:scene];
}

#pragma mark GCHelperDelegate

-(void)matchStarted {
    NSLog(@"match started");
}

-(void)matchEnded {
    NSLog(@"match ended");
}

-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Received data");
}

@end
