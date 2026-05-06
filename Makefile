# استهداف المعماريات الحديثة
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HussainTweak
HussainTweak_FILES = Tweak.x
HussainTweak_CFLAGS = -fobjc-arc
HussainTweak_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
