CREATE TABLE TURNI(
      codicefiscale varchar(14) REFERENCES VOLONTARIO,
      DataOra TIMESTAMP,
      Attivita varchar(30),
      PRIMARY KEY (codicefiscale,DataOra)
);






--persona

INSERT INTO socialmarket.persona VALUES ('S9PG6FQ9S52HR1', 'SALVATORE', 'CARRINO');
INSERT INTO socialmarket.persona VALUES ('KR2XC3UVV58PFK', 'MAURA ROSARIA', 'DONADIO');
INSERT INTO socialmarket.persona VALUES ('C18E594FDCCLFB', 'NICOLA', 'DONADIO');
INSERT INTO socialmarket.persona VALUES ('GAXN7W7G8K57AQ', 'DOMENICO', 'TUCCI');
INSERT INTO socialmarket.persona VALUES ('KJDMPEWNY81W8L', 'ANTONIO', 'MONTESANO');
INSERT INTO socialmarket.persona VALUES ('6VQAR21YRWPQFQ', 'SALVATORE', 'DONADIO');
INSERT INTO socialmarket.persona VALUES ('UUL4HOB9UOIH67', 'GIANLUIGI', 'FINOCCHIARO');
INSERT INTO socialmarket.persona VALUES ('3GBC2QNYAI53EO', 'ANDREA', 'BENEDETTO');
INSERT INTO socialmarket.persona VALUES ('NEE27WTN0RJRGM', 'VINCENZO', 'BELLINO');
INSERT INTO socialmarket.persona VALUES ('XN2N6P9FA7ACVU', 'GIUSEPPE', 'PIZZOLLA');
INSERT INTO socialmarket.persona VALUES ('B1Z8MHP7NRGL8K', 'VITO', 'TUCCI');
INSERT INTO socialmarket.persona VALUES ('MNJ8ZD7UKY3M4B', 'ROCCO', 'SCARANGELLA');
INSERT INTO socialmarket.persona VALUES ('8V8A2GF9ZAZ6P3', 'MICHELE', 'IANNUZZI');
INSERT INTO socialmarket.persona VALUES ('6BSK3CLXQMRNPS', 'STEFANO', 'SANTARCANGELO');
INSERT INTO socialmarket.persona VALUES ('AHCBVL99KT1HYD', 'RAFFAELE', 'CONTE');
INSERT INTO socialmarket.persona VALUES ('84XUT7TLS3QF5S', 'GIUSEPPE', 'STIGLIANO');
INSERT INTO socialmarket.persona VALUES ('1WSOI86W2GHGHP', 'NICOLA', 'LOMBARDI');
INSERT INTO socialmarket.persona VALUES ('8W9FG3QEUDN8OO', 'ROCCO', 'MATARRESE');
INSERT INTO socialmarket.persona VALUES ('EEBWI1QFN96P38', 'GINO', 'TRUNCELLITO');
INSERT INTO socialmarket.persona VALUES ('1IUA3ZPC8H8HFO', 'VINCENZO', 'ANTEZZA');

--recapito

INSERT INTO socialmarket.recapito VALUES ('S9PG6FQ9S52HR1',  '3672377179');
INSERT INTO socialmarket.recapito VALUES ('KR2XC3UVV58PFK',  '3817982693');
INSERT INTO socialmarket.recapito VALUES ('C18E594FDCCLFB',  '3806225424');
INSERT INTO socialmarket.recapito VALUES ('GAXN7W7G8K57AQ',  '3714141048');
INSERT INTO socialmarket.recapito VALUES ('KJDMPEWNY81W8L',  '3496909481');
INSERT INTO socialmarket.recapito VALUES ('6VQAR21YRWPQFQ',  '3911497031');
INSERT INTO socialmarket.recapito VALUES ('UUL4HOB9UOIH67',  '3977304435');
INSERT INTO socialmarket.recapito VALUES ('3GBC2QNYAI53EO',  '3533577793');
INSERT INTO socialmarket.recapito VALUES ('NEE27WTN0RJRGM',  '3599358204');
INSERT INTO socialmarket.recapito VALUES ('XN2N6P9FA7ACVU',  '3731987981');
INSERT INTO socialmarket.recapito VALUES ('B1Z8MHP7NRGL8K',  '3384969835');
INSERT INTO socialmarket.recapito VALUES ('MNJ8ZD7UKY3M4B',  '3511726580');
INSERT INTO socialmarket.recapito VALUES ('8V8A2GF9ZAZ6P3',  '3663897736');
INSERT INTO socialmarket.recapito VALUES ('6BSK3CLXQMRNPS',  '3341135661');
INSERT INTO socialmarket.recapito VALUES ('AHCBVL99KT1HYD',  '3564117824');
INSERT INTO socialmarket.recapito VALUES ('84XUT7TLS3QF5S',  '3986603394');
INSERT INTO socialmarket.recapito VALUES ('1WSOI86W2GHGHP',  '3660742860');
INSERT INTO socialmarket.recapito VALUES ('8W9FG3QEUDN8OO',  '3539844058');
INSERT INTO socialmarket.recapito VALUES ('EEBWI1QFN96P38',  '3805873173');
INSERT INTO socialmarket.recapito VALUES ('1IUA3ZPC8H8HFO',  '3492018250');

