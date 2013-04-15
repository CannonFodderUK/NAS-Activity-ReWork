SET DEFINE OFF;
CREATE TABLE R_BOOKING_COMPONENT
(
  BOOKING_REF                NUMBER(18),
  SERVICE_SEQ                NUMBER(18),
  SEQ                        INTEGER,
  ISEQ                       INTEGER,
  DELETED                    VARCHAR2(1 BYTE),
  PER_DURATION               VARCHAR2(1 BYTE),
  REQ_MASK                   VARCHAR2(50 BYTE),
  SUPPLIER_NAME              VARCHAR2(255 BYTE),
  SERVICE_ID                 VARCHAR2(50 BYTE),
  DESCRIPTION                VARCHAR2(300 BYTE),
  VCHR_NOTES                 VARCHAR2(2000 BYTE),
  COST_CODE                  VARCHAR2(300 BYTE),
  VCHR_TYPE                  VARCHAR2(10 BYTE),
  TOUR_CODE                  VARCHAR2(100 BYTE),
  MANIFEST_CODE              VARCHAR2(50 BYTE),
  CONTRACT_THRU              VARCHAR2(20 BYTE),
  COMM_TIMING                VARCHAR2(3 BYTE),
  BLOCK_TYPE                 VARCHAR2(3 BYTE),
  INVENTAY_MAP               VARCHAR2(50 BYTE),
  CONFIRM_INFO               VARCHAR2(1024 BYTE),
  SHARE_WITH                 VARCHAR2(50 BYTE),
  DESTINATION                VARCHAR2(3 BYTE),
  TO_DESTINATION             VARCHAR2(3 BYTE),
  LOCATION_CODE              VARCHAR2(180 BYTE),
  SERVICE_ORDER              INTEGER,
  FREENT                     VARCHAR2(125 BYTE),
  SUPPLIER_MENO              VARCHAR2(200 BYTE),
  ADDTIONAL_INFO             VARCHAR2(2500 BYTE),
  ADDITIONAL_DATA            CLOB,
  XL_RULE                    VARCHAR2(1500 BYTE),
  IX                         VARCHAR2(2 BYTE),
  DESIG                      VARCHAR2(75 BYTE),
  MASK                       VARCHAR2(50 BYTE),
  QUOTE_PRICE_GST            NUMBER(18,4),
  QUOTE_PRICE_ENC            NUMBER(18,2),
  SUPPLIER_COMM_FORM         VARCHAR2(200 BYTE),
  LOCAL_SUPPLIER_COMM        NUMBER(18,2),
  LOCAL_SUPPLIER_COMM_REC    NUMBER(18,2),
  ROOMS_ASSIGNED             VARCHAR2(500 BYTE),
  DATA_PRIOR_TO_CHG          VARCHAR2(2000 BYTE),
  SUPPLIER_REPORTED          VARCHAR2(6 BYTE),
  SUPPLIER_REPORTED_DATE_ID  NUMBER(8),
  NEED_TO_REPORT             VARCHAR2(3 BYTE),
  PAID_TO_SUPPLIER           VARCHAR2(250 BYTE),
  ADDED_BY                   VARCHAR2(50 BYTE),
  ADED_BY_DATE_ID            NUMBER(8),
  P_USER                     VARCHAR2(50 BYTE),
  LAST_UPDATE_ID             NUMBER(8),
  GROUP_SEQ                  INTEGER,
  PRODUCT_CODE               VARCHAR2(50 BYTE),
  ITEM_ROLE                  VARCHAR2(10 BYTE),
  SERVICE_TYPE               VARCHAR2(50 BYTE),
  SERVICE_DATE_ID            NUMBER(8),
  ON_TIME                    VARCHAR2(5 BYTE),
  SERVICE_DURATION           INTEGER,
  MARKET_CODE                VARCHAR2(20 BYTE),
  SELL_METHOD                VARCHAR2(10 BYTE),
  SUPPLIER_ID                VARCHAR2(50 BYTE),
  INVOICE_FLAG               VARCHAR2(1 BYTE),
  VAT_CODE                   VARCHAR2(10 BYTE),
  BLOCK_CODE                 VARCHAR2(50 BYTE),
  CONFIRM_STATUS             VARCHAR2(6 BYTE),
  CONFIRM_DATE_ID            NUMBER(8),
  COST_CURRENCY              VARCHAR2(3 BYTE),
  COST_EXCH                  NUMBER(18,6),
  QUANTITY                   INTEGER,
  LOCAL_COST                 NUMBER(18,2),
  LOCAL_COST_TAX             NUMBER(18,2),
  LOCAL_COST_GST             NUMBER(18,2),
  QUOTE_PRICE                NUMBER(18,2),
  QUOTE_DISPLAY_PRICE        NUMBER(18,2),
  QUOTE_PRICE_TAX            NUMBER(18,2),
  COMM_PER                   NUMBER(18,4),
  MAX_COMM                   NUMBER(18,2)
)
LOB (ADDITIONAL_DATA) STORE AS (
  TABLESPACE  DTW_ADV_TABLES
  ENABLE      STORAGE IN ROW
  CHUNK       16384
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          80K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                  FLASH_CACHE      DEFAULT
                  CELL_FLASH_CACHE DEFAULT
                 ))
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
