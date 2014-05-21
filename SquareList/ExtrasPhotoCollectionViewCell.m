//
//  ExtrasPhotoCollectionViewCell.m
//  SquareList
//
//  Created by Skylar Peterson on 12/7/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ExtrasPhotoCollectionViewCell.h"

@interface ExtrasPhotoCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ExtrasPhotoCollectionViewCell

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageView];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
}

@end
