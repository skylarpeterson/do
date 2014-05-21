//
//  ColorSelectionView.m
//  SquareList
//
//  Created by Skylar Peterson on 12/5/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ColorSelectionView.h"

#import "Colors.h"
#import "Fonts.h"

@interface ColorSelectionView()

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic) BOOL oniPad;

@end

@implementation ColorSelectionView

- (void)setTextColor:(NSInteger)textColor
{
    _textColor = textColor;
    for (int i = 0; i < [self.buttons count]; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        [button setTitleColor:(textColor == 0) ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
    }
}

#define SELECTED_BORDER_WIDTH 5.0
- (void)setSelectedColor:(NSInteger)selectedColor
{
    _selectedColor = selectedColor;
    if (selectedColor < 0) return;
    if (self.selectedButton) self.selectedButton.layer.borderWidth = 0.0;
    UIButton *colorButton = [self.buttons objectAtIndex:selectedColor];
    colorButton.layer.borderWidth = SELECTED_BORDER_WIDTH;
    if (self.oniPad) colorButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    else colorButton.layer.borderColor = [[Colors backdropColor] CGColor];
    self.selectedButton = colorButton;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.oniPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
        NSMutableArray *tempButtons = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i++) {
            UIButton *colorButton = [[UIButton alloc] init];
            colorButton.titleLabel.font = [Fonts subBodyTextFont];
            [colorButton setTitle:[NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
            [colorButton setTitleColor:(self.textColor == 0) ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
            //[colorButton setTitleColor:[Colors colorForColorIndex:i] forState:UIControlStateDisabled];
            [colorButton setBackgroundImage:[ColorSelectionView imageWithColor:[Colors colorForColorIndex:i]] forState:UIControlStateNormal];
            [colorButton setBackgroundImage:[ColorSelectionView imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
            CGColorRef disabledColor = [(UIColor *)[Colors colorForColorIndex:i] CGColor];
            const CGFloat *components = CGColorGetComponents(disabledColor);
            [colorButton setBackgroundImage:[ColorSelectionView imageWithColor:[UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:.6]] forState:UIControlStateDisabled];
            [colorButton addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:colorButton];
            [tempButtons addObject:colorButton];
        }
        self.buttons = [tempButtons copy];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat individualWidth = self.frame.size.width/2.0;
    for (NSInteger i = 0; i < COLORS_IN_PALETTES; i++) {
        NSInteger row = i / 2;
        NSInteger col = i % 2;
        UIButton *colorButton = [self.buttons objectAtIndex:i];
        colorButton.frame = CGRectMake(col * individualWidth, row * (self.frame.size.height/3.0), individualWidth, self.frame.size.height / 3.0);
    }
}

#pragma mark - Color Selection Methods

- (void)selectColor:(id)sender
{
    if (self.selectedButton) self.selectedButton.layer.borderWidth = 0.0;
    UIButton *colorButton = (UIButton *)sender;
    
    NSInteger row = (colorButton.frame.origin.y + 1.0) / (self.frame.size.height / 3.0);
    NSInteger col = (colorButton.frame.origin.x + 1.0) / (self.frame.size.width / 2.0);
    NSInteger index = [self indexFromRow:row andCol:col];
    
    self.selectedColor = index;
    self.selectedButton = colorButton;
    if (self.oniPad) self.selectedButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    else colorButton.layer.borderColor = [[Colors backdropColor] CGColor];
    self.selectedButton.layer.borderWidth = SELECTED_BORDER_WIDTH;
}

- (NSInteger)indexFromRow:(NSInteger)row andCol:(NSInteger)col
{
    if (col == 0) {
        if (row == 0) return 0;
        if (row == 1) return 2;
        if (row == 2) return 4;
    } else if (col == 1) {
        if (row == 0) return 1;
        if (row == 1) return 3;
        if (row == 2) return 5;
    }
    return -1;
}

#pragma mark - Class Provided Methods

// stack overflow 990976
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
