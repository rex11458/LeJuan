//
//  HPQRView.m
//  Demo
//
//  Created by gurgle on 15/9/22.
//  Copyright © 2015年 handpay. All rights reserved.
//

#import "LJQRView.h"
static NSTimeInterval kQrLineanimateDuration = 0.02;

@interface LJQRView()
{
    UIImageView *qrLine;
    CGFloat qrLineY;
}
@end

@implementation LJQRView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (!qrLine) {
        
        [self initQRLine];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kQrLineanimateDuration target:self selector:@selector(show) userInfo:nil repeats:YES];
        [timer fire];
        
        [self initBtmView];
        
    }
}

- (void)initBtmView {
    
    UIView *view = self;
    UIView *controls;
    CGRect r = view.bounds;
    r.origin.y = r.size.height - 54;
    r.size.height = 54;
    controls = [[UIView alloc]
                initWithFrame: r];
    controls.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleTopMargin;
    controls.backgroundColor = [UIColor blackColor];
    
    UIToolbar *toolbar =
    [UIToolbar new];
    r.origin.y = 0;
    toolbar.frame = r;
    toolbar.barStyle = UIBarStyleBlackOpaque;
    toolbar.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    
    toolbar.items =
    [NSArray arrayWithObjects:
     [[UIBarButtonItem alloc]
       initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
       target: self
       action: @selector(cancelAction)],
     [[UIBarButtonItem alloc]
       initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
       target: nil
       action: nil],
     nil];
    [controls addSubview: toolbar];
    
    [view addSubview: controls];
}

- (void)cancelAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelAction)]) {
        [self.delegate cancelAction];
    }
}

- (void)initQRLine {
    qrLine  = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - self.transparentArea.width / 2, self.bounds.size.height / 2 - self.transparentArea.height / 2, self.transparentArea.width, 2)];
    qrLine.image = [UIImage imageNamed:@"qr_scan_line"];
    qrLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:qrLine];
    qrLineY = qrLine.frame.origin.y;
}

- (void)show {
    
    [UIView animateWithDuration:kQrLineanimateDuration animations:^{
        
        CGRect rect = qrLine.frame;
        rect.origin.y = qrLineY;
        qrLine.frame = rect;
        
    } completion:^(BOOL finished) {
        
        CGFloat maxBorder = self.frame.size.height / 2 + self.transparentArea.height / 2 - 2;
        if (qrLineY > maxBorder) {
            
            qrLineY = self.frame.size.height / 2 - self.transparentArea.height /2;
        }
        qrLineY++;
    }];
}

- (void)drawRect:(CGRect)rect {
    
    //整个二维码扫描界面的颜色
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
                                      self.transparentArea.width,self.transparentArea.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect {
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

@end
