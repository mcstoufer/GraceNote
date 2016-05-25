//
//  SettingsViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/25/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

-(IBAction)handleUnwindAction:(id)sender
{
    [self performSegueWithIdentifier:@"SettingsUnwindSegue" sender:self];
}

@end
