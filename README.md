# Checkout

Checkout is a utility library for writing payment forms in iOS apps.

## Example

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        
        // ...
        
        self.saveButton.enabled = NO;

        self.checkoutView = [[STPCheckoutView alloc] initWithFrame:CGRectMake(15,20,290,55) andKey:@"STRIPE_PUB_KEY"];
        self.checkoutView.delegate = self;
        [self.view addSubview:self.checkoutView];
    }
    
    - (void)checkoutView:(STPCheckoutView *)view withCard:(PKCard *)card isValid:(BOOL)valid
    {
        self.saveButton.enabled = valid;
    }
    
    - (IBAction)save:(id)sender
    {
        [self.checkoutView createToken];
    }
    
    - (void)checkoutView:(STPCheckoutView *)view hasToken:(STPToken *)token
    {
        NSLog(@"Received token %@", token.tokenId);

        [token postToURL:[NSURL URLWithString:@"https://example.com/tokens"]
              withParams:nil
       completionHandler:^(NSURLResponse *response,  NSData *data, NSError *error) {
            // Check error response
        }];
    }

## Installation & Usage

For full docs see our site: https://stripe.com/docs/mobile/ios