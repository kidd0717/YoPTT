//
//  ViewController.h
//  telnet
//
//  Created by MITAKE on 2015/5/6.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSStreamDelegate,UITextFieldDelegate>
- (IBAction)loginPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end

