//
//  TweeterViewController.m
//  GraceNote
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "TweeterViewController.h"
#import "TweeterTableViewController.h"
#import "PoliticalTweetStream.h"
#import "FlickrKit.h"
#import "FKAuthViewController.h"
#import "UserDefaults.h"

@interface TweeterViewController ()
/**
 *  @brief A loading overlay view for the table. Will be running while data is being fetched off in the background.
 */
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *filterBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *settingsBarButtonItem;

/**
 *  @brief The embedded UITableViewController subclass that will be in charge of displaying the data.
 */
@property (nonatomic, strong) TweeterTableViewController *tableViewCtlr;
/**
 *  @brief A Flickr object used for checking if the saved OAuth token is still valid.
 */
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
/**
 *  @brief A Flickr object used for handling once initial or subsequent OAuth validation is completed.
 */
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
/**
 *  @brief The view controller used to display the OAuth steps via web view.
 */
@property (nonatomic, strong) FKAuthViewController *auth;
/**
 *  @brief The Flickr UserID that is currently authorized.
 */
@property (nonatomic, retain) NSString *userID;

@end

@implementation TweeterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Start listening for success Flickr OAuth validation.
    // This notification is fired in the AppDelegate once the app tries to handle a custom URL fired off by the
    //  webview context during OAuth.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    
    self.settingsBarButtonItem.title = @"\u2699";
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *dict = @{NSFontAttributeName:f1};
    [self.settingsBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Once view is up, we need to see if OAuth needs to happen again.
    // TODO: This shoul be put off into an AlertController context asking/telling user they need to authenticate
    //        before moving forward. The current implementation is unacceptable for long-term use.
    
    // Check to see if current authorization is still valid.
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
                
                if (![FlickrKit sharedFlickrKit].isAuthorized) {
                    [self performSegueWithIdentifier:@"FlickrOAuthShowSegue" sender:self];
                }
            } else {
                NSLog(@"Flickr auth error: %@", error.localizedDescription);
            }
        });
    }];
}

- (void) userLoggedIn:(NSString *)username userID:(NSString *)userID {
    self.userID = userID;
}

/**
 *  @brief Prepare for various Segue actions
 *
 *  @param segue  The current segue schedule to take place.
 *  @param sender The sender that sent this segue.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Embed the TableViewController to handle the display of Tweets.
    if ([segue.identifier isEqualToString:@"TweeterTableEmbedSegue"]) {
        TweeterTableViewController *destination = (TweeterTableViewController *)segue.destinationViewController;
        self.tableViewCtlr = destination;
        
        // Set the stream on thie view controller and let it fire off its config and fetching of data.
        [destination setTweetStream:[PoliticalTweetStream new] withCompletion:^(BOOL complete) {
            // TODO: How to handle when the timeout to fetch all the tweets fires and return NO here?
            // Refire off loading, display alert message?
            if (complete)
            {
                // Once data is retrieved, we can nicely hide the loading overlay.
                [UIView animateWithDuration:0.3 animations:^{
                    self.loadingView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.loadingView.hidden = YES;
                }];
            }
        }];
        
        [[UserDefaults standardUserDefaults] setKeywords: @[@"Hillary", @"Clinton", @"Bernie", @"Sanders", @"Barack", @"Obama", @"Democrat", @"berniesanders", @"barackobama", @"hillaryclinton"]
                                                forParty:PartyDemocrat];
        [[UserDefaults standardUserDefaults] setKeywords:@[@"Donald", @"Trump", @"Republican", @"realdonaldtrump"]
                                                forParty:PartyRepublican];
    }
    // If the segue is push on the OAuth webview, just keep track of the view controller so we can tell it
    //  to trigger its unwind segue. This is due to the callback nature of the authorization process.
    else if ([segue.identifier isEqualToString:@"FlickrOAuthShowSegue"]) {
        self.auth = (FKAuthViewController *)segue.destinationViewController;
    }
}

/**
 *  @brief Just a placeholder method so the Storyboard knows where the unwind segue is supposed to go.
 *
 *  @param segue The unwind segue
 */
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

-(IBAction)handleFilterBarButtonAction:(id)sender
{
    
}

-(IBAction)handleSettingsBarButtonAction:(id)sender
{
    
}

/**
 *  @brief The handler method for when the UserAuthCallbackNotification is fired in the app delegate.
 *  @discussion Handle the success/error of the authorizaton phase and respond as needed.
 *
 *  @param notification <#notification description#>
 */
- (void) userAuthenticateCallback:(NSNotification *)notification {
    NSURL *callbackURL = notification.object;
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            // Now tell the OAuth view controller that it can start its unwind to exit seque.
            [self.auth performSegueWithIdentifier:@"FlickrOAuthUnwindSegue" sender:self];
            // And also have the table view reload its data as we can now get to the Flickr data.
            [self.tableViewCtlr.tableView reloadData];
        });
    }];
}

@end
