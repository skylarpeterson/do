//
//  SingleListViewController.m
//  SquareList
//
//  Created by Skylar Peterson on 11/18/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SingleListViewController.h"
#import "SingleListCell.h"
#import "ListItem+Reorder.h"

#import "CustomTableView.h"
#import "SingleListCellExtrasView.h"

#import "ImageViewingController.h"

#import "Colors.h"
#import "Fonts.h"

@interface SingleListViewController () <UITextFieldDelegate, SingleListCellDelegate, ListExtrasViewDataSource, CustomTableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet CustomTableView *tableView;

@property (nonatomic, strong) NSMutableArray *listItems;
@property (nonatomic, strong) UITableViewCell *selectedCell;
@property (nonatomic) BOOL addingCell;
@property (nonatomic) BOOL movingCell;
@property (nonatomic, strong) SingleListCell *browsingCell;
@property (nonatomic, strong) SingleListCellExtrasView *extrasView;
@property (nonatomic) BOOL browsingPhotos;
@property (nonatomic) BOOL keyboardVisible;

@end

#define CELL_IDENTIFIER @"List Cell"
#define SHOW_PHOTO_IDENTIFIER @"ShowPhoto"
#define NUM_BADGE_KEY @"NumForBadgeIcon"

@implementation SingleListViewController

- (void)setList:(List *)list
{
    _list = list;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:self.document.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    request.predicate = [NSPredicate predicateWithFormat:@"list == %@", list];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES]]];
    
    NSError *error;
    NSArray *array = [self.document.managedObjectContext executeFetchRequest:request error:&error];
    if (!array) {
        NSLog(@"Array is nil");
    } else {
        self.listItems = [array mutableCopy];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.view.clipsToBounds = NO;
    self.view.tintColor = [Colors interactiveColor];
    
    self.view.backgroundColor = [Colors colorForColorIndex:self.list.color.integerValue];
    
    self.titleField.text = self.list.title;
    self.titleField.textColor = (self.list.textColor.integerValue == 0) ? [UIColor whiteColor] : [UIColor blackColor];
    self.titleField.font = [Fonts mainTitleFont];
    self.titleField.adjustsFontSizeToFitWidth = YES;
    self.titleField.returnKeyType = UIReturnKeyDone;
    self.titleField.delegate = self;
    
    [self.addButton setBackgroundImage:[[UIImage imageNamed:@"AddIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.closeButton setBackgroundImage:[[UIImage imageNamed:@"CloseIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.borderColor = [[Colors interactiveColor] CGColor];
    self.tableView.layer.borderWidth = 1.0f;
    
    self.keyboardVisible = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.list.textColor.integerValue == 0) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - Table view data source

- (Class)classForCellType
{
    return [SingleListCell class];
}

- (UIFont *)fontForTableView
{
    return [Fonts bodyTextFont];
}

- (NSInteger)numRowsForTableView
{
    return [self.listItems count];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListItem *listItem = [self.listItems objectAtIndex:indexPath.row];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:listItem.contents
                                                                         attributes:@{ NSFontAttributeName : [Fonts bodyTextFont]}];
    CGSize textViewSize = [SingleListCell sizeForTextViewWithText:attributedText inCellWidth:self.tableView.frame.size.width - LIST_COMPLETION_VIEW_SIZE - IMAGE_BUTTON_SIZE];
    return textViewSize.height + 40.0;
}

- (UITableViewCell *)infoForCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath includingTitle:(BOOL)titleIncluded
{
    if ([cell isKindOfClass:[SingleListCell class]]) {
        SingleListCell *listCell = (SingleListCell *)cell;
        
        if (titleIncluded) {
            ListItem *listItem = [self.listItems objectAtIndex:indexPath.row];
            listCell.listItem = listItem;
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:listItem.contents
                                                                                 attributes:@{ NSFontAttributeName : [Fonts bodyTextFont],
                                                                                               NSForegroundColorAttributeName : (self.list.textColor.integerValue == 0) ? [UIColor whiteColor] : [UIColor blackColor] }];
            listCell.text = attributedText;
            if ([listItem.completed boolValue]) cell.alpha = 0.5;
            else cell.alpha = 1.0;
        } else {
            listCell.text = [[NSAttributedString alloc] initWithString:@""
                                                            attributes:@{ NSFontAttributeName : [Fonts bodyTextFont] }];
        }
        listCell.color = [Colors colorForColorIndex:self.list.color.integerValue];
        listCell.delegate = self;
    }
    return cell;
}

- (void)cellAdded:(UITableViewCell *)cell
{
    SingleListCell *listCell = (SingleListCell *)cell;
    listCell.textColor = (self.list.textColor.integerValue == 0) ? [UIColor whiteColor] : [UIColor blackColor];
    [listCell cellJustAdded];
}

#pragma mark - Single List Cell delegate methods

- (void)textViewDidBeginEditingForCell:(UITableViewCell *)cell
{
    self.selectedCell = cell;
}

- (void)textViewDidEndEditingForCell:(UITableViewCell *)cell
{
    if ([self.selectedCell isEqual:cell]) {
        self.selectedCell = nil;
    }
}

- (void)textViewDidGrowVertically:(UITableViewCell *)cell toHeight:(CGFloat)height
{
    [self.tableView growCellAtRow:[self.tableView rowForCell:cell] toHeight:height];
}

- (void)editedTextChanged:(UITableViewCell *)cell
{    SingleListCell *listCell = (SingleListCell *)cell;
    if (self.addingCell) {
        ListItem *listItem = [NSEntityDescription insertNewObjectForEntityForName:@"ListItem"
                                                           inManagedObjectContext:self.document.managedObjectContext];
        listItem.completed = [NSNumber numberWithBool:NO];
        listItem.order = [NSNumber numberWithInteger:[self.listItems count]];
        listItem.contents = listCell.text.string;
        listItem.numPhotos = [NSNumber numberWithInt:0];
        listItem.photos = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
        listItem.list = self.list;
        
        [listItem shiftOrderforList:self.list
                            toOrder:0
                  inManagedDocument:self.document
                 movingItemDownward:NO];
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForOverwriting
               completionHandler:^(BOOL finished){
                   listCell.listItem = listItem;
               }];
        
        NSNumber *numForBadge = [[NSUserDefaults standardUserDefaults] objectForKey:NUM_BADGE_KEY];
        numForBadge = [NSNumber numberWithInt:numForBadge.intValue + 1];
        [[NSUserDefaults standardUserDefaults] setObject:numForBadge forKey:NUM_BADGE_KEY];
        
        self.addingCell = NO;
    } else {
        listCell.listItem.contents = listCell.text.string;
    }
}

