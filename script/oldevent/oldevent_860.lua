--function oldevent_860()

    if instruct_4(174,2,0) ==false then    --  4(4):是否使用物品[银两]？是则跳转到:Label0
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0


    if instruct_31(600,6,0) ==false then    --  31(1F):判断银子是否够600是则跳转到:Label1
        instruct_1(3379,236,0);   --  1(1):[???]说: 钱不够啊，这可不行，我这*已经是成本价了，怎么说你*也要让我糊口啊。
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label1

    instruct_32(174,-600);   --  32(20):物品[银两]+[-600]
    instruct_1(3380,236,0);   --  1(1):[???]说: 好，一手交钱，一手交货。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_2(50,1);   --  2(2):得到物品[伏魔杵][1]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_3(-2,-2,-2,0,861,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
--end

