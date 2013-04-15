SET DEFINE OFF;
CREATE TABLE L_SUPPLIERRATES
(
  SUPPLIERID             VARCHAR2(50 BYTE),
  SERVICEID              VARCHAR2(50 BYTE),
  PERIOD                 NUMBER(9),
  FROMDATE               DATE,
  TODATE                 DATE,
  BEGINBDATE             DATE,
  ENDBDATE               DATE,
  PAXRANGE               VARCHAR2(10 BYTE),
  WEEKDAYS               VARCHAR2(10 BYTE),
  SUPPLIERRATES_COMMENT  VARCHAR2(250 BYTE),
  COSTCODE               VARCHAR2(200 BYTE),
  VATCODE                VARCHAR2(10 BYTE),
  FREENIGHTS             VARCHAR2(200 BYTE),
  FREEQTY                VARCHAR2(200 BYTE),
  MAXCOMM                NUMBER(9),
  ARRONLY                VARCHAR2(10 BYTE),
  STAYOVER               VARCHAR2(10 BYTE),
  RATETYPE               VARCHAR2(3 BYTE),
  MINDUR                 VARCHAR2(10 BYTE),
  N1                     NUMBER(9),
  NT1                    NUMBER(9),
  NG1                    NUMBER(9),
  P1                     NUMBER(9),
  PT1                    NUMBER(9),
  PG1                    NUMBER(9),
  NCOM1                  NUMBER(9),
  N2                     NUMBER(9),
  NT2                    NUMBER(9),
  NG2                    NUMBER(9),
  P2                     NUMBER(9),
  PT2                    NUMBER(9),
  PG2                    NUMBER(9),
  NCOM2                  NUMBER(9),
  N3                     NUMBER(9),
  NT3                    NUMBER(9),
  NG3                    NUMBER(9),
  P3                     NUMBER(9),
  PT3                    NUMBER(9),
  PG3                    NUMBER(9),
  NCOM3                  NUMBER(9),
  N4                     NUMBER(9),
  NT4                    NUMBER(9),
  NG4                    NUMBER(9),
  P4                     NUMBER(9),
  PT4                    NUMBER(9),
  PG4                    NUMBER(9),
  NCOM4                  NUMBER(9),
  N5                     NUMBER(9),
  NT5                    NUMBER(9),
  NG5                    NUMBER(9),
  P5                     NUMBER(9),
  PT5                    NUMBER(9),
  PG5                    NUMBER(9),
  NCOM5                  NUMBER(9),
  N6                     NUMBER(9),
  NT6                    NUMBER(9),
  NG6                    NUMBER(9),
  P6                     NUMBER(9),
  PT6                    NUMBER(9),
  PG6                    NUMBER(9),
  NCOM6                  NUMBER(9),
  N7                     NUMBER(9),
  NT7                    NUMBER(9),
  NG7                    NUMBER(9),
  P7                     NUMBER(9),
  PT7                    NUMBER(9),
  PG7                    NUMBER(9),
  NCOM7                  NUMBER(9),
  N8                     NUMBER(9),
  NT8                    NUMBER(9),
  NG8                    NUMBER(9),
  P8                     NUMBER(9),
  PT8                    NUMBER(9),
  PG8                    NUMBER(9),
  NCOM8                  NUMBER(9),
  CHILDAGE1              NUMBER(4),
  FREEWADT1              VARCHAR2(10 BYTE),
  NC1                    NUMBER(9),
  NTC1                   NUMBER(9),
  NGC1                   NUMBER(9),
  PC1                    NUMBER(9),
  PTC1                   NUMBER(9),
  PGC1                   NUMBER(9),
  CHILDAGE2              NUMBER(4),
  FREEWADT2              VARCHAR2(10 BYTE),
  NC2                    NUMBER(9),
  NTC2                   NUMBER(9),
  NGC2                   NUMBER(9),
  PC2                    NUMBER(9),
  PTC2                   NUMBER(9),
  PGC2                   NUMBER(9),
  CHILDAGE3              NUMBER(4),
  FREEWADT3              VARCHAR2(10 BYTE),
  NC3                    NUMBER(9),
  NTC3                   NUMBER(9),
  NGC3                   NUMBER(9),
  PC3                    NUMBER(9),
  PTC3                   NUMBER(9),
  PGC3                   NUMBER(9),
  OTPRFEE                VARCHAR2(20 BYTE),
  OTPPFEE                VARCHAR2(20 BYTE),
  FEEPERNT               VARCHAR2(20 BYTE),
  TAXFEEPERNT            VARCHAR2(1 BYTE),
  COSTTAXFORMULA         VARCHAR2(80 BYTE),
  PRICETAXFORMULA        VARCHAR2(80 BYTE),
  SUPPLIERCOMMPER        VARCHAR2(80 BYTE),
  COLOR                  NUMBER(4),
  DISCOUNT               VARCHAR2(200 BYTE),
  WHOSTAMP               VARCHAR2(50 BYTE),
  DATESTAMP              DATE
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