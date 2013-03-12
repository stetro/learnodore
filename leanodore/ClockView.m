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
        self.percent = 0.60;
        self.green = false;
    }
    return self;
}

- (void)drawBackgroundCircle:(CGContextRef)contextRef {
    CGContextSetRGBStrokeColor(contextRef, 245, 245, 245, 1);
    CGContextSetLineWidth(contextRef, 3);
    CGContextStrokeEllipseInRect(contextRef, CGRectMake(25,25, 200, 200));
}

- (void)drawRedTimeCircle:(CGContextRef)contextRef {
    CGContextSetRGBStrokeColor(contextRef,245, 0,0, 1);
    CGContextSetLineWidth(contextRef, 4);
    CGContextAddArc(contextRef, 125, 125, 100, M_PI_2 + 2 * M_PI *self.percent, M_PI/2 , 1);
    CGContextStrokePath(contextRef);
}
- (void)drawRedTimeSquare:(CGContextRef)contextRef {
    CGContextSetRGBStrokeColor(contextRef,245, 0, 0, 0);
    CGContextSetRGBFillColor(contextRef,245, 0, 0, 1);
    CGPoint startPoint = CGPointMake(125 - sin(2 * M_PI *(self.percent))*107, 125 + cos(2 * M_PI *(self.percent))*107);
    CGContextSaveGState(contextRef);
    CGContextTranslateCTM(contextRef, startPoint.x, startPoint.y);
    CGContextRotateCTM(contextRef, self.percent * M_PI * 2+M_PI_4);
    CGRect rect = CGRectMake(-10, -10, 10, 10);
    CGContextAddRect(contextRef, rect);
    CGContextFillPath(contextRef);
    CGContextRestoreGState(contextRef);
}

- (void)drawGreenTimeCircle:(CGContextRef)contextRef {
    CGContextSetRGBStrokeColor(contextRef,0, 255, 0, 1);
    CGContextSetLineWidth(contextRef, 4);
    CGContextAddArc(contextRef, 125, 125, 100, M_PI_2 + 2 * M_PI *self.percent, M_PI/2 , 1);
    CGContextStrokePath(contextRef);
}
- (void)drawGreenTimeSquare:(CGContextRef)contextRef {
    CGContextSetRGBStrokeColor(contextRef,0, 255, 0, 0);
    CGContextSetRGBFillColor(contextRef,0, 255, 0, 1);
    CGPoint startPoint = CGPointMake(125 - sin(2 * M_PI *(self.percent))*107, 125 + cos(2 * M_PI *(self.percent))*107);
    CGContextSaveGState(contextRef);
    CGContextTranslateCTM(contextRef, startPoint.x, startPoint.y);
    CGContextRotateCTM(contextRef, self.percent * M_PI * 2+M_PI_4);
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
    if(self.green){
        [self drawGreenTimeCircle:contextRef];
        [self drawGreenTimeSquare:contextRef];
    }
    else
    {
        [self drawRedTimeCircle:contextRef];
        [self drawRedTimeSquare:contextRef];
    }
}

@end
