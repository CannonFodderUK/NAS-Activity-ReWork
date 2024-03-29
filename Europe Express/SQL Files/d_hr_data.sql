SET DEFINE OFF;
CREATE TABLE D_HR_DATA
(
  EMPLOYEENO      CHAR(20 BYTE),
  PAYDATE         CHAR(50 BYTE),
  DEPARTMENT      CHAR(20 BYTE),
  DEPARTMENTNAME  CHAR(60 BYTE),
  FIRSTNAME       CHAR(50 BYTE),
  LASTNAME        CHAR(50 BYTE),
  HOURLYRATE      CHAR(20 BYTE),
  ANNUALSALARY    CHAR(50 BYTE),
  INCDOLLARS      CHAR(50 BYTE),
  ADJUSTHOURS     CHAR(50 BYTE),
  BONUSDOLLARS    CHAR(50 BYTE),
  FUNERALHOURS    CHAR(50 BYTE),
  HOLIDAYHOURS    CHAR(50 BYTE),
  INCENTDOLLARS   CHAR(50 BYTE),
  JURYHOURS       CHAR(50 BYTE),
  MISCHOURS       CHAR(50 BYTE),
  MISCDOLLARS     CHAR(50 BYTE),
  OVERTIMEHOURS   CHAR(50 BYTE),
  PTOHOURS        CHAR(50 BYTE),
  REGHOURS        CHAR(50 BYTE),
  SALHOURS        CHAR(50 BYTE),
  WKNMGRHOURS     CHAR(50 BYTE),
  WKNMGROTHOURS   CHAR(50 BYTE),
  PAIDGROSSWAGES  CHAR(50 BYTE),
  USERID          CHAR(50 BYTE),
  HIRE            CHAR(50 BYTE),
  IS_TYPE         CHAR(50 BYTE),
  MANAGER         CHAR(50 BYTE),
  GENDER          CHAR(50 BYTE)
)
TABLESPACE DTW_ADV_TABLES
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
