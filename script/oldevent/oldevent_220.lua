--function oldevent_220()
    instruct_1(515,0,1);   --  1(1):[资差]说: 又一大群蜘蛛，看我灭之！
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(65,4,0,0) ==false then    --  6(6):战斗[65]是则跳转到:Label0
        instruct_15(0);   --  15(F):战斗失败，死亡
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0

    instruct_3(-2,32,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [32]
    instruct_3(-2,33,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [33]
    instruct_3(-2,34,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [34]
    instruct_3(-2,35,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [35]
    instruct_3(-2,42,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [42]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_2(210,5);   --  2(2):得到物品[食材][5]
    instruct_0();   --  0(0)::空语句(清屏)
--end

