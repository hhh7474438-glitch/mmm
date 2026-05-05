TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = jokdinstagram

jokdinstagram_FILES = Tweak.x
jokdinstagram_CFLAGS = -fobjc-arc
jokdinstagram_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS)/makefiles/tweak.mk
