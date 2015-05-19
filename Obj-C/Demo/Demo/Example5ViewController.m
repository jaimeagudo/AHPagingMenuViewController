//
//  Example5ViewController.m
//  Demo
//
//  Created by André Henrique Silva on 08/05/15.
//  Copyright (c) 2015 André Henrique Silva. All rights reserved.
//

#import "Example5ViewController.h"
#import "AHPagingMenuViewController.h"
#import "Example4ViewController.h"

@interface Example5ViewController ()

@property (nonatomic) NSInteger current;

@end

@implementation Example5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.current = 1;
}

- (IBAction)newController:(id)sender {
    [self.pagingMenuViewController addNewController:[Example4ViewController new] andTitleView:[NSString stringWithFormat:@"New %ld", (long)self.current]];
    [self.pagingMenuViewController setPosition:[self.pagingMenuViewController.viewControllers count] -1 animated:YES];
    self.current++;
}

- (IBAction)goToFirst:(id)sender {
    [self.pagingMenuViewController setPosition:0 animated:YES];
}

- (IBAction)goToLast:(id)sender {
     [self.pagingMenuViewController setPosition:[self.pagingMenuViewController.viewControllers count] -1 animated:YES];
}

- (IBAction)setArrow:(id)sender {
    [self.pagingMenuViewController setShowArrow:!self.pagingMenuViewController.showArrow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)next:(id)sender {
    [self.pagingMenuViewController goNextView];
}

- (IBAction)reset:(id)sender {
    [self.pagingMenuViewController setBounce:!self.pagingMenuViewController.isBounce];
}

- (IBAction)Previeus:(id)sender {
      [self.pagingMenuViewController goPrevieusView];
}

- (IBAction)changeFonte:(id)sender {
    [self.pagingMenuViewController setChangeFont:!self.pagingMenuViewController.changeFont];
}

- (IBAction)transform:(id)sender {
    [self.pagingMenuViewController setTransformScale: !self.pagingMenuViewController.transformScale];
}

- (IBAction)fade:(id)sender {
     [self.pagingMenuViewController setFade: !self.pagingMenuViewController.fade];
}

- (IBAction)randonFirst:(id)sender {
    [self.pagingMenuViewController setSelectedColor:[self randomColor]];
}

- (IBAction)randonSecond:(id)sender {
    [self.pagingMenuViewController setDissectedColor:[self randomColor]];
}

- (IBAction)navColor:(id)sender {
    [self.pagingMenuViewController setNavBackgroundColor:[self randomColor]];
}

- (IBAction)navLineColor:(id)sender
{
    [self.pagingMenuViewController setNavLineBackgroundColor:[self randomColor]];
}

- (IBAction)scaleTitle:(id)sender {
    [self.pagingMenuViewController setScaleMax:((double)arc4random() / 0x100000000) + 0.3 andScaleMin:((double)arc4random() / 0x100000000)];
}

- (IBAction)firstFont:(id)sender {
    [self.pagingMenuViewController setSelectedFont:[UIFont fontWithName:@"Chalkduster" size:16]];
}

- (IBAction)secondFont:(id)sender {
     [self.pagingMenuViewController setDissectedFont:[UIFont fontWithName:@"BradleyHandITCTT-Bold" size:16]];
}

-(UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


@end
