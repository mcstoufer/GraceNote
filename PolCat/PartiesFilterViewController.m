//
//  PartiesFilterViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "PartiesFilterViewController.h"
#import "Constants.h"
#import "Filters.h"

@interface PartiesFilterViewController ()

@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UISwitch *dSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *rSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *oSwitch;

@property (nonatomic, weak) IBOutlet UILabel *dLabel;
@property (nonatomic, weak) IBOutlet UILabel *rLabel;
@property (nonatomic, weak) IBOutlet UILabel *oLabel;

@end

@implementation PartiesFilterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dSwitch.on = [[Filters sharedFilters] stateForPartyFilter:PartyDemocrat];
    self.rSwitch.on = [[Filters sharedFilters] stateForPartyFilter:PartyRepublican];
    self.oSwitch.on = [[Filters sharedFilters] stateForPartyFilter:PartyOther];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveState];
}

-(void)saveState
{
    if (self.touched) {
        [[Filters sharedFilters] updateSelectedParties:@{stringForPartyEnum(PartyDemocrat): @(self.dSwitch.on),
                                                         stringForPartyEnum(PartyRepublican): @(self.rSwitch.on),
                                                         stringForPartyEnum(PartyOther): @(self.oSwitch.on)}];
        self.touched = NO;
    }
}

-(IBAction)handlePartySwitchAction:(id)sender
{
    self.touched = YES;
}

@end
