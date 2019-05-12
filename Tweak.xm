#import "ModernPower.h"

/*
	Preference Variables
*/

// Is the tweak is installed from another repo that isn't repo.conorthedev.com?
BOOL dpkgInvalid = false;
// Is the tweak enabled?
BOOL enabled = true;
// Custom background colour
UIColor* backgroundColor;
// Custom tint colour
UIColor* tintColor;
// What style the user chose (Default (0), Modern (1), Custom (2))
int style;
// What blur style the user chose (Extra Light (0), Light (1), Dark (2))
int blurStyle;
// What theme the user chose (Systemless' Theme (0), Pixel Blue (1), Pixel Green (2))
int defaultTheme;
// Should we override the tint (if blurred)
BOOL overrideTint = false;

%group main
%hook SBPowerDownController

-(void)viewDidLoad {
	%orig;
	// Render the "main view"
	[self renderMain];
	
	/*
		Animate in
	*/
	CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

	rect.origin.x = rect.origin.x - 300;

	[UIView animateWithDuration:0.3
	 delay:0.0
	 options:UIViewAnimationCurveEaseIn
	 animations:^{
	  self.view.frame = rect;
	 }
	 completion: nil];
}

/*
	Advanced view
*/
%new -(void)renderAdvanced {
	UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
	// Add tap recognizer outside the mask layer we create later
	UITapGestureRecognizer *singleFingerTap = 
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
	[myView addGestureRecognizer:singleFingerTap];

	// Create a mask layer and the frame to determine what will be visible in the view.
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	
	CGRect maskRect = CGRectMake(self.view.frame.size.width - 110, self.view.frame.size.height / 2 - 200, 200, 600);
	
	// Create a path with the rectangle in it.
	CGPathRef path = CGPathCreateWithRoundedRect(maskRect, 15, 15, NULL);

	// Set the path to the mask layer.
	maskLayer.path = path;

	// Release the path since it's not covered by ARC.
	CGPathRelease(path);

	// Set the mask of the view.
	myView.layer.mask = maskLayer;

	// Set the blur style if the user selected 'Modern'
	if(style == 1) {
		self.view.backgroundColor = [UIColor clearColor];

		UIBlurEffect *blurEffect = nil;
		
		if(blurStyle == 0) {
  		blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
		} else if (blurStyle == 1) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		} else if (blurStyle == 2) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		}
		
  	UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

  	blurEffectView.frame = myView.bounds;
  	blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  	[myView addSubview:blurEffectView];
	}

	NSBundle* bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/ModernPowerPrefs.bundle"];
	NSString* respring = [bundle pathForResource:@"respring" ofType:@"png"];
	NSString* back = [bundle pathForResource:@"back" ofType:@"png"];

	/*
	        Respring Button
	 */
	UIButton *respringButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	respringButton.frame = CGRectMake(self.view.frame.size.width - 110, self.view.frame.size.height / 2 - 180, 100, 50);
	[respringButton setImage:[UIImage imageWithContentsOfFile: respring] forState:UIControlStateNormal];
	[respringButton addTarget:self action:@selector(respring) forControlEvents:UIControlEventTouchUpInside];
	if(style == 1 && !overrideTint) {			
		// Set the tint colour depending on what the user has chose for the blur style
		if(blurStyle == 0) {
  		respringButton.tintColor = [UIColor blackColor];
		} else if (blurStyle == 1) {
			respringButton.tintColor = [UIColor blackColor];
		} else if (blurStyle == 2) {
			respringButton.tintColor = [UIColor whiteColor];
		}
	} else if(style != 0) {
		respringButton.tintColor = tintColor;
	} else {
		if(defaultTheme == 0) {
  		respringButton.tintColor = LCPParseColorString(@"#6a009c", @"#6a009c");
		} else if (defaultTheme == 1) {
			respringButton.tintColor = LCPParseColorString(@"#1a73e8", @"#1a73e8");
		} else if (defaultTheme == 2) {
			respringButton.tintColor = LCPParseColorString(@"#1ed760", @"#1ed760");
		} else if (defaultTheme == 3) {
			respringButton.tintColor = LCPParseColorString(@"#007AFF", @"#007AFF");
		}
	}
	[respringButton centerVertically];
	[myView addSubview:respringButton];



	/*
	   Back Button
	 */
	UIButton *backButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	backButton.frame = CGRectMake(self.view.frame.size.width - 110, self.view.frame.size.height / 2 + 30, 100, 50);
	[backButton setImage:[UIImage imageWithContentsOfFile: back] forState:UIControlStateNormal];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(renderMain) forControlEvents:UIControlEventTouchUpInside];
	if(style == 1 && !overrideTint) {			
		if(blurStyle == 0) {
  		backButton.tintColor = [UIColor blackColor];
		} else if (blurStyle == 1) {
			backButton.tintColor = [UIColor blackColor];
		} else if (blurStyle == 2) {
			backButton.tintColor = [UIColor whiteColor];
		}
	} else if(style != 0) {
		backButton.tintColor = tintColor;
	} else {
		if(defaultTheme == 0) {
  		backButton.tintColor = LCPParseColorString(@"#6a009c", @"#6a009c");
		} else if (defaultTheme == 1) {
			backButton.tintColor = LCPParseColorString(@"#1a73e8", @"#1a73e8");
		} else if (defaultTheme == 2) {
			backButton.tintColor = LCPParseColorString(@"#1ed760", @"#1ed760");
		} else if (defaultTheme == 3) {
			backButton.tintColor = LCPParseColorString(@"#007AFF", @"#007AFF");
		}
	}
	[backButton centerVertically];
	[myView addSubview:backButton];

	self.view = myView;
	if(style == 2) {
		[self.view setBackgroundColor:backgroundColor];
	} else if (style == 0) {
		UIColor *pixelBg = LCPParseColorString(@"#202026", @"#202026");
		if(defaultTheme == 0) {
			[self.view setBackgroundColor:[UIColor blackColor]];
		} else if(defaultTheme == 1 || defaultTheme == 2){
			[self.view setBackgroundColor:pixelBg];
		} else {
			[self.view setBackgroundColor: [UIColor whiteColor]];
		}
	}
}

