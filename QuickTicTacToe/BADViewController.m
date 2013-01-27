//
//  BADViewController.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/5/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADViewController.h"
#import "BADConstants.h"

@interface BADViewController ()

@end

@implementation BADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[NSUserDefaults resetStandardUserDefaults];

    NSString *dif = [[NSUserDefaults standardUserDefaults] valueForKey:DIFFICULTY];
    NSString *xuser = [[NSUserDefaults standardUserDefaults] valueForKey:XPLAYERTAG];
    NSString *ouser = [[NSUserDefaults standardUserDefaults] valueForKey:OPLAYERTAG];
    if(!(dif && xuser && ouser))
    {
            [[NSUserDefaults standardUserDefaults] setValue:@"Easy" forKey:DIFFICULTY];
            [[NSUserDefaults standardUserDefaults] setValue:@"X" forKey:XPLAYERTAG];
            [[NSUserDefaults standardUserDefaults] setValue:@"O" forKey:OPLAYERTAG];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
