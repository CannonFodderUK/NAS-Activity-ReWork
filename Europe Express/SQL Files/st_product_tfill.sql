SET DEFINE OFF;
CREATE TABLE ST_PRODUCT_TFILL
(
  PRODUCT_CODE   VARCHAR2(50 BYTE),
  MASK           VARCHAR2(20 BYTE),
  PROD_CODE_SEQ  NUMBER,
  BEGIN_DATE     DATE,
  ACTIVE_PAX     NUMBER
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
