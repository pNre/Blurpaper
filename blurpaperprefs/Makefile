TARGET = iphone:clang::7.0

include theos/makefiles/common.mk

export ARCHS = armv7 arm64

BUNDLE_NAME = BlurpaperPrefs
BlurpaperPrefs_FILES = BlurpaperPrefs.mm BlurpaperSettings.mm
BlurpaperPrefs_INSTALL_PATH = /Library/PreferenceBundles
BlurpaperPrefs_FRAMEWORKS = UIKit
BlurpaperPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Blurpaper$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Blurpaper/Blurpaper.plist$(ECHO_END)
