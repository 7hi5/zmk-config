BOARD ?= xiao_ble
SHIELD_LEFT ?= totem_left
SHIELD_RIGHT ?= totem_right
ZMK_CONFIG_PATH ?= $(shell pwd)
FLASH_DRIVE_PATH ?= /run/media/$(USER)/XIAO-SENSE
ZEPHYR_BASE ?= $(shell pwd)/zephyr

.PHONY: all clean install-left install-right $(SHIELD_LEFT) $(SHIELD_RIGHT)

all: $(SHIELD_LEFT) $(SHIELD_RIGHT)

$(SHIELD_LEFT): build/$(SHIELD_LEFT)/zephyr/zmk.uf2
$(SHIELD_RIGHT): build/$(SHIELD_RIGHT)/zephyr/zmk.uf2

build/$(SHIELD_LEFT)/zephyr/zmk.uf2:
	export ZEPHYR_BASE=$(ZEPHYR_BASE) && west build -s zmk/app -b $(BOARD) -d build/$(SHIELD_LEFT) -- -DSHIELD=$(SHIELD_LEFT) -DZMK_CONFIG=$(ZMK_CONFIG_PATH) -DZEPHYR_BASE=$(ZEPHYR_BASE) -DZephyr_DIR=$(ZEPHYR_BASE)/share/zephyr-package/cmake

build/$(SHIELD_RIGHT)/zephyr/zmk.uf2:
	export ZEPHYR_BASE=$(ZEPHYR_BASE) && west build -s zmk/app -b $(BOARD) -d build/$(SHIELD_RIGHT) -- -DSHIELD=$(SHIELD_RIGHT) -DZMK_CONFIG=$(ZMK_CONFIG_PATH) -DZEPHYR_BASE=$(ZEPHYR_BASE) -DZephyr_DIR=$(ZEPHYR_BASE)/share/zephyr-package/cmake

install-left: build/$(SHIELD_LEFT)/zephyr/zmk.uf2
	cp $< $(FLASH_DRIVE_PATH)/

install-right: build/$(SHIELD_RIGHT)/zephyr/zmk.uf2
	cp $< $(FLASH_DRIVE_PATH)/

clean:
	rm -rf build
