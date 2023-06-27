select * from emp;
select * from DEPT;
select * from student;
select * from PROFESSOR;
select * from employees;
select * from locations;
select * from department;

/* 고유 인덱스 생성 예 */
CREATE UNIQUE INDEX idx_dept_name
ON department(dname);

/* 비고유 인덱스 생성 예 */
CREATE INDEX idx_stud_brithdate
ON student(birthdate);

/* 결합 인덱스 생성 예*/
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade);

/* DESCCENDING INDEX : 칼럼별로 정렬 순서를 별도로 지정하여 결합 인덱스를 생성하기 위한 방법 */
CREATE INDEX fidx_stud_no_name
ON student(deptno DESC, name ASC);

/* 함수 기반 인덱스 */
CREATE INDEX uppercase_idx ON emp (UPPER(ename));
SELECT * FROM emp WHERE UPPER(ename) = 'KING';

/* 함수 기반 인덱스 예 */
CREATE INDEX idx_standard_weight ON student((height-100)*0.9);

/* 인덱스 실행 경로 확인 1 */
SELECT  deptno, dname
FROM    department
WHERE   dname = '정보미디어학부';

/*인덱스 삭제*/
DROP INDEX IDX_DEPT_NAME; 

/*실행경로 사용예 : 학생테이블에서 생일이 '79/04/02'인 학생 이름을 검색한 결과에 대한 실행경로를 분석하여라*/
SELECT name, birthdate
FROM student
WHERE birthdate = '79/04/02';

DROP INDEX idx_stud_birthdate;

/* 인덱스 정보 조회 */
SELECT  index_name, uniqueness
FROM    user_indexes
WHERE   table_name = 'STUDENT';

/* 인덱스 재구성 - 인덱스를 정의한 테이블의 칼럼 값에 대해 변경 작업이 자주 발생하여, 불필요하게
생성된 인덱스 내부 노드를 정리하는 작업 */
ALTER INDEX sutd_no_pk REBUILD;

/* ---- 뷰 ---- */
CREATE view v_stud_dept101 as
        SELECT  studno, name, deptno
        FROM    student
        WHERE   deptno = 101;
SELECT * FROM v_stud_dept101;

/* 복합 뷰 */
CREATE view v_stud_dept102
AS  SELECT  s.studno, s.name, s.grade, d.dname
    FROM    student s, department d
    WHERE   s.deptno = d.deptno and s.deptno = 102;
SELECT * from v_stud_dept102;

/* 복합 뷰 - 함수 사용 */
CREATE view v_prof_avg_sal
as  SELECT  deptno, sum(sal) sum_sal, avg(sal) av_sal
    FROM    professor
    group by deptno;
select * from v_prof_avg_sal;

/*인라인 뷰(inline view)
  - FROM 절에서 참조하는 테이블의 크기가 클 경우, 필요한 행과 컬럼만으로 구성된 집합을 재정의하여 질의문을 효율적 구정
  - FROM 절에서 서브쿼리를 사용하여 생성한 임시 뷰
  사용예 : 인라인뷰를 사용하여 학과별로 학생들의 평균 키와 몸무게, 학과이름을 출력하라*/
SELECT dname, avg_height, avg_weight
FROM(SELECT deptno, avg(height) avg_height, avg(weight) avg_weight
     FROM student
     GROUP BY deptno) s, department d
WHERE s.deptno = d.deptno;

/* ---- 문제 ---- */
/* 학과별 최대키를 구하고 최대키를 가진 학생의
학과명, 최대키, 이름, 키를 출력하세요.(결과는 아래~)
학과명           최대키    이름     키
-------------------------------------
멀티미디어학과	 177	오유석 	177
컴퓨터공학과	     186 	서재진	 	186
전자공학과	     184	조명훈		184 */
SELECT dname, max_height, s.name, s.height
FROM(SELECT deptno, max(height) max_height
     FROM student
     GROUP BY deptno) a, student s, department d
WHERE s.deptno = a.deptno
AND s.height = a.max_height
AND s.deptno = d.deptno;

/* 뷰 조회 */
SELECT  view_name, text
FROM    user_views;

/* 뷰의 삭제 - 뷰를 정의한 기본 테이블의 구조나 데이터에는 전혀 영향 없음 */
DROP VIEW v_stud_dept101;
DROP VIEW v_stud_dept102;

/* ---- 사용자 권한 제어 ---- */
/* 현재 세션에 부여된 시스템 권한 조회 */
SELECT * FROM session_privs;

/* 객체 권한 부여 예 - select 권한 */
CREATE USER tiger IDENTIFIED BY tiger123
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp;

/* 1. encore라는 테이블 스페이스를 만들고
   2. encore/encore123 이라는 유저가 테이블 스페이스는 encore/temp를 사용하도록
   3. enocre가 hr의 student 테이블을 select 하도록 하시오 */
conn system/manager
CREATE tablespace encore
datafile 'C:\oraclexe\app\oracle\oradata\XE\encore.dbf' size 100m;
CREATE USER encore IDENTIFIED BY encore123
DEFAULT TABLESPACE encore
TEMPORARY TABLESPACE temp;
GRANT connect, resource to encore;
conn hr/hr
GRANT SELECT ON hr.student TO encore;
conn encore/encore123
select*from hr.student;

/* 롤(role) */
conn system/manager

create role hr_clerk;
create role hr_mgr
identified by manager;

