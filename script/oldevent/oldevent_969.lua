--function oldevent_969()
    instruct_1(3820,58,0);   --  1(1):[杨过]说: 下一场战斗，要我出场吗？
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_9(2,0) ==false then    --  9(9):是否要求加入?是则跳转到:Label0
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0


    if instruct_20(19,0) ==false then    --  20(14):队伍是否满？是则跳转到:Label1
        instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_10(58);   --  10(A):加入人物[杨过]
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label1

    instruct_1(3821,58,0);   --  1(1):[杨过]说: 你得队伍已满，我等下一场*战斗再上场吧。
    instruct_0();   --  0(0)::空语句(清屏)
--end

