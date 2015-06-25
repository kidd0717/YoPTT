//
//  ViewController.m
//  telnet
//
//  Created by MITAKE on 2015/5/6.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import "ViewController.h"
#import "Utility.h"

enum telnetState{
    TOP_LEVEL,
    SEENIAC,
    SEENWILL,
    SEENWONT,
    SEENDO,
    SEENDONT,
    SEENSB,
    SUBNEGOT,
    SUBNEG_IAC,
    SEENCR
};

@interface ViewController ()
{
    NSInputStream *iStream;
    NSOutputStream *oStream;
    enum telnetState state;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    NSString *ip = @"140.112.172.4";
    UInt32 port = 23;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)(ip), port, &readStream, &writeStream);
    if(readStream && writeStream)
    {
//        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
//        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        iStream = (__bridge NSInputStream *)(readStream);
        [iStream setDelegate:self];
        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [iStream open];
        
        oStream = (__bridge NSOutputStream *)writeStream;
        [oStream setDelegate:self];
        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [oStream open];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
        case NSStreamEventOpenCompleted: {

            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            NSMutableData *data = [[NSMutableData alloc]init];
            
            
            while ([(NSInputStream *)aStream hasBytesAvailable])
            {
                uint8_t buf[4096];
                NSInteger len = [(NSInputStream *)aStream read: buf maxLength: 4096];
                if (len > 0)
                {
                    [data appendBytes:buf length:len];
//                    printf(buf);
                }
            }
            NSString *s = [Utility getStringFromTelnetData:data];
            
            NSLog(@"%@",s);
            
            break;
        }
        case NSStreamEventHasSpaceAvailable: {
            break;
        }
        case NSStreamEventErrorOccurred: {
//            [self setIsProcessing: NO];
//            NSLog(@"Error: %@", [stream streamError]);
        }
        case NSStreamEventEndEncountered: {
//            [self setIsProcessing: NO];
//            [stream close];
//            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//            [stream release];
//            if (stream == _inputStream)
//                _inputStream = nil;
//            else if (stream == _outputStream)
//                _outputStream = nil;
//            [self setConnected: NO];
//            [[self terminal] closeConnection];
//            break;
        }
    }
}
//
//- (void) receiveBytes: (unsigned char *)bytes length: (NSUInteger)length
//{
//    
//    unsigned char *stream = (unsigned char *) bytes;
//    std::deque<unsigned char> terminalBuf;
//    
//    /* parse the telnet command. */
//    int L = length;
//#ifdef __DUMPPACKET__
//    //	dump_packet(stream, L);
//#endif
//    
//    while (L--) {
//        unsigned char c = *stream++;
//        switch (state) {
//            case TOP_LEVEL:
//            case SEENCR:
//            {
//                if (c == NUL && _state == SEENCR)
//                    _state = TOP_LEVEL;
//                else if (c == IAC)
//                    _state = SEENIAC;
//                else {
//                    if (!_synch)
//                        terminalBuf.push_back(c);
//                    else if (c == DM)
//                        _synch = NO;
//                    
//                    if (c == CR)
//                        _state = SEENCR;
//                    else
//                        _state = TOP_LEVEL;
//                }
//                break;
//            }
//            case SEENIAC:
//            {
//                if (c == DO || c == DONT || c == WILL || c == WONT) {
//                    _typeOfOperation = c;
//                    if (c == DO)
//                        _state = SEENDO;
//                    else if (c == DONT)
//                        _state = SEENDONT;
//                    else if (c == WILL)
//                        _state = SEENWILL;
//                    else if (c == WONT)
//                        _state = SEENWONT;
//                } else if (c == SB)
//                    _state = SEENSB;
//                else if (c == DM) {
//                    _synch = NO;
//                    _state = TOP_LEVEL;
//                } else {
//                    /* ignore everything else; print it if it's IAC */
//                    if (c == IAC) {
//                        // TODO: cwrite(c);
//                    }
//                    _state = TOP_LEVEL;
//                }
//                break;
//            }
//            case SEENWILL:
//            {
//                if (c == TELOPT_ECHO || c == TELOPT_SGA)
//                    [self sendCommand: DO option: c];
//                else if (c == TELOPT_BINARY)
//                    [self sendCommand: DO option: c];
//                else
//                    [self sendCommand: DONT option: c];
//                
//                _state = TOP_LEVEL;
//                break;
//            }
//            case SEENWONT:
//                [self sendCommand: DONT option: c];
//                _state = TOP_LEVEL;
//                break;
//            case SEENDO:
//            {
//                if (c == TELOPT_TTYPE)
//                    [self sendCommand: WILL option: TELOPT_TTYPE];
//                else if (c == TELOPT_NAWS) {
//                    unsigned char b[] = {IAC, SB, TELOPT_NAWS, 0, 80, 0, 24, IAC, SE};
//                    [self sendCommand: WILL option: TELOPT_NAWS];
//                    [self performSelector: @selector(sendData:) withObject: [NSData dataWithBytes:b length:9] afterDelay: 0.001];
//                    //					[self sendBytes: b length: 9];
//                } else if (c == TELOPT_BINARY) {
//                    [self sendCommand: WILL option: c];
//                } else
//                    [self sendCommand: WONT option: c];
//                _state = TOP_LEVEL;
//                break;
//            }
//            case SEENDONT:
//                [self sendCommand: WONT option: c];
//                _state = TOP_LEVEL;
//                break;
//            case SEENSB:
//                _sbOption = c;
//                [_sbBuffer release];
//                _sbBuffer = [[NSMutableData data] retain];
//                _state = SUBNEGOT;
//                break;
//            case SUBNEGOT:
//                if (c == IAC)
//                    _state = SUBNEG_IAC;
//                else
//                    [_sbBuffer appendBytes: &c length: 1];
//                break;
//            case SUBNEG_IAC:
//                /*  [IAC,SB,<option code number>,SEND,IAC],SE */
//                if (c != SE) {
//                    [_sbBuffer appendBytes: &c length: 1];
//                    _state = SUBNEGOT;
//                } else {
//                    const unsigned char *buf = (const unsigned char *)[_sbBuffer bytes];
//                    if ([_sbBuffer length])
//                        if (_sbOption == TELOPT_TTYPE && [_sbBuffer length] == 1 && buf[0] == TELQUAL_SEND) {
//                            unsigned char b[] = {IAC, SB, TELOPT_TTYPE, TELQUAL_IS, 'v', 't', '1', '0', '0', IAC, SE};
//                            [self performSelector:@selector(sendData:) withObject: [NSData dataWithBytes: b length: 11] afterDelay: 0.001];
//                            //						[self sendBytes: b length: 11];
//                        }
//                    _state = TOP_LEVEL;
//                    [_sbBuffer release];
//                    _sbBuffer = nil;
//                }
//                break;
//        }
//    }
//    
//    unsigned char chunkBuf[1024];
//    while (!terminalBuf.empty()) {
//        int length = 1024;
//        if (terminalBuf.size() < 1024) 
//            length = terminalBuf.size();
//        int i;
//        for (i = 0; i < length; i++) {
//            chunkBuf[i] = terminalBuf.front();
//            terminalBuf.pop_front();
//        }
//        [_terminal feedBytes: chunkBuf length: length connection: self];
//    }
//}
- (IBAction)loginPress:(id)sender
{
    NSString *us = self.accountField.text;
    NSString *pw = self.passwordField.text;
    
    NSString *loginString = [NSString stringWithFormat:@"%@\r%@\r",us,pw];

    [self sendString:loginString];
//    [self sendString:us];
//    [self sendNewLine];
//    [self sendString:pw];
//    [self sendNewLine];
}

