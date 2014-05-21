//
//  ListItem+Reorder.h
//  SquareList
//
//  Created by Skylar Peterson on 12/6/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ListItem.h"

@interface ListItem (Reorder)

- (void)shiftOrderforList:(List *)list
                  toOrder:(NSInteger)order
        inManagedDocument:(UIManagedDocument *)document
       movingItemDownward:(BOOL)downward;

@end
