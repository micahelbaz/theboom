//
//  Console.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-12.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Console.h"

@implementation Console

- (instancetype) initConsole
{
    self = [super init];
    if (self) {
        // Creates the console box
        CGRect consoleFrame = CGRectMake(fullScreenWidth+20-visualBarWidth,
                                         visualBarHeight/2+150,
                                         visualBarWidth-40,
                                         visualBarHeight/2-200);
        _textView = [[UITextView alloc]initWithFrame:consoleFrame];
        _textView.clipsToBounds = YES;
        _textView.layer.cornerRadius = 5.0f;
        [_textView setScrollEnabled:YES];
        //[_textView setFont:[UIFont fontWithName:@"28DaysLater" size:16]];
        [_textView setUserInteractionEnabled:YES];
        [_textView setEditable:NO];
        [_textView setBackgroundColor:[UIColor grayColor]];
        
    }
    return self;
}

- (void) setConsoleText:(NSString*) text
{
    [_textView setText:[[_textView text] stringByAppendingString:text]];
    [_textView scrollRangeToVisible:NSMakeRange([_textView.text length], 0)];
    [_textView setScrollEnabled:NO];
    [_textView setScrollEnabled:YES];
}

@end
