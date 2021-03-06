//
//  SinglyViewController.m
//  SinglySDK Example
//
//  Created by Thomas Muldowney on 8/22/12.
//  Copyright (c) 2012 Singly. All rights reserved.
//

#import "SinglyViewController.h"

@interface SinglyViewController ()
{
    SinglyLoginPickerViewController* _picker;
    SinglyLogInViewController* loginVC_;
    SinglySession* session_;
}
@end

@implementation SinglyViewController

-(void)viewWillAppear:(BOOL)animated
{
}

-(void) viewDidAppear:(BOOL)animated
{
    [session_ checkReadyWithCompletionHandler:^(BOOL ready) {
        NSLog(@"Ready is %d", ready);
        //_picker = [[SinglyLoginPickerViewController alloc] initWithSession:session_];
        //[self presentModalViewController:_picker animated:YES];
        
        if (ready) {
            SinglySharingViewController* sharingView = [[SinglySharingViewController alloc] initWithSession:session_ forService:kSinglyServiceTwitter];
            [sharingView addImage:[UIImage imageNamed:@"typing.gif"]];
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentModalViewController:sharingView animated:YES];
        } else {
            SinglyLogInViewController* login = [[SinglyLogInViewController alloc] initWithSession:session_ forService:kSinglyServiceTwitter];
            [self presentModalViewController:login animated:YES];
        }
        
        if(ready) {

#if 0
            SinglyFriendPickerViewController* friendPicker = [[SinglyFriendPickerViewController alloc] initWithSession:session_];
            [self presentModalViewController:friendPicker animated:YES];
            NSLog(@"We're already done!");
            [session_ requestAPI:[SinglyAPIRequest apiRequestForEndpoint:@"profiles"] withCompletionHandler:^(NSError *error, id json) {
                NSLog(@"The profiles result is: %@", json);
            }];
#endif
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    session_ = [[SinglySession alloc] init];
    session_.delegate = self;
    session_.clientID = @"";
    session_.clientSecret = @"";
    NSLog(@"Session account is %@ and access token is %@", session_.accountID, session_.accessToken);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - SinglySessionDelegate
-(void)singlySession:(SinglySession *)session didLogInForService:(NSString *)service;
{
    NSLog(@"All done, telling it to dismiss");
}
-(void)singlySession:(SinglySession *)session errorLoggingInToService:(NSString *)service withError:(NSError *)error;
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - SinglyLoginViewControllerDelegate
-(void)singlyLogInViewController:(SinglyLogInViewController *)controller didLoginForService:(NSString *)service;
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
