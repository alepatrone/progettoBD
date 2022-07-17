--procedure


--scarico inventario
CREATE FUNCTION scarico_inventario()
RETURNS void
AS
$$ 

declare 
	randVolontario varchar(14);
begin


randVolontario:= (SELECT codicefiscale FROM socialmarket.volontario  
ORDER BY RANDOM()  
LIMIT 1);


INSERT INTO socialmarket.scarica (codicefiscale,dataora,nome, scadenza,quantita)
SELECT randVolontario,CURRENT_TIMESTAMP, nome, scadenza, quantita FROM socialmarket.prodotto
where scadenza <= CURRENT_TIMESTAMP;
end;
$$

LANGUAGE plpgsql ;


--turnicheck

CREATE FUNCTION turni_check(volontario varchar(14),data1 TIMESTAMP, data2 TIMESTAMP)
RETURNS SETOF socialmarket.turni
AS
$$ 

begin

RETURN QUERY EXECUTE '
SELECT *
FROM socialmarket.turni
WHERE (codicefiscale = $1 AND  dataora >= $2 AND dataora <= $3)' USING volontario,data1,data2 ;

end;
$$

LANGUAGE plpgsql ;


--trigger

--attivitàcontemporanee


CREATE OR REPLACE FUNCTION volontario_non_disponibile() RETURNS trigger AS
$$
BEGIN
IF EXISTS (SELECT * FROM socialmarket.turni
WHERE NEW.codicefiscale=codicefiscale AND extract(day from NEW.dataora) = extract(day from dataora))
THEN
RAISE EXCEPTION 'Volontario già impegnato in altra attività';
ROLLBACK;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER attivita_contemp
BEFORE INSERT OR UPDATE
ON socialmarket.turni
FOR EACH ROW
EXECUTE PROCEDURE volontario_non_disponibile();


--mantenimento_disponibilita

CREATE OR REPLACE FUNCTION  mantenimento_disponibilita() RETURNS trigger AS
$$
BEGIN

    UPDATE socialmarket.prodotto
    SET quantita = socialmarket.prodotto.quantita - subquery.quantita
    FROM (SELECT nome, quantita
     FROM  socialmarket.compra 
     WHERE NEW.nome = nome) AS subquery
    WHERE NEW.nome = prodotto.nome;
RAISE NOTICE 'fatto';
RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER disponibilita
AFTER INSERT OR UPDATE
ON socialmarket.compra
FOR EACH ROW
EXECUTE PROCEDURE mantenimento_disponibilita();


--PARTE III


--popolamento

COPY socialmarket.membro(codicefiscale,titolaretessera,fasciaeta,autorizzato)
FROM 'C:\membro.csv'
DELIMITER ','
CSV HEADER

--interrogazioni

---1

SELECT *
FROM socialmarket.cliente
WHERE saldo >= 45 AND puntimensili >= 37


71 ms

43 ms --index

37 ms --cluster

----2

SELECT rifornisce.nome, rifornisce.quantita AS rQ, scarica.quantita AS sQ
FROM socialmarket.scarica
JOIN socialmarket.rifornisce ON rifornisce.quantita = scarica.quantita

52 ms

32 ms ---index

29 ms --cluster


---3

SELECT membro.codicefiscale, persona.nome, persona.cognome
FROM socialmarket.membro
JOIN socialmarket.persona ON persona.codicefiscale = membro.codicefiscale
WHERE membro.fasciaeta = 't' AND membro.autorizzato = true

41 ms



33 ms --cluster



--progetto fisico

CREATE INDEX idxCF ON socialmarket.persona(codicefiscale)
CREATE INDEX idxProdotto ON socialmarket.prodotto(nome)


--- Transaction

BEGIN TRANSACTION;

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

-- 42 ms

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