//
//  ColorSelectionView.h
//  SquareList
//
//  Created by Skylar Peterson on 12/5/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorSelectionView : UIView

@property (nonatomic) NSInteger textColor;
@property (nonatomic) NSInteger selectedColor;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
