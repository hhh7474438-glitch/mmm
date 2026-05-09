ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Telegram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HusseinTelegram
HusseinTelegram_FILES = Tweak.x
HusseinTelegram_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
