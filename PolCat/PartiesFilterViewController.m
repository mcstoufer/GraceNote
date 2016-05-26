//
//  PartiesFilterViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "PartiesFilterViewController.h"
#import "Constants.h"
#import "UserDefaults.h"

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
    
    self.dSwitch.on = [[UserDefaults standardUserDefaults] stateForPartyFilter:PartyDemocrat];
    self.rSwitch.on = [[UserDefaults standardUserDefaults] stateForPartyFilter:PartyRepublican];
    self.oSwitch.on = [[UserDefaults standardUserDefaults] stateForPartyFilter:PartyOther];
}

-(IBAction)handleUnwindAction:(id)sender
{
    [self.parent handleUnwindAction:self];
}

-(IBAction)handlePartySwitchAction:(id)sender
{
    UISwitch *_switch = (UISwitch *)sender;
    switch ((Party)_switch.tag) {
        case PartyDemocrat:
            [[UserDefaults standardUserDefaults] togglePartyFilter:PartyDemocrat
                                                             state:_switch.on];
            break;
        
        case PartyRepublican:
            [[UserDefaults standardUserDefaults] togglePartyFilter:PartyRepublican
                                                             state:_switch.on];
            break;
            
        case PartyOther:
            [[UserDefaults standardUserDefaults] togglePartyFilter:PartyOther
                                                             state:_switch.on];
            break;
            
        default:
            break;
    }
    NSString *state = (_switch.on ? @"on" : @"off");
    NSLog(@"Sender tag: %ld state:%@", (long)_switch.tag, state);
}

@end
