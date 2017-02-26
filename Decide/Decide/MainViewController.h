//
//  MainViewController.h
//  random choice
//
//  Created by Daniel Medina on 1/25/14.
//  Copyright (c) 2014 Medalabs Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface MainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ADBannerViewDelegate>{
    NSMutableArray *choices;
    NSMutableArray *decisions;
    IBOutlet UITableView *options;
    IBOutlet UITextField *numChoices;
    IBOutlet UILabel *pick;
    IBOutlet UIButton *donee;
    IBOutlet UILabel *canRepeat;
    IBOutlet UILabel *detail;
    IBOutlet UIButton *decide;
    IBOutlet UISwitch *repeat;
    
    IBOutlet UIButton *howto;
    
    BOOL _bannerIsVisible;
    IBOutlet ADBannerView *_adBanner;
    
    IBOutlet UILabel *answers;
    IBOutlet UILabel *dest;
    IBOutlet UIButton *backBtn;
    
    IBOutlet UIImageView *script;
    
    NSInteger randm;
    
}
@property(nonatomic,retain) IBOutlet UITextField *numChoices;
@property(nonatomic,retain) NSMutableArray *choices;
@property(nonatomic,retain) NSMutableArray *decisions;

- (IBAction)makeChoice:(id)sender;
- (IBAction)hideKeyb;
- (IBAction)repeatOp:(UISwitch *)sender;
- (IBAction)back_btn:(id)sender;

@end
