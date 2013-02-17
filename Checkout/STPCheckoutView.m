//
//  STPCheckoutView.m
//  Checkout Example
//
//  Created by Alex MacCaw on 2/14/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "STPCheckoutView.h"

@implementation STPCheckoutView

@synthesize paymentView, key, pending;

- (id)initWithFrame: (CGRect)frame andKey: (NSString*)stripeKey
{
    self = [self initWithFrame:frame];
    if (self) {
        self.key = stripeKey;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.paymentView = [[PKView alloc] initWithFrame:CGRectMake(0,0,290,55)];
        self.paymentView.delegate = self;
        [self addSubview:self.paymentView];
    }
    return self;
}

- (void)paymentView:(PKView*)paymentView withCard:(PKCard *)card isValid:(BOOL)valid
{
    if ([self.delegate respondsToSelector:@selector(checkoutView:withCard:isValid:)]) {
        [self.delegate checkoutView:self withCard:card isValid:valid];
    }
}

- (void)successHandler:(STPToken *)token
{
    if ([self.delegate respondsToSelector:@selector(checkoutView:hasToken:)]) {
        [self.delegate checkoutView:self hasToken:token];
    }
}

- (void)errorHandler:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(checkoutView:hasError:)]) {
        [self.delegate checkoutView:self hasError:error];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                          message:[error localizedDescription]
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)pendingHandler:(BOOL)isPending
{
    pending = isPending;
    self.userInteractionEnabled = !pending;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:pending];

    if ([self.delegate respondsToSelector:@selector(checkoutView:isPending:)]) {
        [self.delegate checkoutView:self isPending:pending];
    }
}

- (void)createToken
{
    if ( ![self.paymentView isValid] ) return;
    if ( pending ) return;
 
    PKCard* card = self.paymentView.card;
    STPCard* scard = [[STPCard alloc] init];
    
    scard.number = card.number;
    scard.expMonth = card.expMonth;
    scard.expYear = card.expYear;
    scard.cvc = card.cvc;
    
    [self pendingHandler:YES];
    
    [Stripe createTokenWithCard:scard
                 publishableKey:self.key success:^(STPToken *token) {
                     [self pendingHandler:NO];
                     [self successHandler:token];
                 } error:^(NSError *error) {
                     [self pendingHandler:NO];
                     [self errorHandler:error];
                 }];

}

@end
