
--�`�θ�ƫ��A����
/*
1.�ƭ�
|----��ƫ��A--|----------------�y�z-----------------------|------����bytes---|
|     smallint |    ���\�ƭȽd��-32768~32767               |     2bytes       |
|     int      |  ���\�ƭȽd��-2147483648~2147483647       |     4bytes       |
|	 bigint    |  ���\�ƭȽd��-9,223,372,036,854,775,808   |     8bytes       |
|	           |       ~9,223,372,036,854,775,807          |                  |
|  	  decomal  |  ���\�ƭȽd��  -1.79E + 308 ~ 1.79E + 308 |   5~17bytes      |
|--------------|-------------------------------------------|------------------|

2.�@��r��
|-----��ƫ��A---|----------------�y�z-----------------------|-----����bytes-----------|
|  char(n)       |--�T�w���סA�̦h4000�r��-------------------|  n Bytes                |
|  varchar(n)    |--�i�ܰʪ��סA�̦h4000�r��-----------------| (n + 2) Bytes           |
|                |                                           |�A�䤤2Bytes�ΨӰO���a�}-|
|  varchar(max)  |--�i�ܰʪ��סA�̦h1,073,741,824�r��--------| 1,073,741,826 Bytes     |
|  text          |--�i�ܰʪ��סA�̦h2Gb�r��------------------|   2Gb                   |
|------------------------------------------------------------|-------------------------|

3.Unicode �r��G(�D�^�Ʀr) �䤤2Bytes�ΨӰO���a�}
|-----��ƫ��A---|----------------�y�z-----------------------|-----����bytes-----------|
|  nchar(n)      |--�T�w���סA�̦h4000�r��-------------------|   (2 �� n) Bytes         |
|  nvarchar(n)   |--�i�ܰʪ��סA�̦h4000�r��-----------------|   (2 �� n + 2) Bytes     |
|  nvarchar(max) |--�i�ܰʪ��סA�̦h536,870,912�r��----------| (536,870,912 �� 2 + 2)   |
|  ntext         |--�i�ܰʪ��סA�̦h2Gb�r��------------------| 2Gb + 2 Bytes           |
|------------------------------------------------------------|-------------------------|

--�į��G
--char��nchar ���֤@�I
--���Ӫ��x�s�Ŷ�
--ncha ��nvarchar �|����2�����Ŷ�

4.���
|-----��ƫ��A---|-------------�y�z-------------|-------------����bytes-------------|
|  datetime      |----���3.33�@��--------------|         8 Bytes                   |
|  datetime2     |----���100�`��---------------|     6 ~ 8 Bytes                   |
|  smalldatetime |----���1����-----------------|         4 Bytes                   |
|    date        |----�Ȧ����------------------|         3 Bytes                   |
|    time        |----�Ȧ��ɶ�------------------|     3 ~ 5 Bytes                   |
|----------------|------------------------------|-----------------------------------|

5.���L
bit =  1 �줸�� (Byte)

6.�G�i��
|-------��ƫ��A-----|-------------------�y�z-------------------|
|    varbinary(n)    | �i�ܰʤG�i���ơA�̦h�i�s8000��Bytes    |
|    varbinary(max)  | �i�ܰʤG�i���ơA�̦h 2Gb �줸��        |

*/


------------------�y�k����------------------

--�إ߸�Ʈw
Create DataBase TestDB

--�]�w��e��Ʈw
Use TestDB

--�إ߸�ƪ�-�ϥΪ�
Create Table TestUsers(
id bigint identity(1,1) primary key not null,--�y����
[name] nvarchar(50) default('') not null,--�ϥΪ̦W��
phone char(15) null,--�ϥΪ̹q��
removed bit not null--���O�R��
)

--�إ߸�ƪ�-�ϥΪ̩Ҿ֦������y
Create Table UsersBook(
id bigint identity(1,1) primary key not null,--�y����
usersId bigint not null,--�����ϥΪ̸�ƪ��y����
[name] nvarchar(200) null,--���y�W��
removed bit not null--���O�R��
)

/*
�إ߸�ƪ��ݩʵ��ѡG
1.identity(1,1) => �y����
2.primary key => �]�w���ޭ�
3.default('') => �]�w�w�]��
*/

--�ϥ�TSql�s�W���
Alter Table UsersBook Add [pageCount] int default 0 not null

