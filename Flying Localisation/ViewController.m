//
//  ViewController.m
//  Flying Localisation
//
//  Created by Jens Andersson on 6/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "ViewController.h"
#import "FlyingLocalizer.h"


@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = JALocalizedString(@"InviteYourFriends", @"Welcome to 2011");
    [self.mainButton setTitle:JALocalizedString(@"main_button_title", @"Press here") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
