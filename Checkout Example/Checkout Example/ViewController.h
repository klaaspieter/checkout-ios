//
//  MasterViewController.h
//  Checkout Example
//
//  Created by Alex MacCaw on 2/13/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPCheckoutController.h"

@interface ViewController : UITableViewController <UITableViewDataSource, STPCheckoutDelegate>

@property (nonatomic, strong) IBOutlet UITableViewCell *paymentCell;

@end
