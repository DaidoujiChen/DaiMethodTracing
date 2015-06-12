DaiMethodTracing
================
This is a tool for understanding your methods. You can monitor the input / output value, method relationships, method process time.

![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/DaiMethodTracing.gif)

DaidoujiChen

daidoujichen@gmail.com

特別感謝 [Hai Feng Kao](https://github.com/haifengkao) 提供 block 部分的做法 [MABlockForwarding](https://github.com/mikeash/MABlockForwarding).

總覽
================
概念起源於 debug 時候的一些想法, 有時候想看看每個 method 的傳值是不是正確, 回傳值是不是正確, 以及執行花費多少時間等等的,
如果一個 method 一個 method 加的話, 實在是太累了, 所以寫了一個方法可以直接監看某個 class, 讓他下面的 method 怎麼執行, 完整地呈現出來.

大概我們可以分成幾個面向來使用這個工具,

1. 當接到一份沒有摸過的而有 bug 的 code, 想要迅速的了解 method 之間的流竄, 可以利用 `DaiMethodTracing` 加速理解.
2. 觀察系統內的 method 傳遞, 比方, `UIWindow`, `UIWebView`, `UIScrollView` 之類, 可以正確的剖析出正確的切入點.
3. 觀察 static library 的活動, 任何可知道 class 名稱的內容, 都可以藉由 `NSClassFromNSString` 切進去.
4. 在 [Hai Feng Kao](https://github.com/haifengkao) 的幫助下, block 目前也可以切得進去囉, 如同 method 一般, 我們可以觀察他的傳入傳出值, 以及運行的時間.

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
無法對付 struct.
- struct, 內建的應該是可以, 但是自定義的 struct 會有解析上的問題.
