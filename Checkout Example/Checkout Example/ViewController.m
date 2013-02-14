//
//  ViewController.m
//  Checkout Example
//
//  Created by Alex MacCaw on 2/13/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "ViewController.h"
#define STRIPE_API_KEY @"pk_test_czwzkTp2tactuLOEOqbMTRzG"

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
    }
    return self;
}

- (void)changeCard
{
    STPCheckoutController *checkout = [[STPCheckoutController alloc] initWithKey:STRIPE_API_KEY];
    checkout.delegate = self;
    checkout.title = @"Checkout";
    [self presentViewController:checkout animated:YES completion:nil];
}

- (void) checkoutController:(STPCheckoutController*)controller hasToken:(STPToken*)token
{
    NSLog(@"Received token %@", token.tokenId);
    
    [token postToURL:[NSURL URLWithString:@"https://example.com/tokens"] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            // Check error response
        }
        
        // Close Checkout
        [controller close];
        
        // Update payment cell details with last4 digits
        self.paymentCell.detailTextLabel.text = token.card.last4;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return self.paymentCell;
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.paymentCell]) [self changeCard];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end