- (void)editedTextIsBlank:(UITableViewCell *)cell
{
    SingleListCell *listCell = (SingleListCell *)cell;
    [self.tableView removeCell:cell animated:YES];
    [self.listItems removeObjectAtIndex:[self.tableView rowForCell:cell]];
    if (!self.addingCell) [self.document.managedObjectContext deleteObject:listCell.listItem];
    else self.addingCell = NO;
    if (self.selectedCell) self.selectedCell = nil;
}

- (BOOL)shouldChangeItemCompletion
{
    if (self.keyboardVisible || self.browsingPhotos) return NO;
    return YES;
}

- (void)changeItemCompletion:(UITableViewCell *)cell toBOOL:(BOOL)completed
{
    SingleListCell *listCell = (SingleListCell *)cell;
    listCell.listItem.completed = [NSNumber numberWithBool:completed];
    if (completed) {
        [listCell.listItem shiftOrderforList:self.list
                                     toOrder:[self.listItems count] - 1
                           inManagedDocument:self.document
                          movingItemDownward:YES];
        [self.tableView moveCell:listCell toIndex:[self.listItems count] - 1 animated:YES completion:nil];
        NSNumber *numForBadge = [[NSUserDefaults standardUserDefaults] objectForKey:NUM_BADGE_KEY];
        numForBadge = [NSNumber numberWithInt:numForBadge.intValue - 1];
        [[NSUserDefaults standardUserDefaults] setObject:numForBadge forKey:NUM_BADGE_KEY];
    } else {
        [listCell.listItem shiftOrderforList:self.list
                                     toOrder:0
                           inManagedDocument:self.document
                          movingItemDownward:NO];
        [self.tableView moveCell:listCell toIndex:0 animated:YES completion:nil];
        NSNumber *numForBadge = [[NSUserDefaults standardUserDefaults] objectForKey:NUM_BADGE_KEY];
        numForBadge = [NSNumber numberWithInt:numForBadge.intValue + 1];
        [[NSUserDefaults standardUserDefaults] setObject:numForBadge forKey:NUM_BADGE_KEY];
    }
}

