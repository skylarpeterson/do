//
//  SquareListSquareCell.m
//  SquareList
//
//  Created by Skylar Peterson on 11/11/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SquareListSquareCell.h"

#import "Colors.h"
#import "Fonts.h"

@interface SquareListSquareCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SquareListSquareCell

- (UILabel *)titleLabel
{
    if (!_titleLabel) _titleLabel = [[UILabel alloc] init];
    return _titleLabel;
}

- (void)setList:(List *)list
{
    _list = list;
    [self.titleLabel setText:list.title];
    [self.titleLabel setTextColor:(list.textColor.integerValue == 0) ? [UIColor whiteColor] : [UIColor blackColor]];
    self.backgroundColor = [Colors colorForColorIndex:list.color.integerValue];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [Fonts bodyTextFont];
        self.titleLabel.numberOfLines = 5;
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.titleLabel];
    }
    return self;
}

#define LABEL_INSET 6.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(LABEL_INSET/2.0, LABEL_INSET/2.0, self.frame.size.width - LABEL_INSET, self.frame.size.height - LABEL_INSET);
}

@end
