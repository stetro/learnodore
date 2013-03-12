//
//  AppDelegate.h
//  leanodore
//
//  Created by Steffen Tröster on 11.03.13.
//  Copyright (c) 2013 Steffen Tröster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ClockView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>


@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *startButton;
@property (assign) IBOutlet NSTextField *minuteField;
@property (assign) IBOutlet NSTextField *secondField;
@property BOOL running;
@property NSTimer *timer;
@property ClockView *clockview;


-(IBAction)startOrStopSessionButton:(id)sender;
-(IBAction)openPreferences:(id)sender;

@end
