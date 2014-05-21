//
//  PalettePickerViewController.m
//  SquareList
//
//  Created by Skylar Peterson on 12/7/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "PalettePickerViewController.h"
#import "PalettePickerTableViewCell.h"

#import "Colors.h"
#import "Fonts.h"

@interface PalettePickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *possiblePalettes;

@end

@implementation PalettePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.possiblePalettes = [Colors possiblePalettes];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.possiblePalettes = [Colors possiblePalettes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL oniPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    if (!oniPad) {
        self.view.backgroundColor = [Colors backdropColor];
        self.tableView.backgroundColor = [Colors backdropColor];
        self.mainLabel.textColor = [Colors oppositeBackdropColor];
        self.tableView.layer.borderColor = [[Colors oppositeBackdropColor] CGColor];
    }
    
    [self.closeButton setBackgroundImage:[[UIImage imageNamed:@"CloseIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
	self.mainLabel.font = [Fonts mainTitleFont];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.borderWidth = 0.5f;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([[Colors backdropColor] isEqual:[UIColor blackColor]]) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - TableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.possiblePalettes count];
}

#define PALETTE_CELL_IDENTIFIER @"PaletteCell"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PalettePickerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PALETTE_CELL_IDENTIFIER
                                                                            forIndexPath:indexPath];
    
    cell.paletteName = [self.possiblePalettes objectAtIndex:indexPath.row];
    cell.paletteColors = [Colors colorsForPalette:cell.paletteName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

#pragma mark - TableView Delegate Methods

#define PALETTE_SEGUE_IDENTIFIER @"PickPalette"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PalettePickerTableViewCell *cell = (PalettePickerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [Colors switchPaletteToPaletteWithName:cell.paletteName andColors:cell.paletteColors];
    [self performSegueWithIdentifier:PALETTE_SEGUE_IDENTIFIER sender:self];
}

@end
