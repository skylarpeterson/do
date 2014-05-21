//
//  Fonts.m
//  Do.
//
//  Created by Skylar Peterson on 12/8/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "Fonts.h"

@implementation Fonts

+ (UIFont *)mainTitleFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:28.0];
}

+ (UIFont *)subTitleFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:24.0];
}

+ (UIFont *)bodyTextFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:20.0];
}

+ (UIFont *)boldBodyTextFont
{
    return [UIFont fontWithName:@"Quicksand-Bold" size:20.0];
}

+ (UIFont *)subBodyTextFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:17.0];
}

+ (UIFont *)introTitleFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:40.0];
}

+ (UIFont *)settingsFont
{
    return [UIFont fontWithName:@"Quicksand-Regular" size:17.0];
}

@end
