#!/bin/bash

DB_NAME="skleppiotr"

# Tworzenie bazy danych
psql -c "CREATE DATABASE $DB_NAME"

# Połączenie z bazą danych
psql -d $DB_NAME << EOF

-- Tworzenie tabeli Klienci
CREATE TABLE Klienci (
  id_klienta SERIAL PRIMARY KEY,
  imie TEXT NOT NULL,
  nazwisko TEXT NOT NULL
);

-- Tworzenie tabeli Produkty
CREATE TABLE Produkty (
  id_produktu SERIAL PRIMARY KEY,
  nazwa TEXT NOT NULL,
  cena FLOAT NOT NULL
);

-- Tworzenie tabeli Zamowienia
CREATE TABLE Zamowienia (
  id_zamowienia SERIAL PRIMARY KEY,
  id_produktu INTEGER NOT NULL,
  id_klienta INTEGER NOT NULL
);

-- Tworzenie tabeli Zdarzenia
CREATE TABLE Zdarzenia (
  id_zdarzenia SERIAL PRIMARY KEY,
  id_zamowienia INTEGER NOT NULL,
  data_zdarzenia TIMESTAMP NOT NULL,
  rodzaj_zdarzenia VARCHAR(50) NOT NULL,
  FOREIGN KEY (id_zamowienia) REFERENCES Zamowienia (id_zamowienia)
);

-- Dodanie typu wyliczeniowego RodzajZdarzenia do tabeli Zdarzenia
CREATE TYPE RodzajZdarzenia AS ENUM ('ProblemZamowienia', 'PrzypisanieKlienta', 'AnulowanieKlienta', 'DostarczenieKlientowi');
ALTER TABLE Zdarzenia ALTER COLUMN rodzaj_zdarzenia SET DATA TYPE RodzajZdarzenia USING rodzaj_zdarzenia::RodzajZdarzenia;

-- Tworzenie sekwencji
CREATE SEQUENCE sekwencja;

EOF
