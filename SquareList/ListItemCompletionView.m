//
//  ListItemCompletionView.m
//  SquareList
//
//  Created by Skylar Peterson on 11/18/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ListItemCompletionView.h"

#import "Colors.h"

@implementation ListItemCompletionView

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setCompleted:(BOOL)completed
{
    _completed = completed;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define DEFAULT_HEIGHT 65.0
#define CORNER_RADIUS 12.0
#define CHECK_BOX_SIDE_LENGTH 35

- (CGFloat)cornerScaleFactor { return DEFAULT_HEIGHT / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width - CHECK_BOX_SIDE_LENGTH) / 2.0, self.frame.size.height / 2.0f - (CHECK_BOX_SIDE_LENGTH / 2.0), CHECK_BOX_SIDE_LENGTH, CHECK_BOX_SIDE_LENGTH)
                                                           cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    if (self.color) {
        [[Colors interactiveColor] setFill];
        UIRectFill(roundedRect.bounds);
        
        [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5] setStroke];
        [roundedRect setLineWidth:1.0f];
        [roundedRect stroke];
    }
    
    if (self.completed) {
        UIBezierPath *fillRoundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(roundedRect.bounds.origin.x + 6.5, roundedRect.bounds.origin.y + 6.5, roundedRect.bounds.size.width - 13.0, roundedRect.bounds.size.height - 13.0)
                                                                                           cornerRadius:[self cornerRadius]];
        [fillRoundedRect addClip];
        
        [self.color setFill];
        UIRectFill(fillRoundedRect.bounds);
    }
}

@end
