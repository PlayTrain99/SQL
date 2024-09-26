#!/bin/bash

# Połączenie z bazą danych
psql -d skleppiotr << EOF

-- Wstawianie rekordów do tabeli Klienci
INSERT INTO Klienci (imie, nazwisko)
VALUES ('Piotr', 'Górka'), ('Ola', 'Szmyt'), ('Marcin', 'Koks'), ('Lukasz', 'Bera'), ('Maria', 'Nowak'), ('Tomek', 'Rys');

-- Wstawianie rekordów do tabeli Produkty
INSERT INTO Produkty (nazwa, cena)
VALUES ('Gitara', 150), ('Pianino', 750), ('Flet', 30), ('Perkusja', 1470), ('Dzwon', 15), ('Skrzypce', 300);

-- Wstawianie rekordów do tabeli Zamowienia
INSERT INTO Zamowienia (id_zamowienia, id_produktu, id_klienta)
VALUES (nextval('sekwencja'), 1, 1), (nextval('sekwencja'), 2, 2), (nextval('sekwencja'), 3, 3), (nextval('sekwencja'), 4, 4), (nextval('sekwencja'), 5, 5), (nextval('sekwencja'), 6, 6);

-- Wstawianie rekordów do tabeli Zdarzenia
INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-01', 'ProblemZamowienia' FROM Zamowienia WHERE id_zamowienia = 1;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-03', 'PrzypisanieKlienta' FROM Zamowienia WHERE id_zamowienia = 1;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-04', 'AnulowanieKlienta' FROM Zamowienia WHERE id_zamowienia = 1;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-05', 'PrzypisanieKlienta' FROM Zamowienia WHERE id_zamowienia = 1;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-06', 'AnulowanieKlienta' FROM Zamowienia WHERE id_zamowienia = 1;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-08', 'PrzypisanieKlienta' FROM Zamowienia WHERE id_zamowienia = 1;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-09', 'AnulowanieKlienta' FROM Zamowienia WHERE id_zamowienia = 1;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-10', 'DostarczenieKlientowi' FROM Zamowienia WHERE id_zamowienia = 1;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-03', 'ProblemZamowienia' FROM Zamowienia WHERE id_zamowienia = 2;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-04', 'PrzypisanieKlienta' FROM Zamowienia WHERE id_zamowienia = 2;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-05', 'AnulowanieKlienta' FROM Zamowienia WHERE id_zamowienia = 2;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-08', 'PrzypisanieKlienta' FROM Zamowienia WHERE id_zamowienia = 2;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-09', 'AnulowanieKlienta' FROM Zamowienia WHERE id_zamowienia = 2;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-10', 'PrzypisanieKlienta' FROM Zamowienia WHERE id_zamowienia = 2;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-11', 'AnulowanieKlienta' FROM Zamowienia WHERE id_zamowienia = 2;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-03', 'ProblemZamowienia' FROM Zamowienia WHERE id_zamowienia = 3;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-04', 'PrzypisanieKlienta' FROM Zamowienia WHERE id_zamowienia = 3;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-05', 'AnulowanieKlienta' FROM Zamowienia WHERE id_zamowienia = 3;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-08', 'PrzypisanieKlienta' FROM Zamowienia WHERE id_zamowienia = 3;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-09', 'AnulowanieKlienta' FROM Zamowienia WHERE id_zamowienia = 3;

INSERT INTO Zdarzenia (id_zdarzenia, id_zamowienia, data_zdarzenia, rodzaj_zdarzenia)
SELECT nextval('sekwencja'), id_zamowienia, '2023-06-10', 'DostarczenieKlientowi' FROM Zamowienia WHERE id_zamowienia = 3;

EOF
