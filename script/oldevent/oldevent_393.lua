--function oldevent_393()
    instruct_1(1529,38,0);   --  1(1):[石破天]说: 那我们一起去侠客岛吧
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_9(0,81) ==true then    --  9(9):是否要求加入?否则跳转到:Label0
        instruct_37(1);   --  37(25):增加道德1
        instruct_1(1530,0,1);   --  1(1):[资差]说: 好啊
        instruct_0();   --  0(0)::空语句(清屏)

        if instruct_20(20,0) ==false then    --  20(14):队伍是否满？是则跳转到:Label1
            instruct_14();   --  14(E):场景变黑
            instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_13();   --  13(D):重新显示场景
            instruct_10(38);   --  10(A):加入人物[石破天]
            do return; end
        end    --:Label1

        instruct_1(12,38,0);   --  1(1):[石破天]说: 你的队伍已满，我就直接去*小村吧。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_14();   --  14(E):场景变黑
        instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
        instruct_3(70,16,1,0,127,0,0,6410,6410,6410,-2,-2,-2);   --  3(3):修改事件定义:场景[资差居]:场景事件编号 [16]
        instruct_3(70,58,1,0,127,0,0,6412,6412,6412,-2,-2,-2);   --  3(3):修改事件定义:场景[资差居]:场景事件编号 [58]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        do return; end
    end    --:Label0

    instruct_1(1531,0,1);   --  1(1):[资差]说: 我还有事，*你在这里等我吧。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_0();   --  0(0)::空语句(清屏)
--end

