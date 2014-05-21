//
//  ColorPaletteView.h
//  SquareList
//
//  Created by Skylar Peterson on 12/7/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPaletteView : UIView

@property (nonatomic, strong) NSArray *colors;

- (UIImage *)imageFromView;

@end
