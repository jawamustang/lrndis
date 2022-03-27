# put your *.o targets here, make should handle the rest!

SRCS = 	main.c\
		stm32f4xx_it.c\
		system_stm32f4xx.c\
		Interrupts.c\
		time.c\
		stm32f4_discovery.c\
		stm32f4_discovery_lis302dl.c\
		fsdata.c\
		\
		usb-files/usb_bsp.c\
		usb-files/usbd_usr.c\
		\
		usb-core/dev-driver/usbd_req.c\
		usb-core/dev-driver/usbd_ioreq.c\
		usb-core/dev-driver/usbd_core.c\
		\
		usb-core/otg-driver/usb_core.c\
		usb-core/otg-driver/usb_dcd.c\
		usb-core/otg-driver/usb_dcd_int.c\
		\
		lrndis/lwip-1.4.1/src/core/def.c\
		lrndis/lwip-1.4.1/src/core/dhcp.c\
		lrndis/lwip-1.4.1/src/core/dns.c\
		lrndis/lwip-1.4.1/src/core/init.c\
		lrndis/lwip-1.4.1/src/core/mem.c\
		lrndis/lwip-1.4.1/src/core/memp.c\
		lrndis/lwip-1.4.1/src/core/netif.c\
		lrndis/lwip-1.4.1/src/core/pbuf.c\
		lrndis/lwip-1.4.1/src/core/raw.c\
		lrndis/lwip-1.4.1/src/core/stats.c\
		lrndis/lwip-1.4.1/src/core/sys.c\
		lrndis/lwip-1.4.1/src/core/tcp.c\
		lrndis/lwip-1.4.1/src/core/tcp_in.c\
		lrndis/lwip-1.4.1/src/core/tcp_out.c\
		lrndis/lwip-1.4.1/src/core/timers.c\
		lrndis/lwip-1.4.1/src/core/udp.c\
		lrndis/lwip-1.4.1/src/core/ipv4/autoip.c\
		lrndis/lwip-1.4.1/src/core/ipv4/icmp.c\
		lrndis/lwip-1.4.1/src/core/ipv4/igmp.c\
		lrndis/lwip-1.4.1/src/core/ipv4/inet.c\
		lrndis/lwip-1.4.1/src/core/ipv4/inet_chksum.c\
		lrndis/lwip-1.4.1/src/core/ipv4/ip.c\
		lrndis/lwip-1.4.1/src/core/ipv4/ip_addr.c\
		lrndis/lwip-1.4.1/src/core/ipv4/ip_frag.c\
		lrndis/lwip-1.4.1/src/netif/etharp.c\
		lrndis/lwip-1.4.1/src/netif/ethernetif.c\
		lrndis/lwip-1.4.1/src/netif/slipif.c\
		\
		lrndis/rndis-stm32/usbd_rndis_core.c\
		lrndis/rndis-stm32/usbd_desc.c\
		\
		lrndis/dhcp-server/dhserver.c\
		\
		lrndis/dns-server/dnserver.c\
		\
		lrndis/lwip-1.4.1/apps/httpserver_raw/fs.c\
		lrndis/lwip-1.4.1/apps/httpserver_raw/httpd.c\



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

vpath %.c src
vpath %.a lib

ROOT=$(shell pwd)

CFLAGS += -Iinc
CFLAGS += -Ilib
CFLAGS += -Ilib/inc 
CFLAGS += -Ilib/inc/core
CFLAGS += -Ilib/inc/peripherals 
CFLAGS += -I usb-core/dev-driver 
CFLAGS += -I usb-core/otg-driver 
CFLAGS += -I usb-files 
CFLAGS += -I usb-files/rndis 
CFLAGS += -I lrndis/lwip-1.4.1/src/include 
CFLAGS += -I lrndis/lwip-1.4.1/src/include/ipv4 
CFLAGS += -I lrndis/rndis-stm32 
CFLAGS += -I lrndis/dhcp-server 
CFLAGS += -I lrndis/dns-server 
CFLAGS += -I lrndis/lwip-1.4.1/apps/httpserver_raw

SRCS += lib/startup_stm32f4xx.s # add startup file to build

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
