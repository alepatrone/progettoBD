create schema "socialmarket";
set search_path to "socialmarket";
set datestyle to "DMY";

CREATE TABLE PERSONA(
      codicefiscale varchar(14) PRIMARY KEY,
      nome varchar(30) not null,
      cognome varchar(30) not null
  );
 
CREATE TABLE RECAPITO(
      codicefiscale varchar(14) REFERENCES PERSONA,
      numero varchar(10), 
      PRIMARY KEY (codicefiscale,numero)
  );

 CREATE TABLE CLIENTE(
	  codicefiscale varchar(14) PRIMARY KEY REFERENCES PERSONA,
          codicetessera decimal(7) UNIQUE NOT NULL,
          Ente VARCHAR(30) NOT NULL,
          Saldo numeric(2) NOT NULL,
          PuntiMensili numeric(2) NOT NULL,
          DataInAut DATE NOT NULL
);

CREATE TABLE MEMBRO(
	  codicefiscale varchar(14) PRIMARY KEY REFERENCES PERSONA,
          Titolaretessera varchar(14) REFERENCES PERSONA,
          FasciaEta char(1) NOT NULL CHECK (FasciaEta IN ('n', 'b', 't', 'a', 'o')),
          Autorizzato BOOLEAN NOT NULL
);

CREATE TABLE NEGOZIO(
      idfiscale varchar(14) PRIMARY KEY,
      nome varchar(30) not null,
      Sede varchar(30) not null
  );

CREATE TABLE DONATORE(
      idfiscale varchar(14) PRIMARY KEY
  );
--- ci vorrebbe trigger che impedisca di inserire id che non siano presenti in negozio oppure in persona

CREATE TABLE DONAZIONE(
      idfiscale varchar(14) REFERENCES DONATORE,
      DataOra TIMESTAMP,
      Importo numeric(9,2) NOT NULL,
      PRIMARY KEY (idfiscale,DataOra)
  );

CREATE TABLE TIPOP(
      Tipo varchar(30) PRIMARY KEY,
      DurataExtra numeric(3) -- espresso in giorni
  );

CREATE TABLE PRODOTTO(
      Nome varchar(30),
      Scadenza DATE,
      Quantita numeric(4) NOT NULL,
      Punti numeric(2) NOT NULL, 
      DataComm DATE,
      Tipo varchar(30) REFERENCES TIPOP,
      DurataExtra numeric(3), -- espressa in giorni
      PRIMARY KEY (Nome, Scadenza) 
  );

CREATE TABLE INCLUDE(
      idfiscale varchar(14) NOT NULL,
      DataOra TIMESTAMP,
      Nome varchar(30),
      Scadenza DATE,
      Quantita numeric(4) NOT NULL,
      Primary KEY (idfiscale,DataOra,Nome,Scadenza),
      FOREIGN KEY (idfiscale,DataOra) REFERENCES DONAZIONE,
      FOREIGN KEY (Nome,Scadenza) REFERENCES PRODOTTO
  );


CREATE TABLE VOLONTARIO(
	  codicefiscale varchar(14) PRIMARY KEY REFERENCES PERSONA,
          Veicolo varchar(7),
          Associazione varchar (30)
);

CREATE TABLE TRASPORTO(
      codicefiscale varchar(14) REFERENCES VOLONTARIO,
      DataOra TIMESTAMP,
      Id varchar(14) REFERENCES NEGOZIO,
      NumeroScatole numeric(4),
      PRIMARY KEY (codicefiscale,DataOra)
  );

CREATE TABLE RIFORNISCE(
      codicefiscale varchar(14) REFERENCES VOLONTARIO,
      DataOra TIMESTAMP,
      Nome varchar(30),
      Scadenza DATE,
      Quantita numeric(4) NOT NULL,
      Primary KEY (codicefiscale,DataOra,Nome,Scadenza),
      FOREIGN KEY (Nome,Scadenza) REFERENCES PRODOTTO
  );

CREATE TABLE SCARICA(
      codicefiscale varchar(14) REFERENCES VOLONTARIO,
      DataOra TIMESTAMP,
      Nome varchar(30),
      Scadenza DATE,
      Quantita numeric(4) NOT NULL,
      Primary KEY (codicefiscale,DataOra,Nome,Scadenza),
      FOREIGN KEY (Nome,Scadenza) REFERENCES PRODOTTO
  );

CREATE TABLE ASSISTENZA(
      codicefiscale varchar(14) REFERENCES VOLONTARIO,
      DataOra TIMESTAMP,
      cfCliente varchar(14) REFERENCES CLIENTE NOT NULL,
      cfMembro varchar(14) REFERENCES MEMBRO,
      SaldoIniziale numeric(2),
      SaldoFinale numeric(2),
      Primary KEY (codicefiscale,DataOra)
  );

CREATE TABLE COMPRA(
      codicefiscale varchar(14) REFERENCES VOLONTARIO,
      DataOra TIMESTAMP,
      Nome varchar(30),
      Scadenza DATE,
      Quantita numeric(4) NOT NULL,
      Primary KEY (codicefiscale,DataOra,Nome,Scadenza),
      FOREIGN KEY (codiceFiscale, DataOra) REFERENCES ASSISTENZA,
      FOREIGN KEY (Nome,Scadenza) REFERENCES PRODOTTO
  );


