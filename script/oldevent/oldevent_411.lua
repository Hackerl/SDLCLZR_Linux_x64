--function oldevent_411()
    instruct_1(1554,21,0);   --  1(1):[定闲]说: 我觉得这句”银鞍照白马”*和”飒沓如流星”连在一起*方为正解．．．
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_16(38,2,0) ==false then    --  16(10):队伍是否有[石破天]是则跳转到:Label0
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label0

    instruct_1(1555,38,1);   --  1(1):[石破天]说: 大哥，这马下的云气，好像*一团团云雾在不断的向前推*涌．．．
    instruct_0();   --  0(0)::空语句(清屏)
--end

