//
//  DetailViewController.m
//  StripePaymentKit
//
//  Created by Alex MacCaw on 2/13/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "STPCheckoutController.h"
#import "MBProgressHUD.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface STPCheckoutController ()
- (void)setupToolbar;
- (void)setupPaymentView;
- (void)successHandler:(STPToken *)token;
- (void)errorHandler:(NSError*)error;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end

@implementation STPCheckoutController

@synthesize paymentView, delegate, toolbar, cancelButton, saveButton, titleView;

- (id)initWithKey:(NSString*)key
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.key = key;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(224,226,230);
    
    [self setupToolbar];
    [self setupPaymentView];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setupToolbar
{
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                         style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(cancel:)];
    
    UIBarButtonItem* spacerLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:self
                                                                                action:nil];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.titleLabel.layer.shadowColor = [RGB(69,80,92) CGColor];
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, -1);
    self.titleLabel.layer.shadowRadius = 0.0;
    self.titleLabel.layer.shadowOpacity = 0.8;
    [self.titleLabel.layer setMasksToBounds:NO];
    
    [self.titleLabel setText:@"Change Card"];
    [self.titleLabel sizeToFit];
    
    self.titleView = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                 forKey:UITextAttributeTextColor]
                                                forState:UIControlStateDisabled ];
    
    UIBarButtonItem* spacerRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    self.saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Save")
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(save:)];
    self.saveButton.enabled = NO;
        
    [self.toolbar setItems:@[self.cancelButton, spacerLeft, self.titleView, spacerRight, self.saveButton]];
    [self.view addSubview:self.toolbar];
}

- (void)setupPaymentView
{
    self.paymentView = [[PKView alloc] initWithFrame:CGRectMake(15,62,290,55)];
    self.paymentView.delegate = self;
    [self.view addSubview:self.paymentView];
}

- (void)setTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (NSString*)title
{
    return self.titleLabel.text;
}

- (void)close
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toolbarEnabled:(BOOL)enabled;
{
    self.toolbar.userInteractionEnabled = enabled;
    self.saveButton.enabled = enabled;
}

- (void)paymentView:(PKView*)paymentView withCard:(PKCard *)card isValid:(BOOL)valid
{
    self.saveButton.enabled = valid;
}

- (void)successHandler:(STPToken *)token
{
    if ([self.delegate respondsToSelector:@selector(checkoutController:hasToken:)]) {
        [self.delegate checkoutController:self hasToken:token];
    }
}

- (void)errorHandler:(NSError*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (IBAction)cancel:(id)sender
{
    [self close];
}

- (IBAction)save:(id)sender
{
    [self toolbarEnabled:NO];
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PKCard* card = self.paymentView.card;
    STPCard* scard = [[STPCard alloc] init];
    
    scard.number = card.number;
    scard.expMonth = card.expMonth;
    scard.expYear = card.expYear;
    scard.cvc = card.cvc;
    
    [Stripe createTokenWithCard:scard
                 publishableKey:self.key success:^(STPToken *token) {
                     [self successHandler:token];
                 } error:^(NSError *error) {
                     [self toolbarEnabled:YES];
                     [self errorHandler:error];
                 }];        
}
							
@end
