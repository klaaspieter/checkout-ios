//
//  DetailViewController.h
//  StripePaymentKit
//
//  Created by Alex MacCaw on 2/13/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKView.h"
#import "Stripe.h"

@class STPCheckoutController;

@protocol STPCheckoutDelegate <NSObject>
@optional
- (void) checkoutController:(STPCheckoutController*)controller hasToken:(STPToken*)token;
@end

@interface STPCheckoutController : UIViewController <PKViewDelegate>

- (id)initWithKey:(NSString*)key;
- (void)close;

@property IBOutlet PKView* paymentView;
@property (copy) NSString* key;
@property id <STPCheckoutDelegate> delegate;

@end