/*
	Main View
*/
%new -(void)renderMain {
	UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 550, self.view.frame.size.width, self.view.frame.size.height)];
	// Add tap recognizer outside the mask layer we create later
	UITapGestureRecognizer *singleFingerTap = 
  [[UITapGestureRecognizer alloc] initWithTarget:self 
                                          action:@selector(close)];
	[myView addGestureRecognizer:singleFingerTap];

	// Create a mask layer and the frame to determine what will be visible in the view.
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	CGRect maskRect = CGRectMake(self.view.frame.size.width - 405, self.view.frame.size.height / 2 - 360, 600, 80);
	// Create a path with the rectangle in it.
	CGPathRef path = CGPathCreateWithRoundedRect(maskRect, 15, 15, NULL);

	// Set the path to the mask layer.
	maskLayer.path = path;

	// Release the path since it's not covered by ARC.
	CGPathRelease(path);

	// Set the mask of the view.
	myView.layer.mask = maskLayer;

	if(style == 1) {
		self.view.backgroundColor = [UIColor clearColor];
	
		UIBlurEffect *blurEffect = nil;
		
		if(blurStyle == 0) {
  		blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
		} else if (blurStyle == 1) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		} else if (blurStyle == 2) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		}

  	UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

  	blurEffectView.frame = myView.bounds;
  	blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  	[myView addSubview:blurEffectView];
	}

	NSBundle* bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/ModernPowerPrefs.bundle"];
	NSString* power = [bundle pathForResource:@"power" ofType:@"png"];
	NSString* reboot = [bundle pathForResource:@"reboot" ofType:@"png"];
