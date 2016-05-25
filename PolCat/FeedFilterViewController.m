//
//  FeedFilterViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/25/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "FeedFilterViewController.h"

@implementation FeedFilterViewController

-(IBAction)handleUnwindAction:(id)sender
{
    [self performSegueWithIdentifier:@"FilterUnwindSegue" sender:self];
}
@end