#pragma mark - send function
- (void)sendString:(NSString *)input
{
    NSMutableData *sendData = [[NSMutableData alloc] init];
    
    for(int i = 0 ; i < [input length] ; i ++)
    {
        unichar ch = [input characterAtIndex:i];
        if(ch < 0x7F) // ASCII, 1 char
        {
            unsigned char buf[1];
            buf[0] = ch;
            [sendData appendBytes:buf length:1];
        }
        else // non ASCII, 2 char
        {
            //不會寫啦幹
        }
    }
    
    [self sendData:sendData];
}

- (void)sendData:(NSData *)data
{
    [self sendByte:(unsigned char *)[data bytes] length:[data length]];
}

- (void)sendByte:(unsigned char*)bytes length:(NSInteger)length
{
    if(length <= 0 || !oStream) //傳入的data沒有值 或 output stream尚未初始化
        return;
    NSStreamStatus status = [oStream streamStatus];
    if(status == NSStreamStatusNotOpen ||
       status == NSStreamStatusError ||
       status == NSStreamStatusClosed ||
       status == NSStreamStatusAtEnd)//output stream的狀態有誤
        return;
    
    
    NSInteger result = [oStream write:bytes maxLength:length];
    if(result == length)
        return;

}

- (void)sendNewLine
{
    unsigned char ch[1];
    ch[0] = 0x0D;
    [self sendByte:ch length:1];
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.accountField])
    {
        [self.passwordField becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
    }
    
    return YES;
}
@end
