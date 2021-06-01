
--(p645)스프링 시큐리티의 지정된 테이블을 생성하는 DDL
-- 시큐리티에서 [사용자id는 username이다] 주의

--사용자정보
CREATE TABLE USERS(
     USERNAME VARCHAR2(50) NOT NULL PRIMARY KEY,
     PASSWORD VARCHAR2(50) NOT NULL,
     ENABLED CHAR(1) DEFAULT '1'
);

--권한
CREATE TABLE AUTHORITIES(
    USERNAME VARCHAR2(50) NOT NULL,
    AUTHORITY VARCHAR2(50) NOT NULL,
    CONSTRAINT FK_AUTHORITIES_USERS
        FOREIGN KEY (USERNAME)
        REFERENCES USERS(USERNAME)
);

-- 사용자id
CREATE UNIQUE INDEX IX_AUTH_USERNAME ON AUTHORITIES(USERNAME, AUTHORITY);

INSERT INTO USERS(USERNAME, PASSWORD) VALUES ('USER00','PW00');
INSERT INTO USERS(USERNAME, PASSWORD) VALUES ('MEMBER00','PW00');
INSERT INTO USERS(USERNAME, PASSWORD) VALUES ('ADMIN00','PW00');

INSERT INTO AUTHORITIES(USERNAME, AUTHORITY) VALUES ('USER00','ROLE_USER');
INSERT INTO AUTHORITIES(USERNAME, AUTHORITY) VALUES ('MEMBER00','ROLE_MANAGER');--MEMBER도 권한은 MANAGER 주의!
INSERT INTO AUTHORITIES(USERNAME, AUTHORITY) VALUES ('ADMIN00','ROLE_MANAGER');
INSERT INTO AUTHORITIES(USERNAME, AUTHORITY) VALUES ('ADMIN00','ROLE_ADMIN');
--대소문잨ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋvarchar에 값으로 넣는걸 대문자로 했으니 대문자로 로그인해야짘ㅋㅋㅋㅋㅋㅋㅋㅋ바보같이 소문자로 하니까
/*
|---------|---------|--------|
|username |password |enabled |
|---------|---------|--------|
|         |         |        |
|---------|---------|--------|
이렇게 나오니까 계정없다고 계속 로그인안됬음 ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ

|---------|---------|--------|
|username |password |enabled |
|---------|---------|--------|
|ADMIN00  |PW00     |true    |
|---------|---------|--------|
이렇게 나와야되는데 ㅋㅋㅋㅋㅋㅋㅋ 개웃기넼ㅋㅋㅋㅋ
*/
select * from users;
select * from AUTHORITIES;

commit;

--ENABLED 를 ENABLE이라고 써서 로그인해도 컬럼명이 틀렸으니까 계속
-- "ENABLED": invalid identifier나옴 ㅋㅋㅋㅋㅋㅋ

--alter table USERS rename column ENABLE to ENABLED;
-- commit;