NSString* respring = [bundle pathForResource:@"respring" ofType:@"png"];
NSString* safemode = [bundle pathForResource:@"safemode" ofType:@"png"];
NSString* close = [bundle pathForResource:@"close" ofType:@"png"];




	/*
	        Reboot Button
	 */
	UIButton *rebootButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	rebootButton.frame = CGRectMake(self.view.frame.size.width - 180, self.view.frame.size.height / 2 - 350, 60, 60);
	[rebootButton setImage:[UIImage imageWithContentsOfFile: reboot] forState:UIControlStateNormal];
	[rebootButton setTitle:@"Reboot" forState:UIControlStateNormal];
	[rebootButton addTarget:self action:@selector(reboot) forControlEvents:UIControlEventTouchUpInside];
	if(style == 1 && !overrideTint) {			
		if(blurStyle == 0) {
  		rebootButton.tintColor = [UIColor blackColor];
		} else if (blurStyle == 1) {
			rebootButton.tintColor = [UIColor blackColor];
		} else if (blurStyle == 2) {
			rebootButton.tintColor = [UIColor whiteColor];
		}
	} else if(style != 0) {
		rebootButton.tintColor = tintColor;
	} else {
		if(defaultTheme == 0) {

  		rebootButton.tintColor = LCPParseColorString(@"#6a009c", @"#6a009c");
		} else if (defaultTheme == 1) {
			rebootButton.tintColor = LCPParseColorString(@"#1a73e8", @"#1a73e8");
		} else if (defaultTheme == 2) {
			rebootButton.tintColor = LCPParseColorString(@"#1ed760", @"#1ed760");
		} else if (defaultTheme == 3) {
			rebootButton.tintColor = LCPParseColorString(@"#007AFF", @"#007AFF");
		}
	}

	[rebootButton centerVertically];
	[myView addSubview:rebootButton];

	// 70 y between each button 

	/*
	   Power Off Button
	 */
	UIButton *powerButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	powerButton.frame = CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height / 2 - 350, 60, 60);
	[powerButton setImage:[UIImage imageWithContentsOfFile: power] forState:UIControlStateNormal];
    [powerButton setTitle:@"PowerOFF" forState:UIControlStateNormal];
	[powerButton addTarget:self action:@selector(powerDown) forControlEvents:UIControlEventTouchUpInside];
	if(style == 1 && !overrideTint) {			
		if(blurStyle == 0) {
  		powerButton.tintColor = [UIColor blackColor];
		} else if (blurStyle == 1) {
			powerButton.tintColor = [UIColor blackColor];
		} else if (blurStyle == 2) {
			powerButton.tintColor = [UIColor whiteColor];
		}
	} else if(style != 0) {
		powerButton.tintColor = tintColor;
	} else {
		if(defaultTheme == 0) {
  		powerButton.tintColor = LCPParseColorString(@"#1a73e8", @"#007AFF");
		} else if (defaultTheme == 1) {
			powerButton.tintColor = LCPParseColorString(@"#1a73e8", @"#1a73e8");
		} else if (defaultTheme == 2) {
			powerButton.tintColor = LCPParseColorString(@"#1ed760", @"#1ed760");
		} else if (defaultTheme == 3) {
			rebootButton.tintColor = LCPParseColorString(@"#007AFF", @"#007AFF");
		}
	}
	[powerButton centerVertically];
	[myView addSubview:powerButton];



/*
Respring Button
*/
UIButton *respringButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
respringButton.frame = CGRectMake(self.view.frame.size.width - 260, self.view.frame.size.height / 2 - 350, 60, 60);
[respringButton setImage:[UIImage imageWithContentsOfFile: respring] forState:UIControlStateNormal];
 [respringButton setTitle:@"Respring" forState:UIControlStateNormal];
[respringButton addTarget:self action:@selector(respring) forControlEvents:UIControlEventTouchUpInside];
if(style == 1 && !overrideTint) {
// Set the tint colour depending on what the user has chose for the blur style
if(blurStyle == 0) {
respringButton.tintColor = [UIColor blackColor];
} else if (blurStyle == 1) {
respringButton.tintColor = [UIColor blackColor];
} else if (blurStyle == 2) {
respringButton.tintColor = [UIColor whiteColor];
}
} else if(style != 0) {
respringButton.tintColor = tintColor;
} else {
if(defaultTheme == 0) {
respringButton.tintColor = LCPParseColorString(@"#6a009c", @"#6a009c");
} else if (defaultTheme == 1) {
respringButton.tintColor = LCPParseColorString(@"#1a73e8", @"#1a73e8");
} else if (defaultTheme == 2) {
respringButton.tintColor = LCPParseColorString(@"#1ed760", @"#1ed760");
} else if (defaultTheme == 3) {
respringButton.tintColor = LCPParseColorString(@"#007AFF", @"#007AFF");
}
}
[respringButton centerVertically];
[myView addSubview:respringButton];

