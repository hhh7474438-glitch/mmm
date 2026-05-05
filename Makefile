# إعدادات الهدف
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = jokdinstagram

# ملفات السورس
jokdinstagram_FILES = Tweak.x

# إعدادات المترجم: إضافة -w لإيقاف التنبيهات تماماً وتجنب خطأ Werror
jokdinstagram_CFLAGS = -fobjc-arc -w

# المكتبات المطلوبة
jokdinstagram_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore

include $(THEOS)/makefiles/tweak.mk
