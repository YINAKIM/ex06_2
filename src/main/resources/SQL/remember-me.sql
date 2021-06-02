-- [chap 35]자동로그인
-- 로그인되었던 정보를 DB에 기록해뒀다가 재방문시 세션에 정보가 없으면 DB를 이용해서 조회, 조회된정보를 사용하는 방법 : 서버의 메모리에만 저장하는것보다 안정적

--스프링 시큐리티 공식 "로그인정보 유지용 테이블"
CREATE TABLE PERSISTENT_LOGINS(
    USERNAME VARCHAR2(64) NOT NULL,
    SERIES VARCHAR2(64) PRIMARY KEY,
    TOKEN VARCHAR2(64) NOT NULL,
    LAST_USED TIMESTAMP NOT NULL
);

SELECT * FROM PERSISTENT_LOGINS;

COMMIT;