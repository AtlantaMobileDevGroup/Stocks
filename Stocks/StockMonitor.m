//
//  StockMonitor.m
//  Stocks
//
//  Created by Jon Cobb on 11/8/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import "StockMonitor.h"

#pragma mark StockMonitor Constants

static NSUInteger DEFAULT_STOCK_VALUE         = 0;
static NSUInteger DEFAULT_RECENT_CHANGE_LIMIT = 4;

#pragma mark StockMonitor Implementation

@implementation StockMonitor

#pragma mark StockMonitor Property Synthesis

@synthesize delegate      = _delegate;
@synthesize value         = _value;
@synthesize trend         = _trend;
@synthesize recentChanges = _recentChanges;

#pragma mark Factory and Initilization Methods

+(id) stockMonitorWithStockValue:(NSUInteger)value {
    return [[[self alloc] initWithStockValue: value] autorelease];
}

-(id) init {
    return [self initWithStockValue: DEFAULT_STOCK_VALUE andRecentChangeLimit: DEFAULT_RECENT_CHANGE_LIMIT];
}

-(id) initWithStockValue: (NSUInteger) value {
    return [self initWithStockValue:value andRecentChangeLimit:DEFAULT_RECENT_CHANGE_LIMIT];
}

-(id) initWithStockValue: (NSUInteger) value andRecentChangeLimit:(NSUInteger)recentChangeLimit {
    
    if(self = [super init]) {
        
        _value             = value;
        _trend             = Level;
        _recentChangeLimit = recentChangeLimit;
        
        _recentChanges = [[NSMutableArray alloc] initWithCapacity: _recentChangeLimit];
        
        for(uint i = 0; i < _recentChangeLimit; i++) {
            [_recentChanges addObject: [NSNumber numberWithInteger: 0]];
        }
    }
    
    return self;
}

#pragma mark Instance Methods

-(void) updateStockValueTrend {
    
    NSInteger recentChanges = 0;
    
    for(id change in _recentChanges) {
        
        NSNumber* currentChange = (NSNumber*) change;
        recentChanges += [currentChange integerValue];
    }
    
    StockTrend newTrend = Level;
    
    if (recentChanges < 0)      newTrend = Decreasing;
    else if (0 < recentChanges) newTrend = Increasing;
    
    if(_trend != newTrend) {
        
        _trend = newTrend;
        
        if(_delegate && [_delegate respondsToSelector:@selector(stockMonitorTrendChanged:)]) {
            [_delegate stockMonitorTrendChanged: _trend];
        }
    }
}

-(void) setValue:(NSUInteger) value {
    
    if(_recentChangeLimit) {
        
        [_recentChanges removeObjectAtIndex: 0];
        [_recentChanges addObject: [NSNumber numberWithInteger: (NSInteger) (value - _value)]];
        
        [self updateStockValueTrend];
    }
    
    _value = value;
    
    if(_delegate && [_delegate respondsToSelector: @selector(stockMonitorValueUpdated:)]) {
        [_delegate stockMonitorValueUpdated: _value];
    }
}

@end