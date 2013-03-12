//
//  ClockView.m
//  leanodore
//
//  Created by Steffen Tröster on 11.03.13.
//  Copyright (c) 2013 Steffen Tröster. All rights reserved.
//

#import "ClockView.h"

@implementation ClockView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _percent = 0.60;
    }
    return self;
}

- (void)drawBackgroundCircle:(CGContextRef)contextRef {
    CGContextSetRGBStrokeColor(contextRef, 245, 245, 245, 1);
    CGContextSetLineWidth(contextRef, 3);
    CGContextStrokeEllipseInRect(contextRef, CGRectMake(25,25, 200, 200));
}

- (void)drawTimeCircle:(CGContextRef)contextRef {
    CGContextSetRGBStrokeColor(contextRef,245, 0,0, 1);
    CGContextSetLineWidth(contextRef, 4);
    CGContextAddArc(contextRef, 125, 125, 100, M_PI_2 + 2 * M_PI *_percent, M_PI/2 , 1);
    CGContextStrokePath(contextRef);
}
- (void)drawTimeSquare:(CGContextRef)contextRef {
    CGContextSetRGBStrokeColor(contextRef,245, 0, 0, 0);
    CGContextSetRGBFillColor(contextRef,245, 0, 0, 1);
    CGPoint startPoint = CGPointMake(125 - sin(2 * M_PI *(_percent))*107, 125 + cos(2 * M_PI *(_percent))*107);
    CGContextSaveGState(contextRef);
    CGContextTranslateCTM(contextRef, startPoint.x, startPoint.y);
    CGContextRotateCTM(contextRef, _percent * M_PI * 2+M_PI_4);
    CGRect rect = CGRectMake(-10, -10, 10, 10);
    CGContextAddRect(contextRef, rect);
    CGContextFillPath(contextRef);
    CGContextRestoreGState(contextRef);
}

- (CGContextRef)bindCGContextFromNSContext {
    NSGraphicsContext * nsContext =[NSGraphicsContext currentContext];
    CGContextRef contextRef =(CGContextRef) [nsContext graphicsPort];
    CGContextSetBlendMode(contextRef, kCGBlendModeNormal);
    return contextRef;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = [self bindCGContextFromNSContext];
    [self drawBackgroundCircle:contextRef];
    [self drawTimeCircle:contextRef];
    [self drawTimeSquare:contextRef];
}

@end
