SET DEFINE OFF;
CREATE TABLE F_BOOKING_COMPONENT
(
  BREF_SK                  NUMBER(22),
  DETAILS_UPDATED_DATE     NUMBER(8),
  BOOKING_REF              NUMBER(18),
  SERVICE_SEQ              NUMBER(18),
  PRODUCT_CODE             VARCHAR2(50 BYTE),
  SERVICE_TYPE             VARCHAR2(50 BYTE),
  SERVICE_DATE_ID          NUMBER(8),
  SERVICE_DURATION         INTEGER,
  SERVICE_ID               VARCHAR2(50 BYTE),
  SUPPLIER_COMM_FORM       VARCHAR2(200 BYTE),
  LOCAL_SUPPLIER_COMM      NUMBER(18,2),
  LOCAL_SUPPLIER_COMM_REC  NUMBER(18,2),
  MARKET_CODE              VARCHAR2(20 BYTE),
  BLOCK_CODE               VARCHAR2(50 BYTE),
  QUANTITY                 INTEGER,
  COST_EXCH                NUMBER(18,2),
  LOCAL_COST               NUMBER(18,2),
  LOCAL_COST_TAX           NUMBER(18,2),
  LOCAL_COST_GST           NUMBER(18,2),
  QUOTE_PRICE              NUMBER(18,2),
  QUOTE_DISPLAY_PRICE      NUMBER(18,2),
  QUOTE_PRICE_TAX          NUMBER(18,2),
  QUOTE_PRICE_GST          NUMBER(18,2),
  QUOTE_PRICE_ENC          NUMBER(18,2),
  COMM_PER                 NUMBER(18,4),
  MAX_COMM                 NUMBER(18,2),
  TTL_LOCAL_COST           NUMBER(18,2),
  TTL_LOCAL_COST_TAX       NUMBER(18,2),
  TTL_LOCAL_COST_GST       NUMBER(18,2),
  TTL_QUOTE_PRICE          NUMBER(18,2),
  TTL_QUOTE_DISPLAY_PRICE  NUMBER(18,2),
  TTL_QUOTE_PRICE_TAX      NUMBER(18,2),
  TRANSACTION_DATE_ID      NUMBER(8),
  REV_IND                  CHAR(1 BYTE),
  CURRENT_IND              CHAR(1 BYTE)
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


CREATE UNIQUE INDEX BOOK_COMPONENT$PK ON F_BOOKING_COMPONENT
(DETAILS_UPDATED_DATE, BOOKING_REF, SERVICE_SEQ, TRANSACTION_DATE_ID)
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


ALTER TABLE F_BOOKING_COMPONENT ADD (
  CONSTRAINT BOOK_COMPONENT$PK
  PRIMARY KEY
  (DETAILS_UPDATED_DATE, BOOKING_REF, SERVICE_SEQ, TRANSACTION_DATE_ID)
  USING INDEX BOOK_COMPONENT$PK
  ENABLE VALIDATE);
