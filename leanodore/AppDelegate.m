//
//  AppDelegate.m
//  leanodore
//
//  Created by Steffen Tröster on 11.03.13.
//  Copyright (c) 2013 Steffen Tröster. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate



-(id)init{
    self = [super init];

    if(self){
        [self setupDefaults];
        [self registerNotifications];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.clockview = [[ClockView alloc] initWithFrame:[self.window frame]];
    [self.window.contentView addSubview:self.clockview];
    [self setGrayBackgroundWith:0.14];
    self.clockview .frame = CGRectMake(0, 0, 250, 250);
    self.running = NO;
    self.working = YES;
    self.window.title = @"";
    NSButton *button = [self.window standardWindowButton:NSWindowCloseButton];
    [button setTarget:self];
    [button setAction:@selector(closeApplication)];
    [self initialViewSetup];
}

- (void) closeApplication
{
    [self stopTimer];
    [self.window close];
}

- (void)updateClockView
{
    long minutes = ((1 - self.clockview.percent) * self.minutes);
    long seconds = (((1 - self.clockview.percent) * self.minutes)-minutes) * 60;
    [[[NSApplication sharedApplication] dockTile]setBadgeLabel:[NSString stringWithFormat:@"%02i:%02i",(int) minutes,(int)seconds]];
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

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *) notification
{
    return true;
}

- (void)notify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:self];
    
    NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
    NSUserNotification *nf = [[NSUserNotification alloc]init];
    nc.delegate = self;
    if(self.working){
        nf.title = @"Learnodore";
        nf.subtitle =[ NSString stringWithFormat: @"Du hast nun %02i Minuten Pause.",
                      (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"procrastinationminutes"]] ;
    }else{
        nf.title = @"Learnodore";
        nf.subtitle =[ NSString stringWithFormat:@"Du solltest nun deine Arbeit für %02i minuten wieder aufnehmen.",
                      (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"minutes"]] ;
    }
    [nc deliverNotification:nf];
    
    NSSound *systemSound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Sounds/Glass.aiff" byReference:YES];
    if (systemSound) {
        [systemSound play];
    }
}

- (void)updateTimer
{
    self.clockview.percent += self.stepsize;
    if(self.clockview.percent >= 1){
        [self notify];
        [self stopTimer];
        [self restartTimerIfNecessary];
        return;
    }
    [self updateClockView];
}

-(void) restartTimerIfNecessary
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"selfPaused"])
    {
        self.working=!self.working;
        [self startTimer];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.running = NO;
    self.startButton.title = @"Start";
}

- (void)startTimer
{
    if(self.working)
    {
        self.minutes = [[NSUserDefaults standardUserDefaults] integerForKey:@"minutes"];
        self.clockview.green = NO;
    }
    else
    {
        self.minutes = [[NSUserDefaults standardUserDefaults] integerForKey:@"procrastinationminutes"];
        self.clockview.green = YES;
    }
    
    self.stepsize = 1.0/(float)(self.minutes * 60 * 4);
    self.clockview.percent  = 0.00;
    self.running = YES;
    self.startButton.title = @"Stop";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES ];
}

- (IBAction)startOrStopSessionButton:(id)sender
{
    self.working = YES;
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

#pragma mark - Helper

- (void)setupDefaults
{
    [[NSUserDefaultsController sharedUserDefaultsController] setAppliesImmediately:true];

    BOOL startedFirstTime = ![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"];

    if (startedFirstTime) {
        [[NSUserDefaults standardUserDefaults] setInteger:25 forKey:@"minutes"];
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"procrastinationminutes"];
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"minminutes"];
        [[NSUserDefaults standardUserDefaults] setInteger:100 forKey:@"maxminutes"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"selfPaused"];
        [[NSUserDefaults standardUserDefaults] setValue:@"/System/Library/Sounds/Glass.aiff" forKey:@"signalPath"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
               selector:@selector(initialViewSetup)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
}

- (void)initialViewSetup
{
    if (!self.running) {
        NSUInteger minutes = [[NSUserDefaults standardUserDefaults] integerForKey:@"minutes"];
        NSUInteger seconds = 0;
        [[[NSApplication sharedApplication] dockTile]setBadgeLabel:[NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)minutes,(unsigned long)seconds]];
        [self.minuteField setStringValue:[NSString stringWithFormat:@"%02lu", (unsigned long)minutes]];
        [self.secondField setStringValue:[NSString stringWithFormat:@"%02lu", (unsigned long)seconds]];
        [self.clockview setNeedsDisplay:YES];
    }
}

@end
