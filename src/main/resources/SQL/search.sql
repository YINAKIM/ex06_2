
--[Part3-15/검색] AND와 OR연산자의 차이로 단일검색과 다중검색이 같은 검색조건으로 다른 결과나오는 것 확인하기


--[1] 단일항목 검색 : 10건
select * from (
                  SELECT
                      /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
                      ROWNUM ALIAS_RN
                       ,BNO ,TITLE ,CONTENT ,WRITER ,REGDATE ,UPDATEDATE
                  FROM TBL_BOARD
                 WHERE TITLE LIKE '%책%' --검색조건
                   AND ROWNUM <= 20
              ) where ALIAS_RN > 10;


--[2] 다중항목 검색
-- 검색(where)조건 2개 이상

-- 예상과 다르게 동작하는 SQL, 32,758건 나옴 : OR연산자보다 AND연산자가 우선순위가 높기때문에
select
*
from (
         SELECT
             /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
             ROWNUM ALIAS_RN
              ,BNO ,TITLE ,CONTENT ,WRITER ,REGDATE ,UPDATEDATE
         FROM TBL_BOARD
         WHERE TITLE LIKE '%책%' --검색조건1
            OR CONTENT LIKE '%책%'
           AND ROWNUM <= 20
         )
where ALIAS_RN > 10;
/*
   실행계획 보면
   "1 - filter("ALIAS_RN">10)"
   "3 - filter("TITLE" LIKE '%책%' OR "CONTENT" LIKE '%책%' AND ROWNUM<=20)"

   [우선순위 1] ROWNUM <= 20 이면서
   [우선순위 2] "TITLE" LIKE '%책%' OR "CONTENT" LIKE '%책%'
   이렇게 검색되니까 10건이 아니라 32,758건 나옴 -> 연산자 우선순위때문에 꼬여서 원하는 결과 안나옴
   (위에) 같은 LIKE '%책%' 의 단일 검색은 10건나옴

   ===> AND 연산자가 OR 연산자보다 먼저실행된다!!
   =======> AND랑 OR를 같이 쓰려면 ()사용해서 묶어줘야 우선 필터링된다
*/


--[3] (~OR~) 사용해서 우선검색시킨 정상결과 : 10건만 정상출력
select
    *
from (
         SELECT
             /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
             ROWNUM ALIAS_RN
              ,BNO ,TITLE ,CONTENT ,WRITER ,REGDATE ,UPDATEDATE
         FROM TBL_BOARD
         WHERE
               (TITLE LIKE '%책%' --검색조건1
            OR CONTENT LIKE '%책%')
             AND ROWNUM <= 20
     )
where ALIAS_RN > 10;
/*
    실행계획 보면
     1 - filter("ALIAS_RN">10)
     2 - filter(ROWNUM<=20)
     3 - filter("TITLE" LIKE '%책%' OR "CONTENT" LIKE '%책%')

    ==> OR조건을 ()로 감싸서
    AND ROWNUM <= 20 과  (~OR~)이 각각 처리되게 검색 : 정상검색됨
*/




