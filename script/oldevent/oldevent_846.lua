--function oldevent_846()

    if instruct_60(-2,4,6120,0,15) ==true then    --  60(3C):判断场景-2事件位置4是否有贴图6120否则跳转到:Label0
        instruct_3(-2,4,-2,0,-2,-2,-2,-2,-2,-2,-2,23,20);   --  3(3):修改事件定义:当前场景:场景事件编号 [4]
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label0


    if instruct_60(-2,5,7022,0,15) ==true then    --  60(3C):判断场景-2事件位置5是否有贴图7022否则跳转到:Label1
        instruct_3(-2,5,-2,0,-2,-2,-2,-2,-2,-2,-2,23,27);   --  3(3):修改事件定义:当前场景:场景事件编号 [5]
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label1

    instruct_3(-2,-2,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_0();   --  0(0)::空语句(清屏)
--end