/*
Safe Mode Button
*/
UIButton *safeModeButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
safeModeButton.frame = CGRectMake(self.view.frame.size.width - 345, self.view.frame.size.height / 2 - 350, 60, 60);
[safeModeButton setImage:[UIImage imageWithContentsOfFile: safemode] forState:UIControlStateNormal];
[safeModeButton setTitle:@"SafeMode" forState:UIControlStateNormal];
[safeModeButton addTarget:self action:@selector(safemode) forControlEvents:UIControlEventTouchUpInside];
if(style == 1 && !overrideTint) {
if(blurStyle == 0) {
safeModeButton.tintColor = [UIColor blackColor];
} else if (blurStyle == 1) {
safeModeButton.tintColor = [UIColor blackColor];
} else if (blurStyle == 2) {
safeModeButton.tintColor = [UIColor whiteColor];
}
} else if(style != 0) {
safeModeButton.tintColor = tintColor;
} else {
if(defaultTheme == 0) {
safeModeButton.tintColor = LCPParseColorString(@"#6a009c", @"#6a009c");
} else if (defaultTheme == 1) {
safeModeButton.tintColor = LCPParseColorString(@"#1a73e8", @"#1a73e8");
} else if (defaultTheme == 2) {
safeModeButton.tintColor = LCPParseColorString(@"#1ed760", @"#1ed760");
} else if (defaultTheme == 3) {
safeModeButton.tintColor = LCPParseColorString(@"#007AFF", @"#007AFF");
}
}
[safeModeButton centerVertically];
[myView addSubview:safeModeButton];


/*
Close Button
*/
UIButton *closeButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
closeButton.frame = CGRectMake(self.view.frame.size.width - 420, self.view.frame.size.height / 2 - 350, 60, 60);
[closeButton setImage:[UIImage imageWithContentsOfFile: close] forState:UIControlStateNormal];
[closeButton setTitle:@"Close" forState:UIControlStateNormal];
[closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
if(style == 1 && !overrideTint) {
if(blurStyle == 0) {
closeButton.tintColor = [UIColor blackColor];
} else if (blurStyle == 1) {
closeButton.tintColor = [UIColor blackColor];
} else if (blurStyle == 2) {
closeButton.tintColor = [UIColor whiteColor];
}
} else if(style != 0) {
closeButton.tintColor = tintColor;
} else {
if(defaultTheme == 0) {
closeButton.tintColor = LCPParseColorString(@"#6a009c", @"#6a009c");
} else if (defaultTheme == 1) {
closeButton.tintColor = LCPParseColorString(@"#1a73e8", @"#1a73e8");
} else if (defaultTheme == 2) {
closeButton.tintColor = LCPParseColorString(@"#1ed760", @"#1ed760");
} else if (defaultTheme == 3) {
rebootButton.tintColor = LCPParseColorString(@"#007AFF", @"#007AFF");
}
}
[closeButton centerVertically];
[myView addSubview:closeButton];


	self.view = myView;

	if(style == 2) {
		[self.view setBackgroundColor:backgroundColor];
	} else if (style == 0) {
		UIColor *pixelBg = LCPParseColorString(@"#202026", @"#202026");
		if(defaultTheme == 0) {
			[self.view setBackgroundColor:[UIColor blackColor]];
		} else if(defaultTheme == 1 || defaultTheme == 2) {
			[self.view setBackgroundColor:pixelBg];
		} else {
			[self.view setBackgroundColor: [UIColor whiteColor]];
		}
	}
}

/*
	Animate out
*/
%new -(void)close {
	[UIView animateWithDuration:0.5
	 delay:0.0
	 options:UIViewAnimationCurveEaseIn
	 animations:^{
	  [self.view setFrame:CGRectOffset([self.view frame], +self.view.frame.size.width, 0)];
	 }
	 completion:^ (BOOL finished) {
	  if (finished) {
			// Exit VC when finished so the user isn't locked in until it auto-dismisses.
	   	[self cancel];
		}
	}];
}

