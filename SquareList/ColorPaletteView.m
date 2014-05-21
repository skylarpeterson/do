//
//  ColorPaletteView.m
//  SquareList
//
//  Created by Skylar Peterson on 12/7/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ColorPaletteView.h"

#import "Colors.h"
#import "Fonts.h"

@interface ColorPaletteView()

@property (nonatomic, strong) NSArray *layers;
@property (nonatomic, strong) NSArray *numbers;

@end

@implementation ColorPaletteView

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    
    NSMutableArray *layers = [[NSMutableArray alloc] init];
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    for (int i = 0; i < COLORS_IN_PALETTES; i++) {
        CALayer *colorLayer = [CALayer layer];
        colorLayer.backgroundColor = [(UIColor *)[colors objectAtIndex:i] CGColor];
        [self.layer addSublayer:colorLayer];
        [layers addObject:colorLayer];
    }
    self.layers = [layers copy];
    self.numbers = [numbers copy];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (NSInteger i = 0; i < COLORS_IN_PALETTES; i++) {
        CALayer *colorLayer = [self.layers objectAtIndex:i];
        colorLayer.frame = CGRectMake(i * self.frame.size.width / COLORS_IN_PALETTES, 0.0, self.frame.size.width / COLORS_IN_PALETTES, self.frame.size.height);
    }
}

//stack overflow 7177637
- (UIImage *)imageFromView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
