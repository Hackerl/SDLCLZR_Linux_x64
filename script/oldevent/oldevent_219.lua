--function oldevent_219()
    instruct_1(515,0,1);   --  1(1):[资差]说: 又一大群蜘蛛，看我灭之！
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(62,4,0,0) ==false then    --  6(6):战斗[62]是则跳转到:Label0
        instruct_15(0);   --  15(F):战斗失败，死亡
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0

    instruct_3(-2,10,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [10]
    instruct_3(-2,11,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [11]
    instruct_3(-2,12,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [12]
    instruct_3(-2,13,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [13]
    instruct_3(-2,14,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [14]
    instruct_3(-2,15,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [15]
    instruct_3(-2,16,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [16]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_2(210,5);   --  2(2):得到物品[食材][5]
    instruct_0();   --  0(0)::空语句(清屏)
--end

