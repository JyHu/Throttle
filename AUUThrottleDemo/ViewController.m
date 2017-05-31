//
//  ViewController.m
//  AUUThrottleDemo
//
//  Created by JyHu on 2017/5/30.
//
//

#import "ViewController.h"
#import "AUUThrottle.h"
#import "AUULoopThrottle+Helper.h"

@interface ViewController ()

@property (retain, nonatomic) AUULoopThrottle *loopThrottle;
@property (weak, nonatomic) IBOutlet UILabel *delayLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (AUULoopThrottle *)loopThrottle
{
    if (!_loopThrottle) {
        _loopThrottle = [AUULoopThrottle throttleWithTarget:self delay:1];
        _loopThrottle.executeAtStart = NO;
        _loopThrottle.loopHandleBlock = ^(AUULoopThrottle *loopThrottle) {
            NSLog(@"loop count %ld", loopThrottle.loopCount);
        };
    }
    return _loopThrottle;
}

- (IBAction)execute:(UISwitch *)sender {
    self.loopThrottle.executeAtStart = sender.on;
}

- (IBAction)reset:(UISwitch *)sender {
    self.loopThrottle.resetCounterWhenPause = sender.on;
}

- (IBAction)resume:(id)sender {
    NSLog(@"resume");
    [self.loopThrottle resume];
}

- (IBAction)pause:(id)sender {
    NSLog(@"pause");
    [self.loopThrottle pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
