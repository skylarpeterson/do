//
//  PalettePickerTableViewCell.m
//  SquareList
//
//  Created by Skylar Peterson on 12/7/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "PalettePickerTableViewCell.h"

#import "ColorPaletteView.h"

#import "Colors.h"
#import "Fonts.h"

@interface PalettePickerTableViewCell()

@property (nonatomic, strong) CALayer *topBorder;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ColorPaletteView *paletteView;

@end

@implementation PalettePickerTableViewCell

- (CALayer *)topBorder
{
    if (!_topBorder) _topBorder = [CALayer layer];
    return _topBorder;
}

- (void)setPaletteName:(NSString *)paletteName
{
    _paletteName = paletteName;
    self.titleLabel.text = paletteName;
}

- (void)setPaletteColors:(NSArray *)paletteColors
{
    _paletteColors = paletteColors;
    self.paletteView.colors = paletteColors;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.paletteView = [[ColorPaletteView alloc] init];
        
        BOOL oniPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
        if (!oniPad) {
            self.backgroundColor = [Colors backdropColor];
            self.layer.borderColor = [[Colors oppositeBackdropColor] CGColor];
            self.titleLabel.textColor = [Colors oppositeBackdropColor];
        }
        self.layer.borderWidth = 0.25;
        
        self.titleLabel.font = [Fonts bodyTextFont];
        [self addSubview:self.titleLabel];
        [self addSubview:self.paletteView];
    }
    return self;
}

#define SIDE_INSET 10.0f
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(SIDE_INSET, 0.0, self.frame.size.width - 2*SIDE_INSET, self.frame.size.height / 3.0);
    self.paletteView.frame = CGRectMake(SIDE_INSET, self.frame.size.height / 3.0, self.frame.size.width - 2*SIDE_INSET, 2.0 * self.frame.size.height / 3.0 - SIDE_INSET);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.topBorder.frame = CGRectMake(0.0, self.frame.size.height, self.frame.size.width, 1.0);
}

@end
