//
//  IntroContentViewController.h
//  Do.
//
//  Created by Skylar Peterson on 2/18/14.
//  Copyright (c) 2014 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroContentViewController : UIViewController

@property (nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) NSString *mainTitleText;
@property (nonatomic, strong) NSString *secondaryText;
@property (nonatomic, strong) NSString *imageFile;

@end
