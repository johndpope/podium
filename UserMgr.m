//
//  UserMgr.m
//  UserMgr
//
//  Created by netGALAXY Studios on 2/7/14.
//  Copyright (c) 2014 ttgspeed. All rights reserved.
//

#import "UserMgr.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "MBHUDView.h"
#import "KeychainItemWrapper.h"

@implementation UserMgr

static NSString *const loginUrl = @"http://s515096415.onlinehome.us//UserManager/core/ios/function.login.php";
static NSString *const registerUrl = @"http://s515096415.onlinehome.us//UserManager/core/ios/function.register.php";
static NSString *const kIdentifier = @"com.netgalaxystudios.iPresentWellForIPad";
static NSString *const recoverUrl = @"http://s515096415.onlinehome.us//UserManager/core/ios/function.initreset.php";
static NSString *const FBRegisterUrl = @"http://s515096415.onlinehome.us//UserManager/core/ios/function.facebook.register.php";
static NSString *const TWRegisterUrl = @"http://s515096415.onlinehome.us//UserManager/core/ios/function.twitter.register.php";
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UserMgr Registration Handling
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (void)requestRegistration:(NSString *)username password:(NSString *)password email:(NSString *)email currentView:(UIView*)currentView completion:(void (^)(NSString *registerResponse))completionBlock
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 460) ];
    HUD.labelText = @"Creating account...";
    [currentView addSubview:HUD];
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"username":username, @"password":password, @"email":email};
    
    [manager POST:registerUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //json "response" object from server response
        NSString *response = [responseObject objectForKey:@"response"];
        
        completionBlock(response);
        
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        
        completionBlock(@"3");
        
        NSLog(@"Registration Error: %@", error);
    }];
}

- (void)userDidRegister:(NSString*)username :(NSString*)password :(NSString*)email :(UIView*)currentView completion:(void (^)(bool didRegister))completionBlock{
    
    [self requestRegistration:username
                     password:password
                        email:email
                  currentView:currentView
                   completion:^(NSString *registerResponse){
                       if ([registerResponse compare:@"0"] == NSOrderedSame)
                       {
                           NSLog(@"Did register: %@", registerResponse);
                           //successful registration
                           completionBlock(TRUE);
                       }
                       else if ([registerResponse compare:@"1"] == NSOrderedSame)
                       {
                           //user already exists
                           MBAlertView *alert = [MBAlertView alertWithBody:@"A user with that username already exists!" cancelTitle:@"Ok" cancelBlock:nil];
                           [alert addToDisplayQueue];
                           
                           completionBlock(FALSE);
                       }
                       else if ([registerResponse compare:@"2"] == NSOrderedSame)
                       {
                           //email already exists
                           MBAlertView *alert = [MBAlertView alertWithBody:@"A user with that email already exists!" cancelTitle:@"Ok" cancelBlock:nil];
                           [alert addToDisplayQueue];
                           
                           completionBlock(FALSE);
                       }
                       else{
                           //unsuccessful login - other error
                           completionBlock(FALSE);
                           
                           //generic error message to go with failed login
                           MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error registering your account. Please try again later." cancelTitle:@"Ok" cancelBlock:nil];
                           [alert addToDisplayQueue];
                       }
                   }];
}
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UserMgr Facebook
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (void)requestFacebookRegistration:(NSString *)fb_id firstname:(NSString *)firstname
                           lastname:(NSString *)lastname email:(NSString *)email
                        currentView:(UIView*)currentView completion:(void (^)(NSString *registerResponse))completionBlock
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 460) ];
    HUD.labelText = @"Verifying Registration...";
    [currentView addSubview:HUD];
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"fb_id":fb_id, @"firstname":firstname, @"lastname":lastname, @"email":email};
    
    [manager POST:FBRegisterUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //json "response" object from server response
        NSString *response = [responseObject objectForKey:@"response"];
        
        completionBlock(response);
        
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        
        completionBlock(@"0");
        
        NSLog(@"Registration Error: %@", error);
    }];
}