// Respring the device by killing backboardd
%new -(void)respring {
	NSTask *t = [[[NSTask alloc] init] autorelease];
	[t setLaunchPath:@"/usr/bin/killall"];
	[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
	[t launch];
} 

// Tell FBSystemService to reboot since we cant w/o root privledges.
%new -(void)reboot {
	[[objc_getClass("FBSystemService") sharedInstance] shutdownAndReboot:1];
}

%end
%end


// Load preferences using HBPreferences, I could use NSUserDefaults but HBPreferences is fine for now.
static void loadPrefs() {
	NSString *kBackgroundColor = @"";
	NSString *kTintColor = @"";

	HBPreferences *colorPrefs = [[HBPreferences alloc] initWithIdentifier:@"com.conorthedev.modernpowerprefs-colors"];
	[colorPrefs registerDefaults:@{
      @"kBackgroundColor": @"#FFFFFF",
			@"kTintColor": @"#007AFF"
  }];

	HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.conorthedev.modernpowerprefs"];
	[preferences registerDefaults:@{
      @"kEnabled": @YES,
      @"kUIStyle": @0,
      @"kModernBlurStyle": @0,
			@"kOverrideTint": @NO,
			@"kDefaultTheme": @3,
			@"kViewPosition": @1
  }];
	
	enabled = [preferences boolForKey:@"kEnabled"];
	kBackgroundColor = [colorPrefs objectForKey:@"kBackgroundColor"];
	kTintColor = [colorPrefs objectForKey:@"kTintColor"];
	style = [preferences integerForKey:@"kUIStyle"];
	blurStyle = [preferences integerForKey:@"kModernBlurStyle"];
	overrideTint = [preferences boolForKey:@"kOverrideTint"];
	defaultTheme = [preferences integerForKey:@"kDefaultTheme"];
	
	// Set the tint and background colour to a UIColor
	tintColor = LCPParseColorString(kTintColor, kTintColor);
	backgroundColor = LCPParseColorString(kBackgroundColor, kBackgroundColor);
}

/*
	Code provided by NepetaDev - Thanks Nep!
*/
%group IntegrityFail
%hook SpringBoard

-(void)applicationDidFinishLaunching: (id)arg1 {
	// Run what SpringBoard needed to do... or else there could be... bad things...
	%orig;
	// If the dpkg isnt invalid, return.
	if (!dpkgInvalid) return;
	// Create alert
	UIAlertController *alertController = [UIAlertController
	  alertControllerWithTitle:@"ModernPower was pirated!"
	  message:@"The build of ModernPower you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: ModernPower is free. Uninstall this build and install the proper version of ModernPower from:\nhttps://repo.conorthedev.com"
	  preferredStyle:UIAlertControllerStyleAlert
	];

	[alertController addAction:[UIAlertAction actionWithTitle:@"OK!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			//[self dismissViewControllerAnimated:YES completion:NULL];
	}]];

	[((UIApplication*)self).keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
}

%end
%end

%ctor {
	/*
		Most pirate repositories change the bundle identifier when publishing a tweak, check if *my* bundle id exists, if not, set dpkgInvalid to true.
	  I know this is easily bypassable, since this is Open Source they could just change it to their bundleID or remove it all together
		It's only a basic thing.
	*/
	dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.conorthedev.modernpower.list"];
	
	/* 
		Load preferences
		Credit to the post below for the check, we don't want HBPreferences going mental.
  	https://www.reddit.com/r/jailbreak/comments/4yz5v5/questionremote_messages_not_enabling/d6rlh88/
	*/
  bool shouldLoad = NO;
  NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
  NSUInteger count = args.count;
	if (count != 0) {
    NSString *executablePath = args[0];

  	if (executablePath) {
    	NSString *processName = [executablePath lastPathComponent];
    	BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
    	BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
    	BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
    	BOOL skip = [processName isEqualToString:@"AdSheet"]
    	  || [processName isEqualToString:@"CoreAuthUI"]
    	  || [processName isEqualToString:@"InCallService"]
    	  || [processName isEqualToString:@"MessagesNotificationViewService"]
    	  || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
    	if (!isFileProvider && (isSpringBoard || isApplication) && !skip) {
      	shouldLoad = YES;
    	}
  	}
	}

	// If we're not SpringBoard or an unsandboxed application, there's an issue.
	if (!shouldLoad) {
		return;
	} else {
		loadPrefs();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.conorthedev.modernpowerprefs/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}

	// If the dpkg is invalid, the tweak was pirated.
	if (dpkgInvalid) {
		// Display alert and don't start the tweak.
		%init(IntegrityFail);
		return;
	} else {
		if(enabled) {
			// Start the tweak! :D
			%init(main);
		}
	}
}
