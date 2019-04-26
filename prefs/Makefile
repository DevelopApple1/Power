include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ModernPowerPrefs
ModernPowerPrefs_FILES = *.m
ModernPowerPrefs_INSTALL_PATH = /Library/PreferenceBundles
ModernPowerPrefs_FRAMEWORKS = UIKit
ModernPowerPrefs_LIBRARIES = colorpicker
ModernPowerPrefs_PRIVATE_FRAMEWORKS = Preferences
ModernPowerPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ModernPowerPrefs.plist$(ECHO_END)
