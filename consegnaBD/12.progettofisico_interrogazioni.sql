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


--71 ms

--43 ms --index

--37 ms --cluster

----2
--Determinare i prodotti il cui rifornimento è uguale allo scarico

SELECT rifornisce.nome, rifornisce.quantita AS rQ, scarica.quantita AS sQ
FROM socialmarket.scarica
JOIN socialmarket.rifornisce ON rifornisce.quantita = scarica.quantita;

--52 ms

--32 ms ---index

--29 ms --cluster


---3

--Determinare i membri autorizzati all'utilizzo della tessera appartenenti alla fascia di età identificata dalla lettera 't'

SELECT membro.codicefiscale, persona.nome, persona.cognome
FROM socialmarket.membro
JOIN socialmarket.persona ON persona.codicefiscale = membro.codicefiscale
WHERE membro.fasciaeta = 't' AND membro.autorizzato = true;

--41 ms

--33 ms --cluster



