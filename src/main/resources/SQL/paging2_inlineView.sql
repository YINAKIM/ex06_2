-- ROWNUM으로 가져온 데이터에서 1페이지분량 빼고 2페이지만 출력하기 : 인라인뷰 사용
-- SELECT문 안쪽 FROM에 다시 SELECT :
/*
 SELECT
   FROM (SELECT ROWNUM으로 가져온 1,2페이지 전체데이터)
  WHERE ROWNUM > 10 ; ------> ROWNUM은 반드시 언제나 1을 포함해야하므로 전체where조건(제일바깥족 where)에 넣음
*/

select bno,title,content,writer
from
    (SELECT /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
            ROWNUM rn, BNO, TITLE, CONTENT, WRITER
       FROM TBL_BOARD
      WHERE ROWNUM <= 20)
where rn > 10 ;






--[1] 나옴 ( ROWNUM 11 ~ 20 )
select alias_rn, bno,title,content,writer
from
    (SELECT /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
            ROWNUM alias_rn, BNO, TITLE, CONTENT, WRITER
       FROM TBL_BOARD
      WHERE ROWNUM <= 20)
where alias_rn > 10 ;


--[2] 안나옴
select ROWNUM, bno,title,content,writer
from
    (SELECT /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
         ROWNUM, BNO, TITLE, CONTENT, WRITER
     FROM TBL_BOARD
     WHERE ROWNUM <= 20)
where ROWNUM > 10 ;

/*
    인라인뷰 안에서 검색한 ROWNUM범위중에 바깥쪽 where 조건을 걸러야되는데
    ROWNUM이라는 말은 오라클이 이미 알고있는 변수다

    → 인라인뷰안의 ROWNUM결과가 아닌 오라클이 알고있는 ROWNUM으로 인식한 것 !

    그렇기때문에 인라인뷰 안쪽에서 alias를 주고 그 alias로 where조건을 검색하면
    alias_rn이라고 별명이 붙은 바로 그 ROWNUM 범위 중에서 where조건을 걸러내는 것
*/


-- 검색데이터 같게 나오는지 확인
SELECT
    ALIAS_RN
     ,BNO
     ,TITLE
     ,CONTENT
     ,WRITER
     ,REGDATE
     ,UPDATEDATE
FROM  (
          SELECT
              /*+ INDEX_DESC(TBL_BOARD PK_BOARD)*/
              ROWNUM ALIAS_RN
               ,BNO
               ,TITLE
               ,CONTENT
               ,WRITER
               ,REGDATE
               ,UPDATEDATE
          FROM TBL_BOARD
          WHERE ROWNUM <= 4 * 10
      )
WHERE ALIAS_RN > (4-1)*10;

/*
  [@Test 돌려서 얻은 결과 (3페이지)-log]
    |---------|-------|
    |alias_rn |bno    |
    |---------|-------|
    |[unread] |425975 |
    |[unread] |425974 |
    |[unread] |425973 |
    |[unread] |425972 |
    |[unread] |425971 |
    |[unread] |425970 |
    |[unread] |425969 |
    |[unread] |425968 |
    |[unread] |425967 |
    |[unread] |425966 |

  [쿼리직접날려서 얻은 결과(3페이지)]
  ALIAS_RN     BNO
        21, 425975
        22, 425974
        23, 425973
        24, 425972
        25, 425971
        26, 425970
        27, 425969
        28, 425968
        29, 425967
        30, 425966

  ==> 일치하는거 확인

    [@Test 돌려서 얻은 결과(4페이지) - 중간에 빠지는 데이터 없이 연결되는 PK값들로 불러와지는지]
  --> 3페이지의 30번째, 데이터의 PK값=425966 ~ 4페이지의, 31번째 데이터의 PK값= 524965 : 연결확인 OK
    |---------|-------|
    |alias_rn |bno    |
    |---------|-------|
    |[unread] |425965 |---> 3페이지의 30번째 (ROWNUM) 데이터의 PK값과 연결확인
    |[unread] |425964 |
    |[unread] |425963 |
    |[unread] |425962 |
    |[unread] |425961 |
    |[unread] |425960 |
    |[unread] |425959 |
    |[unread] |425958 |
    |[unread] |425957 |
    |[unread] |425956 |
    |---------|-------|

    [쿼리직접날려서 얻은 결과(4페이지) - 중간에 빠지는 데이터 없이 연결되는 PK값들로 불러와지는지]
    --> 3페이지의 30번째, 데이터의 PK값=425966 ~ 4페이지의, 31번째 데이터의 PK값= 524965 : 연결확인 OK
  ALIAS_RN     BNO
        31 ,425965 ---> 3페이지의 30번째 (ROWNUM) 데이터의 PK값과 연결확인
        32 ,425964
        33 ,425963
        34 ,425962
        35 ,425961
        36 ,425960
        37 ,425959
        38 ,425958
        39 ,425957
        40 ,425956


*/