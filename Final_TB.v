
module proc_tb;

reg clk, rst;
reg [12:0]instruction_in;
wire [9:0]inst_addr;
wire [3:0]data_addr;
reg [15:0]data_in;
reg [3:0]data_in0;
reg [3:0]data_in1;
reg [3:0]data_in2;
reg [3:0]data_in3;

wire [3:0]data_addr0;
wire [3:0]data_addr1;
wire [3:0]data_addr2;
wire [3:0]data_addr3;

reg [12:0] INST_MEM[1023:0];
reg [15:0] DATA_MEM[15:0];
reg [3:0] VDATA_MEM[15:0];
CPUtop M(clk,rst,instruction_in,inst_addr,data_addr,data_in,data_addr0,data_addr1,data_addr2,data_addr3,data_in0,data_in1,data_in2,data_in3);


initial begin
$dumpfile ("module1.vcd"); 
$dumpvars(0, proc_tb);
clk=0; 
rst=0;
end



initial 
begin
//INSTRUCTION MEMORY
   //load R3,(offset+Rs) d = 6'b 000001 value of R3=5                                
INST_MEM[0]=13'b1010000011001;    //LOOP: VLOAD R5,0(R1) x[i],x[i+1],x[i+2],x[i+3]   
INST_MEM[1]=13'b0100101010101;    //      VMUL R1,R5,2    a*x[i],a*x[i+1],a*x[i+2],a*x[i+3] 
INST_MEM[2]=13'b1010110011001;    //      VLOAD R5,3(R1)  Y[i],Y[i+1],Y[i+2],Y[i+3] 
INST_MEM[3]=13'b0101010100001;    //      VADD R2,R2,R5   Y + a X[i]
INST_MEM[4]=13'b0011110010000;    //      ADD R1,R1,R7     R1=R1+1
INST_MEM[5]=13'b0100010110010;    //      SUB R2,R3,R1     R3=R3-R1
INST_MEM[6]=13'b0001010100110;    //      BNEZ R2,LOOP

//DATA MEMORY for scalar

 DATA_MEM[0]=16'd0 ;
 DATA_MEM[1]=16'd1 ;
 DATA_MEM[2]=16'd2 ;
 DATA_MEM[3]=16'd3 ;
 DATA_MEM[4]=16'd4 ;
 DATA_MEM[5]=16'd5 ;
 DATA_MEM[6]=16'd6 ;

//DATA MEMORY FOR VECTOR
 VDATA_MEM[0]=16'd0 ;
 VDATA_MEM[1]=16'd1 ;
 VDATA_MEM[2]=16'd2 ;
 VDATA_MEM[3]=16'd3 ;
 VDATA_MEM[4]=16'd4 ;
 VDATA_MEM[5]=16'd0 ;
 VDATA_MEM[6]=16'd1 ;
 VDATA_MEM[7]=16'd2 ;
 VDATA_MEM[8]=16'd3 ;
 VDATA_MEM[9]=16'd4 ;
 VDATA_MEM[10]=16'd5 ;



end

always @(inst_addr)
begin
   instruction_in <= INST_MEM[inst_addr];
   $display("inst_addr %d: %b",inst_addr,INST_MEM[inst_addr]);
end

always @(data_addr)
begin
   data_in <= DATA_MEM[data_addr];
   $display("inst_addr %d: %b",inst_addr,INST_MEM[inst_addr]);
end

always @(data_addr0)
begin
   data_in0 <= VDATA_MEM[data_addr0];
end

always @(data_addr1)
begin
   data_in1 <= VDATA_MEM[data_addr1];
end

always @(data_addr2)
begin
   data_in2 <= VDATA_MEM[data_addr2];
end

always @(data_addr0)
begin
   data_in3 <= VDATA_MEM[data_addr3];
end


always #5 clk =~clk;
endmodule

