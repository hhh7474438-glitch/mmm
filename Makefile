DEBUG = 0
FINAL_PACKAGE = 1

# استهداف أجهزة الآيفون الحديثة
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SecurityHussein
SecurityHussein_FILES = Tweak.x
SecurityHussein_CFLAGS = -fobjc-arc
SecurityHussein_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
