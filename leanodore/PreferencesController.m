//
//  PreferencesController.m
//  leanodore
//
//  Created by Steffen Tröster on 12.03.13.
//  Copyright (c) 2013 Steffen Tröster. All rights reserved.
//

#import "PreferencesController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(IBAction)formatMinutes:(id)sender{
    NSInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:@"minutes"];
    [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"minutes"];
    NSInteger j = [[NSUserDefaults standardUserDefaults] integerForKey:@"procrastinationminutes"];
    [[NSUserDefaults standardUserDefaults] setInteger:j forKey:@"procrastinationminutes"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

@end
