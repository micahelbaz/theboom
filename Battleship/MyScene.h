//
//  MyScene.h
//  Battleship
//

//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BattleshipGame.h"
#import "Ship.h"
#import "Cruiser.h"
#import "Destroyer.h"
#import "TorpedoBoat.h"
#import "RadarBoat.h"
#import "MineLayer.h"
#import "Helpers.h"
#import "Names.h"
#import "MiniMap.h"
#import "Containers.h"
#import "Background.h"
#import "MainGameController.h"

@interface MyScene : SKScene <GKMatchDelegate>

@property (nonatomic, strong) BattleshipGame *game;
@property (nonatomic, strong) MainGameController *mainGameController;
@property (nonatomic, strong) Coordinate* moveFromCoordinate;
@property int shipIndex;

@property UIPinchGestureRecognizer *pinchRecognizer;

@property (nonatomic, strong) SKNode *nodeTouched;

@property BOOL miniMapTouched;

- (id) initWithSize:(CGSize)size;
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)sendCannonHit:(Coordinate*)hitLocation and:(NSString*)hitType;
- (IBAction) handlePinch:(UIPinchGestureRecognizer *)recognizer;

@end
