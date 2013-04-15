SET DEFINE OFF;
CREATE TABLE L_MRKSEGMENT
(
  CLIENTID             VARCHAR2(30 BYTE)        NOT NULL,
  CAMPAIGNID           VARCHAR2(30 BYTE)        NOT NULL,
  CHANNELID            VARCHAR2(30 BYTE),
  SEGMENTID            VARCHAR2(30 BYTE),
  SEQ                  INTEGER                  NOT NULL,
  DISPLAYORDER         INTEGER,
  DISPLAYTEXT          VARCHAR2(50 BYTE),
  BRANDS               VARCHAR2(300 BYTE),
  MARKETS              VARCHAR2(300 BYTE),
  ADVID                VARCHAR2(40 BYTE),
  SEGMENTTYPE          VARCHAR2(30 BYTE),
  DESCRIPTION          VARCHAR2(255 BYTE),
  INSERTIONDATE        DATE,
  BEGDATE              DATE,
  ENDDATE              DATE,
  MATERIALDUEDATE      DATE,
  SUBMISSIONDATE       DATE,
  COST1                VARCHAR2(30 BYTE),
  COST2                VARCHAR2(30 BYTE),
  NETCOST              NUMBER(18,2),
  REFERENCE            VARCHAR2(30 BYTE),
  INVOICERECEIVEDDATE  DATE,
  PROCESSEDBYTRANS     VARCHAR2(30 BYTE),
  PROCESSEDBYCHECK     VARCHAR2(30 BYTE),
  WHOSTAMP             VARCHAR2(50 BYTE),
  DATESTAMP            DATE
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