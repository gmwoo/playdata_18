select * from emp;
select * from DEPT;
select * from student;
select * from PROFESSOR;
select * from employees;
select * from locations;
select * from department;

/* ���� �ε��� ���� �� */
CREATE UNIQUE INDEX idx_dept_name
ON department(dname);

/* ����� �ε��� ���� �� */
CREATE INDEX idx_stud_brithdate
ON student(birthdate);

/* ���� �ε��� ���� ��*/
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade);

/* DESCCENDING INDEX : Į������ ���� ������ ������ �����Ͽ� ���� �ε����� �����ϱ� ���� ��� */
CREATE INDEX fidx_stud_no_name
ON student(deptno DESC, name ASC);

/* �Լ� ��� �ε��� */
CREATE INDEX uppercase_idx ON emp (UPPER(ename));
SELECT * FROM emp WHERE UPPER(ename) = 'KING';

/* �Լ� ��� �ε��� �� */
CREATE INDEX idx_standard_weight ON student((height-100)*0.9);

/* �ε��� ���� ��� Ȯ�� 1 */
SELECT  deptno, dname
FROM    department
WHERE   dname = '�����̵���к�';

/*�ε��� ����*/
DROP INDEX IDX_DEPT_NAME; 

/*������ ��뿹 : �л����̺��� ������ '79/04/02'�� �л� �̸��� �˻��� ����� ���� �����θ� �м��Ͽ���*/
SELECT name, birthdate
FROM student
WHERE birthdate = '79/04/02';

DROP INDEX idx_stud_birthdate;

/* �ε��� ���� ��ȸ */
SELECT  index_name, uniqueness
FROM    user_indexes
WHERE   table_name = 'STUDENT';

/* �ε��� �籸�� - �ε����� ������ ���̺��� Į�� ���� ���� ���� �۾��� ���� �߻��Ͽ�, ���ʿ��ϰ�
������ �ε��� ���� ��带 �����ϴ� �۾� */
ALTER INDEX sutd_no_pk REBUILD;

/* ---- �� ---- */
CREATE view v_stud_dept101 as
        SELECT  studno, name, deptno
        FROM    student
        WHERE   deptno = 101;
SELECT * FROM v_stud_dept101;

/* ���� �� */
CREATE view v_stud_dept102
AS  SELECT  s.studno, s.name, s.grade, d.dname
    FROM    student s, department d
    WHERE   s.deptno = d.deptno and s.deptno = 102;
SELECT * from v_stud_dept102;

/* ���� �� - �Լ� ��� */
CREATE view v_prof_avg_sal
as  SELECT  deptno, sum(sal) sum_sal, avg(sal) av_sal
    FROM    professor
    group by deptno;
select * from v_prof_avg_sal;

/*�ζ��� ��(inline view)
  - FROM ������ �����ϴ� ���̺��� ũ�Ⱑ Ŭ ���, �ʿ��� ��� �÷������� ������ ������ �������Ͽ� ���ǹ��� ȿ���� ����
  - FROM ������ ���������� ����Ͽ� ������ �ӽ� ��
  ��뿹 : �ζ��κ並 ����Ͽ� �а����� �л����� ��� Ű�� ������, �а��̸��� ����϶�*/
SELECT dname, avg_height, avg_weight
FROM(SELECT deptno, avg(height) avg_height, avg(weight) avg_weight
     FROM student
     GROUP BY deptno) s, department d
WHERE s.deptno = d.deptno;

/* ---- ���� ---- */
/* �а��� �ִ�Ű�� ���ϰ� �ִ�Ű�� ���� �л���
�а���, �ִ�Ű, �̸�, Ű�� ����ϼ���.(����� �Ʒ�~)
�а���           �ִ�Ű    �̸�     Ű
-------------------------------------
��Ƽ�̵���а�	 177	������ 	177
��ǻ�Ͱ��а�	     186 	������	 	186
���ڰ��а�	     184	������		184 */
SELECT dname, max_height, s.name, s.height
FROM(SELECT deptno, max(height) max_height
     FROM student
     GROUP BY deptno) a, student s, department d
WHERE s.deptno = a.deptno
AND s.height = a.max_height
AND s.deptno = d.deptno;

/* �� ��ȸ */
SELECT  view_name, text
FROM    user_views;

/* ���� ���� - �並 ������ �⺻ ���̺��� ������ �����Ϳ��� ���� ���� ���� */
DROP VIEW v_stud_dept101;
DROP VIEW v_stud_dept102;

