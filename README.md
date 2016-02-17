# News Wall

News Wall是一個新聞聚合的APP，
於2015年5月左右在APP Store上架，
因為News Wall其中使用的一項服務KIMONO(https://www.kimonolabs.com/) 賣給了Palantir(註1)，
將在2016年2月底停止對外公開服務，
所以連帶使得News Wall無法繼續提供服務即日將從APP Stroe下線，
因此Ryan將程式碼公開給有需要的朋友參考，
但也不再更新程式碼或Debug

當初開發News Wall是因為自己常固定瀏覽幾個新聞或內容網站，
但不喜歡在瀏覽器中一直點選書籤在網站間跳來跳去的，
另外，並不是每一個網站都有提供RSS的功能，
所以想說做一個能將各個網站首頁的最新消息與內容集中在一個APP的想法，
這樣我只要打開APP刷一下就可以看到我喜歡的網站現在最新的內容，節省時間又方便存取，
而頁面包含了圖片和標題，若是喜歡就點進去詳閱，需要收藏就點選愛心成為我的最愛可供日後繼續閱讀，
另外就是有一個訂閱的功能，若我暫時不想再follow某個網站，可以在訂閱功能中取消訂閱，
News Wall上線後確實也解決了我這方面的困擾和滿足了我一個APP就看到所有新聞內容的需求，

![alt tag](https://github.com/ryan0817/News-Wall/blob/master/screenshot/e.jpg)

以下簡單介紹News Wall的架構，
News Wall除了剛才提到的KIMONO服務以外，
資料也分別存在iCloud與本機端的Core Data中

1. KIMONO服務
是一個相當優秀的爬資料服務，他可以將不同網頁內文中的資料轉為可用Http呼叫的API，
API傳遞的方式有JSON, XML, CSV，
另外也可以透過Javascript客製化要轉出的格式內容，
發現這個服務也才突發奇想的透過KIMONO來抓新聞，
APP再透過網路來取得JSON(僅包含來源網站的圖片URL，標題與新聞連結)，
這樣就可以解決在不同網站各自開發的HTML間爬文，
若是自己開一個Web server來處理這樣的爬文內容也是件麻煩的事情，
而KIMONO用很優雅的方式解決了這樣的問題

2. iCloud:
News Wall將可訂閱的網站設定資料儲存在iCloud上，
若有新增可訂閱的網站可隨時取得訂閱，
原本有考慮用Parse的服務，因為iColud只有iOS App可存取，使用Parse未來可開發Android程式一起用，
但寫下本篇文章的近期剛好Parse也宣布要關閉服務，
心情真是有些複雜

3. Core Data:
儲存我的最愛和user訂閱的網站

後續：原本想繼續開發Android版，但很可惜核心KIMONO停止服務無法接續，
我的最愛和訂閱的網站資訊目前存放在client端，若是改到像Parse的雲端服務就可以提供跨平台的使用，
目前有參考到AWS去年所提出的Mobile解決方案，整合AWS其他相關服務很方便，



註1:Palantir 是 Paypal 的共同創辦人 Peter Thiel 在 2004 年所創辦的公司，因為當時他認為支付公司的「反詐騙技術」可以用來打擊「恐怖主義」。藉由將大量分離資料拉在一起，使其中不易發現的關係浮現出來，而成為政府部門用來管理反恐戰爭、毒品販賣的分析平台。而從那時候開始，Palantir 的事業除了政府之外，也逐漸拓展到私部門、網路安全和醫療工業上。
(資料來源：http://buzzorange.com/techorange/2015/06/25/palantir/)


APP Demo
![alt tag](https://github.com/ryan0817/News-Wall/blob/master/screenshot/f.gif)


