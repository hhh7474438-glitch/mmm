ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HusseinMemoryHack

HusseinMemoryHack_FILES = Tweak.x
HusseinMemoryHack_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
# إضافة Frameworks النظام الضرورية
HusseinMemoryHack_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
