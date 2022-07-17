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
RAISE NOTICE 'Quantità aggiornata';
RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER disponibilita
AFTER INSERT OR UPDATE
ON socialmarket.compra
FOR EACH ROW
EXECUTE PROCEDURE mantenimento_disponibilita();