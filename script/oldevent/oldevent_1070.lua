--function oldevent_1070()

    if instruct_16(90,34,0) ==false then    --  16(10):队伍是否有[钟灵]是则跳转到:Label0
        instruct_1(3989,247,1);   --  1(1):[???]说: 这貂儿真可爱。*咦？跑掉了……
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_3(-2,-2,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
        instruct_3(41,6,1,0,1067,0,0,7264,7264,7264,-2,-2,-2);   --  3(3):修改事件定义:场景[山洞]:场景事件编号 [6]
        do return; end
    end    --:Label0

    instruct_1(3990,90,1);   --  1(1):[???]说: 我的闪电貂！原来跑到这里*来了，总算找到了。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_3(-2,-2,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_35(90,0,113,800);   --  35(23):设置钟灵武功0:闪电貂攻击力800
--end

