# Checkout

Checkout is a utility library for writing payment forms in iOS apps.

## Installation

### Install with CocoaPods

[CocoaPods](http://cocoapods.org/) is a library dependency management tool for Objective-C. To use Checkout with CocoaPods, simply add the following to your Podfile and run pod install:

    pod 'Checkout', :git => 'https://github.com/stripe/checkout-ios.git'

### Install by adding files to project

1. Clone this repository
1. In the menubar, click on 'File' then 'Add files to "Project"...'
1. Select the 'Checkout' directory in your cloned Checkout repository
1. Make sure "Copy items into destination group's folder (if needed)" is checked"
1. Click "Add"

## Checkout Controller

**1)** Add the `QuartzCore` framework to your application.

**2)** Import the headers into any controllers you want to use Checkout in.

    #import <UIKit/UIKit.h>
    #import "STPCheckoutController.h"

    @interface ViewController : UIViewController <STPCheckoutDelegate>

Notice we're importing `STPCheckoutController.h` and the class conforms to `STPCheckoutDelegate`.

**3)** Instantiate and navigate to a `STPCheckoutController` instance.

    - (void)changeCard
    {
        STPCheckoutController *checkout = [[STPCheckoutController alloc] initWithKey:@"STRIPE_PUBLISHABLE_KEY"];
        checkout.delegate = self;
        checkout.title = @"Checkout";
        [self presentViewController:checkout animated:YES completion:nil];
    }

**4)** Implement `STPCheckoutDelegate` method `checkoutController:hasToken`. This gets passed a `STPCheckoutController` instance, and a `STPToken` instance containing the Stripe token.

    - (void) checkoutController:(STPCheckoutController*)controller hasToken:(STPToken*)token
    {
        NSLog(@"Received token %@", token.tokenId);

        [token postToURL:[NSURL URLWithString:@"https://yourapi.com/tokens"] withParams:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                // Check error response
            }

            // Close Checkout
            [controller close];
        }];
    }

That's all! No further reading is required.