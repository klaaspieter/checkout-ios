# Checkout

Checkout is a utility library for writing payment forms in iOS apps.

## API 

### Instance methods

Call `initWithFrame:andKey` to instantiate the checkout. For example:

    self.checkoutView = [[STPCheckoutView alloc] initWithFrame:CGRectMake(15,20,290,55) andKey:@"STRIPE_PUB_KEY"];
    self.checkoutView.delegate = self;
    [self.view addSubview:self.checkoutView];

`createToken` instructs the Checkout to send off a Stripe token request. This method will noop if the Checkout isn't valid.

    - (IBAction)save:(id)sender
    {
        [self.checkoutView createToken];
    }

### Delegate methods

All delegate methods are optional.

`checkoutView:withCard:isValid` will be called whenever a valid card is entered:

    - (void)checkoutView:(STPCheckoutView *)view withCard:(PKCard *)card isValid:(BOOL)valid
    {
        // For example, toggle the navigational save button
        self.navigationItem.rightBarButtonItem.enabled = valid;
    }

`checkoutView:isPending` will be called whenever a Stripe token request has started or stopped pending:

    - (void)checkoutView:(STPCheckoutView *)view isPending:(BOOL)pending
    {
        // For example, toggle a spinner
        if (pending) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }

`checkoutView:hasError` will be called whenever a Stripe token request fails. If you don't implement this, the
default behavior is to alert the error msg.

    - (void)checkoutView:(STPCheckoutView *)view hasError:(NSError *)error
    {
        // For example, alert the error message
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                          message:[error localizedDescription]
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
    }

`checkoutView:hasToken` will be called whenever the Checkout receives a token:

    - (void)checkoutView:(STPCheckoutView *)view hasToken:(STPToken *)token
    {
        NSLog(@"Received token %@", token.tokenId);

        // For example, post the token off to your server
        [token postToURL:[NSURL URLWithString:@"https://example.com"]
              withParams:nil
       completionHandler:^(NSURLResponse *response,  NSData *data, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if (error) {
                // Check error response
            }

            [self.navigationController popViewControllerAnimated:YES];
        }];
    }


## Installation & Usage

For more docs see our site: https://stripe.com/docs/mobile/ios