//
//  STPCheckoutView.h
//  Checkout Example
//
//  Created by Alex MacCaw on 2/14/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stripe.h"
#import "PKView.h"

@class STPCheckoutView;

@protocol STPCheckoutDelegate <NSObject>
@optional
- (void) checkoutView:(STPCheckoutView*)view hasToken:(STPToken*)token;
- (void) checkoutView:(STPCheckoutView*)view hasError:(NSError*)error;
- (void) checkoutView:(STPCheckoutView*)view isPending:(BOOL)pending;
- (void) checkoutView:(STPCheckoutView*)view withCard:(PKCard *)card isValid:(BOOL)valid;
@end

@interface STPCheckoutView : UIView <PKViewDelegate>

- (id)initWithFrame: (CGRect)frame andKey: (NSString*)stripeKey;

@property IBOutlet PKView* paymentView;
@property (copy) NSString* key;
@property id <STPCheckoutDelegate> delegate;

- (void) createToken;

@end