/* ---- ����� ���� ���� ---- */
/* ���� ���ǿ� �ο��� �ý��� ���� ��ȸ */
SELECT * FROM session_privs;

/* ��ü ���� �ο� �� - select ���� */
CREATE USER tiger IDENTIFIED BY tiger123
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp;

/* 1. encore��� ���̺� �����̽��� �����
   2. encore/encore123 �̶�� ������ ���̺� �����̽��� encore/temp�� ����ϵ���
   3. enocre�� hr�� student ���̺��� select �ϵ��� �Ͻÿ� */
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

/* ��(role) */
conn system/manager

create role hr_clerk;
create role hr_mgr
identified by manager;

/* ���Ǿ�(synonym) */
    -- �ٸ� ����ڰ� ������ ��ü�� ��ȸ�� ������ �������� ���̵� ��ü �̸� �տ� ÷��
    -- ��, ��ü�� ��ȸ�� ������ ��ü�� �����ڸ� ������ �����ϴ� ����� �ſ� ���ŷο�
    -- ���Ǿ�� �ϳ��� ��ü�� ���� �ٸ� �̸��� �����ϴ� ���

/* ���� ���Ǿ� ���� �� */
    -- ���� ���Ǿ �����ϱ� ���� sys �Ǵ� system���� ����
    -- ���뵿�Ǿ�(Pub_project) ����
    -- �����(hr)�� ������ ���Ǿ �������� �ʾƵ� ���� ���Ǿ ���� system ������ project ���̺� ��ȸ

/* ���Ǿ� ���� */
    -- ����: DROP SYNONYM synonym;
    -- 

/* ---- ������ ���ǹ� ---- */
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

/* ������ ���� */
SELECT  LEVEL
        , LPAD(' ', (LEVEL-1)*2) || dname ������
FROM    department
START WITH  dname = '��������'
CONNECT BY PRIOR    deptno = college;

/* ������ ���ǹ��� ����Ͽ� �μ� ���̺��� dname Į���� �ܴ�, �к�, �а� ������ top-down ������
���� ������ ���. ��, '�����̵���к�'�� �����ϰ� ��� */
SELECT  deptno, college, dname, loc
FROM    department
WHERE   dname != '�����̵���к�'
START WITH college is null
CONNECT BY PRIOR deptno = college;

/*  ������ ���ǹ��� ����Ͽ� �μ� ���̺��� dname Į���� �ܴ�, �к�, �а� ������ top-down ������
���� ������ ���. ��, '�����̵���к�'�� '�����̵���к�'�� ���� ��� �а��� �����ϰ� ��� */
SELECT  deptno, college, dname, loc
FROM    department
START WITH college is null
CONNECT BY PRIOR deptno = college
AND dname != '�����̵���к�';

/* CONNECT_BY_ROOT : ������ ���ǹ��� ����ؼ� LEVLE 1�� �ֻ����ο��� ������ ���� �� ���� */
SELECT  LPAD(' ', 4*(LEVEL-1)) || ename �����
        , empno ���
        , CONNECT_BY_ROOT empno �ֻ������
        , LEVEL
FROM    emp
START WITH job = UPPER('PRESIDENT')
CONNECT BY PRIOR empno = mgr;

/* CONNECT_BY_ISLEAF : ������ ���� ���θ� ��ȯ. ������ ���� 1, �ƴϸ� 0*/
SELECT  LPAD(' ', 4*(LEVEL-1)) || ename �����
        , empno ���
        , CONNECT_BY_ISLEAF Leaf_YN
        , LEVEL
FROM    emp
START WITH job = UPPER('PRESIDENT')
CONNECT BY PRIOR empno = mgr;

/* SYS_CONNECT_BY_PATH : ���� Row������ PATH ������ ���� ���� �� ���� */
SELECT  LPAD(' ', 4*(LEVEL-1)) || ename �����
        , empno ���
        , SYS_CONNECT_BY_PATH(ename, '/') PATH
FROM    emp
START WITH job = UPPER('PRESIDENT')
CONNECT BY PRIOR empno = mgr;

/* ORDER SIBLINGS BY*/
SELECT  LPAD(' ', 4*(LEVEL-1)) || ename �����
        , empno ename2, empno ���, level
FROM    emp
START WITH job = UPPER('PRESIDENT')
CONNECT BY NOCYCLE PRIOR empno = mgr
ORDER SIBLINGS BY ename;

/* ---- ���� ������ ���̽� ������ ---- */


/* ---- ���� ---- */
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
-------------����� ��ȯ--------------------------------
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