- (void)showPhotosForCell:(UITableViewCell *)cell
{
    if (self.keyboardVisible || (self.browsingCell && ![self.browsingCell isEqual:cell])) return;
    if (self.browsingPhotos) {
        self.browsingCell = nil;
        self.tableView.scrollView.contentSize = CGSizeMake(self.tableView.scrollView.contentSize.width, self.tableView.scrollView.contentSize.height - 100.0f);
        self.browsingPhotos = NO;
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.extrasView.alpha = 0.0;
                             SingleListCell *listCell = (SingleListCell *)cell;
                             [listCell shiftCellBorderByOffset:-100.0f];
                             [self.tableView shiftCellsStartingAtRow:[self.tableView rowForCell:cell] + 1 toEndRow:[self.listItems count] byOffset:-100.0f];
                         }completion:^(BOOL finished){
                             if (finished) {
                                 [self.extrasView removeFromSuperview];
                                 self.extrasView = nil;
                             }
                         }];
    } else {
        self.browsingPhotos = YES;
        self.tableView.scrollView.contentSize = CGSizeMake(self.tableView.scrollView.contentSize.width, self.tableView.scrollView.contentSize.height + 100.0f);
        self.browsingCell = (SingleListCell *)cell;
        self.extrasView = [[SingleListCellExtrasView alloc] initWithFrame:CGRectMake(0.0, cell.frame.origin.y + cell.frame.size.height, cell.frame.size.width, 100.0f)];
        self.extrasView.photos = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:self.browsingCell.listItem.photos];
        self.extrasView.dataSource = self;
        self.extrasView.alpha = 0.0;
        [self.tableView.scrollView insertSubview:self.extrasView aboveSubview:cell];
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.tableView shiftCellsStartingAtRow:[self.tableView rowForCell:cell] + 1 toEndRow:[self.listItems count] byOffset:100.0f];
                             SingleListCell *listCell = (SingleListCell *)cell;
                             [listCell shiftCellBorderByOffset:100.0f];
                             self.extrasView.alpha = 1.0;
                         }
                         completion:nil];
    }
}

- (void)deleteItemForCell:(UITableViewCell *)cell
{
    if (self.keyboardVisible || self.browsingPhotos) return;
    SingleListCell *listCell = (SingleListCell *)cell;
    
    if (listCell.listItem.completed.boolValue == NO) {
        NSNumber *numForBadge = [[NSUserDefaults standardUserDefaults] objectForKey:NUM_BADGE_KEY];
        numForBadge = [NSNumber numberWithInt:numForBadge.intValue - 1];
        [[NSUserDefaults standardUserDefaults] setObject:numForBadge forKey:NUM_BADGE_KEY];
    }
    
    [self.tableView removeCell:listCell animated:YES];
    [self.listItems removeObjectAtIndex:[self.tableView rowForCell:cell]];
    [self.document.managedObjectContext deleteObject:listCell.listItem];
}

- (void)cellMoved:(UITableViewCell *)cell
{
    SingleListCell *cellToMove = (SingleListCell *)[self.tableView cellWithMiddleOverlappingAboveCell:cell];
    if (!cellToMove) cellToMove = (SingleListCell *)[self.tableView cellWithMiddleOverlappingBelowCell:cell];
    if (cellToMove && !self.movingCell) {
        self.movingCell = YES;
        NSInteger row = [self.tableView rowForCell:cell];
        NSNumber *newRow = cellToMove.listItem.order;
        cellToMove.listItem.order = [NSNumber numberWithInteger:row];
        SingleListCell *newCell = (SingleListCell *)cell;
        newCell.listItem.order = newRow;
        [self.tableView moveCell:cellToMove toIndex:row animated:YES completion:^{
            self.movingCell = NO;
        }];
    }
}

