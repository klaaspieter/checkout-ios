//
//  PaymentViewController.h
//  Checkout Example
//
//  Created by Alex MacCaw on 2/14/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPCheckoutView.h"

@interface PaymentViewController : UIViewController <STPCheckoutDelegate>

@property IBOutlet STPCheckoutView* checkoutView;

- (IBAction)save:(id)sender;

@end