- (void)facebookUserDidRegister:(NSString *)fb_id firstname:(NSString *)firstname
                       lastname:(NSString *)lastname email:(NSString *)email
                    currentView:(UIView*)currentView completion:(void (^)(bool didRegister))completionBlock{
    
    [self requestFacebookRegistration:fb_id
                            firstname:firstname
                             lastname:lastname
                                email:email
                          currentView:currentView
                           completion:^(NSString* registerResponse){
                               if ([registerResponse compare:@"1"] == NSOrderedSame)
                               {
                                   NSLog(@"Did register: %@", registerResponse);
                                   //successful registration
                                   completionBlock(TRUE);
                               }
                               else{
                                   //unsuccessful login - other error
                                   completionBlock(FALSE);
                                   
                                   //generic error message to go with failed login
                                   MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error registering your account. Please try again later." cancelTitle:@"Ok" cancelBlock:nil];
                                   [alert addToDisplayQueue];
                               }
                           }];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UserMgr Twitter
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (void)requestTwitterRegistration:(NSString *)tw_id :(NSString *)tw_username currentView:(UIView*)currentView
                        completion:(void (^)(NSString *registerResponse))completionBlock
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 460) ];
    HUD.labelText = @"Verifying Registration...";
    [currentView addSubview:HUD];
    [HUD show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"tw_id":tw_id,@"tw_username":tw_username};
    
    [manager POST:TWRegisterUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //json "response" object from server response
        NSString *response = [responseObject objectForKey:@"response"];
        NSLog(@"response%@",response);
        completionBlock(response);
        
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        
        completionBlock(@"0");
        
        NSLog(@"Registration Error: %@", error);
    }];
}

- (void)twitterUserDidRegister:(NSString *)tw_id :(NSString *)tw_username currentView:(UIView*)currentView
                    completion:(void (^)(bool didRegister))completionBlock{
    [self requestTwitterRegistration:tw_id :tw_username
                         currentView:currentView
                          completion:^(NSString* registerResponse){
                              if ([registerResponse compare:@"1"] == NSOrderedSame)
                              {
                                  NSLog(@"Did register: %@", registerResponse);
                                  //successful registration
                                  completionBlock(TRUE);
                              }
                              else{
                                  //unsuccessful login - other error
                                  completionBlock(FALSE);
                                  
                                  //generic error message to go with failed login
                                  MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error registering your account. Please try again later." cancelTitle:@"Ok" cancelBlock:nil];
                                  [alert addToDisplayQueue];
                              }
                          }];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UserMgr SignIn Handling
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (void)requestSignIn:(NSString *)username password:(NSString *)password currentView:(UIView*)currentView completion:(void (^)(NSString *signInRequest))completionBlock
{
    NSString *dname = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *uuid = [self getUUID];
    
    if ([username length] != 0 && [password length] != 0){
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 460) ];
        HUD.labelText = @"Logging in...";
        [currentView addSubview:HUD];
        [HUD show:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *parameters = @{@"username":username, @"password":password, @"dname":dname, @"uuid":uuid};
        
        [manager POST:loginUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //json "response" object from server response
            NSString *response = [responseObject objectForKey:@"response"];
            
            completionBlock(response);
            
            [HUD hide:YES];
            [HUD removeFromSuperViewOnHide];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD hide:YES];
            [HUD removeFromSuperViewOnHide];
            
            completionBlock(@"2");
            
            NSLog(@"Login Error: %@", error);
        }];
    }
    else{
        completionBlock(@"0");
    }
}

- (void)userDidSignIn:(NSString*)username :(NSString*)password :(UIView*)currentView completion:(void (^)(bool didSignIn))completionBlock{
    
    [self requestSignIn:username
               password:password
            currentView:currentView
             completion:^(NSString *signInRequest){
                 if ([signInRequest compare:@"1"] == NSOrderedSame || [signInRequest compare:@"2"] == NSOrderedSame)
                 {
                     //successful login/1-new device/2-existing device
                     NSLog(@"Login successful");
                     
                     [self saveUserDetails:username :password];
                     completionBlock(TRUE);
                 }
                 else if ([signInRequest compare:@"0"] == NSOrderedSame)
                 {
                     //unsuccessful login - invalid password
                     NSLog(@"Login failed: invalid username/password");
                     completionBlock(FALSE);
                 }
                 else{
                     //unsuccessful login - other error
                     NSLog(@"Login failed");
                     completionBlock(FALSE);
                     
                     //generic error message to go with failed login
                     MBAlertView *alert = [MBAlertView alertWithBody:@"There was an error signing in. Please try again later." cancelTitle:@"Ok" cancelBlock:nil];
                     [alert addToDisplayQueue];
                 }
             }];
}

