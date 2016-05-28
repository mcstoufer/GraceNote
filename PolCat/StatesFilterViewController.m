//
//  StatesFilterViewController.m
//  PolCat
//
//  Created by Martin Stoufer on 5/26/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "StatesFilterViewController.h"
#import "StateFilterTableCell.h"
#import "SelectionFilterTableCell.h"
#import "Utility.h"
#import "UserDefaults.h"

@interface StatesFilterViewController ()

@property (nonatomic, strong) NSMutableDictionary *stateDict;

@end

@implementation StatesFilterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.stateDict = [NSMutableDictionary dictionaryWithCapacity:50];
    for (int x=1; x<=50; x++) {
        NSString *us_state = [states() objectAtIndex:x*2-2];
        self.stateDict[us_state] = @([[UserDefaults standardUserDefaults] selectedState:us_state]);
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UserDefaults standardUserDefaults] toggleStateFilters:self.stateDict];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SelectionFilterTableCell *cell = (SelectionFilterTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
        [cell configureWithSelectionState];
        return cell;
    } else {
        StateFilterTableCell *cell = (StateFilterTableCell *)[tableView dequeueReusableCellWithIdentifier:@"StateFilterCell"];
        
        NSString *us_state = [states() objectAtIndex:(indexPath.row)*2-2];
        BOOL selected = [self.stateDict[us_state] boolValue];
        [cell configureWithStateValue:us_state withSelection:selected];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SelectionFilterTableCell *selected_cell = [tableView cellForRowAtIndexPath:indexPath];
        [selected_cell toggleSelectionState];
        
        for (NSInteger r = 1; r < [tableView numberOfRowsInSection:0]-1; r++) {
            NSString *us_state = [states() objectAtIndex:(r)*2-2];
            self.stateDict[us_state] = @(selected_cell.checked);
        }
        [tableView reloadData];
    } else {
        StateFilterTableCell *selected_cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *us_state = selected_cell.stateLabel.text;
        self.stateDict[us_state] = @(!selected_cell.checked);
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 51; // 50 states plus one top cell to handle (de)select all.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
@end
