//
//  NewListViewController.m
//  SquareList
//
//  Created by Skylar Peterson on 12/5/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ModalListController.h"
#import "ColorSelectionView.h"

#import "Colors.h"
#import "Fonts.h"

@interface ModalListController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textColorControl;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) ColorSelectionView *colorSelectionView;
@property (nonatomic) BOOL deleteItem;
@property (nonatomic) BOOL oniPad;

@end

@implementation ModalListController

- (ColorSelectionView *)colorSelectionView
{
    if (!_colorSelectionView) _colorSelectionView = [[ColorSelectionView alloc] init];
    return _colorSelectionView;
}

- (void)setCurrentTitle:(NSString *)currentTitle
{
    _currentTitle = currentTitle;
    self.titleField.text = currentTitle;
}

#define BUTTON_HEIGHT 75.0f
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.oniPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    
    self.deleteItem = NO;
    
	self.mainLabel.font = [Fonts mainTitleFont];
    self.titleLabel.font = [Fonts subTitleFont];
    self.titleField.font = [Fonts subTitleFont];
    self.colorLabel.font = [Fonts subTitleFont];
    [self.textColorControl setTitleTextAttributes:@{ NSFontAttributeName : [Fonts subBodyTextFont] }
                                         forState:UIControlStateNormal];
    
    self.createButton.titleLabel.font = [Fonts subTitleFont];
    [self.createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [Fonts subTitleFont];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [Fonts subTitleFont];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.textColorControl addTarget:self
                              action:@selector(changeTextColor)
                    forControlEvents:UIControlEventValueChanged];
    
    self.titleField.returnKeyType = UIReturnKeyDone;
    self.titleField.delegate = self;
    if (self.editing) {
        self.titleField.text = self.list.title;
        self.textColorControl.selectedSegmentIndex = self.list.textColor.integerValue;
        self.colorSelectionView.selectedColor = self.list.color.integerValue;
        self.colorSelectionView.textColor = self.list.textColor.integerValue;
    } else {
        self.colorSelectionView.textColor = 0;
        self.colorSelectionView.selectedColor = -1;
    }
    
    CGFloat borderBezel = 10.0f;
    CGFloat colorHeight;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) colorHeight = 405.0;
    else colorHeight = self.view.frame.size.height - 20.0 - self.mainLabel.frame.size.height - self.titleLabel.frame.size.height - self.colorLabel.frame.size.height - self.textColorControl.frame.size.height - BUTTON_HEIGHT - 2.75 * borderBezel;
    self.colorSelectionView.frame = CGRectMake(borderBezel, self.colorLabel.frame.origin.y + self.colorLabel.frame.size.height + borderBezel, self.colorLabel.frame.size.width, colorHeight - 3.5 * borderBezel);
    [self.view addSubview:self.colorSelectionView];
    
    [self.closeButton setBackgroundImage:[[UIImage imageNamed:@"CloseIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.createButton setBackgroundImage:[ColorSelectionView imageWithColor:[Colors mainInteractiveColor]] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[ColorSelectionView imageWithColor:[Colors mainInteractiveColor]] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[ColorSelectionView imageWithColor:[Colors deleteColor]] forState:UIControlStateNormal];
    
    if (!self.oniPad) {
        self.view.backgroundColor = [Colors backdropColor];
        self.mainLabel.textColor = [Colors oppositeBackdropColor];
        self.titleLabel.textColor = [Colors oppositeBackdropColor];
        self.titleField.textColor = [Colors oppositeBackdropColor];
        self.colorLabel.textColor = [Colors oppositeBackdropColor];
    }
}

- (UIButton *)buttonWithFrame:(CGRect)frame withTitle:(NSString *)title withColor:(UIColor *)color
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = [Fonts subTitleFont];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[ColorSelectionView imageWithColor:color] forState:UIControlStateNormal];
    return button;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.oniPad) return UIStatusBarStyleDefault;
    if ([[Colors backdropColor] isEqual:[UIColor blackColor]]) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

//stack overflow 2523501
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
//    return (newLength > 14) ? NO : YES;
//}

#pragma mark - Target Action Methods

- (void)changeTextColor
{
    self.colorSelectionView.textColor = self.textColorControl.selectedSegmentIndex;
}

#pragma mark - Segue Methods

#define CREATE_LIST_IDENTIFIER @"CreateNewList"
#define SAVE_LIST_IDENTIFIER @"SaveList"
#define DELETE_LIST_IDENTIFIER @"DeleteList"

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:CREATE_LIST_IDENTIFIER] || [identifier isEqualToString:SAVE_LIST_IDENTIFIER]) {
        if ([self.titleField.text isEqualToString:@""]) {
            [self alert:@"List must have a title"];
            return NO;
        } else if (self.colorSelectionView.selectedColor < 0) {
            [self alert:@"List must have a selected color. Tap on a color to select one."];
            return NO;
        } else {
            return YES;
        }
    } else if ([identifier isEqualToString:DELETE_LIST_IDENTIFIER]) {
        if (!self.deleteItem) {
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CREATE_LIST_IDENTIFIER]) {
        NSString *listString = @"List";
        List *newList = [NSEntityDescription insertNewObjectForEntityForName:listString
                                                      inManagedObjectContext:self.document.managedObjectContext];
        newList.title = self.titleField.text;
        newList.color = [NSNumber numberWithInteger:self.colorSelectionView.selectedColor];
        newList.textColor = [NSNumber numberWithInteger:self.textColorControl.selectedSegmentIndex];
        newList.dateAdded = [NSDate date];
        
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForOverwriting
               completionHandler:nil];
        
        self.list = newList;
    } else if ([segue.identifier isEqualToString:SAVE_LIST_IDENTIFIER]) {
        self.list.title = self.titleField.text;
        self.list.color = [NSNumber numberWithInteger:self.colorSelectionView.selectedColor];
        self.list.textColor = [NSNumber numberWithInteger:self.textColorControl.selectedSegmentIndex];
        
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForOverwriting
               completionHandler:nil];
    }
}

- (IBAction)deleteList:(id)sender
{
    [self deleteAlert];
}


#pragma mark - Alert Methods

- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Create New List"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

- (void)deleteAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Delete List"
                                message:@"Are you sure you want to delete this list?"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Delete", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.deleteItem = YES;
        [self performSegueWithIdentifier:DELETE_LIST_IDENTIFIER sender:self];
    } else {
        self.deleteItem = NO;
    }
}

@end
