
--常用資料型態介紹
/*
1.數值
|----資料型態--|----------------描述-----------------------|------消耗bytes---|
|     smallint |    允許數值範圍-32768~32767               |     2bytes       |
|     int      |  允許數值範圍-2147483648~2147483647       |     4bytes       |
|	 bigint    |  允許數值範圍-9,223,372,036,854,775,808   |     8bytes       |
|	           |       ~9,223,372,036,854,775,807          |                  |
|  	  decomal  |  允許數值範圍  -1.79E + 308 ~ 1.79E + 308 |   5~17bytes      |
|--------------|-------------------------------------------|------------------|

2.一般字串
|-----資料型態---|----------------描述-----------------------|-----消耗bytes-----------|
|  char(n)       |--固定長度，最多4000字元-------------------|  n Bytes                |
|  varchar(n)    |--可變動長度，最多4000字元-----------------| (n + 2) Bytes           |
|                |                                           |，其中2Bytes用來記錄地址-|
|  varchar(max)  |--可變動長度，最多1,073,741,824字元--------| 1,073,741,826 Bytes     |
|  text          |--可變動長度，最多2Gb字元------------------|   2Gb                   |
|------------------------------------------------------------|-------------------------|

3.Unicode 字串：(非英數字) 其中2Bytes用來記錄地址
|-----資料型態---|----------------描述-----------------------|-----消耗bytes-----------|
|  nchar(n)      |--固定長度，最多4000字元-------------------|   (2 × n) Bytes         |
|  nvarchar(n)   |--可變動長度，最多4000字元-----------------|   (2 × n + 2) Bytes     |
|  nvarchar(max) |--可變動長度，最多536,870,912字元----------| (536,870,912 × 2 + 2)   |
|  ntext         |--可變動長度，最多2Gb字元------------------| 2Gb + 2 Bytes           |
|------------------------------------------------------------|-------------------------|

--效能比：
--char跟nchar 較快一點
--消耗的儲存空間
--ncha 跟nvarchar 會消耗2倍的空間

4.日期
|-----資料型態---|-------------描述-------------|-------------消耗bytes-------------|
|  datetime      |----精度3.33毫秒--------------|         8 Bytes                   |
|  datetime2     |----精度100奈秒---------------|     6 ~ 8 Bytes                   |
|  smalldatetime |----精度1分鐘-----------------|         4 Bytes                   |
|    date        |----僅有日期------------------|         3 Bytes                   |
|    time        |----僅有時間------------------|     3 ~ 5 Bytes                   |
|----------------|------------------------------|-----------------------------------|

5.布林
bit =  1 位元組 (Byte)

6.二進位
|-------資料型態-----|-------------------描述-------------------|
|    varbinary(n)    | 可變動二進位資料，最多可存8000個Bytes    |
|    varbinary(max)  | 可變動二進位資料，最多 2Gb 位元組        |

*/


------------------語法介紹------------------

--建立資料庫
Create DataBase TestDB

--設定當前資料庫
Use TestDB

--建立資料表-使用者
Create Table TestUsers(
id bigint identity(1,1) primary key not null,--流水號
[name] nvarchar(50) default('') not null,--使用者名稱
phone char(15) null,--使用者電話
removed bit not null--註記刪除
)

--建立資料表-使用者所擁有的書籍
Create Table UsersBook(
id bigint identity(1,1) primary key not null,--流水號
usersId bigint not null,--對應使用者資料表的流水號
[name] nvarchar(200) null,--書籍名稱
removed bit not null--註記刪除
)

/*
建立資料表的屬性註解：
1.identity(1,1) => 流水號
2.primary key => 設定索引值
3.default('') => 設定預設值
*/

--使用TSql新增欄位
Alter Table UsersBook Add [pageCount] int default 0 not null

--變更特定欄位的資料型態
/*
注意事項：
如果執行下列第1點步驟有出現類似以下字串的錯誤訊息，則先執行第2步驟再依序執行步驟1跟步驟3
--('DF__UsersBook__pageC__15502E78' 與 資料行 'pageCount' 相依。)
*/

