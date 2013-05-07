//
//  BADAchievements.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 2/4/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BADAchievements : UIView

@property (weak, nonatomic) IBOutlet UIButton *easyImage;
@property (weak, nonatomic) IBOutlet UIButton *mediumImage;
@property (weak, nonatomic) IBOutlet UIButton *hardImage;
@property (weak, nonatomic) IBOutlet UIButton *onlineImage;
@property (weak, nonatomic) IBOutlet UILabel *easyLbl;
@property (weak, nonatomic) IBOutlet UILabel *mediumLbl;
@property (weak, nonatomic) IBOutlet UILabel *hardLbl;
@property (weak, nonatomic) IBOutlet UILabel *onlineLbl;

- (IBAction)buttonTUI:(id)sender;

@end
