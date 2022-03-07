//pipeline2.v
module pipeline_2 (
    input   clk                       ,
    input   rst                       ,
    //需要在流水段间传递的控制信号
    input   stage3_allowin_in         ,
    output  stage2_allowin_out        ,
    //来自于pipeline2的信号
    input   stage1_to_stage2_valid_in ,
    input   stage1_to_stage2_bus_in   ,
    //pipeline2传递到pipeline3的信号
    output  stage2_to_stage3_valid_out,
    output  wire stage2_to_stage3_bus_out
);
    //*******************************************************************
    //                  stage1 和 stage2 之间段间寄存器
    //*******************************************************************
    reg stage2_valid_r;
    reg stage2_bus_r;

    wire stage2_allowin;
    wire stage2_ready_go;
    wire stage2_to_stage3_valid;

    assign stage2_ready_go        = /*TODO*/;
    assign stage2_allowin         = !stage2_valid_r || stage2_ready_go && stage3_allowin_in;
    assign stage2_to_stage3_valid = stage2_valid_r && stage2_ready_go;

    /*
    *   stage2_ready_go信号说明：
    *       描述stage2当前拍状态的信号，该信号有效说明此时stage2的处理任务已经完成，可以向后一流水段传递数据。
    *       由于在部分流水段中，单个周期可能无法完成该阶段的信号转换，故而设置了该信号。
    *   stage2_ready_go信号赋值说明：
    *       TODO部分需要填充的是stage2的信号完成标志信号，如果可以确定当前流水段一定在单周期内完成信号转换，则可恒置为1。
    *   
    *   stage2_allowin信号说明：
    *       stage2传递给stage1的信号，该信号有效说明下一拍stage2可以接受stage1的数据。
    *   stage2_allowin信号赋值说明：
    *       如果当前流水段为null（段间寄存器内不存在任何数据），那么该信号置为有效。
    *       如果当前流水段不为null（段间寄存器内存在数据），且已知该流水段的信号已经处理完毕，且下一流水段可以接受数据，那么该信号置为有效。
    *
    *   stage2_to_stage3_valid信号说明：
    *       stage2传递给stage3的信号。该信号有效说明此时stage2有数据需要在下一周期传递给stage3。
    *   stage2_to_stage3_valid信号赋值说明：
    *       如果当前流水段不为null（段间寄存器内存在数据），且已知该流水段的信号已经处理完毕，那么该信号置为有效
    */
    always @(posedge clk) begin
        if (rst) begin
            stage2_valid_r <= 0;
        end else if (stage2_allowin) begin
            stage2_valid_r <= stage1_to_stage2_valid_in;
        end

        if (stage2_allowin && stage1_to_stage2_valid_in) begin
            stage2_bus_r <= stage1_to_stage2_bus_in;
        end
    end

    //*******************************************************************
    //                             stage2 
    //*******************************************************************

    //TODO:需要完成的信号转换 stage2_bus_r >> stage2_to_stage3_bus

    //*******************************************************************
    //                           输出信号
    //*******************************************************************
    assign stage2_allowin_out         = stage2_allowin;
    assign stage2_to_stage3_valid_out = stage2_to_stage3_valid;
    assign stage2_to_stage3_bus_out   = stage2_to_stage3_bus;

endmodule