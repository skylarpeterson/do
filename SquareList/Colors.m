//
//  Globals.m
//  ColorList
//
//  Created by Skylar Peterson on 10/23/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "Colors.h"
@interface Colors()
@end

@implementation Colors

#define COLORS_DICTIONARY_KEY @"Colors.ColorsDictionary"
#define BACKDROP_KEY @"BackdropColor"
#define OPPOSITE_BACKDROP_KEY @"OppositeBackdropColor"
#define COLORS_IN_USE_NAME_KEY @"ColorsInUseKey"
#define COLORS_IN_USE_PALETTE_KEY @"ColorsInUsePalette"

#pragma mark - Shortcut Methods

+ (UIColor *)colorWithRed:(float)red andGreen:(float)green andBlue:(float)blue andAlpha:(float)alpha
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (NSData *)dataForColor:(UIColor *)color
{
    return [NSKeyedArchiver archivedDataWithRootObject:color];
}

+ (UIColor *)colorForData:(NSData *)data
{
    return (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - Color Palettes

+ (UIColor *)standardRed { return [self colorWithRed:221.0f andGreen:30.0f andBlue:47.0f andAlpha:1.0f]; }
+ (UIColor *)standardOrange { return [self colorWithRed:255.0f andGreen:102.0f andBlue:0.0f andAlpha:1.0f]; }
+ (UIColor *)standardYellow { return [self colorWithRed:255.0f andGreen:204.0f andBlue:0.0f andAlpha:1.0f]; }
+ (UIColor *)standardGreen { return [self colorWithRed:33.0f andGreen:133.0f andBlue:89.0f andAlpha:1.0f]; }
+ (UIColor *)standardBlue { return [self colorWithRed:6.0f andGreen:162.0f andBlue:203.0f andAlpha:1.0f]; }
+ (UIColor *)standardPurple { return [self colorWithRed:128.0f andGreen:0.0f andBlue:128.0f andAlpha:1.0f]; }
+ (NSArray *)standardPalette
{
    return @[[self dataForColor:[self standardRed]], [self dataForColor:[self standardOrange]], [self dataForColor:[self standardYellow]],
             [self dataForColor:[self standardGreen]], [self dataForColor:[self standardBlue]], [self dataForColor:[self standardPurple]]];
}

+ (UIColor *)winterLightBlue {return [self colorWithRed:191.0f andGreen:211.0f andBlue:221.0f andAlpha:1.0]; }
+ (UIColor *)winterBlue { return [self colorWithRed:128.0f andGreen:179.0f andBlue:203.0f andAlpha:1.0]; }
+ (UIColor *)winterDarkBlue { return [self colorWithRed:50.0f andGreen:58.0f andBlue:72.0f andAlpha:1.0]; }
+ (UIColor *)winterDark { return [self colorWithRed:63.0f andGreen:61.0f andBlue:72.0f andAlpha:1.0]; }
+ (UIColor *)winterPurple { return [self colorWithRed:128.0f andGreen:133.0f andBlue:160.0f andAlpha:1.0]; }
+ (UIColor *)winterOrange { return [self colorWithRed:254.0f andGreen:183.0f andBlue:153.0f andAlpha:1.0]; }
+ (NSArray *)winterPalette
{
    return @[[self dataForColor:[self winterLightBlue]], [self dataForColor:[self winterBlue]], [self dataForColor:[self winterDarkBlue]],
             [self dataForColor:[self winterDark]], [self dataForColor:[self winterPurple]], [self dataForColor:[self winterOrange]]];
}

+ (UIColor *)springLightPink { return [self colorWithRed:236.0f andGreen:212.0f andBlue:230.0f andAlpha:1.0]; }
+ (UIColor *)springPink { return [self colorWithRed:224.0f andGreen:177.0f andBlue:212.0f andAlpha:1.0]; }
+ (UIColor *)springRed { return [self colorWithRed:211.0f andGreen:78.0f andBlue:110.0f andAlpha:1.0]; }
+ (UIColor *)springDarkGreen { return [self colorWithRed:45.0f andGreen:94.0f andBlue:90.0f andAlpha:1.0]; }
+ (UIColor *)springBlue { return [self colorWithRed:133.0f andGreen:187.0f andBlue:187.0f andAlpha:1.0]; }
+ (UIColor *)springGreen { return [self colorWithRed:167.0f andGreen:217.0f andBlue:180.0f andAlpha:1.0]; }
+ (NSArray *)springPalette
{
    return @[[self dataForColor:[self springLightPink]], [self dataForColor:[self springPink]], [self dataForColor:[self springRed]],
             [self dataForColor:[self springDarkGreen]], [self dataForColor:[self springBlue]], [self dataForColor:[self springGreen]]];
}

+ (UIColor *)summerYellow { return [self colorWithRed:255.0f andGreen:241.0f andBlue:119.0f andAlpha:1.0]; }
+ (UIColor *)summerTan { return [self colorWithRed:255.0f andGreen:218.0f andBlue:112.0f andAlpha:1.0]; }
+ (UIColor *)summerOrange { return [self colorWithRed:244.0f andGreen:108.0f andBlue:24.0f andAlpha:1.0]; }
+ (UIColor *)summerTeal { return [self colorWithRed:162.0f andGreen:228.0f andBlue:212.0f andAlpha:1.0]; }
+ (UIColor *)summerBlue { return [self colorWithRed:16.0f andGreen:197.0f andBlue:197.0f andAlpha:1.0]; }
+ (UIColor *)summerGreen { return [self colorWithRed:195.0f andGreen:238.0f andBlue:195.0f andAlpha:1.0]; }
+ (NSArray *)summerPalette
{
    return @[[self dataForColor:[self summerYellow]], [self dataForColor:[self summerTan]], [self dataForColor:[self summerOrange]],
             [self dataForColor:[self summerTeal]], [self dataForColor:[self summerBlue]], [self dataForColor:[self summerGreen]]];
}

+ (UIColor *)autumnYellow { return [self colorWithRed:244.0f andGreen:242.0f andBlue:173.0f andAlpha:1.0]; }
+ (UIColor *)autumnOrange { return [self colorWithRed:223.0f andGreen:130.0f andBlue:93.0f andAlpha:1.0]; }
+ (UIColor *)autumnRed { return [self colorWithRed:180.0f andGreen:71.0f andBlue:66.0f andAlpha:1.0]; }
+ (UIColor *)autumnBrown { return [self colorWithRed:125.0f andGreen:91.0f andBlue:71.0f andAlpha:1.0]; }
+ (UIColor *)autumnGreen { return [self colorWithRed:117.0f andGreen:125.0f andBlue:92.0f andAlpha:1.0]; }
+ (UIColor *)autumnLightBrown { return [self colorWithRed:175.0f andGreen:152.0f andBlue:137.0f andAlpha:1.0]; }
+ (NSArray *)autumnPalette
{
    return @[[self dataForColor:[self autumnYellow]], [self dataForColor:[self autumnOrange]], [self dataForColor:[self autumnRed]],
             [self dataForColor:[self autumnBrown]], [self dataForColor:[self autumnGreen]], [self dataForColor:[self autumnLightBrown]]];
}

+ (UIColor *)pastelRed { return [self colorWithRed:255.0f andGreen:105.0f andBlue:97.0f andAlpha:1.0]; }
+ (UIColor *)pastelOrange { return [self colorWithRed:255.0f andGreen:179.0f andBlue:71.0f andAlpha:1.0]; }
+ (UIColor *)pastelYellow { return [self colorWithRed:253.0f andGreen:153.0f andBlue:150.0f andAlpha:1.0]; }
+ (UIColor *)pastelGreen { return [self colorWithRed:119.0f andGreen:221.0f andBlue:119.0f andAlpha:1.0]; }
+ (UIColor *)pastelBlue { return [self colorWithRed:119.0f andGreen:158.0f andBlue:203.0f andAlpha:1.0]; }
+ (UIColor *)pastelPurple { return [self colorWithRed:100.0f andGreen:20.0f andBlue:100.0f andAlpha:1.0]; }
+ (NSArray *)pastelPalette
{
    return @[[self dataForColor:[self pastelRed]], [self dataForColor:[self pastelOrange]], [self dataForColor:[self pastelYellow]],
             [self dataForColor:[self pastelGreen]], [self dataForColor:[self pastelBlue]], [self dataForColor:[self pastelPurple]]];
}

+ (UIColor *)neonPink { return [self colorWithRed:255.0f andGreen:0.0f andBlue:153.0f andAlpha:1.0]; }
+ (UIColor *)neonYellow { return [self colorWithRed:243.0f andGreen:243.0f andBlue:21.0f andAlpha:1.0]; }
+ (UIColor *)neonGreen { return [self colorWithRed:131.0f andGreen:245.0f andBlue:44.0f andAlpha:1.0]; }
+ (UIColor *)neonOrange { return [self colorWithRed:255.0f andGreen:102.0f andBlue:0.0f andAlpha:1.0]; }
+ (UIColor *)neonBlue { return [self colorWithRed:25.0f andGreen:50.0f andBlue:209.0f andAlpha:1.0]; }
+ (UIColor *)neonPurple { return [self colorWithRed:110.0f andGreen:13.0f andBlue:208.0f andAlpha:1.0];}
+ (NSArray *)neonPalette
{
    return @[[self dataForColor:[self neonPink]], [self dataForColor:[self neonYellow]], [self dataForColor:[self neonGreen]],
             [self dataForColor:[self neonOrange]], [self dataForColor:[self neonBlue]], [self dataForColor:[self neonPurple]]];
}

+ (UIColor *)watermelonLightGreen { return [self colorWithRed:198.0f andGreen:215.0f andBlue:185.0f andAlpha:1.0]; }
+ (UIColor *)watermelonPink { return [self colorWithRed:246.0f andGreen:185.0f andBlue:173.0f andAlpha:1.0]; }
+ (UIColor *)watermelonRed { return [self colorWithRed:238.0f andGreen:111.0f andBlue:104.0f andAlpha:1.0]; }
+ (UIColor *)watermelonLightOrange { return [self colorWithRed:255.0f andGreen:165.0f andBlue:79.0f andAlpha:1.0]; }
+ (UIColor *)watermelonOrange { return [self colorWithRed:246.0f andGreen:143.0f andBlue:60.0f andAlpha:1.0]; }
+ (UIColor *)watermelonGreen { return [self colorWithRed:94.0f andGreen:141.0f andBlue:90.0f andAlpha:1.0]; }
+ (NSArray *)watermelonPalette
{
    return @[[self dataForColor:[self watermelonLightGreen]], [self dataForColor:[self watermelonPink]], [self dataForColor:[self watermelonRed]],
             [self dataForColor:[self watermelonLightOrange]], [self dataForColor:[self watermelonOrange]], [self dataForColor:[self watermelonGreen]]];
}

+ (UIColor *)peppermintWhite { return [self colorWithRed:231.0f andGreen:236.0f andBlue:236.0f andAlpha:1.0]; }
+ (UIColor *)peppermintLightBlue { return [self colorWithRed:203.0f andGreen:209.0f andBlue:217.0f andAlpha:1.0]; }
+ (UIColor *)peppermintBlue { return [self colorWithRed:64.0f andGreen:89.0f andBlue:105.0f andAlpha:1.0]; }
+ (UIColor *)peppermintDarkRed { return [self colorWithRed:142.0f andGreen:25.0f andBlue:52.0f andAlpha:1.0]; }
+ (UIColor *)peppermintRed { return [self colorWithRed:190.0f andGreen:16.0f andBlue:65.0f andAlpha:1.0]; }
+ (UIColor *)peppermintLightRed { return [self colorWithRed:219.0f andGreen:194.0f andBlue:198.0f andAlpha:1.0]; }
+ (NSArray *)peppermintPalette
{
    return @[[self dataForColor:[self peppermintWhite]], [self dataForColor:[self peppermintLightBlue]], [self dataForColor:[self peppermintBlue]],
             [self dataForColor:[self peppermintDarkRed]], [self dataForColor:[self peppermintRed]], [self dataForColor:[self peppermintLightRed]]];
}

+ (UIColor *)petalPink { return [self colorWithRed:233.0f andGreen:211.0f andBlue:224.0f andAlpha:1.0]; }
+ (UIColor *)petalOrange { return [self colorWithRed:222.0f andGreen:176.0f andBlue:110.0f andAlpha:1.0]; }
+ (UIColor *)petalRed { return [self colorWithRed:179.0f andGreen:86.0f andBlue:110.0f andAlpha:1.0]; }
+ (UIColor *)petalBrown { return [self colorWithRed:99.0 andGreen:92.0f andBlue:86.0f andAlpha:1.0]; }
+ (UIColor *)petalGreen { return [self colorWithRed:134.0f andGreen:158.0f andBlue:113.0f andAlpha:1.0]; }
+ (UIColor *)petalTeal { return [self colorWithRed:157.0f andGreen:195.0f andBlue:173.0f andAlpha:1.0]; }
+ (NSArray *)petalPalette
{
    return @[[self dataForColor:[self petalPink]], [self dataForColor:[self petalOrange]], [self dataForColor:[self petalRed]],
             [self dataForColor:[self petalBrown]], [self dataForColor:[self petalGreen]], [self dataForColor:[self petalTeal]]];
}

+ (UIColor *)earthYellow { return [self colorWithRed:245.0f andGreen:200.0f andBlue:145.0f andAlpha:1.0]; }
+ (UIColor *)earthRed { return [self colorWithRed:190.0f andGreen:101.0f andBlue:91.0f andAlpha:1.0]; }
+ (UIColor *)earthBlack { return [self colorWithRed:38.0f andGreen:34.0f andBlue:48.0f andAlpha:1.0]; }
+ (UIColor *)earthDarkBlue { return [self colorWithRed:49.0f andGreen:54.0f andBlue:85.0f andAlpha:1.0]; }
+ (UIColor *)earthTurquoise { return [self colorWithRed:90.0f andGreen:180.0f andBlue:189.0f andAlpha:1.0]; }
+ (UIColor *)earthBlue { return [self colorWithRed:191.0f andGreen:221.0f andBlue:218.0f andAlpha:1.0f]; }
+ (NSArray *)earthPalette
{
    return @[[self dataForColor:[self earthYellow]], [self dataForColor:[self earthRed]], [self dataForColor:[self earthBlack]],
             [self dataForColor:[self earthDarkBlue]], [self dataForColor:[self earthTurquoise]], [self dataForColor:[self earthBlue]]];
}

+ (UIColor *)skylightsLightGreen { return [self colorWithRed:174.0f andGreen:236.0f andBlue:212.0f andAlpha:1.0]; }
+ (UIColor *)skylightsGreen { return [self colorWithRed:109.0f andGreen:189.0f andBlue:139.0f andAlpha:1.0]; }
+ (UIColor *)skylightsDarkGreen { return [self colorWithRed:37.0f andGreen:68.0f andBlue:49.0f andAlpha:1.0]; }
+ (UIColor *)skylightsDark { return [self colorWithRed:23.0f andGreen:32.0f andBlue:43.0f andAlpha:1.0]; }
+ (UIColor *)skylightsBlue { return [self colorWithRed:49.0 andGreen:95.0f andBlue:110.0f andAlpha:1.0]; }
+ (UIColor *)skylightsRed { return [self colorWithRed:253.0f andGreen:109.0f andBlue:94.0f andAlpha:1.0]; }
+ (NSArray *)skylightsPalette
{
    return @[[self dataForColor:[self skylightsLightGreen]], [self dataForColor:[self skylightsGreen]], [self dataForColor:[self skylightsDarkGreen]],
             [self dataForColor:[self skylightsDark]], [self dataForColor:[self skylightsBlue]], [self dataForColor:[self skylightsRed]]];
}

+ (UIColor *)purplesOne { return [self colorWithRed:236.0f andGreen:201.0f andBlue:220.0f andAlpha:1.0]; }
+ (UIColor *)purplesTwo { return [self colorWithRed:163.0f andGreen:146.0f andBlue:162.0f andAlpha:1.0]; }
+ (UIColor *)purplesThree { return [self colorWithRed:122.0f andGreen:100.0f andBlue:113.0f andAlpha:1.0]; }
+ (UIColor *)purplesFour { return [self colorWithRed:127.0f andGreen:77.0f andBlue:126.0f andAlpha:1.0]; }
+ (UIColor *)purplesFive { return [self colorWithRed:198.0f andGreen:137.0f andBlue:203.0f andAlpha:1.0]; }
+ (UIColor *)purplesSix { return [self colorWithRed:244.0f andGreen:207.0f andBlue:255.0f andAlpha:1.0]; }
+ (NSArray *)purplesPalette
{
    return @[[self dataForColor:[self purplesOne]], [self dataForColor:[self purplesTwo]], [self dataForColor:[self purplesThree]],
             [self dataForColor:[self purplesFour]], [self dataForColor:[self purplesFive]], [self dataForColor:[self purplesSix]]];
}

+ (UIColor *)greenteaWhite { return [self colorWithRed:238.0f andGreen:233.0f andBlue:227.0f andAlpha:1.0]; }
+ (UIColor *)greenteaLightGreen { return [self colorWithRed:238.0f andGreen:248.0f andBlue:162.0f andAlpha:1.0]; }
+ (UIColor *)greenteaGreen { return [self colorWithRed:174.0f andGreen:191.0f andBlue:88.0f andAlpha:1.0]; }
+ (UIColor *)greenteaDarkGreen { return [self colorWithRed:64.0f andGreen:98.0f andBlue:55.0f andAlpha:1.0]; }
+ (UIColor *)greenteaDarkBrown { return [self colorWithRed:51.0f andGreen:41.0f andBlue:24.0f andAlpha:1.0]; }
+ (UIColor *)greenteaBrown {return [self colorWithRed:153.0f andGreen:129.0f andBlue:108.0f andAlpha:1.0]; }
+ (NSArray *)greenteaPalette
{
    return @[[self dataForColor:[self greenteaWhite]], [self dataForColor:[self greenteaLightGreen]], [self dataForColor:[self greenteaGreen]],
             [self dataForColor:[self greenteaDarkGreen]], [self dataForColor:[self greenteaDarkBrown]], [self dataForColor:[self greenteaBrown]]];
}

+ (UIColor *)horizonPurple { return [self colorWithRed:120.0f andGreen:106.0f andBlue:127.0f andAlpha:1.0]; }
+ (UIColor *)horizonTan { return [self colorWithRed:158.0f andGreen:116.0f andBlue:113.0f andAlpha:1.0]; }
+ (UIColor *)horizonOrange { return [self colorWithRed:236.0f andGreen:172.0f andBlue:119.0f andAlpha:1.0]; }
+ (UIColor *)horizonYellow { return [self colorWithRed:253.0f andGreen:231.0f andBlue:193.0f andAlpha:1.0]; }
+ (UIColor *)horizonBrown { return [self colorWithRed:157.0f andGreen:126.0f andBlue:99.0f andAlpha:1.0]; }
+ (UIColor *)horizonDarkBrown { return [self colorWithRed:53.0f andGreen:37.0f andBlue:35.0f andAlpha:1.0]; }
+ (NSArray *)horizonPalette
{
    return @[[self dataForColor:[self horizonPurple]], [self dataForColor:[self horizonTan]], [self dataForColor:[self horizonOrange]],
             [self dataForColor:[self horizonYellow]], [self dataForColor:[self horizonBrown]], [self dataForColor:[self horizonDarkBrown]]];
}

#pragma mark - Basic Methods/Colors

+ (UIColor *)interactiveColor
{
    return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
}

+ (UIColor *)mainInteractiveColor
{
    return [self colorWithRed:128.0f andGreen:128.0f andBlue:128.0f andAlpha:1.0];
}

+ (UIColor *)deleteColor
{
    return [self colorWithRed:250.0f andGreen:128.0f andBlue:114.0f andAlpha:1.0f];
}


+ (UIColor *)randomColor
{
    NSInteger randomNum = arc4random() % 6;
    return [[self colorArrayWithColorData:[self colorsInUse]] objectAtIndex:randomNum];
}

#pragma mark - Retrieval Methods

+ (NSMutableDictionary *)initializeColorDict
{
    NSDictionary *colorDictionary = @{BACKDROP_KEY: [NSKeyedArchiver archivedDataWithRootObject:[UIColor whiteColor]],
                                      OPPOSITE_BACKDROP_KEY: [NSKeyedArchiver archivedDataWithRootObject:[UIColor blackColor]],
                                      COLORS_IN_USE_NAME_KEY : @"Standard",
                                      COLORS_IN_USE_PALETTE_KEY: [self standardPalette]};
    [[NSUserDefaults standardUserDefaults] setObject:colorDictionary forKey:COLORS_DICTIONARY_KEY];
    return [colorDictionary mutableCopy];
}

+ (NSDictionary *)colorDictionary
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *colorDictionary = [defaults dictionaryForKey:COLORS_DICTIONARY_KEY];
    if (!colorDictionary) colorDictionary = [self initializeColorDict];
    return colorDictionary;
}

+ (UIColor *)checkForColor:(NSString *)colorKey withDefaultColor:(UIColor *)defaultColor
{
    return [self colorForData:[[self colorDictionary] objectForKey:colorKey]];
}

+ (UIColor *)backdropColor
{
    return [Colors checkForColor:BACKDROP_KEY withDefaultColor:[UIColor whiteColor]];
}

+ (UIColor *)oppositeBackdropColor
{
    return [Colors checkForColor:OPPOSITE_BACKDROP_KEY withDefaultColor:[UIColor blackColor]];
}

+ (UIColor *)colorForColorIndex:(NSInteger)colorIndex
{
    NSArray *colorsInUse = [self colorsInUse];
    switch (colorIndex) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            return [self colorForData:[colorsInUse objectAtIndex:colorIndex]];
            break;
        default:
            return [self mainInteractiveColor];
            break;
    }
}