--1.變更欄位資料型態
Alter Table UsersBook Alter Column [pageCount] bigint not null

--2.刪除該欄位的條件約束
Alter Table UsersBook Drop CONSTRAINT DF__UsersBook__pageC__15502E78

--3.把剛剛刪除的條件約束新增回來
ALTER TABLE UsersBook ADD CONSTRAINT DF__UsersBook__pageC__15502E78 DEFAULT 0 FOR [pageCount]

--刪除欄位(先刪除條件約束再刪除欄位)
Alter Table UsersBook Drop CONSTRAINT DF__UsersBook__pageC__15502E78
Alter Table UsersBook Drop Column [pageCount]

--重設識別規格
DBCC CHECKIDENT(TestUsers, RESEED, 2)

--新增資料
Insert Into TestUsers Values('Shilvain','0912345678',0)
Insert Into TestUsers Values('Shilvain','0912345678',0)

--新增一筆資料，指定部分欄位的資料，其餘未指定則使用預設值
Insert Into TestUsers (phone,removed) Values('0987654321',0)
Insert Into UsersBook Values(1,'我會好好的',0)
Insert Into UsersBook Values(1,'天逅',0)
Insert Into UsersBook Values(2,'哈立波特，神秘的教室',0)
Insert Into UsersBook Values(2,'哈利潑忑，玻璃杯的測驗',0)
Insert Into UsersBook Values(2,'魔獸爭霸',0)

--更新資料
Update TestUsers Set phone = '0912345679' where id = 1--修改資料表TestUsers，id 等於 1 的 phone 欄位為 '0912345679'

--永久刪除資料
Delete From TestUsers Where id = 1--刪除id = 1的資料

--查詢資料
Select * From TestUsers
Select * From UsersBook

--跨資料表查詢(使用Join、LeftJoin、RightJoin)
--依靠圖檔較容易理解差別，圖檔參考資源 => 
--https://www.google.com/search?q=join+left+join&rlz=1C1GCEU_zh-TWTW865TW927&hl=zh-TW&sxsrf=AOaemvKVRxMN7vU_Ov_DC5BCo02R-xas2g:1630912610297&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMhq_25unyAhUlBKYKHY49DE0Q_AUoAXoECAEQAw&biw=1920&bih=937#imgrc=IZyINc4AaLoOEM
Select * From UsersBook as ub
Join TestUsers As tu On tu.id = ub.usersId
where tu.[name] = 'Shilvain'

--條件篩選資料
Select * From TestUsers where [name] = ''--phone 值為empty
Select * From TestUsers where [name] like '%987%'--phone值有著987連續的字串
Select * From TestUsers where phone in ('0987654321','0912345679')--phone 的值存在於陣列中

--子查詢(通常不建議使用子查詢，因為效能較差)
--查詢資料表TestUsers，欄位 name 等於 'Shilvain' 的 UsersBook 資料表的資料
Select * From UsersBook where usersId in (Select id From TestUsers where [name] = 'Shilvain')

--排序 (Order By 預設為遞增)
Select * From TestUsers Order By id--遞增 (Asc)
Select * From TestUsers Order By id Desc--遞增

--Group By (特定欄位相同的資料分成幾個群組，每個群組僅傳回一筆資料)，範例為計算各使用者，各自所擁有的書籍數
Select tu.id,Count(*) As '書籍的筆數' From UsersBook as ub
Join TestUsers As tu On tu.id = ub.usersId
Group By tu.id

------------------常用函數------------------

--計算字元數
Select LEN('123') As [Count]

--轉型-轉數值
Select Convert(int,'111') 
select Cast('111' as int)

--轉型-轉字串
Select Convert(nvarchar(10),1230) 
Select Cast(1230 as nvarchar(10))

--轉型-轉浮點數
Select Convert(decimal(6,2),'123.66') 
Select Cast('123.66' as decimal(6,2))

--轉型-轉日期
Select Convert(datetime,'2021-09-06 14:30:16') 
Select Cast('2021-09-06 14:30:16' as datetime)

--計算資料筆數
Select Count(*) From TestUsers