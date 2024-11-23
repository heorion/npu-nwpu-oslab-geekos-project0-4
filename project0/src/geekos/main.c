/*
 * GeekOS C code entry point
 * Copyright (c) 2001,2003,2004 David H. Hovemeyer <daveho@cs.umd.edu>
 * Copyright (c) 2003, Jeffrey K. Hollingsworth <hollings@cs.umd.edu>
 * Copyright (c) 2004, Iulian Neamtiu <neamtiu@cs.umd.edu>
 * $Revision: 1.51 $
 * 
 * This is free software.  You are permitted to use,
 * redistribute, and modify it as specified in the file "COPYING".
 */

#include <geekos/bootinfo.h>
#include <geekos/string.h>
#include <geekos/screen.h>
#include <geekos/mem.h>
#include <geekos/crc32.h>
#include <geekos/tss.h>
#include <geekos/int.h>
#include <geekos/kthread.h>
#include <geekos/trap.h>
#include <geekos/timer.h>
#include <geekos/keyboard.h>




/*
 * Kernel C code entry point.
 * Initializes kernel subsystems, mounts filesystems,
 * and spawns init process.
 */

int test = 0;

void print_key(ulong_t arg)
{
    Keycode k;
    while(1)
    {
        k = Wait_For_Key();
        if(k == ('d'|KEY_CTRL_FLAG))
	{   
            Print("\nexit\n");
            break;
	}
	if(k & KEY_RELEASE_FLAG)
	    continue;
        
        Print("%c", k&0xFF);
    }
}

void fun1()
{
    int i = 0;
    while(i<10)
    {
	test++;
	Print("%d\n", test);
        i++;
    }
}

void fun2()
{
    int i = 0;
    while(i<10)
    {
	test++;
	Print("%d\n", test);
        i++;
    }
}

void pa()
{
	while(1)Print("a");
}

void pb()
{
	while(1)Print("b");
}




void Main(struct Boot_Info* bootInfo)
{
    Init_BSS();
    Init_Screen();
    Init_Mem(bootInfo);
    Init_CRC32();
    Init_TSS();
    Init_Interrupts();
    Init_Scheduler();
    Init_Traps();
    Init_Timer();
    Init_Keyboard();


    Set_Current_Attr(ATTRIB(BLACK, GREEN|BRIGHT));
    Print("Welcome to GeekOS!\n");
    Set_Current_Attr(ATTRIB(BLACK, GRAY));


    // TODO("Start a kernel thread to echo pressed keys and print counts");
    
    Start_Kernel_Thread(print_key, 0, PRIORITY_NORMAL, true);

    Start_Kernel_Thread(fun1, 0, PRIORITY_NORMAL, true);
    Start_Kernel_Thread(fun2, 0, PRIORITY_NORMAL, true);

    //Start_Kernel_Thread(pa, 0, PRIORITY_NORMAL, true);
    //Start_Kernel_Thread(pb, 0, PRIORITY_NORMAL, true);


    /* Now this thread is done. */
    Exit(0);
}









