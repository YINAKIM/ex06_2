--아무 조건 없이 조회하는데 rownum만 적용해보기 : where조건 없기때문에 데이터는 섞인 상태 그대로 ROWNUM이 지정되어 나온다.
SELECT ROWNUM, BNO, TITLE
FROM TBL_BOARD;

/*
ROWNUM 은 123456...오름차순으로 나오는데
ROWNUM  BNO는 이렇게 뒤죽박죽나옴
1       1---> 우연
2       19
3       18---> 그냥 3번째로 꺼내진것 뿐***
4       113
5       15
6       20

=> 테이블에서 데이터를 가져온 후
*/


SELECT /*+ full(tbl_board)*/
       ROWNUM, BNO, TITLE
FROM TBL_BOARD
WHERE BNO < 20
ORDER BY BNO;
/* 이렇게 해보면
    1. 테이블 FULL스캔
    2. BNO < 20 --> 편의상.. 데이터 너무많아서
    3. ORDER BY BNO 했을 때 ROWNUM은
       BNO =18 에 붙긴하는데 뒤죽박죽나옴

   => ORDER BY가 제일 나중에 실행된다. ROWNUM도 예외없이 ORDER BY 가 제일나중!
*/


-- 힌트로 PK통한 인덱스 타고 검색 후 ROWNUM붙게 해보기
SELECT /*+ INDEX_ASC(TBL_BOARD PK_BOARD)*/
    ROWNUM, BNO, TITLE, CONTENT
from TBL_BOARD;
/*
    1. 테이블에서 /힌트/에 해당되는 인덱스를 기준으로 검색
    2. INDEX_ASC(TBL_BOARD PK_BOARD) 라서 BNO 오름차순으로 정렬
    3. 정렬 후 ROWNUM붙는데, 오름차순으로 붙었다

    ►►►►►►►► 가장 먼저 꺼낸 데이터가 ROWNUM=1 이다 !
    => ROWNUM은 테이블에 접근하는 순서를 의미한다.
    => 가장 최신 글, 조회수 많은 TOP5 등 실제 웹에서 ROWNUM을 사용할 때는 DESC된 상태에서 ROWNUM을 붙여야한다.
       (지금 PK에 지정된 SEQ값이 큰값이 가장 최근 업데이트된 데이터기때문)
*/


SELECT /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
    ROWNUM, BNO, TITLE, CONTENT
from TBL_BOARD;
/*
 INDEX_DESC 로 힌트 줌 -> PK_BOARD인 BNO값이 가장 큰 값을 가장 먼저 찾음 (ROWNUM 1붙음)
*/




--한페이지에 10줄씩 넣는다고하면
--ROWNUM값이 1~10 인 데이터가 1페이지에 들어가는 것
SELECT /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
    ROWNUM, BNO, TITLE, CONTENT
FROM TBL_BOARD
WHERE ROWNUM <=10;

/*
    BNO 값이 가장 큰 데이터 10건만 출력됨

    실행계획보면
    Plan hash value: 3303624827

------------------------------------------------------------------------------------------
| Id  | Operation                    | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |           |    10 |   630 |     4   (0)| 00:00:01 |
|*  1 |  COUNT STOPKEY               |           |       |       |            |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| TBL_BOARD |    10 |   630 |     4   (0)| 00:00:01 |
|   3 |    INDEX FULL SCAN DESCENDING| PK_BOARD  |   425K|       |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter(ROWNUM<=10) ===> 필터링조건으로 ROWNUM이 사용됨

*/




--같은 방식으로 2페이지 출력해보기 rownum>=10 && rownum <=20
SELECT /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
    ROWNUM, BNO, TITLE, CONTENT
FROM TBL_BOARD
WHERE ROWNUM >10 and rownum <= 20; -- 안나온다

/*
    안나오는 이유
    Plan hash value: 2657112392

-------------------------------------------------------------------------------------------
| Id  | Operation                     | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |           |    20 |  1260 |     4   (0)| 00:00:01 |
|*  1 |  COUNT STOPKEY                |           |       |       |            |          | ==> 여기서 검색하면서 ROWNUM 부여 ?
|*  2 |   FILTER                      |           |       |       |            |          | =====> 여기서 where 조건으로 ROWNUM이 무효화되고
|   3 |    TABLE ACCESS BY INDEX ROWID| TBL_BOARD |    20 |  1260 |     4   (0)| 00:00:01 | =====> 여기서 index로 테이블에 접근, 힌트보고 PK_BOARD값에 접근
|   4 |     INDEX FULL SCAN DESCENDING| PK_BOARD  |   425K|       |     3   (0)| 00:00:01 | =====> 근데 힌트에 INDEX_DESC니까 젤 큰값으로 접근
-------------------------------------------------------------------------------------------


Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter(ROWNUM<=20)
   2 - filter(ROWNUM>10)

    => 필터 1번으로 20번째 미만의 데이터는 가져왔는데 필터2번으로 10번째  이상을 못가져옴
    => ROWNUM은 데이터를 검색한 순서다. 그러니까 첫번째로 검색한 결과가 반드시 포함되어야 필터링했을 때 데이터를 가져올 수 있다.
    => 그래서 페이징할 때 ROWNUM조건에 1을 꼭 포함시티는 것
*/



SELECT /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
    ROWNUM, BNO, TITLE, CONTENT
FROM TBL_BOARD
WHERE ROWNUM <= 20; --나옴
/*
Plan hash value: 3303624827

------------------------------------------------------------------------------------------
| Id  | Operation                    | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |           |    20 |  1260 |     4   (0)| 00:00:01 |
|*  1 |  COUNT STOPKEY               |           |       |       |            |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| TBL_BOARD |    20 |  1260 |     4   (0)| 00:00:01 |
|   3 |    INDEX FULL SCAN DESCENDING| PK_BOARD  |   425K|       |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter(ROWNUM<=20)
*/


