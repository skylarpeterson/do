//
//  NewListViewController.h
//  SquareList
//
//  Created by Skylar Peterson on 12/5/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

@interface ModalListController : UIViewController

@property (nonatomic, strong) List *list; //set to editing list when in edited mode
@property (nonatomic) BOOL editing;
@property (nonatomic, strong) UIManagedDocument *document;

//Properties only used when editing
@property (nonatomic, strong) NSString *currentTitle;
@property (nonatomic) NSInteger currentColor;

@end
