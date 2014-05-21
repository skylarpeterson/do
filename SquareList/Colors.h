//
//  Globals.h
//  ColorList
//
//  Created by Skylar Peterson on 10/23/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colors : NSObject

#define COLORS_IN_PALETTES 6

+ (UIColor *)interactiveColor;
+ (UIColor *)mainInteractiveColor;
+ (UIColor *)deleteColor;

+ (UIColor *)backdropColor;
+ (UIColor *)oppositeBackdropColor;
+ (NSString *)currentPaletteName;
+ (NSArray *)currentPalette;
+ (NSArray *)possiblePalettes;
+ (NSArray *)colorsForPalette:(NSString *)palette;
+ (UIColor *)colorForColorIndex:(NSInteger)colorIndex;

+ (void)switchBackdropColor;
+ (void)switchPaletteToPaletteWithName:(NSString *)paletteName andColors:(NSArray *)colors;

+ (UIColor *)randomColor;

@end
