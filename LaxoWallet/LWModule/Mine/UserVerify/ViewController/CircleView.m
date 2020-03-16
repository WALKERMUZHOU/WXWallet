//
//  CircleView.m
//  IDLFaceSDKDemoOC
//
//  Created by Tong,Shasha on 2017/8/31.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView{
    UIImageView *successImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        successImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        successImageView.image = [UIImage imageNamed:@"home_enabled"];
        successImageView.hidden = YES;
        [self addSubview:successImageView];
        successImageView.center = self.center;
    }
    return self;
}

- (void)setConditionStatusFit:(BOOL)conditionStatusFit
{
    if (_conditionStatusFit != conditionStatusFit) {
        _conditionStatusFit = conditionStatusFit;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setNeedsDisplay];
        });
    }
}

- (void)setDetectCompelet:(BOOL)detectCompelet{
    _detectCompelet = detectCompelet;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->successImageView.backgroundColor = [UIColor whiteColor];
        self->successImageView.image = nil;
    });

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setNeedsDisplay];
    });
}


- (void)setCircleRect:(CGRect)circleRect{
    _circleRect = circleRect;
    successImageView.frame = CGRectMake(self.circleRect.origin.x + 20, self.circleRect.origin.y + 20, self.circleRect.size.width - 40, self.circleRect.size.height -40);
    successImageView.layer.cornerRadius = self.circleRect.size.width/2.0 - 20;
    successImageView.layer.masksToBounds = YES;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 12);
    
    if (self.detectCompelet) {
        CGContextSetStrokeColorWithColor(context, lwColorGray.CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 20);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context3 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context3, 12);
        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, M_PI/2,M_PI , 0);
        CGContextDrawPath(context3, kCGPathStroke);
        
        CGContextRef context4 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context4, 12);
        CGContextSetStrokeColorWithColor(context4, lwColorGray.CGColor);
        CGContextAddArc(context4, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20 - 12, 0, 2*M_PI, 0);
        CGContextDrawPath(context4, kCGPathStroke);
        
        CGContextRef context5 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context5, 12);
        CGContextSetStrokeColorWithColor(context5, lwColorNormal.CGColor);
        CGContextAddArc(context5, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20 - 12, -M_PI/2,0 , 0);
        CGContextDrawPath(context5, kCGPathStroke);
        successImageView.hidden = YES;
        return;
    }
    
    if (self.livenessCompelet) {
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.169 green:0.714 blue:0.588 alpha:0.5].CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 20);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context3 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context3, 12);
        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, -M_PI/2,0 , 0);
        CGContextDrawPath(context3, kCGPathStroke);
        successImageView.hidden = NO;
        return;
    }
    
    if (self.livenessFail) {
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1].CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 20);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context3 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context3, 12);
        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, -M_PI/2,0 , 0);
        CGContextDrawPath(context3, kCGPathStroke);
        successImageView.hidden = NO;
        return;
    }
    
    if (!self.conditionStatusFit) {
        
//        CGContextSetStrokeColorWithColor(context, BackgroundColor.CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-1, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextSetStrokeColorWithColor(context, OutSideColor.CGColor);
//        CGFloat lengths[] = {12,10};
//        CGContextSetLineDash(context, 0, lengths, 2);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-1, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextSetStrokeColorWithColor(context, lwColorGray.CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 20);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context3 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context3, 12);
        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, -M_PI/2,0 , 0);
        CGContextDrawPath(context3, kCGPathStroke);
    
    }else {
        
        CGContextSetStrokeColorWithColor(context, lwColorGray.CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 20);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef context3 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context3, 12);
        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, -M_PI/2,M_PI *2 + M_PI/2 , 0);
        CGContextDrawPath(context3, kCGPathStroke);
        
    }
}


@end
