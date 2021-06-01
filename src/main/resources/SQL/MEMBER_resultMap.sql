--resultMap으로 가져올 JOIN쿼리 짜기

         SELECT MEM.USERID
               ,USERPW
               ,ENABLED
               ,REGDATE
               ,UPDATEDATE
               ,AUTH
           FROM TBL_MEMBER MEM
LEFT OUTER JOIN TBL_MEMBER_AUTH AUTH
             ON MEM.USERID = auth.USERID
          WHERE MEM.USERID = 'admin90';