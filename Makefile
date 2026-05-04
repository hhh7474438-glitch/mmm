# تحديد المعماريات المطلوبة لأجهزة آيفون وآيباد الحديثة
ARCHS = arm64 arm64e
# تحديد أقل إصدار نظام مدعوم
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HusseinSaadLogo

# ملفات الكود المصدرية
HusseinSaadLogo_FILES = Tweak.x
# المكتبات المطلوبة للواجهة
HusseinSaadLogo_FRAMEWORKS = UIKit
# إضافة خيارات لتجاهل التحذيرات (Warnings) التي تعطل البناء
HusseinSaadLogo_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
