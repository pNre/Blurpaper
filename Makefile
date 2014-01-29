THEOS_DEVICE_IP = 192.168.1.247

TARGET = iphone:clang::7.0

include theos/makefiles/common.mk

export ARCHS = armv7 armv7s arm64

TWEAK_NAME = Blurpaper
Blurpaper_FILES = Tweak.xm	\
PNBlurController.xm \
PNBackdropView.xm \
PNBackdropViewCustomSettings.xm PNBackdropViewSettingsDefault.xm PNBackdropViewSettingsUltraLight.xm \
PNWallpaperLayer.xm PNLayer.xm \
_UIBackdropView.xm	\
SBFWallpaperView.xm	\
SBWallpaperController.xm \
NSUserDefaults.xm

Blurpaper_FRAMEWORKS = UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"

SUBPROJECTS += blurpaperprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
