ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.5

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = jokdinstagram
jokdinstagram_FILES = Tweak.x
jokdinstagram_CFLAGS = -fobjc-arc -w
jokdinstagram_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