--cliente

INSERT INTO socialmarket.cliente VALUES ('S9PG6FQ9S52HR1',  '8314600','Servizi Sociali',18,45,'11/07/2022');
INSERT INTO socialmarket.cliente VALUES ('KR2XC3UVV58PFK',  '5305620','Centro di Ascolto',29,30,'09/01/2022');
INSERT INTO socialmarket.cliente VALUES ('C18E594FDCCLFB',  '9663734','Servizi Sociali',15,60,'09/07/2022');
INSERT INTO socialmarket.cliente VALUES ('GAXN7W7G8K57AQ',  '2212994','Servizi Sociali',8,35,'08/06/2022');
INSERT INTO socialmarket.cliente VALUES ('KJDMPEWNY81W8L',  '5436780','Servizi Sociali',17,37,'06/05/2022');
INSERT INTO socialmarket.cliente VALUES ('6VQAR21YRWPQFQ',  '7742672','Centro di Ascolto',19,31,'10/03/2022');
INSERT INTO socialmarket.cliente VALUES ('UUL4HOB9UOIH67',  '2425511','Centro di Ascolto',7,55,'09/06/2022');
INSERT INTO socialmarket.cliente VALUES ('3GBC2QNYAI53EO',  '1010090','Servizi Sociali',35,60,'01/02/2022');
INSERT INTO socialmarket.cliente VALUES ('NEE27WTN0RJRGM',  '9163488','Servizi Sociali',18,50,'30/03/2022');
INSERT INTO socialmarket.cliente VALUES ('XN2N6P9FA7ACVU',  '7632012','Servizi Sociali',45,50,'21/04/2022');
INSERT INTO socialmarket.cliente VALUES ('B1Z8MHP7NRGL8K',  '8049169','Centro di Ascolto',18,37,'21/04/2022');
INSERT INTO socialmarket.cliente VALUES ('MNJ8ZD7UKY3M4B',  '1171620','Centro di Ascolto',22,35,'09/02/2022');
INSERT INTO socialmarket.cliente VALUES ('8V8A2GF9ZAZ6P3',  '5940416','Centro di Ascolto',19,48,'20/01/2022');
INSERT INTO socialmarket.cliente VALUES ('6BSK3CLXQMRNPS',  '7595340','Servizi Sociali',50,55,'22/02/2022');
INSERT INTO socialmarket.cliente VALUES ('AHCBVL99KT1HYD',  '7884659','Servizi Sociali',18,37,'03/03/2022');



--membro

