module CPUtop(clk,rst,instruction_in,inst_addr,data_addr,data_in,data_addr0,data_addr1,data_addr2,data_addr3,data_in0,data_in1,data_in2,data_in3);

input clk,rst;
    input [12:0] instruction_in;
    output [9:0]inst_addr;
	input [15:0]data_in;
	input [3:0]data_in0;
	input [3:0]data_in1;
	input [3:0]data_in2;
	input [3:0]data_in3;
	output reg [3:0] data_addr;
	output reg [3:0] data_addr0;
	output reg [3:0] data_addr1;
	output reg [3:0] data_addr2;
	output reg [3:0] data_addr3;
	
	
    reg [9:0]PC;		   
	reg [12:0] opcode;
	reg [15:0] R0,R1,R2,R3,R4,R5,R6,R7;
    reg [2:0] current_state,next_state;
	reg D_state,E_state,M_state,WB_state;
	wire decoder,execute,write_back,memory;
	reg branch_reg;
	
	reg ADD,SUB,MUL,BRANCH,LOAD,STORE;
	reg VADD,VSUB,VMUL,VBRANCH,VLOAD,VSTORE;
	reg [15:0]Rs1,Rs2,Rd,op1,op2,op3;
	
	reg [5:0] op;
	
    reg	[2:0] L_OFFSET;
	
	reg [3:0] V1,V2,V3,V4,X1,X2,X3,X4,Y1,Y2,Y3,Y4;
	
	
	
	//REGISTER FILE
initial begin
R0=16'd0;
R1=16'd1; 
R2=16'd2;
R3=16'd3;
R4=16'd4;
R5=16'd5;
R6=16'd6;
R7=16'd1;
end
assign inst_addr = PC ;



initial begin
current_state = 3'b000;
opcode = 11'b0;
branch_reg =0;
PC = 10'b0;
//branch_off_reg=6'b0;
D_state=0;
M_state=0;
E_state=0;
WB_state=0;
end

always @(posedge clk)
begin
 if(rst==1) 
 current_state <= 3'b000;
 else
 current_state <= next_state;
end 


////////////******************* FETCH STAGE *************////////////////////

