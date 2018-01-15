//
//  TTSpark.m
//  FaveButton
//
//  Created by yitailong on 16/8/9.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import "TTSpark.h"
#import "UIView+TTAutoLayout.h"


@interface TTSpark ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *firstColor;
@property (nonatomic, strong) UIColor *secondColor;
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign) DotRadius dotRadius;

@property (nonatomic, strong) UIView *dotFirst;
@property (nonatomic, strong) UIView *dotSecond;

@end

@implementation TTSpark

- (instancetype)init:(CGFloat)radius firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor angle:(CGFloat)angle dotRadius:(DotRadius )dotRadius
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.radius = radius;
        self.firstColor = firstColor;
        self.secondColor = secondColor;
        self.angle = angle;
        self.dotRadius = dotRadius;
        
        [self applyInit];
    }
    return self;
}

- (void)applyInit
{
    self.dotFirst = [self createDotView:self.dotRadius.first fillColor:self.firstColor];
    self.dotFirst.translatesAutoresizingMaskIntoConstraints = NO;
    self.dotSecond = [self createDotView:self.dotRadius.second fillColor:self.secondColor];
    self.dotSecond.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leftDotSecond = [NSLayoutConstraint constraintWithItem:self.dotSecond attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *topDotSecond = [NSLayoutConstraint constraintWithItem:self.dotSecond attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.dotRadius.first * 2.0 + 4];
    NSLayoutConstraint *widthDotSecond = [NSLayoutConstraint constraintWithItem:self.dotSecond attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.dotRadius.second * 2.0];
    NSLayoutConstraint *heightDotSecond = [NSLayoutConstraint constraintWithItem:self.dotSecond attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.dotRadius.second * 2.0];
    [self addConstraints:@[leftDotSecond, topDotSecond]];
    [self.dotSecond addConstraints:@[widthDotSecond, heightDotSecond]];
    
    NSLayoutConstraint *rightDotFirst = [NSLayoutConstraint constraintWithItem:self.dotFirst attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottomDotFirst = [NSLayoutConstraint constraintWithItem:self.dotFirst attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.dotSecond attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *widthDotFirst = [NSLayoutConstraint constraintWithItem:self.dotFirst attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.dotRadius.first * 2.0];
    NSLayoutConstraint *heightDotFirst = [NSLayoutConstraint constraintWithItem:self.dotFirst attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.dotRadius.first * 2.0];
    [self addConstraints:@[rightDotFirst, bottomDotFirst]];
    [self.dotFirst addConstraints:@[widthDotFirst, heightDotFirst]];
    
    self.transform = CGAffineTransformMakeRotation(self.angle*M_PI / 180.0);

}

- (UIView *)createDotView:(CGFloat)radius  fillColor:(UIColor*)fillColor
{
    UIView *dot = [[UIView alloc] initWithFrame:CGRectZero];
    dot.backgroundColor = fillColor;
    dot.layer.cornerRadius = radius;
    
    [self addSubview:dot];
    return dot;
}

+ (TTSpark *)createSpark:(TTFaveButton *)faveButton radius:(CGFloat)radius firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor angle:(CGFloat)angle dotRadius:(DotRadius )dotRadius
{
    TTSpark *spark = [[TTSpark alloc] init:radius firstColor:firstColor secondColor:secondColor angle:angle dotRadius:dotRadius];
    spark.translatesAutoresizingMaskIntoConstraints = NO;
    spark.layer.anchorPoint = CGPointMake(0.5, 1);
    spark.alpha = 0.0;

    [faveButton.superview insertSubview:spark belowSubview:faveButton];
    
    CGFloat width = (dotRadius.first * 2.0 + dotRadius.second * 2.0);
    CGFloat height = radius + dotRadius.first * 2.0 + dotRadius.second * 2.0;

    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    [faveButton.superview addConstraints:@[centerXConstraint, centerYConstraint]];
    [spark addConstraints:@[widthConstraint, heightConstraint]];
    
    return spark;
}

- (void)animateIgniteShow:(CGFloat)radius duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [self layoutIfNeeded];
    
    CGFloat diameter = (self.dotRadius.first * 2.0) + (self.dotRadius.second * 2.0);
    CGFloat height = radius + diameter + 4;
    
    NSLayoutConstraint *heightConstraint = [self TTConstraintForAttribute:NSLayoutAttributeHeight];
    heightConstraint.constant = height;
    
    [UIView animateWithDuration:0 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:duration*0.7 delay:delay options: UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
}

- (void)animateIgniteHide:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:duration*0.5 delay:delay options: UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:delay options: UIViewAnimationOptionCurveEaseOut animations:^{
        self.dotSecond.backgroundColor = self.firstColor;
        self.dotFirst.backgroundColor  = self.secondColor;
    } completion:nil];
    
    for (UIView *dotView in @[self.dotFirst, self.dotSecond]) {
        [dotView setNeedsLayout];
        
        NSLayoutConstraint *heightConstraint = [dotView TTConstraintForAttribute:NSLayoutAttributeHeight];
        heightConstraint.constant = 0;
        
        NSLayoutConstraint *widthConstraint = [dotView TTConstraintForAttribute:NSLayoutAttributeWidth];
        widthConstraint.constant = 0;
    }

    [UIView animateWithDuration:duration delay:delay options: UIViewAnimationOptionCurveEaseOut animations:^{
        [self.dotFirst layoutIfNeeded];
    } completion:nil];
 
    [UIView animateWithDuration:duration*1.7 delay:delay options: UIViewAnimationOptionCurveEaseOut animations:^{
        [self.dotSecond layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