--�ܧ�S�w��쪺��ƫ��A
/*
�`�N�ƶ��G
�p�G����U�C��1�I�B�J���X�{�����H�U�r�ꪺ���~�T���A�h�������2�B�J�A�̧ǰ���B�J1��B�J3
--('DF__UsersBook__pageC__15502E78' �P ��Ʀ� 'pageCount' �̡ۨC)
*/

--1.�ܧ�����ƫ��A
Alter Table UsersBook Alter Column [pageCount] bigint not null

--2.�R������쪺�������
Alter Table UsersBook Drop CONSTRAINT DF__UsersBook__pageC__15502E78

--3.����R������������s�W�^��
ALTER TABLE UsersBook ADD CONSTRAINT DF__UsersBook__pageC__15502E78 DEFAULT 0 FOR [pageCount]

--�R�����(���R����������A�R�����)
Alter Table UsersBook Drop CONSTRAINT DF__UsersBook__pageC__15502E78
Alter Table UsersBook Drop Column [pageCount]

--���]�ѧO�W��
DBCC CHECKIDENT(TestUsers, RESEED, 2)

--�s�W���
Insert Into TestUsers Values('Shilvain','0912345678',0)
Insert Into TestUsers Values('Shilvain','0912345678',0)

--�s�W�@����ơA���w������쪺��ơA��l�����w�h�ϥιw�]��
Insert Into TestUsers (phone,removed) Values('0987654321',0)
Insert Into UsersBook Values(1,'�ڷ|�n�n��',0)
Insert Into UsersBook Values(1,'�Ѱm',0)
Insert Into UsersBook Values(2,'���ߪi�S�A�������Ы�',0)
Insert Into UsersBook Values(2,'���Q���סA�����M������',0)
Insert Into UsersBook Values(2,'�]�~���Q',0)

--��s���
Update TestUsers Set phone = '0912345679' where id = 1--�ק��ƪ�TestUsers�Aid ���� 1 �� phone ��쬰 '0912345679'

--�ä[�R�����
Delete From TestUsers Where id = 1--�R��id = 1�����

--�d�߸��
Select * From TestUsers
Select * From UsersBook

--���ƪ�d��(�ϥ�Join�BLeftJoin�BRightJoin)
--�̾a���ɸ��e���z�Ѯt�O�A���ɰѦҸ귽 => 
--https://www.google.com/search?q=join+left+join&rlz=1C1GCEU_zh-TWTW865TW927&hl=zh-TW&sxsrf=AOaemvKVRxMN7vU_Ov_DC5BCo02R-xas2g:1630912610297&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMhq_25unyAhUlBKYKHY49DE0Q_AUoAXoECAEQAw&biw=1920&bih=937#imgrc=IZyINc4AaLoOEM
Select * From UsersBook as ub
Join TestUsers As tu On tu.id = ub.usersId
where tu.[name] = 'Shilvain'

--����z����
Select * From TestUsers where [name] = ''--phone �Ȭ�empty
Select * From TestUsers where [name] like '%987%'--phone�Ȧ���987�s�򪺦r��
Select * From TestUsers where phone in ('0987654321','0912345679')--phone ���Ȧs�b��}�C��

--�l�d��(�q�`����ĳ�ϥΤl�d�ߡA�]���į���t)
--�d�߸�ƪ�TestUsers�A��� name ���� 'Shilvain' �� UsersBook ��ƪ����
Select * From UsersBook where usersId in (Select id From TestUsers where [name] = 'Shilvain')

--�Ƨ� (Order By �w�]�����W)
Select * From TestUsers Order By id--���W (Asc)
Select * From TestUsers Order By id Desc--���W

--Group By (�S�w���ۦP����Ƥ����X�Ӹs�աA�C�Ӹs�նȶǦ^�@�����)�A�d�Ҭ��p��U�ϥΪ̡A�U�۩Ҿ֦������y��
Select tu.id,Count(*) As '���y������' From UsersBook as ub
Join TestUsers As tu On tu.id = ub.usersId
Group By tu.id

------------------�`�Ψ��------------------

--�p��r����
Select LEN('123') As [Count]

--�૬-��ƭ�
Select Convert(int,'111') 
select Cast('111' as int)

--�૬-��r��
Select Convert(nvarchar(10),1230) 
Select Cast(1230 as nvarchar(10))

--�૬-��B�I��
Select Convert(decimal(6,2),'123.66') 
Select Cast('123.66' as decimal(6,2))

--�૬-����
Select Convert(datetime,'2021-09-06 14:30:16') 
Select Cast('2021-09-06 14:30:16' as datetime)

--�p���Ƶ���
Select Count(*) From TestUsers