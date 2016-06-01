//
//  TweeterTableViewCell.h
//  GraceNote
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetImageView.h"
#import "TweetMessage.h"

@interface TweeterTableViewCell : UITableViewCell

/**
 *  @brief The "Primary" image used for display in the cell. This may be used, or not. This
 *          image should play a primary role in describing the intent of the content of this cell.
 */
@property (nonatomic, weak) IBOutlet TweetImageView *tweetImage;
/**
 *  @brief The text to display in the cell.
 */
@property (nonatomic, weak) IBOutlet UILabel *tweetTitle;
/**
 *  @brief The "Auxiliary" image used for display in the cell This may be used, or not. This
 *          image should play a secondary role in describing the intent of the content of this cell.
 */
@property (nonatomic, weak) IBOutlet UIImageView *auxImage;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

-(void)configureCellWithTweetMessage:(TweetMessage *)tweetMessage;
@end
