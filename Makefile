include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

TWEAK_NAME = ModernPower
ModernPower_FILES = Tweak.xm
ModernPower_LIBRARIES = colorpicker
ModernPower_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
