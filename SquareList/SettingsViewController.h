//
//  SettingsViewController.h
//  SquareList
//
//  Created by Skylar Peterson on 11/28/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsDelegate <NSObject>

@optional
- (void)backdropColorChanged;
- (void)paletteChanged;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) id<SettingsDelegate> delegate;

@end
