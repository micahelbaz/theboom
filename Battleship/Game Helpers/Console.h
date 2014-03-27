//
//  Console.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-12.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface Console : NSObject

@property (nonatomic, strong) UITextView* textView;

- (instancetype) initConsole;
- (void) setConsoleText:(NSString*) text;

@end
