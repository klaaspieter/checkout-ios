//
//  DetailViewController.m
//  StripePaymentKit
//
//  Created by Alex MacCaw on 2/13/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "STPCheckoutController.h"
#import "MBProgressHUD.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface STPCheckoutController ()
- (void)successHandler:(STPToken *)token;
- (void)errorHandler:(NSError*)error;
- (IBAction)save:(id)sender;
@end

@implementation STPCheckoutController

@synthesize paymentView, delegate;

- (id)initWithKey:(NSString*)key
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.key = key;
        self.title = NSLocalizedString(@"Change Card", @"Change Card");
        self.view.backgroundColor = RGB(224,226,230);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Save")
                                                                   style:0
                                                                  target:self
                                                                  action:@selector(save:)];
    saveButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.paymentView = [[PKView alloc] initWithFrame:CGRectMake(15, 25, 290, 55)];
    self.paymentView.delegate = self;
    [self.view addSubview:self.paymentView];
}

- (void)close
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)paymentView:(PKView*)paymentView withCard:(PKCard *)card isValid:(BOOL)valid
{
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

- (void)successHandler:(STPToken *)token
{
    if ([self.delegate respondsToSelector:@selector(checkoutController:hasToken:)]) {
        [self.delegate checkoutController:self hasToken:token];
    }
}

- (void)errorHandler:(NSError*)error
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (IBAction)save:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
                     [self errorHandler:error];
                 }];        
}
							
@end
