//
//  AppDelegate.m
//  leanodore
//
//  Created by Steffen Tröster on 11.03.13.
//  Copyright (c) 2013 Steffen Tröster. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.clockview = [[ClockView alloc] initWithFrame:[self.window frame]];
    [self.window.contentView addSubview:self.clockview];
    [self setGrayBackgroundWith:0.14];
    self.clockview .frame = CGRectMake(0, 0, 250, 250);
    self.running = NO;
    self.window.title = @"";
    NSButton *button = [self.window standardWindowButton:NSWindowCloseButton];
    [button setTarget:self];
    [button setAction:@selector(closeApplication)];
}

- (void) closeApplication
{
    [self stopTimer];
    [self.window close];
}

- (void)updateClockView
{
    long minutes = ((1 - self.clockview.percent) * 25.0);
    long seconds = (((1 - self.clockview.percent) * 25.0)-minutes) * 60;
    [self.minuteField setStringValue:[NSString stringWithFormat:@"%02i",(int) minutes]];
    [self.secondField setStringValue:[NSString stringWithFormat:@"%02i",(int) seconds]];
    [self.clockview setNeedsDisplay:YES];
}

-(IBAction)openPreferences:(id)sender
{
    if(!self.preferencesController)
    {
        self.preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"PreferencesController"];
    }
    [self.preferencesController showWindow:self];
}

- (void)setGrayBackgroundWith: (CGFloat) brightness
{
    self.window.backgroundColor = [NSColor colorWithSRGBRed:brightness green:brightness blue:brightness alpha: 1.0];
}

- (void)updateTimer
{
    self.clockview.percent += 0.00016666666;
    if(self.clockview.percent >= 1){
        
        NSSound *systemSound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Sounds/Glass.aiff" byReference:YES];
        if (systemSound) {
            [systemSound play];
        }
        [self stopTimer];
        return;
    }
    [self updateClockView];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.running = NO;
    self.startButton.title = @"Start";
}

- (void)startTimer
{
    self.clockview.percent  = 0.00;
    self.running = YES;
    self.startButton.title = @"Stop";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (IBAction)startOrStopSessionButton:(id)sender
{
    if(self.running == YES){
        [self stopTimer];
    }
    else{
        [self startTimer];   
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    self.running = NO;
    return YES;
}

@end
