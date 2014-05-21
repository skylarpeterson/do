//
//  ImageViewingController.m
//  SquareList
//
//  Created by Skylar Peterson on 12/8/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ImageViewingController.h"

#import "Colors.h"

@interface ImageViewingController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ImageViewingController

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    
    self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.width);
    self.scrollView.contentSize = self.image ? self.imageView.frame.size : CGSizeZero;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [Colors backdropColor];
    
    [self.closeButton setBackgroundImage:[[UIImage imageNamed:@"CloseIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([[Colors backdropColor] isEqual:[UIColor blackColor]]) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
