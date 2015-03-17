//
//  TimerCode.m
//  TimerCode
//
//  Created by ma on 13-12-14.
//  Copyright (c) 2013年 ma. All rights reserved.
//

#import "MyTimer.h"

@interface TimerCode : NSObject

+(TimerCode*)sharedInstance;

- (MyTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)aUserInfo repeats:(BOOL)isRepeat;

- (void)deleteTimer:(MyTimer*)timer;

@end

@interface TimerCode()
{
	NSMutableArray *list,*removeList;
	NSThread *thread;
	NSLock *listLock;
	NSLock *removeLock;
	int dealedFrames;//已经处理完的帧数
}

@end

@interface MyTimer()
{
@public
	CGFloat interval;
	id target;
	SEL selector;
	id userInfo;
	BOOL isRepeat;
	NSTimeInterval currentTime;
	BOOL isEnabled;
}
@property (nonatomic,assign) NSTimeInterval startTime;
@property (nonatomic,assign) CGFloat interval;
@property (nonatomic,retain) id target;
@property (nonatomic,assign) SEL selector;
@property (nonatomic,retain) id userInfo;
@property (nonatomic,assign) BOOL isRepeat;
@property (nonatomic,assign) NSTimeInterval currentTime;//距离上一次触发过去的时间
@property (nonatomic,assign) BOOL isEnabled;

@end

@implementation MyTimer
@synthesize startTime,interval,target,selector,userInfo,isRepeat,currentTime,isEnabled;

-(id)init
{
	self = [super init];
	if(self){
		startTime = [NSDate timeIntervalSinceReferenceDate];
	}
	return self;
}

+ (MyTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)aUserInfo repeats:(BOOL)isRepeat
{
	return [[TimerCode sharedInstance] scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:aUserInfo repeats:isRepeat];
}

- (void)invalidate
{
	isEnabled = NO;
	[[TimerCode sharedInstance] deleteTimer:self];
}

-(void) update
{
	if(isEnabled)
		[target performSelector:selector withObject:userInfo];
}
@end

///////////////////////////////////////////////////////////////////

static TimerCode *timerCode;

@implementation TimerCode

-(id)init
{
	self = [super init];
	if(self){
		list = [[NSMutableArray alloc]init];
		removeList = [[NSMutableArray alloc]init];
		listLock = [[NSLock alloc]init];
		removeLock = [[NSLock alloc]init];
		thread = [[NSThread alloc]initWithTarget:self selector:@selector(timerOperationQueue) object:nil];
		[thread start];
	}
	return self;
}

- (MyTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)aUserInfo repeats:(BOOL)isRepeat
{
	if(ti<0)
	{
		ti = 0.0;
		NSLog(@"[WARNING]时间间隔小于0");
	}

	MyTimer *item = [[MyTimer alloc]init];
	item.interval = ti;
	item.target = aTarget;
	item.selector = aSelector;
	item.userInfo = aUserInfo;
	item.isRepeat = isRepeat;
	item.isEnabled = YES;
	//判断队列里面 有没有相同任务
	//...
	[listLock lock];
#ifdef _DEBUG
	int count = [list count];
	for(int i=0;i<count;i++){
		MyTimer *t = (MyTimer*)[list objectAtIndex:i];
		if(t && t.interval==item.interval && t.selector==item.selector && t.target==item.target){
			NSLog(@"您之前已经提交了一个完全一样的时间函数任务 是不是要检查下？");
		}
	}
#endif
	[list addObject:item];
	[listLock unlock];
	return item;
}

#define MAXFRAMEDIFF 1 //差大帧数差值（已扫描的帧数减去主线程已经处理完的帧数）
#define MAXSLEEPTIME 16667 //微秒。限制最高60帧
-(void)timerOperationQueue
{
	NSTimeInterval lastTime = [NSDate timeIntervalSinceReferenceDate];
	NSMutableArray* tempRemoveList = [[NSMutableArray alloc] init];
	int currentFrame = dealedFrames;
	for(;;)
	{
		while(currentFrame-dealedFrames>MAXFRAMEDIFF)//帧数差值过大表示主线程卡住了，这个时候就不再处理任务，等待主线程空闲下来。
			usleep(MAXSLEEPTIME/3);

		NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
		NSTimeInterval deltaTime = time -lastTime;
		lastTime = time;
		int count = [list count];
		if(count==0)
		{
			usleep(MAXSLEEPTIME);
			continue;
		}
		for(int i=0;i<count;i++){
			MyTimer *item = (MyTimer*)[list objectAtIndex:i];
			if(item->isEnabled==NO)
				continue;
			NSTimeInterval t = item->currentTime + deltaTime;
            BOOL isExecute = NO;
			if(item->interval==0)
			{
				t = 0;
				[item performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
                isExecute = YES;
			}
			else
			{
				BOOL performed = FALSE;
				while(t>item->interval){
					t-=item->interval;
					if(performed)
						continue;
					[item performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
                    isExecute = YES;
					performed = TRUE;
				}
			}
			item->currentTime = t;
			if(isExecute && !item->isRepeat){
				//删除该任务
				[list removeObjectAtIndex:i];
				count--;
				i--;
			}
		}

		//扫描完一次任务队列后，将finishAFrame函数提交到主线程执行
		//如果主线程执行了这个函数，就表示当前帧的所有任务都已经处理完了都已经处理完
		[self performSelectorOnMainThread:@selector(finishAFrame)
							   withObject:nil waitUntilDone:NO];

		[removeLock lock];
		[tempRemoveList addObjectsFromArray:removeList];
		[removeList removeAllObjects];
		[removeLock unlock];

		[listLock lock];
		int removeCount = [tempRemoveList count];
		for(int i=0;i<removeCount;i++){
			MyTimer *removeTimer = [tempRemoveList objectAtIndex:i];
			[list removeObject:removeTimer];
		}
		[listLock unlock];

		[tempRemoveList removeAllObjects];

		NSTimeInterval dealTime = [NSDate timeIntervalSinceReferenceDate]-time;
//		if(currentFrame-dealedFrames>MAXFRAMEDIFF-1)
//			NSLog(@"%.3f %d",dealTime,currentFrame-dealedFrames);//currentFrame+=0;

		currentFrame++;

		int dealTimeMS =((int)(dealTime*1000000.0));
		if(dealTimeMS<MAXSLEEPTIME)
			usleep(MAXSLEEPTIME-dealTimeMS);
	}
}

-(void)finishAFrame//完成一帧的处理
{
	dealedFrames++;
}
-(void)deleteTimer:(MyTimer*)timer
{
	[removeLock lock];
	[removeList addObject:timer];
	[removeLock unlock];
}


#pragma mark - staticMethod

+(TimerCode*)sharedInstance
{
	if(!timerCode)
		timerCode = [[TimerCode alloc]init];
	return timerCode;
}

@end
