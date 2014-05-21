//
//  SingleListViewController.h
//  SquareList
//
//  Created by Skylar Peterson on 11/18/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

@interface SingleListViewController : UIViewController

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) List *list;

@end
