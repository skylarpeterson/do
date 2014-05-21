//
//  ListItem+Reorder.m
//  SquareList
//
//  Created by Skylar Peterson on 12/6/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ListItem+Reorder.h"
#import "List.h"

@implementation ListItem (Reorder)

- (void)shiftOrderforList:(List *)list
                  toOrder:(NSInteger)order
        inManagedDocument:(UIManagedDocument *)document
       movingItemDownward:(BOOL)downward
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:document.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    request.predicate = [NSPredicate predicateWithFormat:@"list.title == %@", list.title];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES]]];
    
    NSError *error;
    NSArray *array = [document.managedObjectContext executeFetchRequest:request error:&error];
    
    if (downward) {
        [self moveItems:array
  upwardAtStartingOrder:self.order.integerValue + 1
          toEndingOrder:order];
    } else {
        [self moveItems:array
downwardAtStartingOrder:order
          toEndingOrder:self.order.integerValue - 1];
    }
    self.order = [NSNumber numberWithInteger:order];
    [document saveToURL:document.fileURL
       forSaveOperation:UIDocumentSaveForOverwriting
      completionHandler:nil];
}

- (void)moveItems:(NSArray *)listItems downwardAtStartingOrder:(NSInteger)startOrder toEndingOrder:(NSInteger)endingOrder
{
    for (NSInteger i = startOrder; i <= endingOrder; i++) {
        ListItem *listItem = [listItems objectAtIndex:i];
        listItem.order = [NSNumber numberWithInteger:listItem.order.integerValue + 1];
    }
}

- (void)moveItems:(NSArray *)listItems upwardAtStartingOrder:(NSInteger)startOrder toEndingOrder:(NSInteger)endingOrder
{
    for (NSInteger i = startOrder; i <= endingOrder; i++) {
        ListItem *listItem = [listItems objectAtIndex:i];
        listItem.order = [NSNumber numberWithInteger:listItem.order.integerValue - 1];
    }
}

@end
