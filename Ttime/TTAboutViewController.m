//
//  TTAboutViewController.m
//  Ttime
//
//  Created by Andrew Barba on 10/28/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTAboutViewController.h"
#import "TTDonationService.h"
#import <MessageUI/MessageUI.h>

@interface TTAboutViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation TTAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[TTTracker sharedTracker] trackScreenWithName:@"About Us"];
    
    if (TT_IS_IOS7()) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:nil
                                                                                action:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Donations

- (void)_startLoading
{
    TT_DISABLE_UI();
    [self.spinner startAnimating];
}

- (void)_endLoading
{
    TT_ENABLE_UI();
    [self.spinner stopAnimating];
}

- (IBAction)_handleSmallDonationTapped:(id)sender
{
    [self _startLoading];
    [[TTDonationService sharedInstance] makeDonation:TTDonationSmallKey onCompletion:^(BOOL success, NSError *error){
        [self _endLoading];
        if (success && !error) {
            [[TTTracker sharedTracker] trackPurchase:TTDonationSmallKey withName:@"Small Donation" forValue:@(0.99f)];
            [self _alertThankYou];
        } else {
            [self _alertError:error];
        }
    }];
}

- (IBAction)_handleMediumDonationTapped:(id)sender
{
    [self _startLoading];
    [[TTDonationService sharedInstance] makeDonation:TTDonationMediumKey onCompletion:^(BOOL success, NSError *error){
        [self _endLoading];
        if (success && !error) {
            [[TTTracker sharedTracker] trackPurchase:TTDonationMediumKey withName:@"Medium Donation" forValue:@(2.99f)];
            [self _alertThankYou];
        } else {
            [self _alertError:error];
        }
    }];
}

- (IBAction)_handleLargeDonationTapped:(id)sender
{
    [self _startLoading];
    [[TTDonationService sharedInstance] makeDonation:TTDonationLargeKey onCompletion:^(BOOL success, NSError *error){
        [self _endLoading];
        if (success && !error) {
            [[TTTracker sharedTracker] trackPurchase:TTDonationLargeKey withName:@"Large Donation" forValue:@(4.99f)];
            [self _alertThankYou];
        } else {
            [self _alertError:error];
        }
    }];
}

- (void)_alertThankYou
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You’re Awesome", nil)
                                message:NSLocalizedString(@"We cannot thank you enough for supporting us! We put a lot of hard work into making TTIME the best MBTA app on the App Store and we are so grateful to have awesome users like you.", nil)
                               delegate:nil
                      cancelButtonTitle:@"Thanks"
                      otherButtonTitles:nil] show];
}

- (void)_alertError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Something went wrong", nil)
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

#pragma mark - Mail

- (IBAction)_handleComposeTapped:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        
        [vc setToRecipients:@[@"team@ttimeapp.com"]];
        
        [vc setSubject:@"TTIME App Question"];
        
        vc.mailComposeDelegate = self;
        [self presentViewController:vc animated:YES completion:^{
            [[TTTracker sharedTracker] trackScreenWithName:@"Contact Us"];
        }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        [[TTTracker sharedTracker] trackEvent:@"contact_us_sent" withName:@"Contact Us email sent"];
    } else {
        [[TTTracker sharedTracker] trackEvent:@"contact_us_cancelled" withName:@"Contact Us email cancelled"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Shake easter egg

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionEnded:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
        [[TTTracker sharedTracker] trackEvent:@"easter_shake" withName:@"Easter Egg - About Shake"];
    }
}



@end
