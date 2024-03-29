SET DEFINE OFF;
CREATE TABLE F_BOOKING
(
  BREF_SK                 NUMBER(15),
  BOOKING_REF             NUMBER(18),
  DETAILS_UPDATED_DATE    NUMBER(8),
  PAX                     INTEGER,
  COMPANY_ID              VARCHAR2(50 BYTE),
  BRAND_ID                VARCHAR2(10 BYTE),
  MARKET_CODE             VARCHAR2(20 BYTE),
  BOOKING_PRODUCT_CODE    VARCHAR2(50 BYTE),
  CUSTOMER_ID             VARCHAR2(15 BYTE),
  CONTACT_ID              INTEGER,
  BOOKING_STATUS          VARCHAR2(50 BYTE),
  DEPARTURE_DATE_ID       NUMBER(8),
  CANCEL_DATE_ID          NUMBER(8),
  BOOKING_DATE_ID         NUMBER(8),
  EXPIRED_OPTION_DATE_ID  NUMBER(8),
  FINAL_PAYMENT_DATE_ID   NUMBER(8),
  CURRENCY                VARCHAR2(3 BYTE),
  EXCHANGE_RATE           FLOAT(126),
  DEPOSIT                 NUMBER(18,2),
  BASE_COST               NUMBER(18,2),
  BASE_COST_TAX           NUMBER(18,2),
  QUOTE_PRICE             NUMBER(18,2),
  QUOTE_PRICE_TAX         NUMBER(18,2),
  QUOTE_PRICE_GST         NUMBER(18,4),
  QUOTE_COMM              NUMBER(18,2),
  QUOTE_NET_DUE           NUMBER(18,2),
  QUOTE_RECIEVED          NUMBER(18,2),
  QUOTE_BALANCE_DUE       NUMBER(18,2),
  LOCAL_ACCOM             NUMBER(18,2),
  QUOTE_ACCOM             NUMBER(18,2),
  LOCAL_AIR               NUMBER(18,2),
  QUOTE_AIR               NUMBER(18,2),
  LOCAL_ANC               NUMBER(18,2),
  QUOTE_ANC               NUMBER(18,2),
  LOCAL_EXTRA             NUMBER(18,2),
  QUOTE_EXTRA             NUMBER(18,2),
  LOCAL_INSUR             NUMBER(18,2),
  QUOTE_INSUR             NUMBER(18,2),
  LOCAL_LAND              NUMBER(18,2),
  QUOTE_LAND              NUMBER(18,2),
  LOCAL_MISC              NUMBER(18,2),
  QUOTE_MISC              NUMBER(18,2),
  LOCAL_PKG               NUMBER(18,2),
  QUOTE_PKG               NUMBER(18,2),
  LOCAL_PROMO             NUMBER(18,2),
  QUOTE_PROMO             NUMBER(18,2),
  TRANSACTION_DATE_ID     NUMBER(8),
  REV_IND                 CHAR(1 BYTE),
  CURRENT_IND             CHAR(1 BYTE)
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


CREATE INDEX BOOKING$PK ON F_BOOKING
(BOOKING_REF, DETAILS_UPDATED_DATE)
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
