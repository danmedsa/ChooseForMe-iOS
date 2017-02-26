//
//  MainViewController.m
//  random choice
//
//  Created by Daniel Medina on 1/25/14.
//  Copyright (c) 2014 Medalabs Development. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    int alt;
    BOOL keyUp;
}
@end

@implementation MainViewController

@synthesize numChoices,decisions,choices;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    choices = [[NSMutableArray alloc] initWithObjects:@"Add a option...", nil];
    decisions = [[NSMutableArray alloc] init];
    numChoices.delegate = self;
    keyUp = NO;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"rep"] == YES){
        repeat.on = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rep"];
    }
    else{
        repeat.on = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _adBanner = [[ADBannerView alloc] init];
    _adBanner.delegate = self;
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_adBanner.superview == nil)
        {
            [self.view addSubview:_adBanner];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = YES;
    }
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = NO;
    }
    
}



- (IBAction)makeChoice:(id)sender{
    [decisions removeAllObjects];
    
    detail.hidden = YES;
    canRepeat.hidden = YES;
    decide.hidden = YES;
    howto.hidden = YES;
    
    if (keyUp == YES) {
        donee.hidden = YES;
        
        [numChoices resignFirstResponder];
    }
    
    alt = 1;
    if ([[choices objectAtIndex:0] isEqualToString:@"Add a option..."]){
        UIAlertView *alertAdd = [[UIAlertView alloc] initWithTitle:@"Add an option" message:@"You need to add an option first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alt = 3;
        [alertAdd show];
    }
    else if ([[numChoices text] integerValue] > ([choices count] - 1) && [[NSUserDefaults standardUserDefaults] boolForKey:@"rep"] == NO) {
        UIAlertView *alertMore = [[UIAlertView alloc] initWithTitle:@"Add more options" message:@"Check your number of choices or add more options" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alt = 2;
        [alertMore show];
        
    }
    if (alt == 1) {
        int x = 0;
        NSMutableArray *last = [[NSMutableArray alloc] initWithObjects:nil];
        [decisions addObjectsFromArray:choices];
        for (NSInteger chosen = [numChoices.text integerValue]; chosen > 0; chosen--) {
            randm = (arc4random() % ([choices count] - 1 - x));
            NSLog(@" choices: %@\n\n",choices);
            NSLog(@" decisions%@\n\n",decisions);
            NSLog(@"%ld",(long)randm);
            [last addObject:[decisions objectAtIndex:(randm + 1)]];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rep"] == NO) {
                [decisions removeObjectAtIndex:(randm + 1)];
                x++;
                [options reloadData];
            }
            answers.hidden = NO;
            backBtn.hidden = NO;
            options.hidden = YES;
            numChoices.hidden=YES;
            pick.hidden = YES;
            donee.hidden = YES;
            repeat.hidden = YES;
            dest.hidden = NO;
            script.hidden = NO;
            NSString *fin = [last componentsJoinedByString:@"\n"];
            NSLog(@"%@",fin);
            answers.text = fin;
        }
    }
}

- (IBAction)back_btn:(id)sender{
    backBtn.hidden = YES;
    answers.hidden = YES;
    options.hidden = NO;
    numChoices.hidden = NO;
    pick.hidden = NO;
    donee.hidden = YES;
    repeat.hidden = NO;
    dest.hidden = YES;
    script.hidden = YES;
    detail.hidden = NO;
    canRepeat.hidden = NO;
    decide.hidden = NO;
    howto.hidden = NO;
}

-(IBAction)repeatOp:(UISwitch *)sender{
    if(sender.isOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rep"];
    }
    
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"rep"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1 && alt == 1){
        if ([choices count] == 1) {
            [choices removeObjectAtIndex:0];
            [choices addObject:@"Add another option..."];
        }
        [choices addObject:[alertView textFieldAtIndex:0].text];
        [options reloadData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)numChoices
{
    keyUp = YES;
    donee.hidden = NO;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            //iphone 5
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 129);
        }
        else
            //iphone 4
        {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 215);
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)numChoices
{
    keyUp = NO;
    donee.hidden = YES;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 129);
        } else
        {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 215);
        }
        
    }
}

- (IBAction)hideKeyb{
    keyUp = NO;
    donee.hidden = YES;
    [numChoices resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [choices removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if ([choices count] == 1) {
            [choices removeObjectAtIndex:0];
            [choices addObject:@"Add a option..."];
        }
    }
    [options reloadData];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        return  YES;
    }
    else
    {
        return NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [choices objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Options" message:@"Write an option you want to choose from" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add",nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alt = 1;
        
        [alert show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
