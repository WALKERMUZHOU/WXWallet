//
//  CircleView.m
//  IDLFaceSDKDemoOC
//
//  Created by Tong,Shasha on 2017/8/31.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "CircleView.h"

@interface CircleView ()

@property (nonatomic, strong) CAShapeLayer *outLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

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
    
//    CGFloat kLineWidth = 10;
//
//    self.outLayer = [CAShapeLayer layer];
//    CGRect rect = circleRect;
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
//    self.outLayer.strokeColor = [UIColor lightGrayColor].CGColor;
//    self.outLayer.lineWidth = kLineWidth;
//    self.outLayer.fillColor =  [UIColor clearColor].CGColor;
//    self.outLayer.lineCap = kCALineCapRound;
//    self.outLayer.path = path.CGPath;
//    [self.layer addSublayer:self.outLayer];
//
//    UIBezierPath *pathOne = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0) radius:self.circleRect.size.width/2.0-5 startAngle:0 endAngle:M_PI/2 clockwise:YES];
//    self.progressLayer = [CAShapeLayer layer];
//    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
//    self.progressLayer.strokeColor = [UIColor blueColor].CGColor;
//    self.progressLayer.lineWidth = kLineWidth;
//    self.progressLayer.lineCap = kCALineCapRound;
//    self.progressLayer.path = pathOne.CGPath;
//    [self.layer addSublayer:self.progressLayer];
//
//    [CATransaction  begin]; //开始一个事务动画
//
//    [CATransaction  setAnimationDuration:1.0]; //自定义动画执行时间
//
//    [CATransaction  setCompletionBlock:^{ // 动画完成后的执行(这里旋转动画会快的多，因为他会是默认动画时长 0.25秒)
//    CGAffineTransform transfrom = self.progressLayer.affineTransform;
//    transfrom = CGAffineTransformRotate(transfrom, M_PI_2);
//        self.progressLayer.affineTransform = transfrom;
//    }];
//
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//
//self.progressLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.9].CGColor;
//
//    [CATransaction  commit]; //开始一个事务动画
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 12);
    
//    if (self.detectCompelet) {
//        CGContextSetStrokeColorWithColor(context, lwColorGray.CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context, 20);
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextRef context3 = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context3, 12);
//        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
//        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, M_PI/2,M_PI , 0);
//        CGContextDrawPath(context3, kCGPathStroke);
//
//        CGContextRef context4 = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context4, 12);
//        CGContextSetStrokeColorWithColor(context4, lwColorGray.CGColor);
//        CGContextAddArc(context4, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20 - 12, 0, 2*M_PI, 0);
//        CGContextDrawPath(context4, kCGPathStroke);
//
//        CGContextRef context5 = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context5, 12);
//        CGContextSetStrokeColorWithColor(context5, lwColorNormal.CGColor);
//        CGContextAddArc(context5, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20 - 12, -M_PI/2,0 , 0);
//        CGContextDrawPath(context5, kCGPathStroke);
//        successImageView.hidden = YES;
//        return;
//    }
    
//    if (self.livenessCompelet) {
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.169 green:0.714 blue:0.588 alpha:1].CGColor);
        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextRef contextOne = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(contextOne, 15);
        CGContextSetStrokeColorWithColor(contextOne, [UIColor whiteColor].CGColor);
        CGContextAddArc(contextOne, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-15, 0, 2*M_PI, 0);
        CGContextDrawPath(contextOne, kCGPathStroke);
        
//        CGContextRef context3 = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context3, 12);
//        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
//        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, -M_PI/2,0 , 0);
//        CGContextDrawPath(context3, kCGPathStroke);
//        successImageView.hidden = NO;
        return;
//    }
    
//    if (self.livenessFail) {
//
//        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1].CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context, 20);
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextRef context3 = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context3, 12);
//        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
//        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, -M_PI/2,0 , 0);
//        CGContextDrawPath(context3, kCGPathStroke);
//        successImageView.hidden = NO;
//        return;
//    }
//
//    if (!self.conditionStatusFit) {
//
////        CGContextSetStrokeColorWithColor(context, BackgroundColor.CGColor);
////        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-1, 0, 2*M_PI, 0);
////        CGContextDrawPath(context, kCGPathStroke);
////
////        CGContextSetStrokeColorWithColor(context, OutSideColor.CGColor);
////        CGFloat lengths[] = {12,10};
////        CGContextSetLineDash(context, 0, lengths, 2);
////        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-1, 0, 2*M_PI, 0);
////        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextSetStrokeColorWithColor(context, lwColorGray.CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context, 20);
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextRef context3 = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context3, 12);
//        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
//        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, -M_PI/2,0 , 0);
//        CGContextDrawPath(context3, kCGPathStroke);
//
//    }else {
//
//        CGContextSetStrokeColorWithColor(context, lwColorGray.CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context, 20);
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        CGContextAddArc(context, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-20, 0, 2*M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//
//        CGContextRef context3 = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context3, 12);
//        CGContextSetStrokeColorWithColor(context3, lwColorNormal.CGColor);
//        CGContextAddArc(context3, self.circleRect.origin.x+self.circleRect.size.width/2.0, self.circleRect.origin.y+self.circleRect.size.height/2.0, self.circleRect.size.width/2.0-5, -M_PI/2,M_PI *2 + M_PI/2 , 0);
//        CGContextDrawPath(context3, kCGPathStroke);
//
//    }
}


@end
