DaiMethodTracing
================
This is a tool for understanding your methods. You can monitor the input / output value, method relationships, method process time.

DaidoujiChen

daidoujichen@gmail.com

總覽
================
概念起源於 debug 時候的一些想法, 有時候想看看每個 method 的傳值是不是正確, 回傳值是不是正確, 以及執行花費多少時間等等的,
如果一個 method 一個 method 加的話, 實在是太累了, 所以寫了一個方法可以直接監看某個 class, 讓他下面的 method 怎麼執行, 完整地呈現出來.

簡易使用
================
還是很簡單, 首先把 DaiMethodTracing 下的所有東西 add 到你的專案中,
然後

    #import "DaiMethodTracing.h"
    
然後, 在任何地方使用, (其中 yourClass 是你想換的那個 class name)

    [DaiMethodTracing tracingClass:[yourClass class]];
    
即可監看該 class 下 method 的活動狀態.

已知問題
================
無法對付 block 和 struct.
- block, 不能知道 block 何時開始執行, 何時結束.
- struct, 內建的應該是可以, 但是自定義的 struct 會有解析上的問題.
