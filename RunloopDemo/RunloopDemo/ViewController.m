//
//  ViewController.m
//  RunloopDemo
//
//  Created by lmh on 2018/1/15.
//  Copyright © 2018年 SK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSThread *thread;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    [self cfRunloopAction];
    [self demo4];
    
    

}

- (void)runloopAction
{
    //定义一个定时器， 约定两秒之后调用self的run方法
    
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 将定时器添加到当前runloop的nsdefaultRunLoopMode下
    
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    // 讲定时器添加到 UITrackingRunLoopMode
    
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    // 将定时器添加到 Common Models
    
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    // scheduled
    
    //    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 等价于
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 将定时器添加到当前runloop的nsdefaultRunLoopMode下
    
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


- (void)cfRunloopAction
{
    
    /*
    typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
        kCFRunLoopEntry = (1UL << 0),               // 即将进入Loop：1
        kCFRunLoopBeforeTimers = (1UL << 1),        // 即将处理Timer：2
        kCFRunLoopBeforeSources = (1UL << 2),       // 即将处理Source：4
        kCFRunLoopBeforeWaiting = (1UL << 5),       // 即将进入休眠：32
        kCFRunLoopAfterWaiting = (1UL << 6),        // 即将从休眠中唤醒：64
        kCFRunLoopExit = (1UL << 7),                // 即将从Loop中退出：128
        kCFRunLoopAllActivities = 0x0FFFFFFFU       // 监听全部状态改变
    };
    */
  
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSLog(@"监听到Runloop发生改变--- %zd", activity);
        
        
        
    });
    
    
    // 添加观察者到当前runloop中
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    // 释放observer, 最后添加完需要释放掉
    CFRelease(observer);
    
    
    
}

- (void)demo3
{
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"IMG_3771.JPG"] afterDelay:4.0 inModes:@[NSDefaultRunLoopMode]];
    
}

- (void)demo4
{
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run1) object:nil];
    
    [self.thread start];
    
}

- (void)run
{
    NSLog(@"----run");
    
    
}

- (void)run2
{
    NSLog(@"----run2");
    
    
}
- (void)run1
{
    NSLog(@"----run1");
    
    
    //添加下边两句代码，就可以开启runloop，之后self.thread就变成了常驻线程，可随时添加任务， 并交于Runloop处理
    
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop currentRunLoop] run];
    
    
    // 测试是否开启了runloop, 如果开启runloop, 则不会走到这一步， 因为runloop开启循环
    NSLog(@"未开启Runloop");
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(run2) onThread:self.thread withObject:nil waitUntilDone:NO];
    
}
@end
