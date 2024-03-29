SET DEFINE OFF;
CREATE TABLE INTEGRATION_CONTROL_HISTORY
(
  TARGET_TABLE_ABBREV     NVARCHAR2(30)         NOT NULL,
  TARGET_TABLE_NAME       VARCHAR2(50 BYTE)     NOT NULL,
  LOAD_TABLE_ABBREV       NVARCHAR2(30)         NOT NULL,
  DEPENDENT_TABLE_ABBREV  VARCHAR2(20 BYTE),
  PRIORITY                INTEGER               NOT NULL,
  FTP_REQUIRED            CHAR(1 BYTE)          NOT NULL,
  FTP_START               DATE,
  FTP_END                 DATE,
  FTP_COMPLETE            CHAR(1 BYTE),
  LOAD_REQUIRED           CHAR(1 BYTE)          NOT NULL,
  LOAD_START              DATE,
  LOAD_END                DATE,
  LOAD_COMPLETE           CHAR(1 BYTE),
  MERGE_REQUIRED          CHAR(1 BYTE)          NOT NULL,
  MERGE_START             DATE,
  MERGE_END               DATE,
  MERGE_COMPLETE          CHAR(1 BYTE),
  INTEGRATION_REQUIRED    CHAR(1 BYTE)          NOT NULL,
  INTEGRATION_START       DATE,
  INTEGRATION_END         DATE,
  INTEGRATION_COMPLETE    CHAR(1 BYTE),
  NO_OF_ERROR_RECORDS     INTEGER,
  SOURCE_FILE_PREFIX      VARCHAR2(30 BYTE)     NOT NULL,
  SOURCE_FILE_SUFFIX      VARCHAR2(20 BYTE)     NOT NULL
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
