
#import "HelpWebViewController.h"

@interface HelpWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HelpWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHomePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadURLString: (NSString *) urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

-(void) loadHomePage{
    [self loadURLString:@"http://en.wikipedia.org/wiki/Tic-tac-toe"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

@end
