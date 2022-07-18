--Alessandro Patrone 4249874
--Sabrina Polidoro 4682624


-- PARTE II

-- 7. [S] Il codice PL/pgSQL sviluppato per implementare le funzioni e procedure richieste,
-- inserendo, come commento nello script, la specifica relativa a ciascuna funzione o procedura.

--scarico inventario
CREATE FUNCTION scarico_inventario()
RETURNS void
AS
$$ 

declare 
	randVolontario varchar(14);
begin


randVolontario:= (SELECT codicefiscale FROM socialmarket.volontario  		--scelta randomica di un volontario dalla tabella dei volontari
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
WHERE (codicefiscale = $1 AND  dataora >= $2 AND dataora <= $3)' USING volontario,data1,data2 ;		--dato un volontario e due date, determino i turni assegnati al volontario in quel periodo

end;
$$

LANGUAGE plpgsql ;

-- FINE punto 7.


-- 8. [S] Il codice PL/pgSQL sviluppato per implementare i trigger richiesti, inserendo, come commento nello script,
-- la specifica relativa a ciascun trigger.

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
RAISE NOTICE 'Quantità aggiornata';
RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER disponibilita
AFTER INSERT OR UPDATE
ON socialmarket.compra
FOR EACH ROW
EXECUTE PROCEDURE mantenimento_disponibilita();