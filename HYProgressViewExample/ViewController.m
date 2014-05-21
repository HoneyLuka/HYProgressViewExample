//
//  ViewController.m
//  HYProgressViewExample
//
//  Created by Shadow on 14-5-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "ViewController.h"
#import "HYProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) HYProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.progressView = [[HYProgressView alloc]initWithFrame:CGRectMake(100, 20, 100, 100)];
    [self.view addSubview:self.progressView];
}

- (IBAction)normalButtonClick:(id)sender {
    self.progressView.type = HYProgressViewTypeDefault;
}

- (IBAction)pieButtonClick:(id)sender {
    self.progressView.type = HYProgressViewTypePie;
}

- (IBAction)ringButtonClick:(id)sender {
    self.progressView.type = HYProgressViewTypeRing;
}

- (IBAction)pieWithBorderButtonClick:(id)sender {
    self.progressView.type = HYProgressViewTypePieWithBorder;
}

- (IBAction)singleColor:(id)sender {
    self.progressView.foreColor = DEFAULT_FORE_COLOR;
}
- (IBAction)multibleColor:(id)sender {
    if (self.progressView.type != HYProgressViewTypePieWithBorder) {
        self.progressView.gradientColors = @[DEFAULT_GRADIENT_LEFT_COLOR, DEFAULT_GRADIENT_RIGHT_COLOR];
    }
}

- (IBAction)plusOne:(id)sender {
    self.progressView.progress += 0.1;
}

- (IBAction)plusFive:(id)sender {
    self.progressView.progress += 0.5;
}

- (IBAction)minusOne:(id)sender {
    self.progressView.progress -= 0.1;
}

- (IBAction)minusFive:(id)sender {
    self.progressView.progress -= 0.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
