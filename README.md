# Checkout

Checkout is a utility library for writing payment forms in iOS apps.

## Requirements

* iOS version: >= 4.3
* Frameworks: QuartzCore.framework

## API

### Instance methods

Call `initWithFrame:andKey` to instantiate the checkout. For example:

    self.checkoutView = [[STPCheckoutView alloc] initWithFrame:CGRectMake(15,20,290,55) andKey:@"STRIPE_PUB_KEY"];
    self.checkoutView.delegate = self;
    [self.view addSubview:self.checkoutView];

`createToken` instructs the Checkout to send off a Stripe token request. This method will noop if the Checkout isn't valid.

    - (IBAction)save:(id)sender
    {
      [self.checkoutView createToken:^(STPToken *token, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];

          if (error) {
              // Handle error
          } else {
              // Handle token
          }
      }];
    }

### Delegate methods

All delegate methods are optional.

`checkoutView:withCard:isValid` will be called whenever a valid card is entered:

    - (void)checkoutView:(STPCheckoutView *)view withCard:(PKCard *)card isValid:(BOOL)valid
    {
        // For example, toggle the navigational save button
        self.navigationItem.rightBarButtonItem.enabled = valid;
    }


## Installation & Usage

For more docs see our site: https://stripe.com/docs/mobile/ios