- (CGPoint)newOriginForMovedCell:(UITableViewCell *)cell
{
    SingleListCell *newCell = (SingleListCell *)cell;
    return [self.tableView originForCellAtIndex:newCell.listItem.order.integerValue];
}

#pragma mark - List Extras Data Source Methods

// Taken from http://www.appcoda.com/ios-programming-camera-iphone-app/
- (void)takePhoto
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

// Taken from http://www.appcoda.com/ios-programming-camera-iphone-app/
- (void)choosePhoto
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)photoSelected:(UIImage *)photo
{
    [self performSegueWithIdentifier:SHOW_PHOTO_IDENTIFIER sender:photo];
}

- (void)photoDeletedAtIndex:(NSInteger)index
{
    NSMutableArray *photos = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:self.browsingCell.listItem.photos];
    [photos removeObjectAtIndex:index];
    self.browsingCell.listItem.photos = [NSKeyedArchiver archivedDataWithRootObject:photos];
    self.browsingCell.listItem.numPhotos = [NSNumber numberWithInteger:self.browsingCell.listItem.numPhotos.integerValue - 1];
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:nil];
}

#pragma mark - Image Picker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.browsingCell.listItem.numPhotos = [NSNumber numberWithInteger:self.browsingCell.listItem.numPhotos.integerValue + 1];
    NSMutableArray *photosArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:self.browsingCell.listItem.photos];
    [photosArray insertObject:chosenImage atIndex:0];
    self.browsingCell.listItem.photos = [NSKeyedArchiver archivedDataWithRootObject:photosArray];
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:nil];
    [self.extrasView addPhoto:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard Methods

// from Text Programming Guide for iOS on Apple Developer Website (slightly modified)
// properly rotated coords comes from stack overflow 11494920. without conversion, problem arises on landscape iPad only
#define X_PADDING 3.0
- (void)keyboardWasShown:(NSNotification *)notification
{
    self.keyboardVisible = YES;
    CGRect rawKeyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect properlyRotatedCoords = [self.view.window convertRect:rawKeyboardRect toView:self.view];
    UIEdgeInsets contentInset = UIEdgeInsetsMake(0.0, 0.0, properlyRotatedCoords.size.height, 0.0);
    self.tableView.scrollView.contentInset = contentInset;
    self.tableView.scrollView.scrollIndicatorInsets = contentInset;
    CGRect aRect = self.view.frame;
    aRect.size.height -= properlyRotatedCoords.size.height;
    CGPoint point = [self.tableView.scrollView convertPoint:self.selectedCell.frame.origin toView:self.view];
    point.x += X_PADDING; // necessary to add because collection view is slightly offscreen (to hide border on either side)
    point.y += self.selectedCell.frame.size.height;
    if (!CGRectContainsPoint(aRect, point) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.selectedCell.frame.origin.y - properlyRotatedCoords.size.height);
        [self.tableView.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    self.keyboardVisible = NO;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.scrollView.contentInset = contentInsets;
    self.tableView.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Button Actions

- (IBAction)addItem:(id)sender
{
    if (self.addingCell || self.browsingPhotos) return;
    self.addingCell = YES;
    [self.listItems addObject:@""];
    [self.tableView addCellAtTop];
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        self.list.title = textField.text;
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForOverwriting
               completionHandler:nil];
        [textField resignFirstResponder];
    }
    return YES;
}

//stack overflow 2523501
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 14) ? NO : YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark - Segues Methods

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (self.keyboardVisible) return NO;
    if ([identifier isEqualToString:@"DismissList"]) {
        if ([self.titleField.text isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"Title Length"
                                        message:@"Title cannot be blank."
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SHOW_PHOTO_IDENTIFIER]) {
        if ([sender isKindOfClass:[UIImage class]]) {
            ImageViewingController *viewController = segue.destinationViewController;
            viewController.image = (UIImage *)sender;
        }
    }
}

#pragma mark - Unwind Methods

- (IBAction)dismissPhoto:(UIStoryboardSegue *)sender { }

@end
