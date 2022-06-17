# put your *.o targets here, make should handle the rest!

SRCS = 	core/src/main.c\
		lib/stm32f4xx_it.c\
		core/src/system_stm32f4xx.c\
		core/src/Interrupts.c\
		core/src/time.c\
		core/src/stm32f4_discovery.c\
		core/src/stm32f4_discovery_lis302dl.c\
		core/src/fsdata.c\
		\
		usb-files/src/usb_bsp.c\
		usb-files/src/usbd_usr.c\
		\
		usb-core/dev-driver/src/usbd_req.c\
		usb-core/dev-driver/src/usbd_ioreq.c\
		usb-core/dev-driver/src/usbd_core.c\
		\
		usb-core/otg-driver/src/usb_core.c\
		usb-core/otg-driver/src/usb_dcd.c\
		usb-core/otg-driver/src/usb_dcd_int.c\
		\
		lwip/lwip-1.4.1/src/core/def.c\
		lwip/lwip-1.4.1/src/core/dhcp.c\
		lwip/lwip-1.4.1/src/core/dns.c\
		lwip/lwip-1.4.1/src/core/init.c\
		lwip/lwip-1.4.1/src/core/mem.c\
		lwip/lwip-1.4.1/src/core/memp.c\
		lwip/lwip-1.4.1/src/core/netif.c\
		lwip/lwip-1.4.1/src/core/pbuf.c\
		lwip/lwip-1.4.1/src/core/raw.c\
		lwip/lwip-1.4.1/src/core/stats.c\
		lwip/lwip-1.4.1/src/core/sys.c\
		lwip/lwip-1.4.1/src/core/tcp.c\
		lwip/lwip-1.4.1/src/core/tcp_in.c\
		lwip/lwip-1.4.1/src/core/tcp_out.c\
		lwip/lwip-1.4.1/src/core/timers.c\
		lwip/lwip-1.4.1/src/core/udp.c\
		lwip/lwip-1.4.1/src/core/ipv4/autoip.c\
		lwip/lwip-1.4.1/src/core/ipv4/icmp.c\
		lwip/lwip-1.4.1/src/core/ipv4/igmp.c\
		lwip/lwip-1.4.1/src/core/ipv4/inet.c\
		lwip/lwip-1.4.1/src/core/ipv4/inet_chksum.c\
		lwip/lwip-1.4.1/src/core/ipv4/ip.c\
		lwip/lwip-1.4.1/src/core/ipv4/ip_addr.c\
		lwip/lwip-1.4.1/src/core/ipv4/ip_frag.c\
		lwip/lwip-1.4.1/src/netif/etharp.c\
		lwip/lwip-1.4.1/src/netif/ethernetif.c\
		lwip/lwip-1.4.1/src/netif/slipif.c\
		\
		lwip/rndis-stm32/usbd_rndis_core.c\
		lwip/rndis-stm32/usbd_desc.c\
		\
		lwip/dhcp-server/dhserver.c\
		\
		lwip/dns-server/dnserver.c\
		\
		lwip/lwip-1.4.1/apps/httpserver_raw/fs.c\
		lwip/lwip-1.4.1/apps/httpserver_raw/httpd.c\

# all the files will be generated with this name (main.elf, main.bin, main.hex, etc)

PROJ_NAME=main

# that's it, no need to change anything below this line!

###################################################

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

CFLAGS  = -g -O2 -Wall -Tstm32_flash.ld 
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16

###################################################

CFLAGS += -DUSE_STDPERIPH_DRIVER 
CFLAGS += -DUSE_USB_OTG_FS 
CFLAGS += -DUSE_DEFAULT_TIMEOUT_CALLBACK 
CFLAGS += -DSTM32F40_41xxx
CFLAGS += -DLWIP_HTTPD_STRNSTR_PRIVATE=0

###################################################

ROOT=$(shell pwd)

CFLAGS += -Icore/inc
CFLAGS += -Ilib
CFLAGS += -Ilib/inc 
CFLAGS += -Ilib/core
CFLAGS += -Iusb-core/dev-driver/inc 
CFLAGS += -Iusb-core/otg-driver/inc 
CFLAGS += -Iusb-files/inc
CFLAGS += -Ilwip/lwip-1.4.1/src/include 
CFLAGS += -Ilwip/lwip-1.4.1/src/include/ipv4 
CFLAGS += -Ilwip/rndis-stm32 
CFLAGS += -Ilwip/dhcp-server 
CFLAGS += -Ilwip/dns-server 
CFLAGS += -Ilwip/lwip-1.4.1/apps/httpserver_raw

SRCS += startup_stm32f4xx.s # add startup file to build

OBJS = $(SRCS:.c=.o)

###################################################

.PHONY: lib proj

all: lib proj

lib:
	$(MAKE) -C lib

proj: 	$(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@ --specs=nosys.specs -Llib -lstm32f4
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	$(MAKE) -C lib clean
	rm -f $(PROJ_NAME).elf
	rm -f $(PROJ_NAME).hex
	rm -f $(PROJ_NAME).bin
