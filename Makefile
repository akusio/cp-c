ARCHS = arm64
export THEOS=/opt/theos/

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FGO_Bypass_64bit
FGO_Bypass_64bit_FILES = Tweak.xm
FGO_Bypass_64bit_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
