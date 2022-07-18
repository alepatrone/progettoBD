--Alessandro Patrone 4249874
--Sabrina Polidoro 4682624


-- 12. [S] Script SQL per la creazione dello schema fisico della base di dati e per la specifica delle interrogazioni
-- contenute nel carico di lavoro, inserendo, come commento nello script, la corrispondente richiesta in linguaggio naturale.

--progetto fisico

CREATE INDEX idxCF ON socialmarket.persona(codicefiscale);
CLUSTER socialmarket.cliente USING idxCF;
CREATE INDEX idxProdotto ON socialmarket.prodotto(nome);
CLUSTER socialmarket.prodotto USING idxProdotto;

--interrogazioni



---1
--Determinare i clienti con saldo maggiore o uguale di 45 e punti mensili maggiori di 37


SELECT *
FROM socialmarket.cliente
WHERE saldo >= 45 AND puntimensili > 37;


----2
--Determinare i prodotti il cui rifornimento è uguale allo scarico

SELECT rifornisce.nome, rifornisce.quantita AS rQ, scarica.quantita AS sQ
FROM socialmarket.scarica
JOIN socialmarket.rifornisce ON rifornisce.quantita = scarica.quantita;


---3

--Determinare i membri autorizzati all'utilizzo della tessera appartenenti alla fascia di età identificata dalla lettera 't'

SELECT membro.codicefiscale, persona.nome, persona.cognome
FROM socialmarket.membro
JOIN socialmarket.persona ON persona.codicefiscale = membro.codicefiscale
WHERE membro.fasciaeta = 't' AND membro.autorizzato = true;



-- 13. [S] Il codice PL/pgSQL sviluppato per implementare la transazione considerata.

--- Transaction

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT *
FROM socialmarket.prodotto
WHERE nome = 'Assorted Desserts';

UPDATE socialmarket.prodotto
SET quantita= quantita + 5
WHERE nome = 'Assorted Desserts';

SELECT nome, quantita
FROM socialmarket.prodotto
WHERE nome = 'Assorted Desserts' OR quantita = '100';

COMMIT;

-- 14. [S] Script SQL per l’implementazione della politica di controllo dell’accesso.

--Controllo privilegi

CREATE USER alice;
CREATE USER roberto;

GRANT insert ON socialmarket.compra TO roberto
GRANT insert ON socialmarket.rifornisce TO roberto
GRANT select ON socialmarket.turni TO roberto
GRANT update ON socialmarket.prodotto TO roberto


GRANT select ON socialmarket.recapito to alice
GRANT select ON socialmarket.volontario to alice

GRANT ALL PRIVILEGES ON socialmarket.rifornisce,socialmarket.cliente, socialmarket.turni,socialmarket.donatore, socialmarket.prodotto,socialmarket.prodotto TO alice
WITH GRANT OPTION;