/* 동의어(synonym) */
    -- 다른 사용자가 소유한 객체를 조회할 때에는 소유자의 아이디를 객체 이름 앞에 첨부
    -- 즉, 객체를 조회할 때마다 객체의 소유자를 일일이 지정하는 방법은 매우 번거로움
    -- 동의어는 하나의 객체에 대해 다른 이름을 정의하는 방법

/* 공용 동의어 생성 예 */
    -- 공용 동의어를 생성하기 위해 sys 또는 system으로 접속
    -- 공용동의어(Pub_project) 생성
    -- 사용자(hr)가 별도로 동의어를 생성하지 않아도 공용 동의어에 의해 system 소유의 project 테이블 조회

/* 동의어 삭제 */
    -- 사용법: DROP SYNONYM synonym;
    -- 

/* ---- 계층적 질의문 ---- */
/* Top down */
SELECT  deptno, dname, college
FROM    department
START WITH  deptno = 10
CONNECT BY PRIOR    deptno = college;

/* bottom up */
SELECT  deptno, dname, college
FROM    department
START WITH  deptno = 102
CONNECT BY PRIOR    college = deptno;

/* 레벨별 구분 */
SELECT  LEVEL
        , LPAD(' ', (LEVEL-1)*2) || dname 조직도
FROM    department
START WITH  dname = '공과대학'
CONNECT BY PRIOR    deptno = college;

/* 계층적 질의문을 사용하여 부서 테이블에서 dname 칼럼을 단대, 학부, 학과 순으로 top-down 형식의
계층 구조로 출력. 단, '정보미디어학부'를 제외하고 출력 */
SELECT  deptno, college, dname, loc
FROM    department
WHERE   dname != '정보미디어학부'
START WITH college is null
CONNECT BY PRIOR deptno = college;

/*  계층적 질의문을 사용하여 부서 테이블에서 dname 칼럼을 단대, 학부, 학과 순으로 top-down 형식의
계층 구조로 출력. 단, '정보미디어학부'와 '정보미디어학부'에 속한 모든 학과를 제외하고 출력 */
SELECT  deptno, college, dname, loc
FROM    department
START WITH college is null
CONNECT BY PRIOR deptno = college
AND dname != '정보미디어학부';

/* CONNECT_BY_ROOT : 계층적 질의문을 사용해서 LEVLE 1인 최상위로우의 정보를 얻을 수 있음 */
SELECT  LPAD(' ', 4*(LEVEL-1)) || ename 사원명
        , empno 사번
        , CONNECT_BY_ROOT empno 최상위사번
        , LEVEL
FROM    emp
START WITH job = UPPER('PRESIDENT')
CONNECT BY PRIOR empno = mgr;

/* CONNECT_BY_ISLEAF : 최하위 레벨 여부를 반환. 최하위 레벨 1, 아니면 0*/
SELECT  LPAD(' ', 4*(LEVEL-1)) || ename 사원명
        , empno 사번
        , CONNECT_BY_ISLEAF Leaf_YN
        , LEVEL
FROM    emp
START WITH job = UPPER('PRESIDENT')
CONNECT BY PRIOR empno = mgr;

/* SYS_CONNECT_BY_PATH : 현재 Row까지의 PATH 정보를 쉽게 얻어올 수 있음 */
SELECT  LPAD(' ', 4*(LEVEL-1)) || ename 사원명
        , empno 사번
        , SYS_CONNECT_BY_PATH(ename, '/') PATH
FROM    emp
START WITH job = UPPER('PRESIDENT')
CONNECT BY PRIOR empno = mgr;

/* ORDER SIBLINGS BY*/
SELECT  LPAD(' ', 4*(LEVEL-1)) || ename 사원명
        , empno ename2, empno 사번, level
FROM    emp
START WITH job = UPPER('PRESIDENT')
CONNECT BY NOCYCLE PRIOR empno = mgr
ORDER SIBLINGS BY ename;

/* ---- 원격 데이터 베이스 엑세스 ---- */


/* ---- 문제 ---- */
--1.
SELECT e.deptno, d.dname, m.m_sal as sal
FROM emp e
JOIN dept d
ON d.deptno = e.deptno
JOIN
        (SELECT deptno, max(sal) as m_sal
        FROM emp
        GROUP BY deptno) m
ON d.deptno = m.deptno
WHERE e.sal = m.m_sal;
--2.
CREATE TABLE emp1 AS
SELECT empno, ename, deptno
FROM emp;
ALTER TABLE emp1
RENAME COLUMN empno TO ID;
ALTER TABLE emp1
RENAME COLUMN ename TO LAST_NAME;
ALTER TABLE emp1
RENAME COLUMN deptno TO DEPT_ID;
select * from emp1;
--3.
ALTER TABLE emp1
MODIFY LAST_NAME  VARCHAR2(30);
-------------사용자 전환--------------------------------
--4.
CREATE TABLE EMPLOYEE(
ID NUMBER(7),
LAST_NAME VARCHAR(25),
FIRST_NAME VARCHAR(25),
DERP_ID NUMBER(7));
INSERT INTO EMPLOYEE values( 123, 'KIM', 'CHI', 1111111);
--5.
CREATE PUBLIC SYNONYM pub_employee FOR employee;
--6.
GRANT SELECT ON employee TO HR;
--7.
DROP PUBLIC SYNONYM pub_employee;
