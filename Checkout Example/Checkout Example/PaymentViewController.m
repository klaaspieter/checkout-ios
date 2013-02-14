//
//  PaymentViewController.m
//  Checkout Example
//
//  Created by Alex MacCaw on 2/14/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "PaymentViewController.h"
#import "MBProgressHUD.h"
#define STRIPE_PUBLISHABLE_KEY @"pk_test_czwzkTp2tactuLOEOqbMTRzG"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Add Card";
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:0 target:self action:@selector(save:)];
    saveButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.checkoutView = [[STPCheckoutView alloc] initWithFrame:CGRectMake(15,20,290,55) andKey:STRIPE_PUBLISHABLE_KEY];
    self.checkoutView.delegate = self;
    [self.view addSubview:self.checkoutView];
}

- (IBAction)save:(id)sender
{
    [self.checkoutView createToken];
}

- (void)checkoutView:(STPCheckoutView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

- (void)checkoutView:(STPCheckoutView *)view isPending:(BOOL)pending
{
    if (pending) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)checkoutView:(STPCheckoutView *)view hasError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)checkoutView:(STPCheckoutView *)view hasToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [token postToURL:[NSURL URLWithString:@"https://example.com"] withParams:nil completionHandler:^(NSURLResponse *response,  NSData *data, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (error) {
            // Check error response
        }
     
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