- (void)restoreSession:(UIView*)currentView completion:(void (^)(bool loginSuccess))completionBlock{
    
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kIdentifier accessGroup:nil];
    
    NSString *username = [[keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *password = [[keychainWrapper objectForKey:(__bridge id)(kSecValueData)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self userDidSignIn:username :password :currentView
             completion:^(bool didrestore){
                 if(didrestore){
                     completionBlock(TRUE);
                 }
                 else{
                     completionBlock(FALSE);
                 }
             }];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UserMgr User Detail Management
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (void)saveUserDetails:(NSString*)username :(NSString*)password{
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kIdentifier accessGroup:nil];
    
    [keychainWrapper setObject:username forKey:(__bridge id)(kSecAttrAccount)];
    [keychainWrapper setObject:password forKey:(__bridge id)(kSecValueData)];
}

- (void)saveUserDetailsFacebook:(NSString*)fb_id :(NSString*)firstname :(NSString*)lastname
                               :(NSString*)email{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"loginType"];
    
    [[NSUserDefaults standardUserDefaults] setObject:fb_id forKey:@"fb_id"];
    [[NSUserDefaults standardUserDefaults] setObject:firstname forKey:@"fb_firstName"];
    [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"fb_lastName"];
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"fb_email"];
    
    NSLog(@"User Facebook details saved");
}

- (void)saveUserDetailsTwitter:(NSString*)tw_username{
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"loginType"];
    
    [[NSUserDefaults standardUserDefaults] setObject:tw_username forKey:@"tw_username"];
    
    NSLog(@"User Twitter username saved");
}

- (BOOL)userDetailsAreSaved:(id)sender{
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kIdentifier accessGroup:nil];
    
    NSString *username = [[keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *password = [[keychainWrapper objectForKey:(__bridge id)(kSecValueData)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return(username.length == 0 & password.length == 0)?FALSE:TRUE;
    
    
}

- (void)clearUserDetails:(id)sender{
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kIdentifier accessGroup:nil];
    
    [keychainWrapper resetKeychainItem];
    
    
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UserMgr Misc Functions
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (BOOL)verifyRegistratonForm:(NSString*)username :(NSString*)password :(NSString*)passwordConfirm
                             :(NSString*)email{
    //verify that the form is filled out
    if([username length] != 0 & [password length] != 0 & [passwordConfirm length] != 0 &
       [email length] != 0)
    {
        //verify the passwords match
        if([password compare:passwordConfirm] == NSOrderedSame){
            return TRUE;
        }
        else{
            MBAlertView *alert = [MBAlertView alertWithBody:@"Your passwords do not match" cancelTitle:@"Ok" cancelBlock:nil];
            [alert addToDisplayQueue];
            
            return FALSE;
        }
    }
    else{
        MBAlertView *alert = [MBAlertView alertWithBody:@"Please fill out all fields" cancelTitle:@"Ok" cancelBlock:nil];
        [alert addToDisplayQueue];
        
        return FALSE;
    }
}

-(NSString *)getUUID
{
    
    //get the saved uuid (this may be nil, but we'll check that in a second
    NSString *savedUUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceUUID"];
    
    NSLog(@"Saved UUID: %@", savedUUID);
    
    if ([savedUUID length] == 0) {
        //there's no saved uuid, so generate a new one
        CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
        NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
        CFRelease(newUniqueId);
        
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:@"deviceUUID"];
        
        //force the uuid to be saved (mostly useful for xcode debugging)
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Saving new UUID: %@", uuidString);
        
        savedUUID = uuidString;
    }
    
    return savedUUID;
}
@end