INSERT INTO socialmarket.membro VALUES ('S9PG6FQ9S52HR1', 'S9PG6FQ9S52HR1', 'a',true);
INSERT INTO socialmarket.membro VALUES ('KR2XC3UVV58PFK', 'KR2XC3UVV58PFK', 'b',true);
INSERT INTO socialmarket.membro VALUES ('C18E594FDCCLFB', 'KR2XC3UVV58PFK', 'b',false);
INSERT INTO socialmarket.membro VALUES ('GAXN7W7G8K57AQ', 'GAXN7W7G8K57AQ', 't',true);
INSERT INTO socialmarket.membro VALUES ('KJDMPEWNY81W8L', 'KJDMPEWNY81W8L', 'o',true);
INSERT INTO socialmarket.membro VALUES ('6VQAR21YRWPQFQ', '6VQAR21YRWPQFQ', 'n',true);
INSERT INTO socialmarket.membro VALUES ('UUL4HOB9UOIH67', '6VQAR21YRWPQFQ', 'n',true);
INSERT INTO socialmarket.membro VALUES ('3GBC2QNYAI53EO', '3GBC2QNYAI53EO', 'a',true);
INSERT INTO socialmarket.membro VALUES ('NEE27WTN0RJRGM', 'NEE27WTN0RJRGM', 't',true);
INSERT INTO socialmarket.membro VALUES ('XN2N6P9FA7ACVU', 'NEE27WTN0RJRGM', 't',true);
INSERT INTO socialmarket.membro VALUES ('B1Z8MHP7NRGL8K', 'GAXN7W7G8K57AQ', 'o',true);
INSERT INTO socialmarket.membro VALUES ('MNJ8ZD7UKY3M4B', 'MNJ8ZD7UKY3M4B', 'a',true);
INSERT INTO socialmarket.membro VALUES ('8V8A2GF9ZAZ6P3', 'MNJ8ZD7UKY3M4B', 'a',false);
INSERT INTO socialmarket.membro VALUES ('6BSK3CLXQMRNPS', '6BSK3CLXQMRNPS', 't',true);
INSERT INTO socialmarket.membro VALUES ('AHCBVL99KT1HYD', 'AHCBVL99KT1HYD', 't',true);


--volontario

INSERT INTO socialmarket.volontario VALUES ('84XUT7TLS3QF5S', 'auto', 'AssociazioneUno');
INSERT INTO socialmarket.volontario VALUES ('1WSOI86W2GHGHP', 'moto', 'AssociazioneDue');
INSERT INTO socialmarket.volontario VALUES ('8W9FG3QEUDN8OO', 'auto', 'AssociazioneUno');
INSERT INTO socialmarket.volontario VALUES ('1IUA3ZPC8H8HFO', 'furgone', 'AssociazioneTre');

--donatore

INSERT INTO socialmarket.donatore VALUES ('EEBWI1QFN96P38');
INSERT INTO socialmarket.donatore VALUES ('00000000000001');
INSERT INTO socialmarket.donatore VALUES ('00000000000002');

--negozio

INSERT INTO socialmarket.negozio VALUES ('00000000000001', 'Supermercato Bio', 'Milano');
INSERT INTO socialmarket.negozio VALUES ('00000000000002', 'Alimentari SRL', 'Genova');

--donazione

INSERT INTO socialmarket.donazione VALUES ('00000000000002', '06/06/2022, 18:45:22', 50.12);
INSERT INTO socialmarket.donazione VALUES ('00000000000001', '11/07/2022, 13:10:23', 237.18);
INSERT INTO socialmarket.donazione VALUES ('EEBWI1QFN96P38', '11/07/2022', 150.20);

--tipop

INSERT INTO socialmarket.tipop VALUES ('Succhi di frutta',6);
INSERT INTO socialmarket.tipop VALUES ('Pasta',1);
INSERT INTO socialmarket.tipop VALUES ('Caffè',12);
INSERT INTO socialmarket.tipop VALUES ('Olio extravergine di oliva',12);
INSERT INTO socialmarket.tipop VALUES ('Salsa di pomodoro',2);
INSERT INTO socialmarket.tipop VALUES ('tonno sottolio',1);
INSERT INTO socialmarket.tipop VALUES ('prodotti da forno secchi',1);
INSERT INTO socialmarket.tipop VALUES ('pandoro',0.5);
INSERT INTO socialmarket.tipop VALUES ('pesce surgelato',2);

--prodotto

INSERT INTO socialmarket.prodotto VALUES ('Bravo ACE', '11/09/2022', 60, 2, '11/03/2023', 'Succhi di frutta',6);
INSERT INTO socialmarket.prodotto VALUES ('Farfalle Barilla', '24/09/2022', 100, 1, '24/10/2022', 'Pasta',1);
INSERT INTO socialmarket.prodotto VALUES ('Caffè Nespresso', '18/09/2022', 15, 5, '18/09/2023', 'Caffè',12);
INSERT INTO socialmarket.prodotto VALUES ('Olio Carli', '08/07/2023', 8, 2, '08/07/2024', 'Olio extravergine di oliva',12);
INSERT INTO socialmarket.prodotto VALUES ('Salsa Mutti', '21/04/2025', 16, 1, '21/06/2025', 'Salsa di pomodoro',2);
INSERT INTO socialmarket.prodotto VALUES ('Tonno pinnagialla', '27/08/2026', 38, 4, '27/09/2026', 'tonno sottolio',1);
INSERT INTO socialmarket.prodotto VALUES ('Taralli', '17/12/2022', 50, 3, '17/01/2023', 'prodotti da forno secchi',1);
INSERT INTO socialmarket.prodotto VALUES ('Pandoro Bauli', '05/03/2023', 12, 6, '20/03/2023', 'pandoro',0.5);
INSERT INTO socialmarket.prodotto VALUES ('Orata', '11/05/2022', 24, 5, '23/11/2022', 'pesce surgelato',2);


