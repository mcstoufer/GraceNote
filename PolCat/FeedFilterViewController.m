//
//  FeedFilterViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/25/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "FeedFilterViewController.h"
#import "StatesFilterViewController.h"
#import "KeywordsFilterViewController.h"
#import "PartiesFilterViewController.h"

@interface FeedFilterViewController ()

@end


@implementation FeedFilterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    PartiesFilterViewController *cont1 = [self.viewControllers objectAtIndex:0];
    cont1.parent = self;
    KeywordsFilterViewController *cont2 = [self.viewControllers objectAtIndex:1];
    cont2.parent = self;
    StatesFilterViewController *cont3 = [self.viewControllers objectAtIndex:2];
    cont3.parent = self;
}

-(void)handleUnwindAction:(id)sender
{
    [self performSegueWithIdentifier:@"FilterUnwindSegue" sender:self];
}

@end
