--function oldevent_494()

    if instruct_16(59,6,0) ==false then    --  16(10):队伍是否有[小龙女]是则跳转到:Label0
        instruct_1(1968,122,0);   --  1(1):[???]说: “娇棠初露朦胧月，疑是箫*声笼雨声”，打一人物。*如果你猜出来，就把此人带*来见我。
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0

    instruct_1(1969,122,0);   --  1(1):[???]说: 哈哈哈，不错不错。这是我*将一阳指武功和书法结合起*来的的独门秘笈，就赠与少*侠吧。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_2(172,1);   --  2(2):得到物品[一阳指书][1]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_34(0,3);   --  34(22):资差增加资质3
    instruct_3(-2,-2,1,0,495,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
--end