--assistenza

INSERT INTO socialmarket.assistenza VALUES ('84XUT7TLS3QF5S', '11/07/2022, 12:43:12', 'C18E594FDCCLFB' ,'KR2XC3UVV58PFK',15,2);
INSERT INTO socialmarket.assistenza VALUES ('1WSOI86W2GHGHP', '01/07/2022, 08:35:52', 'MNJ8ZD7UKY3M4B' ,'MNJ8ZD7UKY3M4B',22,10);
INSERT INTO socialmarket.assistenza VALUES ('1IUA3ZPC8H8HFO', '02/06/2022, 08:45:15', '6BSK3CLXQMRNPS' ,'6BSK3CLXQMRNPS',50,22);

UPDATE socialmarket.cliente
SET saldo = socialmarket.assistenza.saldofinale
FROM socialmarket.assistenza
WHERE socialmarket.cliente.codicefiscale = socialmarket.assistenza.cfcliente;

--compra


INSERT INTO socialmarket.compra VALUES ('84XUT7TLS3QF5S', '11/07/2022, 12:43:12', 'Salsa Mutti','21/04/2025',6);
INSERT INTO socialmarket.compra VALUES ('1WSOI86W2GHGHP', '01/07/2022, 08:35:52', 'Farfalle Barilla','24/09/2022',2);
INSERT INTO socialmarket.compra VALUES ('1IUA3ZPC8H8HFO', '02/06/2022, 08:45:15', 'Caffè Nespresso','18/09/2022',3);

--include

INSERT INTO socialmarket.include VALUES ('00000000000002', '06/06/2022, 18:45:22', 'Olio Carli', '08/07/2023', 2);
INSERT INTO socialmarket.include VALUES ('00000000000001', '11/07/2022, 13:10:23', 'Tonno pinnagialla', '27/08/2026', 15);
INSERT INTO socialmarket.include VALUES ('EEBWI1QFN96P38', '11/07/2022', 'Bravo ACE', '11/09/2022', 7);


--riceve

INSERT INTO socialmarket.rifornisce VALUES ('84XUT7TLS3QF5S', '12/07/2022, 17:43:12', 'Olio Carli', '08/07/2023', 2);
INSERT INTO socialmarket.rifornisce VALUES ('1WSOI86W2GHGHP', '11/07/2022, 18:20:18', 'Tonno pinnagialla', '27/08/2026', 15);
INSERT INTO socialmarket.rifornisce VALUES ('84XUT7TLS3QF5S', '12/07/2022', 'Bravo ACE', '11/09/2022', 7);

--scarica

INSERT INTO socialmarket.scarica VALUES ('84XUT7TLS3QF5S', '15/07/2022, 17:20:18', 'Orata', '11/05/2022', 2);

--trasporto

INSERT INTO socialmarket.trasporto VALUES ('84XUT7TLS3QF5S', '14/07/2022, 13:15:32', '00000000000001', 5);


--turni

INSERT INTO socialmarket.turni VALUES ('84XUT7TLS3QF5S', '12/07/2022', 'Rifornimento');
INSERT INTO socialmarket.turni VALUES ('1WSOI86W2GHGHP', '11/07/2022', 'Rifornimento');
INSERT INTO socialmarket.turni VALUES ('8W9FG3QEUDN8OO', '15/07/2022', 'Accoglienza');
INSERT INTO socialmarket.turni VALUES ('1IUA3ZPC8H8HFO', '12/07/2022', 'Riordino');
INSERT INTO socialmarket.turni VALUES ('1IUA3ZPC8H8HFO', '13/07/2022', 'Accoglienza');
INSERT INTO socialmarket.turni VALUES ('1IUA3ZPC8H8HFO', '20/07/2022', 'Rifornimento');




