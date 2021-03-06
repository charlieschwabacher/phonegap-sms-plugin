// phonegap-sms-plugin https://github.com/aharris88/phonegap-sms-plugin
//  from SMS Composer plugin for PhoneGap- SMSComposer.m Created by Grant Sanders on 12/25/2010.
//  https://github.com/phonegap/phonegap-plugins/blob/master/iOS/SMSComposer

// Revised by Adam Harris https://github.com/aharris88
// Revised by Clément Vollet https://github.com/dieppe
// Quick Revision by Johnny Slagle 10/15/2013

#import "Sms.h"
#import <Cordova/NSArray+Comparisons.h>

@implementation Sms

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView {
	self = (Sms *)[super initWithWebView:theWebView];
	return self;
}

- (void)send:(CDVInvokedUrlCommand*)command {
	
	[self.commandDelegate runInBackground:^{
		if(![MFMessageComposeViewController canSendText]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
									message:@"SMS Text not available."
								       delegate:self
							      cancelButtonTitle:@"OK"
							      otherButtonTitles:nil];
			[alert show];
			return;
		}
	
		MFMessageComposeViewController *composeViewController = [[MFMessageComposeViewController alloc] init];
		composeViewController.messageComposeDelegate = self;
	
		NSString* body = [command.arguments objectAtIndex:1];
		if (body != nil) {
			[composeViewController setBody:body];
		}
	
		NSArray* recipients = [command.arguments objectAtIndex:0];
		if (recipients != nil) {
			[composeViewController setRecipients:recipients];
		}
		
		self._callbackId = command.callbackId;
	
		[self.viewController presentViewController:composeViewController animated:YES completion:nil];
	}];
}

#pragma mark - MFMessageComposeViewControllerDelegate Implementation
// Dismisses the composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
	CDVPluginResult* pluginResult = nil;
	int webviewResult = 0;

	switch (result) {
		case MessageComposeResultCancelled:
			[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"cancelled"];
			webviewResult = 0;
			break;

		case MessageComposeResultSent:
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
			webviewResult = 1;
			break;

		case MessageComposeResultFailed:
			[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"failed"];
			webviewResult = 2;
			break;

		default:
			[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"error"];
			webviewResult = 3;
			break;
	}

	[self.viewController dismissViewControllerAnimated:YES completion:nil];
	// [[UIApplication sharedApplication] setStatusBarHidden:NO];// Note: I put this in because it seemed to be missing.
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:self._callbackId];
}

@end
