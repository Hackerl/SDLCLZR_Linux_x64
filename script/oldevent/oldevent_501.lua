--function oldevent_501()
    instruct_14();   --  14(E):场景变黑
    instruct_26(61,0,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(61,8,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(61,17,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(61,16,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_3(-2,-2,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_13();   --  13(D):重新显示场景
    instruct_30(47,36,28,33);   --  30(1E):主角走动47-36--28-33
    instruct_40(2);   --  40(28):改变主角站立方向2
    instruct_1(2007,61,0);   --  1(1):[欧阳克]说: 黄姑娘，我想你想的好苦啊
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2008,56,0);   --  1(1):[黄蓉]说: 七公，这小子就是欧阳克。*还有后面那个家伙，也不是*好东西。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2009,69,0);   --  1(1):[洪七公]说: 就是你们两个，欺负蓉儿？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2010,61,0);   --  1(1):[欧阳克]说: 在下心仪黄姑娘已久，遇与*之百年合欢，怎那说欺负呢*？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2011,56,0);   --  1(1):[黄蓉]说: 七公，你听听，他明明是要*欺负我，还装出一副好人的*模样。还有那个家伙，一听*见西毒的名头，下得腿都软*了，靖哥哥要来帮我，他居*然拦着！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2012,0,1);   --  1(1):[资差]说: 在下也是觉得欧阳公子风流*潇洒，黄姑娘美若天仙，正*好是天生一对呀。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2013,69,0);   --  1(1):[洪七公]说: 嘿嘿，别人害怕欧阳锋，我*老叫化当他是个屁！人家喜*欢谁，自有人家自己作主。*那轮得到你们两个小子在此*胡言乱语！休怪老叫化不客*气了！
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(188,1,0,0) ==false then    --  6(6):战斗[188]是则跳转到:Label0
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label0

    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(2014,69,0);   --  1(1):[洪七公]说: 我今日手下留情，你们滚吧*，免得人家说我以大欺小。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2015,61,0);   --  1(1):[欧阳克]说: 哼，七公与家叔齐名，却来*欺负我们两个晚辈。我对黄*姑娘可是一片真情啊，我这*就去找我叔叔，到桃花岛提*亲。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2016,69,0);   --  1(1):[洪七公]说: 提亲？难道老叫化就不会吗*？蓉儿，靖儿，你们先回桃*花岛。老叫化料理一下帮中*事务，随后就到。我倒要看*看黄老邪是不是真疼他的女*儿!
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,0,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [0]
    instruct_3(-2,6,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [6]
    instruct_3(-2,7,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [7]
    instruct_40(0);   --  40(28):改变主角站立方向0
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(2017,61,0);   --  1(1):[欧阳克]说: 兄弟，你我脾气相投，他日*有缘，我定叫我叔父教你几*手功夫。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2018,247,1);   --  1(1):[???]说: 我就喜欢结交欧阳公子这样*的人物，后会有期。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,8,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [8]
    instruct_3(75,39,0,0,0,0,502,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:场景[桃花岛]:场景事件编号 [39]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
--end

