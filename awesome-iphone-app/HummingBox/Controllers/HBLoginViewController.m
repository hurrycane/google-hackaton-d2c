//
//  HBLoginViewController.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBLoginViewController.h"
#import "HBTabBarController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

#define kHBGooglePlusClientId           @"594228369799-51r75u9k26rb64f18sebivj7b1m99erv.apps.googleusercontent.com"

@interface HBLoginViewController ()

@end

@implementation HBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"Login Logo"];
    imageView.frame = CGRectMake(0, -70, 172, 184);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                                 UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:imageView];
    
    GPPSignInButton *signInButton = [[GPPSignInButton alloc] initWithFrame:CGRectMake(0, 420, 290, 44)];
    signInButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [view addSubview:signInButton];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserID = YES;
    
    signIn.clientID = kHBGooglePlusClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     nil];
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)redirectToMainScreen {
    HBTabBarController *tabController = [[HBTabBarController alloc] init];
    HBAppDelegate *delegate = (HBAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = tabController;
}

#pragma mark - Google Plus Signin delegate methods

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *) error {
    if (!error) {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        NSLog(@"Logged in with user ID: %@", signIn.googlePlusUser.identifier);
        
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                              signIn.googlePlusUser.name.givenName,
                              signIn.googlePlusUser.name.familyName];
        [HBApiClient loginWithGoogeUserId:signIn.googlePlusUser.identifier
                                 fullname:fullName
                              andCallback:^(BOOL result, NSError *error) {
                                  [self redirectToMainScreen];
                              }];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Humming Box"
                                                            message:@"There was an error at login. Please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
