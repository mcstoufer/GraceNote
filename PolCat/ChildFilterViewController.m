//
//  ChildFilterViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "ChildFilterViewController.h"

@implementation ChildFilterViewController

-(IBAction)handleUnwindAction:(id)sender
{
    [self saveState];
    [self.parent handleUnwindAction:self];
}

-(void)saveState
{
    // No-op
}
@end
