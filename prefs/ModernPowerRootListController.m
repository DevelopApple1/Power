#include "ModernPowerRootListController.h"
#define UIColorFromRGB(rgbValue) \
	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
	 green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
	 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
	 alpha:1.0];

@implementation ModernPowerRootListController

@synthesize respringButton;

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		appearanceSettings.tintColor = UIColorFromRGB(0xf75454);
		appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
		self.hb_appearanceSettings = appearanceSettings;
		self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring"
		                       style:UIBarButtonItemStylePlain
		                       target:self
		                       action:@selector(respring)];
		self.respringButton.tintColor = UIColorFromRGB(0xf75454);
		self.navigationItem.rightBarButtonItem = self.respringButton;
	}

	return self;
}

-(void)viewDidLoad {
	if(![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.conorthedev.modernpower.list"]) {
		UIAlertController *alertController = [UIAlertController
	        alertControllerWithTitle:@"ModernPower was pirated!"
	        message:@"The build of ModernPower you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: ModernPower is free. Uninstall this build and install the proper version of ModernPower from:\nhttps://repo.conorthedev.com"
	        preferredStyle:UIAlertControllerStyleAlert
	    ];

		[alertController addAction:[UIAlertAction actionWithTitle:@"OK!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"cydia://url/https://cydia.saurik.com/api/share#?source=https://repo.conorthedev.com"]];
		}]];

		[self presentViewController:alertController animated:YES completion:NULL];
	} else {
		[super viewDidLoad];
	}
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	return _specifiers;
}

- (void)respring {
	NSTask *t = [[[NSTask alloc] init] autorelease];
	[t setLaunchPath:@"/usr/bin/killall"];
	[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
	[t launch];
}

- (void)share {
	UIAlertController *alertController = [UIAlertController
	    alertControllerWithTitle:@"ModernPower"
	    message:[NSString stringWithFormat:@"Enter Theme Name"]
	    preferredStyle:UIAlertControllerStyleAlert
	];

	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	}]];

	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Theme Name";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];

	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		NSArray * textfields = alertController.textFields;
        UITextField * themeField = textfields[0];

		[themeField setText:[themeField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];

		if([themeField.text isEqual: @""]) {
			UIAlertController *alertController = [UIAlertController
	   			alertControllerWithTitle:@"ModernPower"
	    		message:@"Theme name can't be blank!"
	    		preferredStyle:UIAlertControllerStyleAlert
			];

			[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			}]];

			[self presentViewController:alertController animated:YES completion:NULL];		
		} else {
			NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.conorthedev.modernpowerprefs.plist"];

			NSString *tintColor = [settings objectForKey:@"kTintColor"] ? [[settings objectForKey:@"kTintColor"] stringValue] : @"#007AFF";
			NSString *bgColor = [settings objectForKey:@"kBackgroundColor"] ? [[settings objectForKey:@"kBackgroundColor"] stringValue] : @"#FFFFFF";

			NSData *nsdata = [[NSString stringWithFormat:@"{\"themeName\": \"%@\", \"settings\": {\"tintColor\": \"%@\", \"backgroundColor\": \"%@\" }}", themeField.text, tintColor, bgColor] 	dataUsingEncoding:NSUTF8StringEncoding];
			NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];

			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://themes.conorthedev.com/publish/modernpower/%@", base64Encoded]];
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    		[request setURL:url];
    		[request setHTTPMethod:@"POST"];

    		NSURLSession *session = [NSURLSession sharedSession];
    		NSURLSessionDataTask *task = [session dataTaskWithRequest:request
    			completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        	        if (data == nil) {
						UIAlertController *alertController = [UIAlertController
	   						alertControllerWithTitle:@"ModernPower"
	    					message:@"Error whilst uploading"
	    					preferredStyle:UIAlertControllerStyleAlert
						];

						[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];

						[self presentViewController:alertController animated:YES completion:NULL];				
         	       } else {
						if([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqual: @"Uploaded!"]) {
         	           		
							UIAlertController *alertController = [UIAlertController
	   							alertControllerWithTitle:@"ModernPower"
	    						message: [NSString stringWithFormat:@"Uploaded!\nLink: https://themes.conorthedev.com/theme/modernpower/%@", themeField.text]
	    						preferredStyle:UIAlertControllerStyleAlert
							];

							[alertController addAction:[UIAlertAction actionWithTitle:@"Copy Link to Clipboard" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
								UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
								pasteboard.string = [NSString stringWithFormat:@"https://themes.conorthedev.com/theme/modernpower/%@", themeField.text];
							}]];

							[self presentViewController:alertController animated:YES completion:NULL];
						}	
        	        }
        	    }];
    		[task resume];
		}

	}]];

	[self presentViewController:alertController animated:YES completion:NULL];
}

