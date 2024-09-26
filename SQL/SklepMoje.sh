#!/bin/bash
psql skleppiotr << EOF

-- Utwórz tabelę DailyKPIs
CREATE TABLE IF NOT EXISTS DailyKPIs (
  execution_date DATE PRIMARY KEY,
  orders_finalized INTEGER NOT NULL,
  orders_in_progress INTEGER NOT NULL,
  customer_order_bank INTEGER NOT NULL
);

-- Oblicz wskaźniki KPI
INSERT INTO DailyKPIs (execution_date, orders_finalized, orders_in_progress, customer_order_bank)
SELECT
  TO_DATE('$1','YYYY-MM-DD') as execution_date,
  COUNT(CASE WHEN a.rodzaj_zdarzenia = 'DostarczenieKlientowi' and a.data_zdarzenia='$1' THEN a.id_zamowienia END) AS orders_finalized,
  COUNT(CASE WHEN a.rodzaj_zdarzenia = 'ProblemZamowienia' AND a.data_zdarzenia<='$1' AND '$1'<COALESCE(b.data_zdarzenia,TO_DATE('$1','YYYY-MM-DD')+ INTERVAL '1 DAY') THEN a.id_zamowienia END) AS orders_in_progress,
  COUNT(CASE WHEN a.rodzaj_zdarzenia = 'PrzypisanieKlienta' AND a.data_zdarzenia<='$1' AND '$1'<COALESCE(b.data_zdarzenia,TO_DATE('$1','YYYY-MM-DD')+ INTERVAL '1 DAY') THEN a.id_zamowienia END)-COUNT(CASE WHEN a.rodzaj_zdarzenia = 'AnulowanieKlienta' AND a.data_zdarzenia<='$1' AND '$1'<COALESCE(b.data_zdarzenia,TO_DATE('$1','YYYY-MM-DD')+ INTERVAL '1 DAY') THEN a.id_zamowienia END) AS customer_order_bank
FROM Zdarzenia a
LEFT JOIN 
(SELECT id_zamowienia, data_zdarzenia FROM Zdarzenia WHERE rodzaj_zdarzenia='DostarczenieKlientowi') b
ON a.id_zamowienia=b.id_zamowienia
GROUP BY execution_date;

EOF
