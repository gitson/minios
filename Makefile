NASM=nasm
RM=rm
VBM=VBoxManage
VMPATH=~/VirtualBox\ VMs/MyOS
TARGET=$(VMPATH)/MyOS.vdi
DD=dd

all: $(TARGET)

$(TARGET): test.com kernel.com test.boot
	$(VBM) storagectl MyOS --add ide --name 'IDE Controller'
	$(DD) conv=notrunc if=test.com of=test.boot
	$(DD) conv=notrunc if=kernel.com of=test.boot seek=1
	$(VBM) convertfromraw test.boot $(TARGET)
	$(VBM) storageattach MyOS --storagectl 'IDE Controller' --type hdd --medium $(TARGET) --port 0 --device 0

start: 
	$(VBM) startvm MyOS


%.com: %.asm
	$(NASM) $< -o $@

clean: cleanvm
	$(RM) -f test.com kernel.com

cleanvm:
	$(VBM) storagectl MyOS --name 'IDE Controller' --remove
	$(VBM) closemedium disk --delete $(TARGET)
