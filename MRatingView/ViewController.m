//
//  ViewController.m
//  MRatingView
//
//  Created by Ester on 01/05/13.
//  Copyright (c) 2013 misato. All rights reserved.
//

#import "ViewController.h"
#import "MRatingView.h"

/**
 Constants for positioning the views
 */
#define kRatingViewXPosition    50.0f
#define kRatingViewYPosition    150.0f
#define kRatingLabelLeftMargin  10.0f
#define kRatingLabelWidth       30.0f
#define kRatingLabelHeight      20.0f

@interface ViewController () <MRatingViewDelegate>

@property (nonatomic, strong) UILabel *ratingLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the RatingView.
    MRatingView *ratingView = [[MRatingView alloc] initWithRating:@1 maxRating:5 editable:YES imageBaseName:@"star"];
    ratingView.delegate = self;
    // Get the minimum size for the view, so we can give it a frame
    CGSize ratingViewSize = [ratingView sizeThatFits:CGSizeZero];
    ratingView.frame = CGRectMake(kRatingViewXPosition, kRatingViewYPosition, ratingViewSize.width, ratingViewSize.height);
    
    [self.view addSubview:ratingView];
    
    CGFloat xPoint = kRatingViewXPosition + ratingViewSize.width + kRatingLabelLeftMargin;
    CGFloat yPoint = kRatingViewYPosition + ((ratingViewSize.height - kRatingLabelHeight ) / 2); // center the label
    
    _ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, kRatingLabelWidth, kRatingLabelHeight)];
    _ratingLabel.text = [ratingView.rating stringValue];
    _ratingLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_ratingLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MRatingViewDelegate

- (void)ratingView:(MRatingView *)ratingView didChangeRating:(NSNumber *)newRating {
    _ratingLabel.text = [NSString stringWithFormat:@"%1.1f", [newRating floatValue]];
}

@end