+ (NSArray *)colorArrayWithColorData:(NSArray *)colorData
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [colorData count]; i++) {
        [colors addObject:[self colorForData:[colorData objectAtIndex:i]]];
    }
    return colors;
}

+ (NSArray *)colorArrayToColorData:(NSArray *)colors
{
    NSMutableArray *colorData = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [colors count]; i++) {
        [colorData addObject:[self dataForColor:[colors objectAtIndex:i]]];
    }
    return colorData;
}

+ (NSArray *)colorsInUse
{
    return [[self colorDictionary] objectForKey:COLORS_IN_USE_PALETTE_KEY];
}

+ (NSString *)currentPaletteName
{
    return [[self colorDictionary] objectForKey:COLORS_IN_USE_NAME_KEY];
}

+ (NSArray *)currentPalette
{
    return [self colorArrayWithColorData:[self colorsInUse]];
}

+ (NSDictionary *)possiblePalettesDict
{
    return @{@"Standard" : [self colorArrayWithColorData:[self standardPalette]], @"Pastel" : [self colorArrayWithColorData:[self pastelPalette]], @"Neon" : [self colorArrayWithColorData:[self neonPalette]], @"Watermelon" : [self colorArrayWithColorData:[self watermelonPalette]], @"Flower Petals" : [self colorArrayWithColorData:[self petalPalette]], @"Earth" : [self colorArrayWithColorData:[self earthPalette]], @"Northern Lights" : [self colorArrayWithColorData:[self skylightsPalette]], @"Horizon" : [self colorArrayWithColorData:[self horizonPalette]], @"Green Tea" : [self colorArrayWithColorData:[self greenteaPalette]],  @"Peppermint" : [self colorArrayWithColorData:[self peppermintPalette]], @"Purples" : [self colorArrayWithColorData:[self purplesPalette]], @"Winter" : [self colorArrayWithColorData:[self winterPalette]], @"Spring" : [self colorArrayWithColorData:[self springPalette]], @"Summer" : [self colorArrayWithColorData:[self summerPalette]], @"Autumn" : [self colorArrayWithColorData:[self autumnPalette]]};
}

