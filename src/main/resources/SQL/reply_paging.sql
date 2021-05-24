--[Part4-17.6.1] 댓글 페이징을 위한 인덱스 설계
/*
댓글은 PK인 댓글번호가 아닌 FK인 글번호로 조회해야한다
왜? [PK인 댓글번호]로 조회하면 :  TBL_REPLY테이블과 TBL_BOARD 테이블을 풀스캔 후 정렬 [1]

[FK인 글번호]에 인덱스 생성 후
[인덱싱된 FK인 글번호]로 조회하면 : TBL_REPLY에서 인덱스로 먼저 찾아서 RANGE SCAN 하므로 실행시간 단축 [2]
*/


-- [1] 댓글PK로 조회해보기 (BNO=425999로 테스트)
SELECT * FROM TBL_REPLY WHERE BNO = 425999 ORDER BY RNO ASC; --350밀리초 (참고, 두번째 조회하니까 캐싱된걸로 조회해서 165ms나옴)
/*
--------------------------------------------------------------------------------
| Id  | Operation          | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |    11 |   605 |     4  (25)| 00:00:01 |
|   1 |  SORT ORDER BY     |           |    11 |   605 |     4  (25)| 00:00:01 | ===> 정렬
|*  2 |   TABLE ACCESS FULL| TBL_REPLY |    11 |   605 |     3   (0)| 00:00:01 | ===> TBL_REPLY FULL SCAN
--------------------------------------------------------------------------------
*/

--인덱스생성
CREATE INDEX IDX_REPLY
          ON TBL_REPLY (BNO DESC, RNO ASC);

select * from USER_INDEXES;

--[2] 인덱스를 이용한 페이징쿼리 (BNO=425999로 테스트)
SELECT /*+ INDEX(TBL_REPLY IDX_REPLY)*/
      ROWNUM RN
     ,BNO,RNO,REPLY,REPLYER,REPLYDATE,UPDATEDATE
  FROM TBL_REPLY
 WHERE BNO = 425999
   AND RNO > 0; --136밀리초 : ORDER BY 를 피해서 빨라짐
/*
------------------------------------------------------------------------------------------
| Id  | Operation                    | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |           |    11 |   605 |     2   (0)| 00:00:01 |
|   1 |  COUNT                       |           |       |       |            |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| TBL_REPLY |    11 |   605 |     2   (0)| 00:00:01 | ===> 정렬 없이 인덱스로 바로접근
|*  3 |    INDEX RANGE SCAN          | IDX_REPLY |     1 |       |     1   (0)| 00:00:01 | ===> RANGE SCAN
------------------------------------------------------------------------------------------
   3 - access(SYS_OP_DESCEND("BNO")=HEXTORAW('3CD4C39BFF')  AND "RNO">0)
       filter(SYS_OP_UNDESCEND(SYS_OP_DESCEND("BNO"))=425999)
*/

--[2]에서 ROWNUM을 이용했기때문에 알아서 RNO가 ASC로 나옴 ---> 인라인뷰에서 한번만 걸르면됨
-- 댓글 1페이지에 10개씩 출력하는데 2페이지출력한 쿼리
SELECT RN,RNO,BNO,REPLY,REPLYER,REPLYDATE,UPDATEDATE
 FROM(
    SELECT /*+ INDEX(TBL_REPLY IDX_REPLY)*/
        ROWNUM RN
         ,BNO,RNO,REPLY,REPLYER,REPLYDATE,UPDATEDATE
    FROM TBL_REPLY
    WHERE BNO = 425999
      AND RNO > 0
      AND ROWNUM <= 20
     )
WHERE RN > 10;
