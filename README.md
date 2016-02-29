# wishbone_uvc
Wishbone protocol open source universal verification component (UVC). It is easy to be used in UVM verification environment for opencpu. 

# wishbone_usage
Wishbone package can be nested in your own package such as:  
    package soc_package;  
      import wishbone_pkg::*;  
      ...  
      ...  
         
    endpackage    

# wishbone_install
Wishbone package is not included the Makefile that can be used in large scale SoC verification environment, if need it, please send email to me (cgzhangwei@gmail.com)

# wishbone_uvc copyright@
//************************************************************************************   
// Copyright 2016 Opening Vision  (Shanghai) Inc and the Author  
// All Rights Reserved.  
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF  
// OPENING VISION INC OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.   
//  
//  Language : SystemVerilog    
//  Version  : 2.3    
//  Author   : Alex Zhang   
//  Date     : 02-26-2016    
//************************************************************************************   