always @ (posedge clk )
begin

		  if(branch_reg==1 && next_state==3'b000 && current_state ==3'b000 )
		     begin
				PC = PC - {7'b0,op[5:0]};
             branch_reg =0;
             end			 
		  else if(branch_reg==0 && next_state==3'b000 && current_state ==3'b000)
				PC = PC + 1'd1;

 end


always @(posedge clk or next_state)
begin
case(current_state)
3'b000 :begin                     
         if (rst==1) 
        begin
          opcode = 0;
		  next_state <= 3'b000;
        end
		  else 
		       assign opcode = instruction_in;
			   next_state <= 3'b001;
          end
		 
       
 
3'b001 :begin                     //decode
       D_state = 1; // go to decoder
	    end 

3'b010 :begin
        E_state = 1;
        
        		//execute
        end

3'b011 :begin       
         M_state = 1;         
         
         		 //memory
        end

3'b100 :begin                   //write back
            WB_state = 1;
		    
			
	    end
endcase
end


//////////***********************DECODE STAGE **************/////////

//decoder
always @ (posedge clk)
begin
if (D_state== 1)
begin

case(opcode[3:0])
		                              4'b0000 :  begin
								 ADD=1;
								 SUB=0;
								 MUL=0;
								 BRANCH=0;
								 LOAD=0;
								 STORE=0;
								 end
		  		              4'b0010 :  begin
								 ADD=0;
								 SUB=1;
								 MUL=0;
								 BRANCH=0;
								 LOAD=0;
								 STORE=0;
								 end
                                               4'b0100 :  begin
								 ADD=0;
								 SUB=0;
								 MUL=1;
								 BRANCH=0;
								 LOAD=0;
								 STORE=0;
								 end

						4'b0110 :  begin
								 ADD=0;
								 SUB=0;
								 MUL=0;
								 BRANCH=1;
								 LOAD=0;
								 STORE=0;
								 end
						4'b1000 :  begin
								 ADD=0;
								 SUB=0;
								 MUL=0;
								 BRANCH=0;
								 LOAD=1;
								 STORE=0;
								 end
						4'b1010 :  begin
								 ADD=0;
								 SUB=0;
								 MUL=0;
								 BRANCH=0;
								 LOAD=0;
								 STORE=1;
								 end
								 
								 //vector
								 
						4'b0001 :  begin
								 VADD=1;
								 VSUB=0;
								 VMUL=0;
								 VBRANCH=0;
								 VLOAD=0;
								 VSTORE=0;
								 end		 
                         4'b0011 :  begin
								 VADD=0;
								 VSUB=1;
								 VMUL=0;
								 VBRANCH=0;
								 VLOAD=0;
								 VSTORE=0;
								 end
						4'b0101 :  begin
								 VADD=0;
								 VSUB=0;
								 VMUL=1;
								 VBRANCH=0;
								 VLOAD=0;
								 VSTORE=0;
								 end
                         4'b0111 :  begin
								 VADD=0;
								 VSUB=0;
								 VMUL=0;
								 VBRANCH=1;
								 VLOAD=0;
								 VSTORE=0;
								 end
                        4'b1001 :  begin
								 VADD=0;
								 VSUB=0;
								 VMUL=0;
								 VBRANCH=0;
								 VLOAD=1;
								 VSTORE=0;
								 end	
                        4'b1011 :  begin
								 VADD=0;
								 VSUB=0;
								 VMUL=0;
								 VBRANCH=0;
								 VLOAD=0;
								 VSTORE=1;
								 end								 
		                endcase 
	



//Selecting source Register RS1


case(opcode[6:4])
3'b000 :begin
        Rs1=R0;
        end
3'b001 :begin
        Rs1=R1;
        end
3'b010 :begin 
        Rs1=R2;
        end
3'b011 :begin
        Rs1=R3;
        end
3'b100 :begin
        Rs1=R4;
        end
3'b101 :begin
        Rs1=R5;
        end
3'b110 :begin 
        Rs1=R6;
        end
3'b111 :begin
        Rs1=R7;
        end		
endcase		


//Selecting source Register RS1

case(opcode[9:7])

3'b000 :begin
        Rs2=R0;
        end
3'b001 :begin
        Rs2=R1;
        end
3'b010 :begin 
        Rs2=R2;
        end
3'b011 :begin
        Rs2=R3;
        end
3'b100 :begin
        Rs2=R4;
        end
3'b101 :begin
        Rs2=R5;
        end
3'b110 :begin 
        Rs2=R6;
        end
3'b111 :begin
        Rs2=R7;
        end		
		
endcase


//Selecting source Register RS1


next_state <= 3'b010;
D_state=0;
end
end

		


/////********** EXECUTION STAGE *******///////////


always @(posedge clk)
begin
 if (E_state==1)
     begin
        if (ADD==1)
        begin
        op1=Rs1;           //ADD Rd,Rs1,Rs2
        op2=Rs2;
        op3= op1 + op2;
        ADD=0;
        end
        else if (SUB==1)
        begin
        op1=Rs1;          //SUB Rd,Rs1,Rs2
        op2=Rs2;           
        op3= op1 - op2;
        SUB=0;
        end
        else if (MUL==1)
        begin
        op1=Rs1;        //MUL Rd,Rs1,Rs2
        op2=Rs2;
        op3= op1 * op2;
        MUL=0;
        end
        else if (BRANCH==1)
        begin
       op1=Rs1;
         if(op1 != 0)
            begin
             branch_reg=1;
			 op =  opcode[12:7];
			end
        BRANCH =0;
        end
        else if (LOAD==1)
        begin
		op1=Rs1;
		L_OFFSET = opcode[9:7];
		data_addr = op1 + L_OFFSET;
        		
        end
        else if (STORE==1)
        begin
	    STORE=0;
        end
		
		else if (VLOAD==1)
        begin
		op1=Rs1;
		L_OFFSET = opcode[9:7];
		data_addr0 = op1 + L_OFFSET;
		data_addr1 = op1 + L_OFFSET + 3'b001;
		data_addr2 = op1 + L_OFFSET + 3'b010;
		data_addr3 = op1 + L_OFFSET + 3'b011;
		end
		
	if (VADD==1)
        begin
        X1= Rs1[3:0];
        X2= Rs1[7:4];
        X3= Rs1[11:8];
        X4= Rs1[15:12];
        Y1=Rs2[3:0];
        Y2=Rs2[7:4];
        Y3=Rs2[11:8];
        Y4=Rs2[15:12];
        V1 = X1 + Y1;
        V2 = X2 + Y2;
        V3 = X3 + Y3;
        V4 = X4 + Y4;
        op3={V4[3:0],V3[3:0],V2[3:0],V1[3:0]};
        VADD=0;
        end
		
		
		if (VMUL==1)
        begin
        X1= Rs1[3:0];
        X2= Rs1[7:4];
        X3= Rs1[11:8];
        X4= Rs1[15:12];
        Y1=Rs2;
        V1 = X1 * Y1;
        V2 = X2 * Y1;
        V3 = X3 * Y1;
        V4 = X4 * Y1;
        op3={V4[3:0],V3[3:0],V2[3:0],V1[3:0]};
        VMUL=0;
        end
	
		
        next_state <= 3'b011;
        E_state=0;
     end 
end







/////////*******MEMORY STAGE ******///////////


always @(posedge clk)
begin
if (M_state == 1 )
begin
if(LOAD==1)
   begin
   op3=data_in;
   case(opcode[12:10])

3'b000 :begin
        R0=op3;
        end
3'b001 :begin
        R1=op3;
        end
3'b010 :begin 
        R2=op3;
        end
3'b011 :begin
        R3=op3;
        end
3'b100 :begin
        R4=op3;
        end
3'b101 :begin
        R5=op3;
        end
3'b110 :begin 
        R6=op3;
        end
3'b111 :begin
        R7=op3;
        end		
endcase

   LOAD=0;
   
   end
else if(VLOAD==1)
begin
V1=data_in0;
V2=data_in1;
V3=data_in2;
V4=data_in3;

op3={V4[3:0],V3[3:0],V2[3:0],V1[3:0]};

case(opcode[12:10])

3'b000 :begin
        R0=op3;
        end
3'b001 :begin
        R1=op3;
        end
3'b010 :begin 
        R2=op3;
        end
3'b011 :begin
        R3=op3;
        end
3'b100 :begin
        R4=op3;
        end
3'b101 :begin
        R5=op3;
        end
3'b110 :begin 
        R6=op3;
        end
3'b111 :begin
        R7=op3;
        end		
endcase
VLOAD=0;
end 
 
   
next_state <= 3'b100;
M_state=0;
end
end


////////**********WB_STAGE *********////////


always @(posedge clk)
begin
if (WB_state == 1)
 begin

 case(opcode[12:10])

 3'b000 :begin  
        R0=op3;
        end
 3'b001 :begin
        R1=op3;
        end
 3'b010 :begin 
        R2=op3;
        end
 3'b011 :begin
        R3=op3;
        end
 3'b100 :begin
        R4=op3;
        end
 3'b101 :begin
        R5=op3;
        end
 3'b110 :begin 
        R6=op3;
        end
 3'b111 :begin
        R7=op3;
        end		
endcase

next_state <= 3'b000;
WB_state=0;
end
end

endmodule
