//
//  ViewController.h
//  Stocks
//
//  Created by Jon Cobb on 11/8/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockMonitor.h"

@interface ViewController : UIViewController<StockMonitorDelegate> {
    
    StockMonitor*      _stockMonitor;
    IBOutlet UISlider* _exchangeStockValueSlider;
    IBOutlet UILabel*  _exchangeStockValueLabel;
    
    IBOutlet UILabel*  _clientStockValueLabel;
    IBOutlet UILabel*  _clientStockTrendLabel;
    IBOutlet UILabel*  _clientRecentLabel0;
    IBOutlet UILabel*  _clientRecentLabel1;
    IBOutlet UILabel*  _clientRecentLabel2;
    IBOutlet UILabel*  _clientRecentLabel3;
}

-(void) updateEntireDisplay;

-(void) updateExchangeDisplay;
-(void) updateExchangeStockValueSlider: (NSUInteger) stockValue;
-(void) updateExchangeStockValueLabel:  (NSUInteger) stockValue;

-(void) updateClientDisplay;
-(void) updateClientStockValueLabel: (NSUInteger) stockValue;
-(void) updateClientStockTrendLabel: (StockTrend) stockTrend;
-(void) updateClientRecentChanges;
-(void) updateClientRecentChange: (NSUInteger) changeIndex displayLabel: (UILabel*) displayLabel;

-(IBAction) exchangeSetButtonTapped;
-(IBAction) exchangeStockValueSliderValueChanged;

@end
