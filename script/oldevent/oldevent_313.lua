--function oldevent_313()
    instruct_1(1117,5,0);   --  1(1):[张三丰]说: 小兄弟想要与老朽切磋武学*的奥妙吗？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1118,0,1);   --  1(1):[资差]说: 还望前辈指导。
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(22,45,0,0) ==false then    --  6(6):战斗[22]是则跳转到:Label0
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景

        if instruct_28(0,90,999,0,31) ==true then    --  28(1C):判断资差品德90-999否则跳转到:Label1

            if instruct_29(0,140,9999,0,24) ==true then    --  29(1D):判断资差武力140-9999否则跳转到:Label2
                instruct_1(1123,5,0);   --  1(1):[张三丰]说: 小兄弟资质不错，功力又增*进不少，不错，不错。**这是我最近研究出的一套剑*法，你拿去好好参详吧。**记住，要领悟剑的"剑意"*而非"剑招"。
                instruct_0();   --  0(0)::空语句(清屏)
                instruct_2(115,1);   --  2(2):得到物品[太极剑法][1]
                instruct_0();   --  0(0)::空语句(清屏)
                instruct_3(-2,-2,1,0,314,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
                do return; end
            end    --:Label2

            instruct_0();   --  0(0)::空语句(清屏)
        end    --:Label1

        instruct_1(1119,5,0);   --  1(1):[张三丰]说: 小兄弟，看来你还需再下一*番努力才是。
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0

    instruct_1(1121,5,0);   --  1(1):[张三丰]说: 少侠武功已到如此境界，*老朽也没什麽好教你的了。
    instruct_3(-2,-2,1,0,314,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_0();   --  0(0)::空语句(清屏)
--end

