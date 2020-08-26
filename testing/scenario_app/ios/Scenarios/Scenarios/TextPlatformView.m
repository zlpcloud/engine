// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "TextPlatformView.h"

@protocol TestGestureRecognizerDelegate <NSObject>

- (void)gestureTouchesBegan;
- (void)gestureTouchesEnded;

@end

@interface TestTapGestureRecognizer : UITapGestureRecognizer

@property(weak, nonatomic)
    NSObject<TestGestureRecognizerDelegate>* testTapGestureRecognizerDelegate;

@end

@implementation TestTapGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
  [self.testTapGestureRecognizerDelegate gestureTouchesBegan];
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
  [self.testTapGestureRecognizerDelegate gestureTouchesEnded];
  [super touchesEnded:touches withEvent:event];
}

@end

@implementation TextPlatformViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  TextPlatformView* textPlatformView = [[TextPlatformView alloc] initWithFrame:frame
                                                                viewIdentifier:viewId
                                                                     arguments:args
                                                               binaryMessenger:_messenger];
  return textPlatformView;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStringCodec sharedInstance];
}

@end

@interface TextPlatformView () <TestGestureRecognizerDelegate>

@end

@implementation TextPlatformView {
  UITextView* _textView;
  FlutterMethodChannel* _channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if ([super init]) {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(50.0, 50.0, 250.0, 100.0)];
    _textView.textColor = UIColor.blueColor;
    _textView.backgroundColor = UIColor.lightGrayColor;
    [_textView setFont:[UIFont systemFontOfSize:52]];
    _textView.text = args;
    _textView.accessibilityIdentifier = @"platform_view";

    TestTapGestureRecognizer* gestureRecognizer =
        [[TestTapGestureRecognizer alloc] initWithTarget:self action:@selector(platformViewTapped)];

    [_textView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.testTapGestureRecognizerDelegate = self;
    _textView.accessibilityLabel = @"";
  }
  return self;
}

- (UIView*)view {
  return _textView;
}

- (void)platformViewTapped {
  _textView.accessibilityLabel =
      [_textView.accessibilityLabel stringByAppendingString:@"-platformViewTapped"];
}

- (void)gestureTouchesBegan {
  _textView.accessibilityLabel =
      [_textView.accessibilityLabel stringByAppendingString:@"-gestureTouchesBegan"];
}

- (void)gestureTouchesEnded {
  _textView.accessibilityLabel =
      [_textView.accessibilityLabel stringByAppendingString:@"-gestureTouchesEnded"];
}

@end
