--function oldevent_426()
    instruct_1(1642,85,0);   --  1(1):[???]说: 贝海石愿效犬马之劳，今后*愿听少侠差遣。
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_9(2,0) ==false then    --  9(9):是否要求加入?是则跳转到:Label0
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label0

    instruct_3(104,48,1,0,986,0,0,7028,7028,7028,-2,-2,-2);   --  3(3):修改事件定义:场景[钓鱼岛]:场景事件编号 [48]
    instruct_1(1640,0,1);   --  1(1):[资差]说: 贝大夫，跟我一起走吧。
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_20(24,0) ==false then    --  20(14):队伍是否满？是则跳转到:Label1
        instruct_1(1641,85,0);   --  1(1):[???]说: 好吧。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_10(85);   --  10(A):加入人物[贝海石]
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label1

    instruct_1(12,85,0);   --  1(1):[???]说: 你的队伍已满，我就直接去*小村吧。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_3(70,47,1,0,185,0,0,7028,7028,7028,-2,-2,-2);   --  3(3):修改事件定义:场景[资差居]:场景事件编号 [47]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_0();   --  0(0)::空语句(清屏)
--end

