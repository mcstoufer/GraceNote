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
#import "Filters.h"

@interface StatesFilterViewController ()

@property (nonatomic, strong) NSMutableDictionary *stateDict;
@property (nonatomic, strong) NSArray *statesSort;
@end

@implementation StatesFilterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.stateDict = [NSMutableDictionary dictionaryWithCapacity:50];
    self.stateDict = [[Filters sharedFilters] allStates];
    self.statesSort = [[self.stateDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString  *_Nonnull obj1, NSString *_Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.touched) {
        [[Filters sharedFilters] updateStates:self.stateDict];
        self.touched = NO;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SelectionFilterTableCell *cell = (SelectionFilterTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
        [cell configureWithSelectionState];
        return cell;
    } else {
        StateFilterTableCell *cell = (StateFilterTableCell *)[tableView dequeueReusableCellWithIdentifier:@"StateFilterCell"];
        
        NSString *us_state = [self.statesSort objectAtIndex:indexPath.row];
        BOOL selected = [self.stateDict[us_state] boolValue];
        [cell configureWithStateValue:us_state withSelection:selected];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.touched = YES;
    if (indexPath.row == 0) {
        SelectionFilterTableCell *selected_cell = [tableView cellForRowAtIndexPath:indexPath];
        [selected_cell toggleSelectionState];
        
        for (NSInteger r = 0; r < [tableView numberOfRowsInSection:0]; r++) {
            NSString *us_state = [self.statesSort objectAtIndex:r];
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
