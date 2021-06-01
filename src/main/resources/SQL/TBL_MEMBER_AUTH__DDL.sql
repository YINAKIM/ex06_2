--기존DB이용하는 방법 : 기존 사용자 테이블 참고해서 권한테이블만 하나 추가함


--이미 있었다치고 데이터 넣어둘 사용자정보 테이블
CREATE TABLE TBL_MEMBER(
    USERID VARCHAR2(50) NOT NULL PRIMARY KEY ,
    USERPW VARCHAR2(100) NOT NULL ,
    USERNAME VARCHAR2(100) NOT NULL,
    REGDATE DATE DEFAULT SYSDATE,
    UPDATEDATE DATE DEFAULT SYSDATE,
    ENABLED CHAR(1) DEFAULT '1');


CREATE TABLE TBL_MEMBER_AUTH(
    USERID VARCHAR2(50) NOT NULL ,
    AUTH VARCHAR2(50) NOT NULL ,
    CONSTRAINT FK_MEMBER_AUTH
        FOREIGN KEY (USERID) REFERENCES TBL_MEMBER(USERID));


SELECT * FROM TBL_MEMBER;
SELECT * FROM TBL_MEMBER_AUTH;

COMMIT;