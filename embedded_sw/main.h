// Library Linking
#include <stdio.h>
#include <xaxidma_hw.h>
#include <xil_exception.h>
#include <xparameters_ps.h> 
#include <xstatus.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "xparameters.h" 
#include "xaxidma.h" // Library for AXI-DMA
#include "xil_types.h" 
#include "sleep.h"
#include "xscugic.h" // Library for Interrupt Handling
#include "xparameters.h"

#define DMA_DEVICE_ID XPAR_AXI_DMA_0_BASEADDR

static XAxiDma dma_ctl;
static XAxiDma_Config *dma_cfg;

u32 i =1;
u32 count =64;
int done =1;
XScuGic IntcInstance;



void Intr_handler(void* CallBackRef){
    xil_printf("\t\t Transfer Next Data \t\t\n");
    XAxiDma_SimpleTransfer(&dma_ctl, (u32)a, 4*64 , XAXIDMA_DMA_TO_DEVICE);
    count = count + 64
    if(count == resolution_size){
      done = 0;
    }

}

u32 checkIdle(u32 baseAddress,u32 offset){
	u32 status;
	status = (XAxiDma_ReadReg(baseAddress,offset))&XAXIDMA_IDLE_MASK;
	return status;
}

int main()
{
    init_platform();
    u32 status;

    xil_printf("DMA_INTERRUPT EXAMPLE 2\n");

    // DMA CONTROLLER INITIALIZATION
    dma_cfg = XAxiDma_LookupConfig(DMA_DEVICE_ID);
    if(dma_cfg == NULL){
        xil_printf("Can't find DMA CONFIGURATION \r\n");
        return XST_FAILURE;
    }
    // DMA CONFIGURATION INITIALIZATION
    status = XAxiDma_CfgInitialize(&dma_ctl, dma_cfg);
    if(status != XST_SUCCESS){
        xil_printf("DMA INITIALIZATION FAILED");
        return XST_FAILURE;
    }

    //Interrupt COntroller setting
    XScuGic_Config* IntcConfig;
    IntcConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
    status = XScuGic_CfgInitialize(&IntcInstance, IntcConfig, 
    IntcConfig->CpuBaseAddress);
    if(status !=XST_SUCCESS){
        printf("INTERRUPT CONTROLLER SETTING FAILED \r\n");
        return XST_FAILURE;
    }



    XScuGic_SetPriorityTriggerType(&IntcInstance, 61, 0xA0, 3);
    // connect interrupt handler
    status =XScuGic_Connect(&IntcInstance, 61, (Xil_InterruptHandler) 
    Intr_handler, (void*) &dma_ctl);
    if(status !=XST_SUCCESS){
        xil_printf("connect interrupt handler failed \n\r");
        return XST_FAILURE;
    }

    XScuGic_Enable(&IntcInstance, 61);


    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler) XScuGic_InterruptHandler, (void*)&IntcInstance);
    Xil_ExceptionEnable();

    Xil_DCacheFlushRange((int)b, 64*sizeof(int));

    xil_printf("send data to device for second interrupt\n");
    XAxiDma_SimpleTransfer(&dma_ctl, (int)b, 4*(160*90) , XAXIDMA_DEVICE_TO_DMA); // resolution -> 1280x720x3 => 160x90x64

    // u32 a[1280 * 720 ] = Image which is  transformed Freqeuency domain 

    //Xil_DCacheFlushRange((u32)a, resolution_size*sizeof(u32));

    xil_printf("send data to device for first interrupt\n");
    XAxiDma_SimpleTransfer(&dma_ctl, (u32)a, 4*64 , XAXIDMA_DMA_TO_DEVICE); // transfer 8x8 block for one-transaction





    while(done){
        usleep(100);
    }

        cleanup_platform();
    return 0;
}