- (void)import {
	UIAlertController *alertController = [UIAlertController
	    alertControllerWithTitle:@"ModernPower"
	    message:[NSString stringWithFormat:@"Enter Theme Link"]
	    preferredStyle:UIAlertControllerStyleAlert
	];

	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	}]];

	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Theme Link";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];

	[alertController addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		NSArray * textfields = alertController.textFields;
        UITextField * urlfield = textfields[0];

		if([urlfield.text isEqual: @""]) {
			UIAlertController *alertController = [UIAlertController
	   			alertControllerWithTitle:@"ModernPower"
	    		message:@"Theme link can't be blank!"
	    		preferredStyle:UIAlertControllerStyleAlert
			];

			[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			}]];

			[self presentViewController:alertController animated:YES completion:NULL];	
			return;
		}

		int length = [urlfield.text length];
		if(length < 48 && ![[urlfield.text substringToIndex:48] isEqualToString:@"https://themes.conorthedev.com/theme/modernpower/"]) {
    		UIAlertController *alertController = [UIAlertController
	   			alertControllerWithTitle:@"ModernPower"
	    		message:@"Invalid theme URL"
	    		preferredStyle:UIAlertControllerStyleAlert
			];

			[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			}]];

			[self presentViewController:alertController animated:YES completion:NULL];	
			return;	
		}

		NSURL *url = [NSURL URLWithString: urlfield.text];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    	[request setURL:url];
    	[request setHTTPMethod:@"GET"];

    	NSURLSession *session = [NSURLSession sharedSession];
    	NSURLSessionDataTask *task = [session dataTaskWithRequest:request
    		completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        	    if (data == nil) {
					UIAlertController *alertController = [UIAlertController
	   					alertControllerWithTitle:@"ModernPower"
	    				message:@"Error whilst getting theme"
	    				preferredStyle:UIAlertControllerStyleAlert
					];

					[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];

					[self presentViewController:alertController animated:YES completion:NULL];				
         	    } else {
					NSString* returnedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
					if(![returnedData isEqual: @"40!"]) {
         	           		
						/*UIAlertController *alertController = [UIAlertController
	   						alertControllerWithTitle:@"ModernPower"
	    					message: [NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]
	    					preferredStyle:UIAlertControllerStyleAlert
						];

						[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];

						[self presentViewController:alertController animated:YES completion:NULL];*/

						if(NSClassFromString(@"NSJSONSerialization"))	 {	
    						NSError *error = nil;
    						id object = [NSJSONSerialization
                     			JSONObjectWithData:data
                      			options:0
                      			error:&error
							];

    						if(error) {
								UIAlertController *alertController = [UIAlertController
	   								alertControllerWithTitle:@"ModernPower"
	    							message: [NSString stringWithFormat:@"Error whilst parsing JSON\nContact ConorTheDev on Twitter with the theme URL"]
	    							preferredStyle:UIAlertControllerStyleAlert
								];

								[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];

								[self presentViewController:alertController animated:YES completion:NULL];
							}
    						if([object isKindOfClass:[NSDictionary class]]) {
								NSDictionary *results = object;
								NSObject *tintColor = results[@"settings"][@"tintColor"];
								NSObject *backgroundColor = results[@"settings"][@"backgroundColor"];
								UIAlertController *alertController = [UIAlertController
	   								alertControllerWithTitle:@"ModernPower"
	    							message: [NSString stringWithFormat:@"Do you want to apply theme: %@?\nValues:\ntintColor:%@\nbackgroundColor:%@", results[@"themeName"], tintColor, backgroundColor]
	    							preferredStyle:UIAlertControllerStyleAlert
								];

								[alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
								}]];

								[alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
									HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.conorthedev.modernpowerprefs"];
									[preferences setObject:tintColor forKey:@"kTintColor"];
									[preferences setObject:backgroundColor forKey:@"kBackgroundColor"];

									UIAlertController *alertController = [UIAlertController
	   									alertControllerWithTitle:@"ModernPower"
	    								message: @"Applied! - Respring to apply!"
	    								preferredStyle:UIAlertControllerStyleAlert
									];

									[alertController addAction:[UIAlertAction actionWithTitle:@"Respring Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
										[self respring];
									}]];

									[self presentViewController:alertController animated:YES completion:NULL];
								}]];

								[self presentViewController:alertController animated:YES completion:NULL];
   							} else {
								// Error
							}
						} else {
								UIAlertController *alertController = [UIAlertController
	   								alertControllerWithTitle:@"ModernPower"
	    							message: [NSString stringWithFormat:@"Error whilst importing\nContact ConorTheDev on Twitter with the theme URL"]
	    							preferredStyle:UIAlertControllerStyleAlert
								];

								[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];

								[self presentViewController:alertController animated:YES completion:NULL];
						}
					}
        	    }
        	}];
    		
			[task resume];
	}]];

	[self presentViewController:alertController animated:YES completion:NULL];
}

@end

@implementation ModernPowerCreditsController

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		appearanceSettings.tintColor = UIColorFromRGB(0xf75454);
		appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
		self.hb_appearanceSettings = appearanceSettings;
	}

	return self;
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Credits" target:self] retain];
	}
	return _specifiers;
}

@end

@implementation ModernPowerDefSettingsController

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		appearanceSettings.tintColor = UIColorFromRGB(0xf75454);
		appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
		self.hb_appearanceSettings = appearanceSettings;
	}

	return self;
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"DefaultSettings" target:self] retain];
	}
	return _specifiers;
}

@end

@implementation ModernPowerModernSettingsController

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		appearanceSettings.tintColor = UIColorFromRGB(0xf75454);
		appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
		self.hb_appearanceSettings = appearanceSettings;
	}

	return self;
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ModernSettings" target:self] retain];
	}
	return _specifiers;
}

@end

@implementation ModernPowerCustomSettingsController

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		appearanceSettings.tintColor = UIColorFromRGB(0xf75454);
		appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
		self.hb_appearanceSettings = appearanceSettings;
	}

	return self;
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"CustomSettings" target:self] retain];
	}
	return _specifiers;
}

@end
