SET DEFINE OFF;
CREATE TABLE F_SUBSCRIPTION_HISTORY
(
  HISTORY_ID        NUMBER(18),
  LIST_ID           VARCHAR2(20 BYTE),
  RECIPIENT         VARCHAR2(793 BYTE),
  SUB_DATE          DATE,
  SUB_PROCESS       VARCHAR2(150 BYTE),
  SUB_EVENT         VARCHAR2(150 BYTE),
  SUB_ORIGIN        VARCHAR2(150 BYTE),
  UNSUB_DATE        DATE,
  UNSUB_PROCESS     VARCHAR2(150 BYTE),
  UNSUB_EVENT       VARCHAR2(150 BYTE),
  UNSUB_ORIGIN      VARCHAR2(150 BYTE),
  SUB_IP_ADDRESS    VARCHAR2(100 BYTE),
  UNSUB_IP_ADDRESS  VARCHAR2(100 BYTE)
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


CREATE UNIQUE INDEX F_SUBSCRIPTION_HISTORY_PK ON F_SUBSCRIPTION_HISTORY
(HISTORY_ID)
LOGGING
TABLESPACE DTW_ADV_TABLES
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


ALTER TABLE F_SUBSCRIPTION_HISTORY ADD (
  CONSTRAINT F_SUBSCRIPTION_HISTORY_PK
  PRIMARY KEY
  (HISTORY_ID)
  USING INDEX F_SUBSCRIPTION_HISTORY_PK
  ENABLE VALIDATE);
