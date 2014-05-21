//
//  ListCell.m
//  SquareList
//
//  Created by Skylar Peterson on 12/2/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ListCell.h"
#import "Colors.h"
#import "ListItemCompletionView.h"

@interface ListCell() <UITextViewDelegate>

@property (nonatomic, strong) CALayer *topBorder;
@property (nonatomic, strong) CALayer *cameraBorder;

@property (nonatomic, strong) ListItemCompletionView *listCompletionView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic) CGRect currentTextRect;

@end

@implementation ListCell

@synthesize text = _text;

- (CALayer *)topBorder
{
    if (!_topBorder) {
        _topBorder = [CALayer layer];
    }
    return _topBorder;
}

- (CALayer *)cameraBorder
{
    if (!_cameraBorder) {
        _cameraBorder = [CALayer layer];
    }
    return _cameraBorder;
}

- (ListItemCompletionView *)listCompletionView
{
    if (!_listCompletionView) {
        _listCompletionView = [[ListItemCompletionView alloc] init];
    }
    return _listCompletionView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc] init];
    }
    return _cameraButton;
}

- (NSString *)text
{
    return self.textView.text;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.listCompletionView.color = self.color;
}

- (void)setBackdropColor:(UIColor *)backdropColor
{
    _backdropColor = backdropColor;
    //self.textView.textColor = backdropColor;
    self.textView.textColor = [UIColor whiteColor];
}

- (void)setText:(NSString *)text
{
    _text = text;
    CGSize viewSize = [ListCell sizeForTextViewWithText:text inCellWidth:self.frame.size.width - LIST_COMPLETION_VIEW_SIZE - IMAGE_BUTTON_SIZE];
    self.textView.text = text;
    self.textView.frame = CGRectMake(LIST_COMPLETION_VIEW_SIZE, self.frame.size.height / 2.0 - viewSize.height / 2.0, viewSize.width, viewSize.height);
    self.currentTextRect = [self.textView caretRectForPosition:[self.textView endOfDocument]];
}

+ (CGSize)sizeForTextViewWithText:(NSString *)text inCellWidth:(CGFloat)width
{
    CGSize stringBounds = [text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Quicksand-Regular" size:20.0]}];
    NSInteger multiplier = stringBounds.width / width + 1;
    return CGSizeMake(width, multiplier * stringBounds.height);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.listCompletionView.color = self.color;
        self.listCompletionView.completed = NO;
        
        self.textView.scrollEnabled = NO;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.font = [UIFont fontWithName:@"Quicksand-Regular" size:20.0];
        [self.textView setTextContainerInset:UIEdgeInsetsZero];
        
        self.topBorder.backgroundColor = [[Colors interactiveColor] CGColor];
        [self.layer addSublayer:self.topBorder];
        
        self.cameraBorder.backgroundColor = [[Colors interactiveColor] CGColor];
        [self.layer addSublayer:self.cameraBorder];
        
        [self addSubview:self.listCompletionView];
        [self addSubview:self.textView];
        UIImage *image = [UIImage imageNamed:@"Camera.png"];
        [self.cameraButton setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self addSubview:self.cameraButton];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeItem)];
        [self.listCompletionView addGestureRecognizer:tapGesture];
    }
    return self;
}

#define CAMERA_BORDER_INSET 10.0f
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topBorder.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 1.0f);
    self.cameraBorder.frame = CGRectMake(self.frame.size.width - IMAGE_BUTTON_SIZE, CAMERA_BORDER_INSET, 1.0f, self.frame.size.height - 2 * CAMERA_BORDER_INSET);
    self.listCompletionView.frame = CGRectMake(0, 0, LIST_COMPLETION_VIEW_SIZE, self.frame.size.height);
    self.cameraButton.frame = CGRectMake(self.frame.size.width - IMAGE_BUTTON_SIZE, self.frame.size.height / 2.0 - IMAGE_BUTTON_SIZE / 2.0, IMAGE_BUTTON_SIZE, IMAGE_BUTTON_SIZE);
}

- (void)completeItem
{
    self.listCompletionView.completed = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate textViewDidBeginEditingForCell:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.delegate textViewDidEndEditingForCell:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize newSize = [ListCell sizeForTextViewWithText:textView.text inCellWidth:textView.frame.size.width];
    if (newSize.height > self.currentTextRect.size.height) {
        NSLog(@"Current Height: %f", self.currentTextRect.size.height);
        NSLog(@"Height to Change To: %f", newSize.height);
        self.textView.frame = CGRectMake(LIST_COMPLETION_VIEW_SIZE, self.frame.size.height / 2.0 - newSize.height / 2.0, newSize.width, newSize.height);
        [self.delegate textViewDidGrowVertically:self toHeight:newSize.height];
        self.currentTextRect = CGRectMake(self.currentTextRect.origin.x, self.currentTextRect.origin.y, newSize.width, newSize.height);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
