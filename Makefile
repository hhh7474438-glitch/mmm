# تحديد الأجهزة المستهدفة (المعمارية arm64 للأجهزة الحديثة)
ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

# إعدادات البناء النهائي (تعطيل وضع التصحيح لتقليل حجم الملف)
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

# اسم المشروع (يجب أن يتطابق مع ما في ملف main.yml)
TWEAK_NAME = Follwerk

# الملفات البرمجية المطلوب تجميعها
Follwerk_FILES = Tweak.x

# إضافة "أعلام" للمترجم لتجنب توقف البناء بسبب التحذيرات (Warnings)
Follwerk_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