+ (NSArray *)possiblePalettes
{
    return @[@"Standard", @"Pastel", @"Neon", @"Watermelon", @"Flower Petals", @"Earth", @"Northern Lights", @"Horizon", @"Green Tea", @"Peppermint", @"Purples", @"Winter", @"Spring", @"Summer", @"Autumn"];
}

+ (NSArray *)colorsForPalette:(NSString *)palette
{
    return [[self possiblePalettesDict] objectForKey:palette];
}

#pragma mark - Default Changing Methods

+ (void)switchBackdropColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *colorDictionary = [[defaults dictionaryForKey:COLORS_DICTIONARY_KEY] mutableCopy];
    UIColor *backdropColor = [self colorForData:[colorDictionary objectForKey:BACKDROP_KEY]];
    if ([backdropColor isEqual:[UIColor whiteColor]]) {
        [colorDictionary setObject:[self dataForColor:[UIColor blackColor]] forKey:BACKDROP_KEY];
        [colorDictionary setObject:[self dataForColor:[UIColor whiteColor]] forKey:OPPOSITE_BACKDROP_KEY];
    } else {
        [colorDictionary setObject:[self dataForColor:[UIColor whiteColor]] forKey:BACKDROP_KEY];
        [colorDictionary setObject:[self dataForColor:[UIColor blackColor]] forKey:OPPOSITE_BACKDROP_KEY];
    }
    [[NSUserDefaults standardUserDefaults] setObject:colorDictionary forKey:COLORS_DICTIONARY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)switchPaletteToPaletteWithName:(NSString *)paletteName andColors:(NSArray *)colors
{
    NSMutableDictionary *colorDictionary = [[self colorDictionary] mutableCopy];
    [colorDictionary setObject:paletteName forKey:COLORS_IN_USE_NAME_KEY];
    [colorDictionary setObject:[self colorArrayToColorData:colors] forKey:COLORS_IN_USE_PALETTE_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:colorDictionary forKey:COLORS_DICTIONARY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
