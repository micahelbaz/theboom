//
//  ViewController.h
//  Battleship
//

//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MyScene.h"
#import "StartScreen.h"
#import "MatchScreen.h"

@interface ViewController : UIViewController

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
- (IBAction)joinBattleshipMatch: (id) sender;
@end
