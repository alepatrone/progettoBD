PGDMP                         z           SocialMarket    9.6.24    9.6.24 Y    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    33164    SocialMarket    DATABASE     �   CREATE DATABASE "SocialMarket" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Italian_Italy.1252' LC_CTYPE = 'Italian_Italy.1252';
    DROP DATABASE "SocialMarket";
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        2615    33165    socialmarket    SCHEMA        CREATE SCHEMA socialmarket;
    DROP SCHEMA socialmarket;
             postgres    false                        3079    12387    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1255    33435    mantenimento_disponibilita()    FUNCTION     �  CREATE FUNCTION public.mantenimento_disponibilita() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 3   DROP FUNCTION public.mantenimento_disponibilita();
       public       postgres    false    3    1            �            1255    33356    scarico_inventario()    FUNCTION     �  CREATE FUNCTION public.scarico_inventario() RETURNS void
    LANGUAGE plpgsql
    AS $$ 

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
$$;
 +   DROP FUNCTION public.scarico_inventario();
       public       postgres    false    3    1            �            1259    33372    turni    TABLE     �   CREATE TABLE socialmarket.turni (
    codicefiscale character varying(14) NOT NULL,
    dataora timestamp without time zone NOT NULL,
    attivita character varying(30)
);
    DROP TABLE socialmarket.turni;
       socialmarket         postgres    false    7            �            1255    33384 X   turni_check(character varying, timestamp without time zone, timestamp without time zone)    FUNCTION     t  CREATE FUNCTION public.turni_check(volontario character varying, data1 timestamp without time zone, data2 timestamp without time zone) RETURNS SETOF socialmarket.turni
    LANGUAGE plpgsql
    AS $_$ 

begin

RETURN QUERY EXECUTE '
SELECT *
FROM socialmarket.turni
WHERE (codicefiscale = $1 AND  dataora >= $2 AND dataora <= $3)' USING volontario,data1,data2 ;

end;
$_$;
 �   DROP FUNCTION public.turni_check(volontario character varying, data1 timestamp without time zone, data2 timestamp without time zone);
       public       postgres    false    1    3    202            �            1255    33391    volontario_non_disponibile()    FUNCTION     f  CREATE FUNCTION public.volontario_non_disponibile() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
IF EXISTS (SELECT * FROM socialmarket.turni
WHERE NEW.codicefiscale=codicefiscale AND extract(day from NEW.dataora) = extract(day from dataora))
THEN
RAISE EXCEPTION 'Volontario già impegnato in altra attività';
ROLLBACK;
END IF;
RETURN NEW;
END;
$$;
 3   DROP FUNCTION public.volontario_non_disponibile();
       public       postgres    false    3    1            �            1259    33314 
   assistenza    TABLE       CREATE TABLE socialmarket.assistenza (
    codicefiscale character varying(14) NOT NULL,
    dataora timestamp without time zone NOT NULL,
    cfcliente character varying(14) NOT NULL,
    cfmembro character varying(14),
    saldoiniziale numeric(2,0),
    saldofinale numeric(2,0)
);
 $   DROP TABLE socialmarket.assistenza;
       socialmarket         postgres    false    7            �            1259    33181    cliente    TABLE       CREATE TABLE socialmarket.cliente (
    codicefiscale character varying(14) NOT NULL,
    codicetessera numeric(7,0) NOT NULL,
    ente character varying(30) NOT NULL,
    saldo numeric(2,0) NOT NULL,
    puntimensili numeric(2,0) NOT NULL,
    datainaut date NOT NULL
);
 !   DROP TABLE socialmarket.cliente;
       socialmarket         postgres    false    7            �            1259    33334    compra    TABLE     �   CREATE TABLE socialmarket.compra (
    codicefiscale character varying(14) NOT NULL,
    dataora timestamp without time zone NOT NULL,
    nome character varying(30) NOT NULL,
    scadenza date NOT NULL,
    quantita numeric(4,0) NOT NULL
);
     DROP TABLE socialmarket.compra;
       socialmarket         postgres    false    7            �            1259    33214    donatore    TABLE     U   CREATE TABLE socialmarket.donatore (
    idfiscale character varying(14) NOT NULL
);
 "   DROP TABLE socialmarket.donatore;
       socialmarket         postgres    false    7            �            1259    33219 	   donazione    TABLE     �   CREATE TABLE socialmarket.donazione (
    idfiscale character varying(14) NOT NULL,
    dataora timestamp without time zone NOT NULL,
    importo numeric(9,2) NOT NULL
);
 #   DROP TABLE socialmarket.donazione;
       socialmarket         postgres    false    7            �            1259    33244    include    TABLE     �   CREATE TABLE socialmarket.include (
    idfiscale character varying(14) NOT NULL,
    dataora timestamp without time zone NOT NULL,
    nome character varying(30) NOT NULL,
    scadenza date NOT NULL,
    quantita numeric(4,0) NOT NULL
);
 !   DROP TABLE socialmarket.include;
       socialmarket         postgres    false    7            �            1259    33193    membro    TABLE     S  CREATE TABLE socialmarket.membro (
    codicefiscale character varying(14) NOT NULL,
    titolaretessera character varying(14),
    fasciaeta character(1) NOT NULL,
    autorizzato boolean NOT NULL,
    CONSTRAINT membro_fasciaeta_check CHECK ((fasciaeta = ANY (ARRAY['n'::bpchar, 'b'::bpchar, 't'::bpchar, 'a'::bpchar, 'o'::bpchar])))
);
     DROP TABLE socialmarket.membro;
       socialmarket         postgres    false    7            �            1259    33209    negozio    TABLE     �   CREATE TABLE socialmarket.negozio (
    idfiscale character varying(14) NOT NULL,
    nome character varying(30) NOT NULL,
    sede character varying(30) NOT NULL
);
 !   DROP TABLE socialmarket.negozio;
       socialmarket         postgres    false    7            �            1259    33166    persona    TABLE     �   CREATE TABLE socialmarket.persona (
    codicefiscale character varying(14) NOT NULL,
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL
);
 !   DROP TABLE socialmarket.persona;
       socialmarket         postgres    false    7            �            1259    33234    prodotto    TABLE       CREATE TABLE socialmarket.prodotto (
    nome character varying(30) NOT NULL,
    scadenza date NOT NULL,
    quantita numeric(4,0) NOT NULL,
    punti numeric(2,0) NOT NULL,
    datacomm date,
    tipo character varying(30),
    durataextra numeric(3,0)
);
 "   DROP TABLE socialmarket.prodotto;
       socialmarket         postgres    false    7            �            1259    33171    recapito    TABLE     �   CREATE TABLE socialmarket.recapito (
    codicefiscale character varying(14) NOT NULL,
    numero character varying(10) NOT NULL
);
 "   DROP TABLE socialmarket.recapito;
       socialmarket         postgres    false    7            �            1259    33284 
   rifornisce    TABLE     �   CREATE TABLE socialmarket.rifornisce (
    codicefiscale character varying(14) NOT NULL,
    dataora timestamp without time zone NOT NULL,
    nome character varying(30) NOT NULL,
    scadenza date NOT NULL,
    quantita numeric(4,0) NOT NULL
);
 $   DROP TABLE socialmarket.rifornisce;
       socialmarket         postgres    false    7            �            1259    33299    scarica    TABLE     �   CREATE TABLE socialmarket.scarica (
    codicefiscale character varying(14) NOT NULL,
    dataora timestamp without time zone NOT NULL,
    nome character varying(30) NOT NULL,
    scadenza date NOT NULL,
    quantita numeric(4,0) NOT NULL
);
 !   DROP TABLE socialmarket.scarica;
       socialmarket         postgres    false    7            �            1259    33229    tipop    TABLE     k   CREATE TABLE socialmarket.tipop (
    tipo character varying(30) NOT NULL,
    durataextra numeric(3,0)
);
    DROP TABLE socialmarket.tipop;
       socialmarket         postgres    false    7            �            1259    33269 	   trasporto    TABLE     �   CREATE TABLE socialmarket.trasporto (
    codicefiscale character varying(14) NOT NULL,
    dataora timestamp without time zone NOT NULL,
    id character varying(14),
    numeroscatole numeric(4,0)
);
 #   DROP TABLE socialmarket.trasporto;
       socialmarket         postgres    false    7            �            1259    33259 
   volontario    TABLE     �   CREATE TABLE socialmarket.volontario (
    codicefiscale character varying(14) NOT NULL,
    veicolo character varying(7),
    associazione character varying(30)
);
 $   DROP TABLE socialmarket.volontario;
       socialmarket         postgres    false    7            �          0    33314 
   assistenza 
   TABLE DATA               s   COPY socialmarket.assistenza (codicefiscale, dataora, cfcliente, cfmembro, saldoiniziale, saldofinale) FROM stdin;
    socialmarket       postgres    false    200   )y       �          0    33181    cliente 
   TABLE DATA               k   COPY socialmarket.cliente (codicefiscale, codicetessera, ente, saldo, puntimensili, datainaut) FROM stdin;
    socialmarket       postgres    false    188   �       �          0    33334    compra 
   TABLE DATA               X   COPY socialmarket.compra (codicefiscale, dataora, nome, scadenza, quantita) FROM stdin;
    socialmarket       postgres    false    201   ͉       �          0    33214    donatore 
   TABLE DATA               3   COPY socialmarket.donatore (idfiscale) FROM stdin;
    socialmarket       postgres    false    191   )�       �          0    33219 	   donazione 
   TABLE DATA               F   COPY socialmarket.donazione (idfiscale, dataora, importo) FROM stdin;
    socialmarket       postgres    false    192   ��       �          0    33244    include 
   TABLE DATA               U   COPY socialmarket.include (idfiscale, dataora, nome, scadenza, quantita) FROM stdin;
    socialmarket       postgres    false    195   ��       �          0    33193    membro 
   TABLE DATA               ^   COPY socialmarket.membro (codicefiscale, titolaretessera, fasciaeta, autorizzato) FROM stdin;
    socialmarket       postgres    false    189   ��       �          0    33209    negozio 
   TABLE DATA               >   COPY socialmarket.negozio (idfiscale, nome, sede) FROM stdin;
    socialmarket       postgres    false    190   +�       �          0    33166    persona 
   TABLE DATA               E   COPY socialmarket.persona (codicefiscale, nome, cognome) FROM stdin;
    socialmarket       postgres    false    186   a�       �          0    33234    prodotto 
   TABLE DATA               f   COPY socialmarket.prodotto (nome, scadenza, quantita, punti, datacomm, tipo, durataextra) FROM stdin;
    socialmarket       postgres    false    194   �	      �          0    33171    recapito 
   TABLE DATA               ?   COPY socialmarket.recapito (codicefiscale, numero) FROM stdin;
    socialmarket       postgres    false    187   _      �          0    33284 
   rifornisce 
   TABLE DATA               \   COPY socialmarket.rifornisce (codicefiscale, dataora, nome, scadenza, quantita) FROM stdin;
    socialmarket       postgres    false    198   ;w      �          0    33299    scarica 
   TABLE DATA               Y   COPY socialmarket.scarica (codicefiscale, dataora, nome, scadenza, quantita) FROM stdin;
    socialmarket       postgres    false    199   J}      �          0    33229    tipop 
   TABLE DATA               8   COPY socialmarket.tipop (tipo, durataextra) FROM stdin;
    socialmarket       postgres    false    193   ��      �          0    33269 	   trasporto 
   TABLE DATA               T   COPY socialmarket.trasporto (codicefiscale, dataora, id, numeroscatole) FROM stdin;
    socialmarket       postgres    false    197   (�      �          0    33372    turni 
   TABLE DATA               G   COPY socialmarket.turni (codicefiscale, dataora, attivita) FROM stdin;
    socialmarket       postgres    false    202   &�      �          0    33259 
   volontario 
   TABLE DATA               P   COPY socialmarket.volontario (codicefiscale, veicolo, associazione) FROM stdin;
    socialmarket       postgres    false    196   ��      4           2606    33318    assistenza assistenza_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY socialmarket.assistenza
    ADD CONSTRAINT assistenza_pkey PRIMARY KEY (codicefiscale, dataora);
 J   ALTER TABLE ONLY socialmarket.assistenza DROP CONSTRAINT assistenza_pkey;
       socialmarket         postgres    false    200    200    200                       2606    33187 !   cliente cliente_codicetessera_key 
   CONSTRAINT     k   ALTER TABLE ONLY socialmarket.cliente
    ADD CONSTRAINT cliente_codicetessera_key UNIQUE (codicetessera);
 Q   ALTER TABLE ONLY socialmarket.cliente DROP CONSTRAINT cliente_codicetessera_key;
       socialmarket         postgres    false    188    188                       2606    33185    cliente cliente_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY socialmarket.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (codicefiscale);
 D   ALTER TABLE ONLY socialmarket.cliente DROP CONSTRAINT cliente_pkey;
       socialmarket         postgres    false    188    188            6           2606    33338    compra compra_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY socialmarket.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (codicefiscale, dataora, nome, scadenza);
 B   ALTER TABLE ONLY socialmarket.compra DROP CONSTRAINT compra_pkey;
       socialmarket         postgres    false    201    201    201    201    201            "           2606    33218    donatore donatore_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY socialmarket.donatore
    ADD CONSTRAINT donatore_pkey PRIMARY KEY (idfiscale);
 F   ALTER TABLE ONLY socialmarket.donatore DROP CONSTRAINT donatore_pkey;
       socialmarket         postgres    false    191    191            $           2606    33223    donazione donazione_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY socialmarket.donazione
    ADD CONSTRAINT donazione_pkey PRIMARY KEY (idfiscale, dataora);
 H   ALTER TABLE ONLY socialmarket.donazione DROP CONSTRAINT donazione_pkey;
       socialmarket         postgres    false    192    192    192            *           2606    33248    include include_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY socialmarket.include
    ADD CONSTRAINT include_pkey PRIMARY KEY (idfiscale, dataora, nome, scadenza);
 D   ALTER TABLE ONLY socialmarket.include DROP CONSTRAINT include_pkey;
       socialmarket         postgres    false    195    195    195    195    195                       2606    33198    membro membro_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY socialmarket.membro
    ADD CONSTRAINT membro_pkey PRIMARY KEY (codicefiscale);
 B   ALTER TABLE ONLY socialmarket.membro DROP CONSTRAINT membro_pkey;
       socialmarket         postgres    false    189    189                        2606    33213    negozio negozio_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY socialmarket.negozio
    ADD CONSTRAINT negozio_pkey PRIMARY KEY (idfiscale);
 D   ALTER TABLE ONLY socialmarket.negozio DROP CONSTRAINT negozio_pkey;
       socialmarket         postgres    false    190    190                       2606    33170    persona persona_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY socialmarket.persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (codicefiscale);
 D   ALTER TABLE ONLY socialmarket.persona DROP CONSTRAINT persona_pkey;
       socialmarket         postgres    false    186    186            (           2606    33238    prodotto prodotto_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY socialmarket.prodotto
    ADD CONSTRAINT prodotto_pkey PRIMARY KEY (nome, scadenza);
 F   ALTER TABLE ONLY socialmarket.prodotto DROP CONSTRAINT prodotto_pkey;
       socialmarket         postgres    false    194    194    194                       2606    33175    recapito recapito_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY socialmarket.recapito
    ADD CONSTRAINT recapito_pkey PRIMARY KEY (codicefiscale, numero);
 F   ALTER TABLE ONLY socialmarket.recapito DROP CONSTRAINT recapito_pkey;
       socialmarket         postgres    false    187    187    187            0           2606    33288    rifornisce rifornisce_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY socialmarket.rifornisce
    ADD CONSTRAINT rifornisce_pkey PRIMARY KEY (codicefiscale, dataora, nome, scadenza);
 J   ALTER TABLE ONLY socialmarket.rifornisce DROP CONSTRAINT rifornisce_pkey;
       socialmarket         postgres    false    198    198    198    198    198            2           2606    33303    scarica scarica_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY socialmarket.scarica
    ADD CONSTRAINT scarica_pkey PRIMARY KEY (codicefiscale, dataora, nome, scadenza);
 D   ALTER TABLE ONLY socialmarket.scarica DROP CONSTRAINT scarica_pkey;
       socialmarket         postgres    false    199    199    199    199    199            &           2606    33233    tipop tipop_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY socialmarket.tipop
    ADD CONSTRAINT tipop_pkey PRIMARY KEY (tipo);
 @   ALTER TABLE ONLY socialmarket.tipop DROP CONSTRAINT tipop_pkey;
       socialmarket         postgres    false    193    193            .           2606    33273    trasporto trasporto_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY socialmarket.trasporto
    ADD CONSTRAINT trasporto_pkey PRIMARY KEY (codicefiscale, dataora);
 H   ALTER TABLE ONLY socialmarket.trasporto DROP CONSTRAINT trasporto_pkey;
       socialmarket         postgres    false    197    197    197            8           2606    33376    turni turni_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY socialmarket.turni
    ADD CONSTRAINT turni_pkey PRIMARY KEY (codicefiscale, dataora);
 @   ALTER TABLE ONLY socialmarket.turni DROP CONSTRAINT turni_pkey;
       socialmarket         postgres    false    202    202    202            ,           2606    33263    volontario volontario_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY socialmarket.volontario
    ADD CONSTRAINT volontario_pkey PRIMARY KEY (codicefiscale);
 J   ALTER TABLE ONLY socialmarket.volontario DROP CONSTRAINT volontario_pkey;
       socialmarket         postgres    false    196    196            P           2620    33392    turni attivita_contemp    TRIGGER     �   CREATE TRIGGER attivita_contemp BEFORE INSERT OR UPDATE ON socialmarket.turni FOR EACH ROW EXECUTE PROCEDURE public.volontario_non_disponibile();
 5   DROP TRIGGER attivita_contemp ON socialmarket.turni;
       socialmarket       postgres    false    203    202            O           2620    33436    compra disponibilita    TRIGGER     �   CREATE TRIGGER disponibilita AFTER INSERT OR UPDATE ON socialmarket.compra FOR EACH ROW EXECUTE PROCEDURE public.mantenimento_disponibilita();
 3   DROP TRIGGER disponibilita ON socialmarket.compra;
       socialmarket       postgres    false    218    201            I           2606    33324 $   assistenza assistenza_cfcliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.assistenza
    ADD CONSTRAINT assistenza_cfcliente_fkey FOREIGN KEY (cfcliente) REFERENCES socialmarket.cliente(codicefiscale);
 T   ALTER TABLE ONLY socialmarket.assistenza DROP CONSTRAINT assistenza_cfcliente_fkey;
       socialmarket       postgres    false    188    200    2076            J           2606    33329 #   assistenza assistenza_cfmembro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.assistenza
    ADD CONSTRAINT assistenza_cfmembro_fkey FOREIGN KEY (cfmembro) REFERENCES socialmarket.membro(codicefiscale);
 S   ALTER TABLE ONLY socialmarket.assistenza DROP CONSTRAINT assistenza_cfmembro_fkey;
       socialmarket       postgres    false    200    2078    189            H           2606    33319 (   assistenza assistenza_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.assistenza
    ADD CONSTRAINT assistenza_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.volontario(codicefiscale);
 X   ALTER TABLE ONLY socialmarket.assistenza DROP CONSTRAINT assistenza_codicefiscale_fkey;
       socialmarket       postgres    false    200    2092    196            :           2606    33188 "   cliente cliente_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.cliente
    ADD CONSTRAINT cliente_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.persona(codicefiscale);
 R   ALTER TABLE ONLY socialmarket.cliente DROP CONSTRAINT cliente_codicefiscale_fkey;
       socialmarket       postgres    false    188    186    2070            K           2606    33339     compra compra_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.compra
    ADD CONSTRAINT compra_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.volontario(codicefiscale);
 P   ALTER TABLE ONLY socialmarket.compra DROP CONSTRAINT compra_codicefiscale_fkey;
       socialmarket       postgres    false    196    2092    201            L           2606    33344 !   compra compra_codicefiscale_fkey1    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.compra
    ADD CONSTRAINT compra_codicefiscale_fkey1 FOREIGN KEY (codicefiscale, dataora) REFERENCES socialmarket.assistenza(codicefiscale, dataora);
 Q   ALTER TABLE ONLY socialmarket.compra DROP CONSTRAINT compra_codicefiscale_fkey1;
       socialmarket       postgres    false    201    201    200    200    2100            M           2606    33349    compra compra_nome_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.compra
    ADD CONSTRAINT compra_nome_fkey FOREIGN KEY (nome, scadenza) REFERENCES socialmarket.prodotto(nome, scadenza);
 G   ALTER TABLE ONLY socialmarket.compra DROP CONSTRAINT compra_nome_fkey;
       socialmarket       postgres    false    201    194    2088    201    194            =           2606    33224 "   donazione donazione_idfiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.donazione
    ADD CONSTRAINT donazione_idfiscale_fkey FOREIGN KEY (idfiscale) REFERENCES socialmarket.donatore(idfiscale);
 R   ALTER TABLE ONLY socialmarket.donazione DROP CONSTRAINT donazione_idfiscale_fkey;
       socialmarket       postgres    false    192    2082    191            ?           2606    33249    include include_idfiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.include
    ADD CONSTRAINT include_idfiscale_fkey FOREIGN KEY (idfiscale, dataora) REFERENCES socialmarket.donazione(idfiscale, dataora);
 N   ALTER TABLE ONLY socialmarket.include DROP CONSTRAINT include_idfiscale_fkey;
       socialmarket       postgres    false    2084    192    192    195    195            @           2606    33254    include include_nome_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.include
    ADD CONSTRAINT include_nome_fkey FOREIGN KEY (nome, scadenza) REFERENCES socialmarket.prodotto(nome, scadenza);
 I   ALTER TABLE ONLY socialmarket.include DROP CONSTRAINT include_nome_fkey;
       socialmarket       postgres    false    194    195    2088    194    195            ;           2606    33199     membro membro_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.membro
    ADD CONSTRAINT membro_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.persona(codicefiscale);
 P   ALTER TABLE ONLY socialmarket.membro DROP CONSTRAINT membro_codicefiscale_fkey;
       socialmarket       postgres    false    2070    186    189            <           2606    33204 "   membro membro_titolaretessera_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.membro
    ADD CONSTRAINT membro_titolaretessera_fkey FOREIGN KEY (titolaretessera) REFERENCES socialmarket.persona(codicefiscale);
 R   ALTER TABLE ONLY socialmarket.membro DROP CONSTRAINT membro_titolaretessera_fkey;
       socialmarket       postgres    false    2070    189    186            >           2606    33239    prodotto prodotto_tipo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.prodotto
    ADD CONSTRAINT prodotto_tipo_fkey FOREIGN KEY (tipo) REFERENCES socialmarket.tipop(tipo);
 K   ALTER TABLE ONLY socialmarket.prodotto DROP CONSTRAINT prodotto_tipo_fkey;
       socialmarket       postgres    false    194    2086    193            9           2606    33176 $   recapito recapito_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.recapito
    ADD CONSTRAINT recapito_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.persona(codicefiscale);
 T   ALTER TABLE ONLY socialmarket.recapito DROP CONSTRAINT recapito_codicefiscale_fkey;
       socialmarket       postgres    false    187    186    2070            D           2606    33289 (   rifornisce rifornisce_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.rifornisce
    ADD CONSTRAINT rifornisce_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.volontario(codicefiscale);
 X   ALTER TABLE ONLY socialmarket.rifornisce DROP CONSTRAINT rifornisce_codicefiscale_fkey;
       socialmarket       postgres    false    2092    196    198            E           2606    33294    rifornisce rifornisce_nome_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.rifornisce
    ADD CONSTRAINT rifornisce_nome_fkey FOREIGN KEY (nome, scadenza) REFERENCES socialmarket.prodotto(nome, scadenza);
 O   ALTER TABLE ONLY socialmarket.rifornisce DROP CONSTRAINT rifornisce_nome_fkey;
       socialmarket       postgres    false    198    2088    194    194    198            F           2606    33304 "   scarica scarica_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.scarica
    ADD CONSTRAINT scarica_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.volontario(codicefiscale);
 R   ALTER TABLE ONLY socialmarket.scarica DROP CONSTRAINT scarica_codicefiscale_fkey;
       socialmarket       postgres    false    2092    196    199            G           2606    33309    scarica scarica_nome_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.scarica
    ADD CONSTRAINT scarica_nome_fkey FOREIGN KEY (nome, scadenza) REFERENCES socialmarket.prodotto(nome, scadenza);
 I   ALTER TABLE ONLY socialmarket.scarica DROP CONSTRAINT scarica_nome_fkey;
       socialmarket       postgres    false    194    194    199    199    2088            B           2606    33274 &   trasporto trasporto_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.trasporto
    ADD CONSTRAINT trasporto_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.volontario(codicefiscale);
 V   ALTER TABLE ONLY socialmarket.trasporto DROP CONSTRAINT trasporto_codicefiscale_fkey;
       socialmarket       postgres    false    197    196    2092            C           2606    33279    trasporto trasporto_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.trasporto
    ADD CONSTRAINT trasporto_id_fkey FOREIGN KEY (id) REFERENCES socialmarket.negozio(idfiscale);
 K   ALTER TABLE ONLY socialmarket.trasporto DROP CONSTRAINT trasporto_id_fkey;
       socialmarket       postgres    false    190    197    2080            N           2606    33377    turni turni_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.turni
    ADD CONSTRAINT turni_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.volontario(codicefiscale);
 N   ALTER TABLE ONLY socialmarket.turni DROP CONSTRAINT turni_codicefiscale_fkey;
       socialmarket       postgres    false    2092    196    202            A           2606    33264 (   volontario volontario_codicefiscale_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY socialmarket.volontario
    ADD CONSTRAINT volontario_codicefiscale_fkey FOREIGN KEY (codicefiscale) REFERENCES socialmarket.persona(codicefiscale);
 X   ALTER TABLE ONLY socialmarket.volontario DROP CONSTRAINT volontario_codicefiscale_fkey;
       socialmarket       postgres    false    2070    186    196            �   �  x�mXk�4��ݬb6��������:U]�sԚ���1�W�8���ݫ���h����������,�w�x+skݫ�+f��vmzf3�������=��>k�:��f���O�d�ӫY��ul�|xƱT�fUfU���w���d��Ԋi�sT����yf3��?c���5�����<c��e,��rVnr&'���y�u�@o羻ӕϸߧ��<А��w���؏���MY��]8�g*sH�A�b��yƊ����)k[:�w&u4���36��,q3q7�;���b��~E�T�jޞ���3�y��1i�����t��Oc�Gf���q��҈��.���[<���x�;�Fl�Sb3�X�6�T{Eܫ�g[��x�X~��$����w��?�Ɖgl8���U��"�|Ӌ�y�HE������wiMK3����V�����o�tz�����u����{�ƙO�ō��B�?BL��<c�i�چ�Y����-�����1�6��2�ﱱq��vDm���S�OX-��L��֭w�8k����ڈZG����0��<�e@��y�ț-��}3�M<c�ReؗV��i�����=r��ty�;r,ׁ�'l�8�zT���)���%���L�*\wkzt��x��¥����]���3��P뫢.l��Fg�1��K��D�i{��H�	C�0۱Y�8�7��oP�0���4�{��橼���3V�$ܸ��W�q��y��D<���*�X��@c-f�1�L\V��f������3���]t|S��G�YW�O8���F�u���*�3��ԋ�;��@c��|+���bE���4��X��2Cg6�
��X�J^����f�qǩ��aE����U��4�&8��.�O���8��{���W��J��|k�!����˙����{\�Ba���㘴�.�Oc��ȯ�	<��)�ksC<c����6�R�U��p�0�84I�B&PP��S�X�g�l#�pQ��(5�#��il8��١����Kc�1�-�x�H
�σa�B��|���ql��=�!�i��1һ,��-��SM��y�ˣ{Ӑ����+
5���~c�&Z����5�;�4��~h��vK��/%�!�i���=��ɰ(���g�+vկ�j���̧�3�ض�-�>��0�r�G�������A�����וa�Z�i<�f��^��G:#k~;�COC�%.b�=~F�{�;��ݝ|�ri�0�8:d������7N|�"6Q�z�}�ٝ�>�х�o]������̜��3��������xʾ��:�3��442�cP�Γ�g|yxD9�]��}�
��g��=��7�ؔ3��^(��Bl6iK9�	_�2�ϰڐ���_�G��f��A�V$���3�����ȸ�d�� ��ÿ8�A�m��xҋD��<6,��m���O���wd�q���->
���)��3��R`edz��-��e��i��e��Xѻ��
��̧�W����jI-/+1��q;�����.�� 󌯾ů����tPql��w�4v]���CM�5���x<�#��N�ǜ�w8������뢦i���8�y��U)>?��F�/;��c ��h�K�K�9C)��)�x�G�ˣ�X�Fi�h�3���P��&v9}?�v�����a��8�#Hlј�c�����[J�?�\]      �   �	  x�MXG��8<���	Q4���y�^�	�LG�a���HöB��p�����9e;����gy8�pd���/\��
B���Uh�kT�C<�Cw[�h�(����멗	<7�]iΡ�&n��(�~�%��g�t�	�W��:������rk�2vН�N<���Kzڕ��d�;���r=���yr�����_Z��9��[U�p{=E��(��g[��/�����	���h��<��@�#����۷�P-�t,UwUt��9g�h�]��^�!��}&(<�<�y.�����v�#?m�t�֞�O��	��9�=$Q�Y�	
:�93�_Vi�e m�s]��*�
��[������T�'�g4�����ӫ"|�}7�� �[W W ùDe}VW]��7ţ�q� ����r�9LESG��9�D�w9�/%�������2�E�5�r�Y�8��-�@�Vָ�38���y\�-�ڑ����eсr���?�M~o���3m��tK�+�&��tm��k���/����3Ga_�.�Kim���͖���LC�(C_�9�W/��n�������8WQZ����]�	Z�[�W������������v��`
`*�$���1��<���p�{�x.�O_��
�CZ�ٶ�����-��~	L�����w2�ݱ��=fM:9*|υ)
�c�D����5czM��[[w`t@��\�0� Ժ}8>c�b��kۗ�u�����/��L�Zmp%ƴ�)��=[/���
�T1���������e'r�y�U��7|��������S.��څ�0���+0=�#Y����G�;L�b%C�YP�'�v�:$IwVԸR?� G�\򡰒A��)��y�����5�c=�P=�j�\հ��q���?���t44�0�MQWi��y�0O�o�W I�]LDa�E�������E�_��	�
��r�L�S���ا+���0!�k�_D�4��|_Ӳ��R�:h�k����1��8���J�H��_L2����;�1��rY���ѡi�QS���2M$��L�ٛ+�:��̳��8�!>O1�{��I���/j��(�#ax�.�#�Θ&�Xc��W��L���h
�(gP���jϦ�c�5������Р\=�g{�EM���*�-G3(e�<��>j������h�
&a�/�$� ȨV�Z�Q�Q�:�\�-!b�
��� �����.?Y�?��H��Bb@=�n���]<�Y�7�]�3��P0t�C6�U�sK�݇�b��2��Kb,�wCqn���S�De٬%7c~s��ݣe3�#��lM����0���{
s���jS]G~�U|��w��EL� �� ���#��M��L�R��yE�0�#P>m6���w�C���7�h^Hb�H���㜢~��z+�gt�;�ш��0 �fP�����*�c #�FQ3
L�`cqSu��v*�����@�_��@�!؂v@�g�i��x�F6=�����X�3��ܶ[���\;��o��`�`!9����<�9?����^@ۮH��a�쌇�����I�/��
�	�<��:�	�ɲuK�t]���C�3����*<5��j���&��O��B���^�t-�r�n ^{?M
pE�E���|�<�Z�{�����ԋ����x�4��2�Ƶ���2�$�!I%�0�����M��K���[4C;��G3Q�r��tJ����䗨����~`W�1�F�vl՝�ži�P������1m���ǽ�ǚj�'kP;/A19�uD�x^�G4��DF#1	���q�0��!xxZvI��U{��|�uTd��>��T `L�m��,[��D��A�(��MD��1Ed��.^�k�F�;�Qv��k�b&�0��4Em��}ב�}W@P³�2��?<=�f+��X"D�77��a��M#Dy���o�;w|��wŏ0R�G@��t��i]��,Wz�|}�P��<1�1��f]�r9�)�*�����tHc������>O���6:��k$4I��jǊ灲Ew7�c��X���|!<�2�]�n�(�n�x���S�0z��cԵ��L�(I��(���}Z_�B ,��M��mE�W���8N�Xސ�2n�뜺c?�fAz���n�,����3�Q��iﻥJ��^3������u��a���~��e��9>њ8�g��8`՘b{��CTS��4Cs��k�h��nXF5��d�����q��;}�%�؃�A�!�z M�_����vz0ANe�G���H���.McG�}����#�B���h���N`K5������CQ�!c:me�'yܥ-)؟������	L����$�Z|����
Q����<�w��ẋ~��~S��&����¶�b��$�Úv��h$�}n*X����*�	-�i��Ş�mU�`w��:֖b����󞩚��Ϥ�L>OZvwI��$kk�2�}��Ӑ�Yt:�g�j�%�D��;�����<^�#s����<�����^��F3�      �   L  x��X[S�~�� ��b�R�f`&vX��Ԧ�bh���mw|Y~}�#_�fH�RE�kdK�|�#�Ujy*��`����B$����D����$M���.�oxʲ��(cqn�ԚTd��O,��W]Y6}r=�C�m�?���ȰX�,�"�:[>-R���MY$����/��.���L�L��D��d��T	i�`_�{/�m������s�
�<�L�2O3i��>n���������P����Pͯ�8o$y�2:,fr~�W�����cE߿(���/Ͷ��ڎE�|�N�+k�4U�g�I�ܔE�l��y��U�0:ͱ�K�&��_����fΒ۶�r�?-#%bm�r���uP�c׎u�[S��ZG�"��J^�7!���|(ve����/%�Sn������aډ �IY�L��si��bГ�Ƣ��O�]��4���,Y��J�S� �������O+��*���߳|~"S���J$�(�yN=��l^�C��.�5��ҍ�y��
��8�2UY�4��<(�P�d]�VÂ_�"���%�V���,�OP��|�~�лf{�|�1tE�@8K.;�Uq�b�g���%��5��_�顭���c��j�#���mry�̱�⌖&>
��@>�OD�b��5^d<�2����p���!	�-q����rH�ˮn��,�GZ��LX�s6�	ON�^<<���.���z\T"�$-7@�j򕇡�}��Ԣ�S ��y��B��9�b!HL��Iv����0�t�t��^�p��X-�f.�J'�s[��c�a�u�tK#R\�	Į����D>����: ��Z��i������8�UW��ǲO.����8KL�TI�Vp� ӿ��'�͡���qU (�f1W8�M��j>>*�xL�k���|{]Y'P@`	z��+�zW�gU�����@�W��@�d��{fR��_:��'��� ���W���4�0��CQS,������C�5�k��X��(\�4O�I+���~76Tůmլ�M�7��H(�0��"�󶩠�窧F�u�j5$�ܹ��k���v�R��?���yA(A��a(�+�,��JP\��Zm��'z�iݶ.�������^U@+vU[{0��Ĺ�АZ�2�V�g�ݶ����;W�$�6C�-�8���h] �[
 C���f<�ܤ0L��͂s��z�����ϲ?v��|�0���(���A�VN{�P�c:�L��tp���0fq���O/er^��4$�A�����ѱlx����o����lV��|ꪠ�"_�Jv�LD�}׶��h��,ϼZ:H �oR�M�2'T��8�~$w���������F$�����Z�oq�cRi��*d�T[�?ԫs g�^�Ν�	����CΧy��ښ\�ɵ*!�6Ǫ+H����W����RX�~d����S[�o[�_���Bxj��� @�`���s�b��-|�l�xl�P=����ئ�w�W��-��몰���s C��~��Z@�m��H#��H�R�l�XhAwc�T�?P���C۔u	�<%�LSD����Z2�(?%�*��8a�s����f�4C�G�z&����V3�M��,������u���-�mbXr�|6�2d��y&|�-�o����%2��u���T
��3ݴ�Sv��ק�|����eN"�`4�)�i�$׋`9{󯹬ۑ�s^�	
tl���2ڈq�B*��xC�'SZSl����� O�/V<� �c�ň�
�y;��pb�C��!�9;�����-K
n��qPZ����n���t٘����qC鼿��՜�9�!3d�����x^���@:�4��%���S^��2l�ӻ��f�t�������ݛ���]�ޒR�6k7d��?���'(?K��5̋pt:��lI���'�S��hJF"l2��fy"�����_��+���N)埄c�t�{����r�j)$
�2%��|�jl�|.�C5`�M>���% pIjF΅�^�����HK��P&����-&���)T�O&V*��ŋ3�7�E$ U�$aڏ?�d�]��q9�O��7 Is��s"�������Ip��S�@2ChF%���]hn�=b�q�܏]��/�}D���Y�'��wQ�]Ay{�j}hP.��y���`�l�%9p��#"Vg��U�9�g�/�g��|Շ�I@ޡ~]�>���ul��B���@)~��7N�@�r�%Zl���}.�n�֥<�cK$�N"�?���0�l�w~/{�ǚD�`#���\q,��	Vx��&%�1���7⟹=%���V�[��rh4Ob��0�K�=O�O�8��nvU>��+4��������ީ��3�L�Κ?�H�5�:Oad�1�C0�@;ߟ�7�4�c��+�;�o�F��@��\�)�Z,��>�	�\`��ga�]�p��i&P��.i�� &�i��"*{V���&��9~$W��],��[d�t�f��l+����W`�]ڒVx�2�:GP��[�� o=����p��7b��4���P.���z��Ĝ�nlJ�)WU�(����e�|s�V���/�~9sw�=�89����cpa��4⻫�\,�4��A[B�Ya9e���Pt-@O���˚e��:��\C7��r,�y8w�} 0ce�|��&�b�
Yb��������2t��������;�]�c�w��,���AS�~d����zm�Ie��mЛ9⸛�i�|�ۂ' �:t�k���;��l��-��dN�n���&Z,��B�<����0cn�ɄQ���M$�(䍔�E��E��e����_��]M}��f�m���?�@ˀ�
��W�0��WS�V����e>"2�^�L"�Y��_�8����      �   n  x�%��m1C��E���{I�u�i����ER���=	�q�\��D���J��>z[n�s�3������\����q�O���z��R	0��QKq�WG;$["KϼX��S�R/����<}�b�q8�Ȩ��;a!f����'��G��8��M�;�F�S�=�%�b�~(�q��a~b��t��L�|:0{�G��WNH��e��^�;��i�:���=�i��K_�R~�OߎF[}�C�PT�=n�Y�}A�y��㝕��[�O>-~�.��^8�qR?o�|�1�F���p���I��n ��V�&�������B�<ۛ���������sy��aM�!h��kmW|���1�����6KW-�&�D��Y�Nf�^m�������*�PP��7��5̒�Q ���A�w�4g��Ds'�������y�����Ӧ�6���I�A�s{��[zeR��72��]<
!�hO2�Zx8�ˇ&��DZs�2Ol�w�j�����NfGgߝZO�S�!���}�8�7CL�g��bE}͗�����u���檌�/�x��_��������Z�������	���yk�%%*�� h<��K������o�g~X�͉����s� ���u      �   �  x�mW�m,9��\�5`Cߒ��뿎�&�3��I��E��[��Ӕ쏐�$�L��{}�pR-�!��x����y�Ix���H玙{g����ĳ.(xe��s+����
]�t���U>��<�H��r��~�WS�Y��mU7��R�����Ϻ]��kH�B�վ���G�N�+tD�4�R۟s�Uo����Sy�����y? �bN���<�s��pQeZ�n�z�������l9�0��ƃ�q����:.h����˫�))�l�������k�$cE�5�g��Ϲ�/���J&�sp��:�9�G����3���^���!�6pv�@�8���:���t$�CK�K�s)\(���foL_N�e���1�H��#_:2��ΐQ)��)��X>��K!��3gW�Kv�O��=2��-��+���G�2J�i_2:�-7�,��B�̿��~^6S&��O{��>s�6450!b�>!��>T뒹s�t9���Uh�a8z���𣣽����p�qu2������A{B? sƧꑛ��c���~�GZ�C��o؏b�=�8�	�d�\�B����l��
<�8�2�Yy���vA��.�N�vqӾ�w9��M��~aQ+`�����Y��o�����tۚ�s�8�%5� E�|�鋧J�������^�vzҏ�j�/�쾧�)�����'ڶ���=�,���f�����M��{�O?*���QF���D�dT_���\H۝���-�e����a��lIMzXz����-C�2�;ܰ�(��tŗ���V�i�=�0�@�~����ss�k`Y��ǊO�P��� `����Џ�:�/�,��=�p�	=fz���\$���M,_��� �R���$#no9G��j����e��ܳ
�-�0R;?0��g��B��UWs���G�/�!#u��̝�j��FoyT�#��/��No��Y�����=׀�u���vQ/�U�-6��ig���-�u�pq{"���f�٦�8���]NV�:"�~z�l���b�����a 
�|g��<<��gf�~��no9�����Q���}��f��k���֡�ٛ!W���8�둍�ͼ��h�ȴy?f@�Y���cXM�AX�uO/�I��/� �0G>�n�[:�4�nT�	��Rr�ə|O�7ʎ�,��A5��������H���W��g�Q�ҡ":�=��ۗ�";�H���*��·Ԡ����hF���_���~I�iFȥ׃�`� f�_�� =:�\*�_Q�zO `vP��&�g�-�W�6r8�©~�·Y�"�r�����-�^�O�D xj輤��k>��)��qiΌ_��y>���|x�v0����{�˜��i��㬛���ig�[�����,��L����%�y�O,�w�� Uq�0*�x���~<uF����M����^=��c��S�~����~�
����OEr��4�sR,�T�Xx��S������ۗ      �   P  x��Y�r��}&� l0wL�$ٲ�Xk���kSy��( Y���3ٛT�ʺ�����n3�k)J��%gE�V�e�W������X�E~톻�>}F%[Y�q.�]QI�NQ���C]wc~}'7lN�
�WZg��Յ���_8��u|x]��#^~մm=���!�j%D�JS���������������v}���VJg��to�?=��C�r��;�;<}��������t>(��UU�)*.E���G\z���~�?u��?�����ې��U�dY ".%���x��ڍ���C�J��,�T��`B�)PK
��aB x�;Lg�M�Ʃ��w����֬�(beU��LR�4���k�.���q�1�
�
!�O�I.ܶn��ݾ�?�&�:�c��#!��\)��B�B*�B�ӂ�vpM���nG�ծ�O��qCM����JŚ�$��(����c��^�2�RZ�BG0���$C���VȟG�d�����&�vO-.�2�N'NV�g�I���$%6��T#g�7ӌ`�ά����b���=kpR���~@�P�ns���>.�$��W3�,2�R,�\"d\A���$���}���wͶ�oqD~ݴ��j�0�kW��q[�$!�;�?R7�)4<�+*�(�B+	"�Ƀߚ�8��E.�]=t��_�C�O!+����B ��x�Ii�I��������Y���S HJ`3e��bѬ�}�T�b��n�T�G�)���1�$���i:��MM�Ew<��4��eHAQ	p�DI�3�CUo����0M!|�Q�<�G��(ߺ�|>��y@�:�h� ���Y��CS���1�ܹ�S�,:�N�b5��#�$��{�y$Z]���-Q �t-y�����[$��r�y���V\Z����T�\]�����_pʶNX9�5*�y�@%-���).ݣ�d���\��	r|U���ŪТ)7���#��ﶇ:0/W���(q{|��LZ���Q?�MX�8(�1d��e��%��LD��w�`�܌T���u�d�"+B#�᫚/�VW�,�5��}}ށj���4��]��%x�҇lix$�T�{�% uW���X9�Ŷ�۠�%�[e�D�R�H��'�v��Qn��Ă�y%2S�r(��e�}r�� ���E%@ڂC��33ﲅ���yn�=����44���JI�zХV(<��M�	�g�&���+)���K�M0�{��ᦹ�߿���sw�@ܨeY< �����m�п�]��ˢ-蕅.��+|��5�S)w��Բ>�ly�v�}�I�%z� ���R�9�������YP�'�y#W*U�x�sXE%)�d�@zL��%>~�L�k=��x����T�|��� ���ꈥ맦CS�?��a� x��J;�C.��b�݆�۷�ƧɵM�N �ʘ$o^��i#��G�kab�%��,��H�A���omq�I�y�)��k0 Ȧ΄��E5w�\����րZdp�:&EVc������ ��~��@*F8ڋ�����~��0#��Q���ʦ�>����x��̏,����� ��3��K�h��иE�H�i�_��M��O����/�Ϧ���Mj��*d8嘿�,q԰�\H�_���1e�l$��,��������|�����yP����`��z=M��Wm�s��6G~����瞬��4�����5!��H������ݬ��L�1�l@9���k�t�C�y!�?�;�����cfVFdP�-��?�rb�hڶ�æZI4'�g��)�)s��5ӂ4�W��w(A�5)q�wC�'�be��%�%���<�uo2U�a�(4*�mR0��nl���z��
NlgH�.z�~{���rf�5�����$�bK��2���5�d  � -�}�0lɢ5�?��?A\�0�[09��_�J�uBj�f��Dn���cB�8v�?^�
;��a�L�j���D��$m��TJ�6m9LM�^Gz���:We��mM���$��%��R�v�^�x��.R'�3��i��5I&o�_L���c�3Q `���S��z�."�0���SE���`&eH���eΤX�����<^���0��KEo�t�)�p�ٞ�lJ�Ƒ�>N��3hQ��/�Ӗ�(^��w4�$�n��Cl��w��H8$Y������P�o�5@�	fj�hv��A}�ّ1mb`	 /Q��S���l�/��p̑O|��QLٙ��%��k�a���zC���^���°`2���>���V�\�	dA��
��a3�t���8:���R��F9�U�)��R�T����� f����
����C�r5��'ȷL�b��><xe~�0��5W�Y�"�VKdYr�Ԡ��`�A�m�'	WGaAO<6U��5\�D��k��`E��������1����D�dW�8�S�T9��ۑ��=�{|�?�w}`4	ZT�C$�L3��n����u���ږ�"�iI,�+12v
�d��2B��ްf!����+�=���,�w�9_�CW��Ӣ��0�F!=E.��n��_R�=�p族�#�M4�,M����K7~������P@�pX��mI��Gk���� ډ΂f2P.�_azټ���3�MŸ:�mL��M�:��*`o��=���03��'����R�[�v���i��c�����7Nb�LM��+F�Qġ�ZR����99�X=N�/1,F;a�h����${����6d-�n1&�J�}�h��y����sK�gE2��U��l��?h"!A!m$��亀x/)@c��h��cJ��q3�����e�M��raW�p0������f��f���Z�,�r�s$i`�_�dY�_���Y      �   '  x�e�An9D��w�@)��K63/��y�~�v�@��Z$��E����.{�6et;}���_�z��~�/=фMz�Ƙ�}��G?���l����>�j�|g.ݭ�%�TV�[ڿ���]�����9ݤ���w�M��}.�&�M��^�~�]��=�6�ݷ�1֩�֝�)ҜDl�-6�W���I��}u�}��H����N��gc�.q��Cq����˗t!���ٷu�U�lZ�^��Pr�xM@Y
f��ؗe�g�:%k�6Nj?`�y&�b=�i�1�y�9���ڍ�2� ��'�:ؘ%��&ϓ��}��sok��5�ybP�c�e��o�72�����1�}��Q���"���+�K*��^$�%0�!�/��<�^`sC�!�tYcT�Bҁ��X���/�N��ض�@��O�W׋wϵ��z%�q�\<�tE��.)p�K��`�@|�,\{$��dD��3����}��)�Q�����35I74	�}�W�Qkj�+ǂ�[hi!m0��|�'�"�؅��\t����˼�q�7f�k/k렏 l�g�i4�H�K���.Ni	�8�O�B�g�G�&-��?5����t�⻌��B���S,���D��A���T�U|���+�_ח|�����#GW�x{�'�A[�v�՗�>�:�M-� ��ĉ&�C�?�]�ݛO�KqR����H���v�y��g��;�a-��[>'��az֘�[��,`�����ߧ�V��\�x�Szy�Տ$����M �2��&���ż��pM�MC[2�t��֑Z槌a�4�U^}�_�=�h���Ȱ���F�ߐ}��=�!��[�����}�vĢyj�3��� A���,��'N��M��y������~&3�~�h���~`�-|�=��r_�O�I�	�T.��p���՞���\�wK�}�8��9�<������G���9��0�>:���跶��ņ	�G���5=#�l`T�	�hk�9���t�K���3���y�}#q��v�'�mG�Ż�\�&��1k��N�S��S?	��[��Ve��۷耹�b��|PfU��PÃ˯�Vc����;p����_����L���B�p�G4(��3��!'g3>%x��1睷MK�3�G��Jnkn��C��҄ug�}g��T�?F���e潪��F��&�:���C��?ǿ�V������z�r���/�ߚב�s-���v�nAq�a��J�wʾ���Вּ������.`ș^w���HIߧ^r!������5���S�����V]`�=��s=�y�x���R�wz���G������?Y      �   &  x�E�Mn�0F��)t��$���F�:N�����5�X�dAI�]o�{���"�IǪ�����͛�N	�ѥa8�^lv���gc���Ң��btѷ���z�6���{nJ-\-��}��2��;{F��/Z,��\��(k�l�f��Q̠�|��
�	c:�<��]єԊ-Sj_|�j~:0�#���V�~��<L�����^�RP�2Fҭ�cW��B@l�ү�i�1�+WW#���4�a<C����^���*6K-�%�.���`<$.U%�ڸ��S>��Ǹc+?�D.ecD�SՒ��>喀��D�&�l9B���\[T�����&�{�-��hQ�4]�5���;�D��2���l#uŞ�4���B����=�|�#�������G�Mi	PH�6�����)�G �VX)j�{'�w�������q�0����S�F�qT�=����j�a��R(��DSMR�m��~����H�o��q����S��L:H�p���%���+K[���p�!`�vG����/����      �      x�]��r�hҭ=���f=��C�,۲l}���UǞ@$D�j��L]�^�z)W�DGJ&	��̕�+W�uvZ��E����a������v��$ΓӤ8��:Y���7�v��������|0*�r���e�:=������$?�?���v�w���];�;O�Z�N�*���z����؞����:M�8^|ow;Y��c�j8����:���\����n����r�>��z��:��2]��f�ymƕ�>-J}]U-.�����ŗn��?�;���(;�����q�ם��j�l��⴬O�$�� ˧��n��7��Xo�w��4Y\���]���}�kO�2?��Ӻ���Ǯ����]^��S;�TUqZħQ�֋�q�����nz�uZ���$���$:��<�zu�����$N��";��4[|F��U3�z�4JN��i�?\l�~?��o���^���IRGzmii�w;�}���>�Q�D��晖���z���~�6��I����3��c���y�Zo��"*N�Tf����ieW���f���M?�1�v�~�k�'q���zu���j^�{���f��o��<�&Ui���v���k�:j�O�$��U��o���sͼ۟�z�H�P$��r�n�B3M���|Tߨ7��7�v�]>u�!}a��fy�������l�q�7��S�e�g��f��,>4/m�x��(y׋��F�r�C��8LZ����Y�+�i�L���y���q~ZԧY��|3vӾ�-�׶�N�,>�S�/ݍ?up���)��R���N�*?�tyʢ^\t�:B�Q��)�"^|��ŝ�h�Ȯ�3�'�bï���$M|K��,?�k���f�-ۧ�2���<�+]�������_��JGO���RF����W:
�����͉>s���E.k��������H�]f���z׼u��r��z��<�1O뤎��틶��nc�̿t��J��F޴����|�.�,D�L~����b�ͨk�r�T�cˉ�yX>y�s} ��%�OS�<4���a�k�u�u"�2Y\�馝7�J��;I3]*]��(�ջ���N+��phG�2�t>����f޽q����!Ya�����n��ZݦLo�i�t?���C���:���e��O�����Բ��|{pV�Q�Ƌ���A������b�Y�H��K��M:���NR��=��T�x��y�{��KVq�8�t%�����~��qNS�vlE%�/;�[oth2Y����߃l~;��4���b�P9-���v��F3�{�q��U��?���_Y����mkٓX[n��Mk�3��I�}	���������㠧�E�m8�9�8�����nq"	�O&</����O���ix9)�]�:�iu<���>d��l{������M�?.|�E�e�Jۡ��SC�Ӟ�����<���ѼN�f�a����W��^i#���:0�~o���GR���[|���~9N�#U��^e�[~��s�`eI0�mr��uV>��Q�}'��.>�^�����aٮ�;U$i���䄷M���퍴|���|��+O�K&��6\Ѻ.��-K~;˙i}�?']�\+>��j����+�ZTq��h��n'#�ǅ��F硲S�:d��L�\l+C�߼6ݾ=���̉�֥N���D�����(Ə��/x)a�q��H������5�OZˡk˦�����גU���M��K��]|�Ƿ����N^!g}���9��9�E��ש��ըc��`�<� �t��L���n��l�����J��~0�3�L��c��Sh5JY�*գ�F��m�m��L�^o�We�i�������:�Orm,�n����Z���e���F�g��������^��=�I�
��e�b>VDڰs��t�NmR4��"=�O�^W���N�5�*�(�/��^���)�'�����^��e&6���OYɼ��*:����&4`_b���NW�q}hé쌄�=�+}/8l�Ψ�����V��[6�/_���O+�f-sq9�2�� ����_8
�"�$���-�ߏ�z�L�J����d.�rcx�W�93�,�}ִ~2���L��;���I���t���'�s��V�z~h�r�B�Uy�T������Z�9�2&�ܱ��e�͟0��º�������k��z?�\>pWʭtKZ��̃�e���I�ѥ����0�r��j�U(�����׮dv��?�ʉ-U!�p��F�5�Ϝ��K�e1�y��}��W��L�6�����Su�<>v����K��*���C���β��\�W�9�##|Τ��YG�����oX������5����WZ����O{R���ɛˤ�O:ˣN�@�wMZTG04<o�Q���G����tp��dִ�2��x/[���wsj��<�I�3�S��+S���}&�5r��i��60�푱�����X�U����ZI����"��׼4
K�����YK�[|$���ș�����M�Ö(���(�-Φ�g��S`�uS�!��S9�}`vNn!�v2[�o��Vn.$���d�W����7R`��{_0�����*���^�f_t\��3�<�1��Rڰ��`H��>�v>% A��O?� ��e�Z�G6��ka�?^����]3�xA"�pAYh������c��	�TIU,�V�1\`1���z�:�n�B1�g}�����R�������K[��M����pO�s���<��|0�cUk�˦W@�����d�%lJg8�?�\��8B���M���֤��V��_������׬�.l�m���/�O��TF��J��K�*��x|�F�:W�)��?�k�_u\�X��]��^(ZUL��#f��s���Jk������~�=,>����TF[X�pH-�p%D���˽��zJ[�%��S�Q���ڂ��r=�@��������<�G������r�/��#���W��^b�-+�ɗ���/A�)�b��LeZȿ}�N���+t��+����`�[�p�R��_~�t7�Ao?y����ׯ)\֎����uǻ�ni�Ҧ���g2���� $�IH�UԒi�el������8�I�����	������%����vrȵa�K��Qw���e%����I��Ve���8��Pw�4ŭ&�6]Z����������B��"Q )��ׇ�Ǳ|�Q�G wq������Z,g*�����U�圖O�*��F�+��s]�ѭ6Q�T�]�?"�Ii<@��bEe<^�]����]�ꄒ��p��Rm�6ov?�u�^�!a�M� �,H��`�wv0�HS��n��#f]�6�(�d�I.#&##�jGᲪ�e�0���=�.��g׃dN�QY�|��ڏ�@�<�<l�-�
!�yz��`'�
!�K}ZgF|d8������,y��Y(S�5r\���*�0����c,��E)u	uj�C>���2�83Yi2Z2؋
���;�<��Y�8�j]*�������6��^�	���2@��*�f�6�
E�d��z8��>Ź�p{���N����,i?A��)'Yp��i9�|h��VU]��W!���ѾT�6W��sG�DEϱV�(�Y��9˧O�������N�e�����V���}��ΕbbE��Gݐ����Gb��&�l�Oڱi�j�˹G��:����v\ζp`A;��]3���d3߄K"�D���hT��==Х�
<���zq��ˈ%\r݀������yґJ�Q&�%H O�m\u+R�~t˒T�G�A~o����,�u�^�n�Û#�'K"�ڬp�e��V�LE��A�u'��)�Hl�^��[\��G��`D�`�,����w�j�g�E��$�վb���R��3]��L)��_�����V��Ћ�\ol��S��U����HР6�e��>����t�	�KdR�����t���S�{z�c#GR`<�B
F��e�a��SߑP����+�[W[����V�`"�R7��.���볟'� ��B��	̳��Ö�ʄhB�g���?�)t���z=��n�&����rm9YV�B��yYMm�[��*.�{�\��
b�l2���#���z�    �P�"G!8:�1�@G�^�и����'�����I�w+�Z�+)�)�յ�퉎
x4J��6�,Ӽ�t@����\C�G���U_�u3�\��v��Z_��,�T���~�D��1��IZ����e!YBx�� rC
�i��G��(��ꞟ�P"6�d���k������v�l�G
	$!�m�b��v���T��]�H�h���:"��K�1��!b~2,���tt*�V���>�=����ܪ�絞!dR�� 8H"�ܒ�%�2-�>�C��}���Ob��{Y�l��|�.�ӻg��F��n9lO����I�8[��c��U�����/q{�G'8)3����H5Jʶˀ����rOq�&!��)D�]FْX��L������}98)��,'(,F!�2��`���f8�rޒ��{

��-�j��]�L��U�H�+Ł��7w����؍�Eu��o�͛v޵�☐R �֝�������Ch��	�5˧��x�-`T�����S��o��S�18Ce��=}�q�i�rc�\���������9�,K�1�]��n��)�[�Ɵv�	��Y J�"�_S=��	��}pfW0�QD���%|�ʯ�D�t����ݶd��I=��$��s�/�F��2K�3wXEWpt�)��s�%/�8&������$3,��-�/�����Dn���e�&m&�ߑ%.���Y�/�cl\�Hc��o�Γ�]����٠�y�7��Ə�ى2p8v��o�,sHg�T�J�X.F�hG�6�ͤ��B����ҭLV$E�x�c�
�ˬ�{�i+c�ALI��!vD�9-�=��ֆ��I��3�0���8ǉ���Ҏԋ�=������ S��%�j��m��#�v�9��au�����pdk��7�^�)U�=�%a�$dB��&��2��r��������37���Q�E!��S�p}������>�zW^���< W�ƣ�+dRy�p���������9n��MZ����*���ӊ˫��Y��JjݟI�G��s�X�T�H'c�)]��k��T��(�;9f}��'H#����3��a�v��K.�ɼ��k�0��Jvw��, xD�\7� ZWt>��xJ�].��#.���=��E����:{sݍ�:T�d\SbJ�g�K�;��m�V��\Z
w]	�Q�q,��d�*�R�.�!h��,�U�pmI�B�ܡ!=Y`��ط��CX���k+�vUp�ƍLB�����C�HBwB�O�,Y��"�����50Y|�G�����qg�L�Ճ�򠯡6�]�|��u�.k/����� �W/���J/�Q��-b�K��/�[��_0��x_׿�k�7��:9���Cg�_��iAb��^�i8:�*r(�'NA��I,�O�I�d��|LZ"prH\�x+�X��S���Q<�aHE9R��џ��O�F8�H`\у�ɟa�UӞ�r��A��6��>��N
J�M��,�eI7{�v�%'�,�v�$���u���A�i�����1��7�}o;Y;�@R�E��>��!W��ع<�n���\�}h��.���05�o��R�Ov�E� Ń����-�B�Y.n]���)W��T���e��>l��nr��cZk����$W����	�����.u�3��N��<��s��j;G��~��C�V�'����4[
%���N����a��E���=����F`�eG/u���\'.u,�Rm�9��ŵܙ����7�+3����/$'���\m�>��2����N%�+�rVH�݁�`�R9�+�����@�M�y�r pM��;1�0w�ڡ��Xs�8��ڵ9?2�'_|m_@/�n6�6'Ip�l�s�it5齣X��#Ń�eF��]gȴ�������_I֛�lô��+�}�)�,��ӟ���.��WݯxM��щ�"6��
��e�r�lz{�Zv�)3	�hczCM�[��*��X��.~zpUXFaZwB��#I�Q�Ǫ�|Qp�rYzm���[ag_W�h"W��6�E��Ե�?ei K9l��f*�{_KR���\���!���N�2�I��Z:'*�Һ}v��bh<�pu;m�P2  ���L���R����<n�a��9����C���I:�CV���n§2���ENH�Mp��|�P��2g@�n�$�[��3�MEmz�?C����؄DpJ����NyUnȕ�B~�RfGU������'��=�((*�a���۟=�a{�A^�G�\��O �k��ݛ"v�'��
����:�����҉A3 J�я�αJ	�('��eXCl�O.����A�EV䉬��[VD�ل���R��NK����J�`X��`l�ӡ�}b����y�A��S:uY�@��z ��(�ԕR�[��H*�z��,����|�:�!��l\7�)V%�#��ɏW"|v�L��l�׶������	��Sr������ڳ'W+���95>k�~�[�^�To����c�>|n,l�����k�9���ԙ�X߽5��r��k���̭�ȸ���L�R�[�W:g�8Zڐ���<�*Rl_[x^�Xjf*�w�����$n$#���x#�at�����)�S�
�w��ы��i�d&"���Wf.�a��~׭��Ye�ﵻQ.M�A~%?:Ʋߓ{�fj��Tl��g��?�q�qǾ�O;-V�d(��\���J6�U~�t �tF}lHm��(ց�@,^D�����3ĕA�x���/�;X�f� �����s=:	�"T�S2�ĽO�Pl�c*�����~	�g���JܓD��0l=Ā����Y ��rMG!�2g��4-�hCM$�	�c�� %��*��� �~{}���m���IQ���Q�y��}h���a�?E�|�z���uEf���u�ڔ �����^�S��GC�pn�f0��f�mR�_�7o�|�"��t��0��L+��O_��~j����"g��m͸�M�Nrh��M�1)7$-H�j�Ҵ�W�6ˋ��Q�*��ڴJ���W�8�{�N����9E��Գ��M)IW&f3��q/���sGN��8��F�cq)�����з�<.�k�1�β����9=9N��� ��K�Mو\�zd�ꏧ�{�-��B��g������kߒl��F�S���&�)gk�w����@���;^qp���[��Z���ԓ��KG�Yz��}1�/
؁�o�d���Jƅ��.M)#�%1���to�P��KE�_�7�	���SA/{?Y���Na�IQ�6\��s�_�������Bv���Ҭg'#``�d��|��tu�Կ��#��K+<��ѭ�'�B���>.+ӫ�7�/d���d(ܦ��_��~���*�]��o�i��nhL��S��w�N���7�m�P�*�� J���*|ֽ	�A��2k��] �nJ��c:�]��g'�I����]�Kw��v8Z�!@�m�M<�ԏ.���q2�� �������)X�x���I�Ȕ�Bw���$+��ҵ��O�p4������[V�@�����Œ��s��MI뒉}uۜ;��I,ܡ����V��^��x����3���1�-�
��B�܏�~,Y�}����Gl@8��pC�Ɓ^u�×���Wl�m��O^ǁ��+E/_[^�U�	�;�'��99��bk.�^B���3	�Ӟ�bج�Vq���3q�u�R��ޱL8O\�c}��w�v�E��nޑ"Ԧ�!M�w`�������2YӷRO$��_���W5+��ǃ	n�p5+�#~�HThȫ�GOSƙ��`�h�D���m��Lu��� �}������	s�%�a��	����$�[n���ePL��8�6(L0Tw�� �c�~������2��Y�Bn]� aK*��XO]i�uIu�Zs쾴��>�4���)ۅ�8��[�O��<��s�y�L�JwpTyR;kb~�W��']_`2m1����f1�q�i�	%��30���-��uL����^�������4���o�rɫɈd$?�"slW&�� 礖�`�*;��9� G����n�0��C�_�KZp]7���?�£�<QbF�*��V�m[?bj    ����n�(��cf60�9��z��]+�~4�����pjs����,rl�T$��w���|Y�ytX���z �B
d+��{ ��im{3G�a�1·aǢ��'C;Rٰ��v��-Y1�}�X��֔Rb�ҕ�������П��
J�8���Ƥ�c�PRT��n���Nd_�뭊����	F>IXx` ���f��ř);�,_F��Mp�纾��-6��#�Y;��nr��p1��������{{B���̥���Pq����q?Cz5��|)Ք4�^e�tȾ�סP�JO���u���H(�/��j�.����r��ӉJ]��Fo�g:Hjg"�
n�-�/E�R�QY�W��N:f��P�*2S�\�5\��B�cd.�T�Þ[��+��@���W�r��ՇD���֞�e�Rm�R��:�'�6�0T����{�ȉP2���\��(�IS��l(6l�g��;8��7�[�k��M{bi�#&�3�����+؆��'˺v���K���:��\�L��	���AÉ�_�ul����N5[a=��>6�C���R�@_'��=Wr�U-g0+��vՐ��K�W�s���!�aǸ�<z>�N�f	�%�]Bە��O�(c���v7L�{�H�,l�pLYp��.�n�T�t������"��g��R��mȄ�O~�����&=R1�P�YS��cBL�G������}��):� ��[;�?(�l*cN/Q�.B��vst�qH<D����b���4�8!�&s��z7���A�0#�4)k]����\T H'��	���V։o��M�bo5�P�O�#�Y��8����v�jMSsv��������!�/����/ P�;Oɑ�d.Y.��f�ʭ�rgT�LB�B�bSy�����A��F���n�.�6Ŗ�+@�{�e_`:¡�q[TR(��GW3��������N�vB�2���O��K�-�� [R$�{x��x�8��/�8"ßM-��MZjc\��m�%r.�N�`�W�~�-�������k)��e7=5;N.͓?�7w����Ja�@���`�$O�k-t���/�	������7�����#��G�q���}n<Tq0�+��Ҁ��b��Vd��=��n鄋
g�&q��g<?*���]��5ªv�#{E�%��CM_�ن��$(짙���.�<m��We�P����{#��y<ɠ�SP׭>��C�Y�  �Pvhu������Uؔܪ���8�y�x4�����In?���|�2��L�P�>�N�=7)���F|Ӹ��Ա{Xl�.[�ִ���/N��|q�.=�ʫ,���	�:�	.���&���*P�u+�ZH��i��Ev��)�)����?td;�����p�aiO��F���1/�����Ҙᤗ���I ��5��?x=��wi�#Xl�Y������x�Zx,�|���\�8��i#:R�n�ͨ���=��(<N�dTLs�[�h��&_Vn>�ȰSky�#=��a����<�n7�L���9;�H��o[�{�<��-��:����Y4�w�[�ȶ���%�${d�&R7�A�+Bb�JW�[�BN��$my�'_O4���#��.ݏ7��n)��	s�bR�_"��e��	�j�ݠF�8����_t�7kd�J9��/��tS�G2�8'W�.$�n�I�P	䥯{H�� ��Q�>'ڎy�';�ROXEn���h�\�0�Q�jk����}r/eF������t�ʬ^�o~��`�p�`��TO6��&9��)�_��>�m氢^��y�O� �.VL�ƞ7�!$�a ��R;��c��Aɧ�#IC�jx��W�&�&$}>렯�\ΊWvf���]�|ܻ�r��>��t��`�����,����y���E7 �`�qDR�>ΓwCtl+X�F�x�muν^A�t|[��O���7pV2�J&������i��#] .Ӻ	]$�Y)��>PO"���n�����@O���.�'���U�.�u�&����=%�*���ؘA��ٮۏ��~rg�X,��s�p���p�A��@J�����̳����t��r�V<��X���w[������;�S�ER���Y���ڏܰ���	�:]S�j��	���z���O�]ơ֠�Z�ֽ�˭�3r���l��s��ev_�JC�x������W��vͼժ��DQ��ʪ�-�/�i����z�����p�`m�x	|��KA�tx�v�V�q���8n����q�r��p��A� ��i�{("8'�ax:򢡷�s��<��:-X�E`��X�-\��83��'�Z�nNO/��4�U��ݴ����|Ja��4m?�C���Z�Bkqg���c�(�������Y�����P���+:N��`�I ���,�q�l���	�;"3{C*̱��"�Ϡ|殼fA5@�	3婯�!�>�U�LsR�Ib"�Pݡ�3RBMj����:�mk9I����yg?���2�[\���R߇�izP����M�#+�lӁt��($ �ܬV:�Cy�d�,���N/Z[������f�Cf����C4�'4,(2���W�������8���?͚�]^�4��i�.0��ΩaL�'
�ɑO���D`�
"���7��c��z�?�5-�8�0��e������s��������ax� �XW�)��[��Ѩ��o*�(Җ�m&�Yf�bq��K��6˃{�Ҙ���o����1?�A(B���i��F] K��+Sa/��7 �Z����N�OQ!A�J�1�4@�"MӐ8��Xk&��T���ˀ.-�����ꯠc���$�<�(Amޠ�Z�U4�,i	�����J����S��4*���_�o�:�)jF$~��;�&i�o��Ѝ״6NPN�T�[kk�TǶ^�6%h���Uk�������AA�|��җ��i2�,f$(>��<�M&�iV%ɗ�y��+���-F-7!)�T��n�ŉ�@s���UT��f��WD1r��ݸo�.0��9�@�m��u�x�1���qA\u�[��iW��w��lk�Ӱ��0�Y��K���Z�s�ӠEX?'�|���3,h�׸I�}#sE����,�{�t��.6$� k'yʢ(��ɡlӣ����>��-�Da֟x��JC:y{-�@��Fsx�ӓ[�c����>߫� �3����o��`#�@̓�g ��i/l�\�	:u%������T�$p��h��0�_��9�L���w�6��N��;k2�t�!L�'��A��M쟐��z�z�o�5I�V��CPn�Ǧo���4�]�ǰ��r�_ZϜܜ�`�.s�xm��hmE���'"�]K,:�8>p��Ǧ��?�F�pVY�ݤ2ޘ�R���/-�!��^ Fb:o3�\Mo�Hi��6u+���Q����*��Cҗj���==�5]�Jk����J���e��'e]��
 �6��k+������V;���~#��y���hIСB̝Mܥ�2��#e�`�r�ݥz�O�Ы��@�����h`�/O�ܱ_E����o���L�vg�-�%�3�f� zSisv�cp�ƾ>%��k|\�}ฐ�q�w�j�WX�m��� aP�2��l�g?����@V"Г�8VÒ�e�v��Fi:f.uf���<i���Wn�u;A��l]T�
�rv�Q�ĲIuM��-s�Vӽ�!�h��aN?��s�*4�9K��D�Ʃ�f����n�w,b��]J�M�aЈ8
�ѫ�Sʼ#��lGb�y6ʡ���]7��0�Gx*\M�0��4}�����A��(����o[6�������
ب�"�W�vB�Ǐ�D]b�_�x��BSCNR"�ނOb�&�J��b*�������/�~�N3��X%rtg�3A]*�̂����P��P�Ŧ�DY(A�����&�<��A��w�t�f._���9��M�C�7:f�K~GE�)�'� ��@n�]�Od��&E)D�u��#��� ���GS�}itW��+qP��*
q    ����qӶB�	Nz4��j9����AU�����q�����jȜE���֐�y�������Ѓ����A/�:lN����	�@r��|��ے2͎*O�$�k�n2%(�B�ke��LR��=`6�A���i�c�+��͢�DnʸK4��݀���X��H];�.�zei\�]D�������g��cQ"/�����<0K��Me&�6��*V�sNܑf�;���]T��LC���΄��ܬ
q�$�f��Z;%�tB�w�~�����v Ѱ�V膞a�+��p	eFu���
��b«T�s�r���i�9F�ўh��y�9"���}}���G�����wV��Gr�dQ蝒Y%[�P�5�gl���Vc����x�wG׀~�Η��;"�!��Uv� /��e/!U����t}�g	� :��֗��KQ6!�z"�ȏ�-ҩF�l�����0sk�]6k�������M��{�����K��	z�7~{��i��S��U��ɬ�n�&�4q�H��^�3�m�|�������Q@�ݭ��[�^��.�A02����;@,F��մ�B�EV%ex�ǲ� �eQA:��a2I�t��R0��UushM��ل-��6Pww&'�=p� �(�h�5�|��ٕ��͌ޏ�f�l��a��_;������H��t�,tK4-�[���Q��$B��1SĦf�E(���rb��c	�4��-��7r��v�qλ�����<�����u��R��-�o��	I~)��2Q�͠���&�%�������P��\��OM��H��D�f�U�#χ5����6JY:W����oi���n>Z���&���e��3$1��܀Y�8��M�jo����)���O�Z�g26h�1ǹ�z�r_A���JCe�4��򁵲���F���y�S�ؐ2��V�qن�R�3���,��׳K�ͯ�m#�CFE�e c@��r`��A��!7rV�ə2k�Ⱦ��D����u����(����us�]a���{��(�2=��j���ոj(TX4�0�����zr�Э��l�Ĭv�9�z�Ԍ]����;.�V���ύ���ќ~�R휄��ɔ��"�Qf�m-B� 񼅋 ���X��|=���#��B�D�����y��Y򰎲w2��0=�O�iqE:g��M��h�0�=��܄�D\��!-S��f^��P��R���AP���<�ȝH�F��H>3A���ҷaq��B��L���Ѐ�B���0eny��uć	p7�.`V�dҔ��)��u8����h.��2�rY�hTbȂ�"y���ĕ_��	�v���D@x���%l�o}�	n�.5�B�G��oI'��y���Q�G#���m\�P�bs>w�]u�ð�,I�Nh
�m���[�%ė�9�m���JC��=�_���[�lB.B��K�;����ށ�z�j;z������gRo�;k�jX�H�ꇋ+�t,~^9��#}���tR�3�������i���G	(붖7�\--\��6�,���ܵփ�B����.�[����
�Π��o�O��veya��(�r~�%G�����*�܄���c��Ȏ5��M�d��=$A'�2p>lܫZZ/����$=�|E}#�h��EIe���m3��������g�9�@��J̈́�(�	�"���K�*��4��O��t��λ����P��L�
K�+���g{��y���#��7]ș=Z���'cq��ΌU�Z���E�$^�æ��qd����]�����s��?X4��Y񑧖W��)���rkuRX�M�F-(4O�zhM͈,Gl�
k��\n�Q����:����衝}�er��~O���Ω�<�"o2��� �!�c�v	����7+vCj@���_!��&W��$r�fBg��D�D � ��Z�bg�{M��nt��Pt��R�$r7�{��t�l��b��v�-"�y�p�82�eul��)���D3�"ȱ<��8��ѡV��Q��h�Y���̎@�E%��]#Wp�� �x=g�5�U`
�\�4���E��LݎA��0��C��0ˉ��"4se�F�ſ��3�2� !b^��r��:I�^������Z���k� ۠���d?���z�%�.l'_��m3�����R�-*4oYʪ�Ba]V�/�n�!s	�3�9�5-"_[B�� /�(C��֠���.a���P�N���P�\�}�t���< �{m�ұ����6�q��K�j�ۇ��ȟ�9:#뺀E�{�KD�HfY`��=���k�rl-�Gǅ́�)���4?v��R݇�'��<��'l�����|+=���,�
�7�%D�hF���{�4Y����M����>�_�TH+�7�P\�\|&n��៬DF����U3���;���u�;H���i`����@#X{��h��(W���C7�B-+Y�.��j��܁�*t��@���Gb�>��B�	����ri�]�:8߇7���h�a�n|�*�d�Ԏ12f����� �����
����F��;C�+w�~����
�ur*U��eń:wCR�c�G�EA
xq�<���J!e3��M觇$�8����\ͻ��=��\���\y�[��E�\z+�(c�;cwd�Pj?�����v˧��"�,��� p��Ћ�� �w�~�� A��
�@��I�bP@g@y��*��[.����|���UB2M�����D��Gm���V��B{�){�z1�>-�C�t�t��%����> R�K���2�}�S��	�0�Pg�v�)��dd��#aW&��a�����c�-h5�k����ѝX�h�L�B���y�X��a����)	!lL#-Օb�%�3'��\ED�����Z�m��H�L���xOߌ���FQ��M��@���@�֞A?�����픆LVf�ߥ� �R%��0
�ӳ_�k���Bw�J��.:]���[�i*�"�� ��3,ZHrX_���6�oG
U%k�����
��m���US����� ���vAi�S���@�B��Yt
��m���\��O��k��`U��h}��� 	����
��0,"I	�Sxo˽��ʂnS�U�}���!?L���M�B"�t|�8�ʐ<�2C�"�M`~�Z�����
�[����x3kw͈�Bg�;M�������D��`ֻ�}4�r����i�� �GW�P.\Z�у����g� Z!w���~S���49Ďy��N��;,�=�V�)БF=D��)�½�X����M�wUQg�Γ qd������\0�ˣܲE(^����^n�<���FX-�Ln�_M��t �q�
�lz�B�j�t΅"JdT;*�+���BG:Є2�@p���P�r�w�+XV�K|� ���U��2��w^�IAd�N�"�+��(� '�����5��{�E����`iBXc!����▹eի�ؔE�������;�2A��=f��z�\B<�9�eJ�'gssxx8�;���X��wO�d�KA��2�_	7�pǢ֦��2��#v
z���r�7����)�e'�d��**�P+p�p  '��a�,Ӿ��F��^&�7�{p%If1��+KѦ�Gq@!1�ƽ�׃����H3"~6�;����Q�h{�Z-�v�XO(-܈��?��P?)2D�mg��!���K�/-"-Sl��'��\��p��)�G�pn�Je�`b�Q�BLz��b2���3�$��6k�Pr}jF�q��shuy蠬Ln��w[�ý���i`�ಲ�Ȭ�M8���v/O�:�uH�!S% No>>|�kz��*5�J$��$�q�5f�2:�O�����Ć䐀����9�63R��^���\ɤ��F�P�i�d�Z�����U�g��1j�9��4��y�B�G�'a{�F��K�����ӹ���Z�Ef}	�wb�-nYP?+X�r#���-3�@K<"�u�ɻuj�{4�k`�Ĵ˯R�$OB��?.6]�&�a3B��qBT�Ɲ�ĮT�f�u����8�ɍ()������a��4J#m���.��UЂB    Z������ѻ��� -zE:V�u_zP�e���Tז*k@���n|C��Zdѻ k�0�W1K�����F���̆#:���,��c�&͹=B/GK����C���QRR�Kaz�Ux������N��ӟ���C�I`�%�p��Ջ�ւ̽�9�9��}f~�h���߆U� 4(ڐ�4㔡|�1��������?h�B7�y�S�b݄r�Ш�#�]��kv��`j�	q�!Ў�a�Y�Ɲ�` ��.!�6����n���	4�o>����c�F]�߸�#b��W�(s�.n���L��e� �Ⱦ]BL�u�I#m�I_W�%�ćZͱ���ׁ�T����tq��]��|�f�(6�]Rh����M��q���2����H�W��a��e����[��Bs���y+��w�;K�����l'�{�X���w��0z��o��$2�51@~oW�-���P��XB��YuºA��3���Ua��j�Kr*�����5-���V�-�B�*�t6����*N=� }�#M�^��v�w�FhJ�o�na��f��Z�e�ŘI�۲����ɺ��o�-�l�Bj�I|쒣!�\K=f��B!�?�<���u$���xG$bNo�:r!���z<7�0����z��L[4|SH�$=���k�I[�,��Q�K�>�����D c�C3=��Tn1���K�th����d�Q�~VVmCU��'>�N���\�_Qҟ+(䁛�bf�x[3�
<֝�����K�Q8��qZv4o�V2Ȓ����l4q�/��2���]�#�]��������;�������n�JK�����(��s:,>G�?%5EQ�1lzji%��W]�O�gf4�����~8L�`�XxaPFo�ѹ�ɥ78�LN����M]妅�Y�_�ְ���'V/�^��6�f����$s)(�g��潣�B� 
Z�᪩T<`�P�\�떒�9���B�����ax"f�]_���neeS].����#��F��.�*� '��?�b�@��Uz"mc�kHj��EM'���m��D���ت9����Vq����$<�ڞL�G)��5� �If��q��+ҝ�$��D}W��'��򅲚�*��V�!˕Lq���8f�5��8��hU�:�|�}�����9����U����v+�����/�Zã7N<�-�Ry�G7}��Bq�r�X�z=�������B%_��H�
�4�q>�7L72%vh(�ꜣ&��.�|Dgk�O��I�2u}�L�8��qZ|m�Є�  �n������3���{��3�^kxɓ�{.F�I��=Y������dj��n,,2��
xnv}�_^�[�J�֝ ��z�P{��<� � ����n��<}�#t2
^����*��he�"��ʺTA�73�7w-d�s~��N��� f>��v
HeB��q:���ec"G+#�����]͡#�	YK�!�L��!�yO �A�5�)�<ȭ��s��R~��U�c��v��g5˝�P���D/CRQ��r�@ ��%�o��^	�nF��PA�{�1(K a2y,�%�2��v��c��|n,3"^�B~�΅�휲�QNʳt����[a]�Q@���<�4�7qi��F��&$z`y��VA6�3D��}���Gb��g��0�d�0E���0������ x��E�KZ�H��R�[�u�P��\$�y���r8��ʩ<�5��-��mcd�[8����L��c�t�HQ
�x[3�� ���c'_���i�X�_-�B�H&�N�\u��˼dV)b>Fk?�L��Ք�s�oQ(����\���@�3�nF�,x�4�{��ic*�?��o�c�dӺV�$�>�kP�.�Z�:B�\1&��}���N�EA8�[~v�N��xf?7T���}���+En{%X\ �E3g�r���p+N��,:ηC��	��e���Z��c=-�F���ݪw�W�>03���a�5J?�|����)�m��u��X�����>5���}�i�@���hk��.��?�B��x�P�@�����1uȘ��ͭ������ж�$!ؕ+�h���<F뚸�"v��n���b�1D�#3�j=->��5ݓm�7O�ܙ�Я|DB�B�E�G/a�@�jq9E�c�s��m�S�+��90*�9�<�snl{To�P��-C� U���h�t�'�Nt�gu� �q����.�a>7�Ò�mK��ks�CO�]P�#���(g��M����`�׀ߋv�=E��c�>�A#���nk��ތ3c��ٽ�$JT�Eͦ�K�7���g2���\�A��S�w��b�X��iǟ�����Ha�5š@ZE��i?�Z`vn<R9'�ycV�D�'h1�}�(�����d�'3�=6�����cp���	�}n$�h�T�m{~��ڷ߇�ǑZv�o}l�BQ�@:q�&�"d���h{��~�1�"����߄����N��-d��b�%��P ��ܛ�n�@�@7ӳ��c���n7�2ʤo�bL*3��2�!=z�t�]��C�fqC{��h�aQ�������k6�h�I5D� �4�"2L��D�����E?�.�<����@*�H�
"w�[pU�yts��|�p��W&���Q@�t�'����(�=Z�L�I���g�^Y��~^3�2צB�]��3s��DyW.�Q�1a�+�WE��)\D���qB��&��w�ni��½��QHªW]����c���� ڏ6|�o��8�E���lt�� ��K��l*����gq.�"!`�f��H��B&cv�����!rD��g���f�6�Z�%�>�j�疌OH�=� �.���	�v�k��λf���/��N-B��TU�@�N�q���O���	*5���rR�]�QE\e��Db�ٟ�+�c3�3�'�={����d���$�#S)��4�����"�چq6
T��ѕZRB��y��E&���HAH=�M�v∌
JL��_{������Λ�aX+C�\��������c&���.o=8Hɜ/%�)A����w4b�?`���(�硉;���q����Aw:�����f�wh�q!������M���1�`�t��B;�K��Ԭ����Zڻ!��6Φ9�������	��{�yh�ʘ�z�S��ۣTWv��x~�!�m�uɒ� �L��j!�3�������'��s�Xv2k4����G����(� ��T�ﱣ�}�_;E�qcr�K�y���x��DL̺��9eZ@?��w�ns����O�Vj-o#�O��1]BYp���J�n۠ϧ��Ӏ�:K��y���bZ9�/֒ ����4h�w��u_߸_�]z��]}ԻQxl��M��pΩ6+�Մ~4��� ]C$#6/ۗ�c�`�e���hʢ�t/�!ڏ=4�\�|h��s!�w
�Dz�وj+'�s9��~�)�_�K�}��yP�8��@Cq��0 ��pb͔>�K��@�L�-��~�ݟ�/�RI����p3�a�/��u\e���q����Υaz�"��Gؾ�VL2*D/ٕK׼��JE�:/�ِ5���q��pQZWg?Y�/�]�d6kB?�������l4�k����o���A�L�x�O��r���ڝtQeU����Mg���Ш&�
�<���n� Z㝝�WP��F'�&���؁y�mi���8H�u��ͯ�"�'D����9_��"�\2!5�S���XuR$�Tl�f{O�k#F�Ɨ��O�:VA���f��CvA��d�5�ZF�~���e����/���|�8�;�1�:eId�vo���3ܻ]��>�./�CC�DrjB3�Q*Ia����b_�e"C!7�;ʭ�	K1naz���|X���%�n���UU��6۳�R�����qF�*�qu`7 g�} |m<D�'�<���%�"����r�������[;�L���|o]�W{L�	U�$���B���<a�i�� �]B�����)�߈Ac D	  ���^%+5&G����3�u?0��R�(�����;�ϸy�ez��ݴ	�9R#��N⠛���T�Q����2�5����1䯦�� �����`�]G>i_���0�ԕ��P�[W�*�����&4}ܷ�h@	���jo��G�*��d+�m��V�������ߔ�ڬ$7��"�a��/'lk{�	�ڴ��*�bt��u���Mϰ'��(a��>��u@�=���*R��]Yz&��pK�VoV�[;��ìSc2E'�r�}$�x$����Z�S��<�X������ü��jѻ֚"��8
W����D�V�8�h�wP��c֝{��ݽ�N����Rh��g�֖`��Z+�-o����R@�[�n]�>�"�k<�M[�Q�2��2{ �w����=��5s��B(H���Z���߈�Ԛ��O�S�H�\��4�H(���Qc���A�vO�c��a\e-���Pɧ�����7L�T��C�i�'4k��FW�� �����:����4ݎ\Fl��Y!Ǌn�����K��$�B��	K��	�ї��aQr��#��6L:������)ς���B�A�ޙϊ	C���c̼�n��qE��iJ�`r≼8�Y��.苺-0�W)�]������]�s�ǑV�:NO�t�P��ДP���y�0�V3�PS�[T8fRe;�_!s���^�[�靲[�'����5Ț�ZZȦ�'���BZ�ʖ�/��\�<hh�5k/_w5m�ܼ�Q�	�!Qf<���RA���:`ο�m)ճ�8�;ìd�=_��S�$�^����ðr:����ꈳ`��^�[�$ܺn!�y���kFV�z<��?����:X g�u���뮉��P�Ev�jzhge���GV���-mX�Ϯ�p��_��B�60����Vo�l0�'��i�A�'Ӫ��s*^L)���! -�&&!�.��Gj��������)�U�<�	�M✘�'ב�y,=)&�\h��!{�,�M�p�v�ݗ����.����[�0���P�@��n���#���
�Y��RhN�Q�b�)�Y����t������}�VA��[���i�	��T���/��Yd1�/�?��χ��P�׃~(�}i�����M�U���d"֌ܐ�"-���!�Z�
���Q^J? �(D��Kk�Qnޢ6� ��O��k-6��jm��Q|��2�n��	]�@m�1̨�B�ݕ�n����P�Tܛ,>�m9��a%�g�u W��L�21�@(��'�"A33J!��N>"���ɩx���C�a@�����LE�e���-a�d�4�t^ZCt0�e�[�&w�
4���?�t�\X�Ǔql�f��ۀ��������LS�\�qI�Y�v^��^�@]$�dXK������C��;r�u����>�B�H��� 4L_���ȵ�Ċ��e	��w�������飃d��Xx#ϙ�ռ��f�Wy��X���M�#��za躯p��%Z7��E����%Éɵ�X���.5]���4s(@�Q �$R=E����2z�x��+���K�G���^��9��4t��ͣ�T�����X�?��>Z��dqg0C���IW���܃�eB�範�/l��
��DtȰxT8-h���L:��n|C�Z�^r@��� ��r�wr����)]�#���_�Dc�7ʈ�;j��,��j��6p�ȃ�A���a��C�H��9x�����qKHU	D\Z�XY{ݒnK�6HqC�J�1!��ܼU�-И�P��|���x>�ތ����:��;2��5�c��ڨ��%E~kb�����1��F��}~$��k��k�'�����X�YG�3!U(���e�<�)�K�!�Y��ѕO�6'��� �6JLE�Ľ�Em���M��<���Bd
w�f�07�=Uh���!r� ��2���\�)gF�^�:=W����Kƽ�F���"ҷ,42��u8S���˹q���[@͎�{����>L�΃�"�,�g}��+�X ��~i֫64hQLӁ��<�4L�*�L��v�D96�<�*Sx�F�.�=����6� qQ�-�g�81���:�f�ɋ>�)-A���[ERn0��!N�����"��\�����o�
4B��t޵L���=X�x����:<�Ǵ��X��� ܌�ae����L������?3��E��$k(	���<����8��ϝim�<./��3)ڷ0��|!tM�0����� ��܁yM�S?Ahfw���j���K��*�uT���l??����srr�� s��      �      x���׶$�q-��YM�s�j Cg�>u�֒�Ck�	�>f�=� �E��*��&�6���$�,�~�dA�+���_���%]h�����_�2E�՝!�[fۿ�N�l�֩��I� k��Ϣ(|�7��úc�4A������}��[���������_E����n/;X���u���N`����O�^@�vp~�˫���Z���\RS�e�$T�.)���Ζ����� /�,U!4m��>�މ�^��������	vS�lf�$A�5xK�߷@�p�߳e� �ދ_�A�v���2EPe���vw�
����ݱu���ʞ�x 7i��2M�2�ݭw�;8��g/�e� �"�]AF\������0TAg�
��'xW�-���5��Lx�o�*h(#�BR�_֗�Q������:N
�)����¶<V�������$�=l2ٞ��a�I0�u��	.,��l�R��Ls4|������up;��3��^�C���?�2�%X��֫�������_l�(�̿ß��`���V�ѫ�^{��%x���a�`��*�'q-	_��]�჋�[&
�s�{�l�����w'�3��[&�V©�l�����4Y�l�u`����ʁ�� p
�lh�^;8,�\ w=a�TA���c�7a�²S�6v�����T��dXw���h5�	u��lA�����-ۃ�����p�B8


�[f�ވ���4�E@��\W�k��6"g�a�"8d8��y��g��@�u���`	�g�VI�;8vX���A��7l�,h
H:�L��	*s˖�.(�l��-�P���:xCvCV�}�Qp6�{��j�0͇g؎��z`�t|yU��xY�A�ٲ=\	��)lK4����[�HT�|i��m�"��������(�r�� �(r/l��C��c�����#�l����#���?�)�*��[B�E����~��;��;[fZ�`�(�!Xx8��
̖f�6��
O;�ɖi��ʻx��%H:��[�w�V�K�Okx�����*8�8�p5�ʜ��O"�e�fR��^���:_Q�@��y/��'�����A6x+��?�u`|Ž"{��s�)x���u�Z���n�dk���k��CCv�F������l\ƀ"{[|������2���`�`�>��͖��p`�9�)��٣�t�*�gP9�f&� #�r����h�wL��a2��+x�2D]�P�FB���V��4nHz	W����2�:�=�i�?~x�?���;�l�=l��������El"��<<\-f���:����	D$a��8�ИK��[`��,�l`�M=��o � ![�S��x�m�w�ٲ���(��{�ˁ���
�� -�<��š��2�~���QcXR^�ep�:}nC`{[ ��q5[�� ��;�p�p
[~DUќ���GX;ײex�܁��I�e[�u��X��g���H������l�����U�P�χc�*p�;xݽ�?[���?�2�Ta�zR�-X��uX/:�u���X���W ��2Oj���[Of I���N��ol	̹�/��~��[��:����^iZ��\n]��AT��Sւ%ú��:]!��l��J�o��HY|<�ҿ�|�W�𙆔���� ��5c��wl�0h��Н�(H��o�2x1USu^���cs�;N�l�ޒҌ�E[A��,� ����y���Xؠ����ԋj �����PX��V�܁m<��� A�	zf���ʈǘ��������o^�2�R���6�36��2d�""#� n���yc��D�t����/����;[&[��b� ���!�|�e`	��pV�RI���l�\�+��o-(�n�Ŗ�^)� �2?M��;[�!���_~���7`�`�%����ۤgd�@�K������y��%h�v���pN���l��x�'ʀ�Ђi���e��/�M�e t��LAvd0��o
�Dac�e����`2;(��;l��V�TH�V�� R ml�JT�3�XM�6[RlW`��  ��q�*�"#�Ԃ5��U`T$[���9�g�l `xpn[Eꔀ�l��� gě�vOلl��.��_��j�#�
e�h��Hm̖�ǵz�����X�IKT���뀀d������ra
�5�p[��~�s|ɏ���*��V���ZF w�M����1H�!x4e wʦd�@�%4��-����雊-��`�E�~���l�ɉ�^���*���R�91�9�0 ��ln>�Y��|�#`W}ӱe���o%��t���oz�
�>�t�j��f`��Z���^J$oF�6_6d����	l����u"�1����D��e�D܍ځa���*�3tj�P��7�Ŗ�M�E�:
Ў��e �@w�`(���B��u`�5���	��:w�ATA�y�[�������1[�MlG�
8���	[�cJ緗��,;e�0\�!�?��op���茭�vj�CY��7�!����v]VAS4RA[�@����['��/c'`>�?]�u��'����́�]�u��@Y���(�� �wt�֡3�#���_1o�n�2���xjo����n�2��(\�[`i��ޱU�_a��#C �ϣ{�#�
S�z�`(8��V �����_A�7G��*D9;��6��S�{��V�ʔjh׿�j��<�u`qu�|4TZ�����-��}E^J���`G�lڮ���|�KY��[l}�B�����u@�1p����9�`�� $�W���:p���O�eU�s�fB� #_l��k�/E;H&����e 䚎^� R���A�-PL��5J0/�?�/����?�U��
�R�  b��v�Ol�DvN�b]Ht���2PI���k�+F��a����!�Wm�D�zG�-ӄ��ʪ���7�o8}�-��;PCg�Ea��2�H����oH����a �'t`U��`���u���3�i�t:�?}�::���~�h�c��N��h�wsj���<����ͷ�O4�4�LÇ�A�|�u�> �x}�����6��������itU�g�I3�;���k+�O��"���ܾ���5@���q�>V�Ƿ/ן��G{m_!P�Yxd����1�9�y��a��5���uR�]<T'�7����̮Yޣ�R�}�b��O{po�?�7�#���^/s��-�P�oЃ�+�s��&C�:����������e<�ۋG�-��mO�7������Q�e@��#<���3�o��s����qx��3���"�p)̈LoA�"0Q��}���5O�>������:����Y
�o�DC������� ����|>�yL^_���E�d��k���G���ytrr��o�/Wx�=� ��BH��!b83>�c���9z	���&\����Ӿ�}x|y���}E"�y?��I��E0e�W��"�?�8p�a��_�^\�g���CxNC��L�M[ή�D��\�_�3�02G����t��_��O���H��Ni#L���������!<}}�r��#��9��IO��C���7��װo}�1w�䙓#Τ�@&���,L�ޝ���s~7?�_?o��{;��clއ�|}s��q]=�_�W��(�|���A�=My��������I�H�x�\������k��������:�L���������(�g�(�C����:��o��y�y����4_���`��z(q�������x�u9��󣇷���8�o.?n�y�Q1�������*\�D�k�|�����/��?���46?���I�9JfL(E��y�)4�!�����:���slӴu�^n�������T�0���7Q.��
~S�~�o��S��"e@(l4	 V��������=j�_o�����y�=�"��~s�	~��:?s̏�g+����Q��V�    �����o k+��Q�|�Y~xO�s���O�{��si�gog��=����5S�>�Ϊ~�W)����97m_��ހ	��uzw��<�?}������{~Ȏ���O�s�	�T������M3��$,��2��(�40��m�ş��J_����|��;�,N��՚,���1O@��(S�Wi�Q�m>�d�^�_�$p������||{��9{l�Y��J�=pq��Z�C�փ�/}�cN��*��.��w�z�H*�gp�)�}z�EH 6�����٣KN���כI��
	}��젣ދT�T���7>~����˛���rʯ��M����3{Tzk`#�YO�Ԡ|���	n�ӯ���'Y���. �^��n^��:�7�D���Y}v��~�O�^In��:�8��mO�0kH�V������\<�*@�:�Su�v�oLL�m��v~UV����0뉄m�����m7�{���x����k��:[�-~�@-5[�n��硛��GfX{O'q�5�$�Ku2<yy��^���P���`@}�xZC�T�>_77�Y�����|���?�9{�����HS�K�$:W��}s�l���t�"r�3�b��L����4f���-|�g�H!���Sg�2q���4�v������On�����I�N��g�A#���	�s�`h-���̜�ڛ����r8No����O�j
�E4LRFQ ������שM�DtT�����K�=:�y�zE�M�}T��ă�k@�������?�����x<?�y	��;�/ i��I���Аx�����h�7����Y��i����S���1���l���z� �ͧ�F�OA}����ft{U�~|�]�_MW� ��썙9���
�,'������}Ƚ6|�G�%�:=iԌJ�v��LL�GS�@ ��/?��{�z�#|1�C�����	O+�{��B>��}jYԌ�7mM�����/�ǳ�8?�n/�x_�H��@�(-X�r �����Z�DkS\L������q��/���(�����;�x8�O�?�؉'@����ǀ�89| ��z����>���';�}���o�N�����<��u���S�
���b�#롽#� A��s�|���[��9��0Χ�s��8���?�Doޒ����z>�+ߎ�����r�a����?gHC���w�\������'�;w����e�/n�6�t��O7|x0O��zɇ���s���Ć��)�U��W�J�����z�f=��d�
[�H�����	26�Og�uQ��/���5X�x�(�V��!�	�s����ԅ��{�㧏���n=Ǒ���sf�%q��596g@EC�:�\}�}��:��o��O�z8��t����$y-g�gH!d}A��,��m�~�ȣ���g�������k�I�Ṵ���N4E_ 8�6���}�z��;�p����������-��+�3V�L4��ؔ�_�{LC��hG�!��1�@'Ucz4�>�c�_o��YX���v��I^/m;���Q`��i�i��0�ʯ�����
���׳����f:%?TL��T^���ƶ���7��JZ��>�-����C��:Y�����8�\cI�bh�ǫ�?�˻��f�Em�B�Du���R7��'y�Ir���ُ�t=:y��Ҙ
8m����LK(�fec]G�oŉ���ݹ5����ɻ;��3�aE�'d�"�q��>:���LہPD�����_���������M��j�SB�7%��wp���z��Lo.����N_�/��loi$]1"���ʔF:�қ������#��{���X���/��;�i��&h��c�4����A��MV���c��<?=Vy���I�d���E5�tE�~o,����������}}���p\]x����FF���̔�b5�g�7�#)ޯ�����	�:}iO_��I��N�\hs��ݱ0�CR~\�E��'_�a��~b�6G��qw��]8-E���B�o ����vN�n�������M#��Ksx�Y'��ͯ��>笘Q�2U�J�_�j��܇��zl���㛋��� ��Ș<�cY�&3/x�yx�o�>���+{�ͺ8E91-'��l��[��)0���߼;�u�����l�.�;�����ˮ.I{�'���e�69ة^R�`�$��r$��dI�\��Q3�^���D �U��_w'�����p{sCj���#r�؜��L;��C���5��
x.ys;��8ؠy�6��&J����*f�|������ZM*�8U�O�z�������O�{�a8�_�����h�\� R��M��`w����l�'LL#��J&Q�ro:�<����//����*<{��P�$�2�=��)�t�
�+`�O�O�#g���ZcȩEz��i��ϴf���h��)0��X ���$��.�����'/5�{7�Cuߒ�.�x�.�ߎfU�R�KRtg̑�(�
��Wz7���By��Ety����;�m^������f{F��*��js@d�k���o�asg�N�:t	�M���d�Sڟ���]}[��#LE�5����w� �M�� �=� (P�f.�w[�1����9'�OW�cX7WΌhe�!�h�v�3J��FY�c�?qˏ[������<�����f��D�A�)d�7]��7���z����MvtZ� �;]�m�~� ���>�Gw���pg����ݹ\�+'�7Uwsy�nr�{�����޳���x���2J ,ɛc?�"'���}���������2]�H�H�4�baꎱSZQk��l�2;"XΔUQ�V��������\9�#fE�]��11M�a=��s¯4��h��S���7mIF�~��By�}��[������� ��&Y�fe?�ndK�� )����)� ��S6P�7�گ4˭������tH�������~P;,�u��ƲЙ}�Um��� �!+#��3i*x���[��d�!�=˘�X�_`���#v�u
W (��aN�f�]m��,m<���x�1�,�\�d�%N��ٖN�y�̓��N	Wzr��g��DAd���;��`r0|��4���C��N9?;m���UZ�у���(6�.��z^�����Mk����Fc���YD�7fT���y����˾S�)am{[Q(�.q���� ��GL��t�fW|m��K���$B�+��)�<��F?��,��:����ԵS�M�^�X��h!A��i�MCa�9'%I���"1�6N������ ����O (�I�%Ў3�oB�����۩ן���4V��#���,]ۇ� �}sgn೓dq�.�F��.�JA���C7����b��sf�ԝ���̷��PALʞ]HaZ�eq�$m^��u�q/�u�D]��D+<� ��"%vIK�n�d:��N���fw��q�n��rMO�P=A7��y���0���:�C�U�y�I��Kĭ�i��8��$v��k4&��xF�Q�����)�7�sj��TK��AK�Ue���[�6ݠt�$��b:Y1��d�i�t�|R�v�U��(Ps�}�����o/��؅��:h 	�j������r�g�a؞��=�}߾�������ף yo��8-	-��c��:+��;βD�q�O���혝Bїx�+���"��H��R7wM��'YjGH-߁�:/�&e���J�Ui�������,R,���t@Ԃ'���I��^�k��9��Y��V�-h��=��QUeeB����"�nɲΙ@P��u봩�x�1�:���G �E��L6UpA�z	Z�ԙ���������q���&5�c�ܙ�vG��v�!�0V��D����յ��j[�yQ�3�Ou��U��"6�	:&?�_���;�9DQg@�6�M��Y�NU�t���RF�ҳ
hЖ(�������ylHS!�7���g�����bGi=�P���e�:�=8��z	?���+A�z����6yzq�*�n=ԭ�9U$/PR��U��^�F�%LU�ڍ-+CH�0M'@�	�Ւ
�G�EDi��,��6�\Xuhp�6 B$�=+q��    ��ί�4��wT�ȱ�]�J���0�w�bt~��s9�c��=I���m�BZ�^�r������ӫ#�җ�΀V�\/)�Y��iV�.��7�$�����%�W˄��;v���]���P�c���8KrPyԿ�2Q���y�J-
{1v]3�m��U�?��2XHc��ℌA�g@��wB��s�+��.ݽ�#M��b�Fׯ �Ƣ$Ǥ%ۣ2 �S��w_!=hl�Z ���Hb�t\�YJP����S�]��C:0��\�w��i��j�fmN+�o��L��8B���
FUJ��6�̝�6�<kl°�;e��Io�8��>ڳy�Q��C0nv��1
&�v��\���ϟ����{�@*)u�L�1	���FiFNw(Ӑd�ތ�ަ�u������lR�V1X��"��^�c����hi��SxY ���0ɬ��<A�G���%pA�H�պ��&&�yK�����.uzR!j��p�.��F����?�::�z	`N}�U�Ar u{$,{0����2���
Bܲss0D�蓯�s�$I�&�ھ�<�7s]g��8K̀�9������}�9��@�Ʈ�`{���X����ϞsGQ���]��w˱�3nT!sP�ۉA�\K���+4���$t�1�* aY��YSq�})��}�r}j`E�^3)ׄ��k���2w�l��A�TT����F}���+<U[��0d���@�+u(�;��UQ��` /*\B  3��x��:��q��}�~�tq'`9q��3��( #�3ø���t�������ء��~3i�E���3Hs�^�:�pӉ�:%!�/��Yt�c�IH
dL*J�z~4�����P�=���T�l��K�6xz@�����h-a��eƱ�g5 웽�'UP�^-�����hU��h}���G𰦝�c��P\\���aKa/R{�$}���mcJI0v�X{�7�q]����Rm�~��N겭�:��%1�ݶ�1�&�Ք����Tu�z��q�y�g^э�H�t��uF 6�U�q
�N G�)�����<�N�x��"i�s���%���n��%���GxGi�5L\1v��j#@�U P1���>��Ȧ�1�G�&i�xl�VSǝ����Հ:������?t��m�^1tA��yq�i��m8�*HRg��x8�c����
p&��)�Z�
��EqAzSQD'QeM &.��� 8�u�g�4����i�����7�o�^ٗCT�B/ ��'�-��_���H{eA��o`�q��}��:�Vk�m
I��9u��>�+/�(,0޷/2<S���9���0���UA��	]�G���ES�.g�Ҷ�4%���,��12��Rke��4�l�p6f��U&<,����)M.��=��T���$��NY��# �z{��YBj8�g����t5Y1���K\� &���L"����~�(1c$X�*� 8�>& �~�z�(H����aѻUPi�q/��V�6�L��Ǣ��o��2Hr��$�AR��;��QpO�6X%�D�x(�`l\���u��c���R��!ElZ��(�$�v^9f���4��_ߗc����i���S$jc����"���X��Ϭ,&�b1�"hL0r	�;�Im���t��"Ϙ5�ft�7�ѧ�2+4�G��n�>f�=fK��tR`J?H�8�*�4�#c9Gt���i���q��w
���V�~5p]J���aC�~p��:��h��es�Ֆ���f����m�{}EW8��YK��p���C0�)Aק�)�#���x�A�~�ܾ�F+����t,��-XR2VR��k� d)K� L��h��٩H�l&:�����x\ �3�H?���}6.����.�����8�j��Dq���A�`A	�#5 ���cgX�]~{����Te��V@@��D[_�� ����)��Y	�����`��ϫ�X�=�&0a�D�	@+�P�� m_T%�0�;�� �Sxx
��$���}@��	�v���x�|K��;�@�h,�����(�.�x �����͑Ye1��qP��è�\�̛k�E��e2<$yP2{��x�V��
dh�ޞ��0�V��n�\����;�817�	���\dSO}_�I��}�\ٜ�����6�h�Ύ�����)s�ԋ|��ؿ�j�0�žQ#)�HRb��V��1�����΂�\�'�\ӂC����AB�:�?S���-u�7��r{�	�W��Y�5N�c6�#�{��YTH����Gg�Z?[~���RV�u/��mQ�8l��8�V��&�� �yL3�d	`�"ay��[xadzY���%����vpVA]st{eH�$�	1-/��>*�l8� Ժ��9)�����1���Wi���S�ڣd�։s3/S�;b�w�Ύ����^�g&� �PQ1��`幦�8A��nK�4l�9MNI<���ޞep��zg�^B-ۗq��ss�����������nf��E��j��Dss��ycj�f[9��a6����zL�p�̞��Tp�|����Ȉ�m�SF�t��jh����*;�* �^������w�<�d湷$� X�N ֡�������w���:�c��4��� ����n�]��f4�Q{]�������H��.?����]����|#۬�4����+2?m��s��D��f�q��m���`|��%��e�p`|>jӲ
��1��@��,�sC�`�\`~���
NSc���l�c؅N������M���qC* +���`���C��-��v��Y�U�x��|,I�|?ܓi���� \�����d,F�.�(��/8��	*�O�r*x�w|�PĐXU:6��ڜc~��R��k��y�r��ܬc�o$�D��ȀI?��q|�nx��Բ�J�J�N�u=^�=S]�^Ը��[/L�RV�)�@��L12���`7<�%�'V��x�ZT�,�x�Eg2��*u}TY�ef���GXAr�T��J�%��d����"�}�nښ����±(��dL��%�H�:�9������^�����ؚ���I�4	#��}W����06� 7�	l^��	X	60�:7"�9�ѿ_�������e���o�<1��:�����1�l  �E>��y��IlcG=�� ׀��?��Թr>���.�]4ĹcU�F�	q�Mp�ʠ�8AU���L;jZ�����d%�1S�Vq��"��x��wj��4�f(y*<���|�"-��2Ҁa���̶q#}fZ���Y.�h�8bMǊ�$�	e�7RF�]�e	b��'�/M	���� ���6��σ)��Nlb�GsR$n�R�ɚ��\\l/,Ӆ��:���i��%���>%I��y{3jQԕqӺ�2�G;lz;���Ik��NM�� ����Q��?EWTG�����b�廘83�C�> ���|����
��Eo��W
��f�WY���S)(O���tI�AWP�ʚ���.k��p c�p���^Vx7�F���5�hcj�Ϫ�df�N��h�SƎ�V��Wy6ԥ�C�6JsZW�9?Q�e��ug&�p����ݾ��^e��J�ʇ�a��r5��V����i"�W�J�?;)ô� �ݞ�y��Yn���`7�a�[�0:��[58\
�L�؎]�(�>��O��`��:c�bs>Z��H��M͚f�dئ����
��u�0���+��%ö�:m��}�ԟ+���e�� �]Eΰ��І1� 	c�[a���U㎱@���&�I^�K��E3A��0�8n��D���@��K���H��,�#b�j�s�`t"��6�4�����W��O"�}���4 A>>e4W�  >���>��w`�ۀy�?d$��i���f��+Pb�ŅO��I���,�Oܧc��V�ZV�`�q@L�?���KT�.�BZ�YR��%��4��&�\����4:o�k���55&j�{?�J����"��    =
P_�/02R��kjr8E�)���$��a78K�5Z dq]�v
�,.���/� ��0�R1o��y������:/����d9't����t����ıG�����M�7QrVoH���]������Uġ����#<졦+���Ev��N�8I��y	i6�VԲ������`�=��N�׍@T�4��+՞�d@)�Qf��)y{!���#`��%��k����:'��ç�09���"��	0� P����]k|x���`O�]`/���-+�}�w`�/ o8���kj����Ӱ6Cf�M'�ؾ�������5D+���4�({�+�Bm�B�.`�͉��� ����1I��� ���Yw�=�J3�&��= ҷ���3�V������1r��-�[��k<��/ P�,q���)E��*�N�#I�&@^z�yM{2\?��8������"�G��,�=&y�����k�����l��d4�p�x8�a6�������h�О��Ԣ}��f�~M�TK��>"L!q����j=�i���au7}S��@4�hFqX�e�g&ȸ��ÕQ,�Aiۙ���8`���D�2�M��ݠ׉Wt5X�1�:��|:Ƭm4�̐���B�>r�(�>�bZV��8?�C,�AX����P��7��H�M��OH���ġ9��|���0�*]�m0FJK�����{����]?���M{xG�PMꌆ`�&r������yn��y <���č]���`�R3�c����
�4�����3۴k3��14J�Ԙ�N� �[��2¶V�Fc:ڑ�7^X��a1U���ӳ��/\PP�7EW�u�����TO��gA��bE�I��.�hѰ��8�Zbs���E1�;4��X��F����/�B¨+��N��aՍqb%q�n�7K��L��BEVI�T��IhzQ������Y	Mq2Ѐ���4�tV�c?�IOCB�$�Ҵ�b�� X�l���*@r$X`���y�3xZKV�	�K���cĵ� w_Ne\9 ����I�}�焐4{o��i(�3�1��bb4�/��YV��g�S�|F����7q�V}�_��X4��A�ߗ�u�na7�*�4�a�4V�L(�$A��E���WNN8�b�w���.���Ʃ������D<W�,2��j_�Ѷ���갮
t�4� [7�f�8]��S�w��r ��q��+M����Z��)q &���GǨk<����K����*�ћ���kSkqn�Vp�;�R����P���C_�ץ� A7Y�$�gjB�]>�Al�~Q����a1��Tv-�� ��k��4#Zv]fYB5f�����%��R�E����c/�X�@���Q�aMݱ�q&��T�!{b�E�z���Tk��?�?��֌��eјSd�!�?��+�&O�Ρ�Yu�x���.pTi��I�x�TՐF��t�V�R�S5n[��EI��أ�,��n�өgl����ez���m�Qi�4%Is��z��&k2W����u=Z��y)���-:�<+92�bap�|�#<_;^�b@tB��v�*�hu�GpO��dh�4��==��?Hpm�P��?�_�m��FaY���k�`���W�X��6I"_p���^Q'Y5�%����	�2XLu���]�QR��{�c��s���-�f������qI0�f�u/�ec/ �&J�C�f������|ݫ!�n�vu�f(��Z-���a	��Lז$}�ڀ���؅����8	.��ܭD3Q��S��)��p�֢�|�*�R���&؂�1`j`������C�`,a��-8``��x�cm�B ��6�"A�	�6��^�MָBw��'Ķ�f ��ȳ}� �3��e�W��<�˲�IӴ���8�?	b.t���`.��"��>�6�ڽ����6Q��alCh��jҢ6I��eZ�0�.��NYډ|��"�y����M�|4H5a]3��x2&��G�ϖ�]���]'�F�&0&�uxԨO�祢fpP yi թ�4���H�\<a;�/5:'Z�yf���#���@�����i��I
t�����T��,+,��9��X8�Ǌ��,�h�wb7�0��v�-��@�Q[+���a!�u�wV�> `�,��ך�'l�%�c�$�8��>���� ����g.�l�s���^ŋ�(j ���::;-�z�la����s�(����8׋�����VMw�% �$`��[P���o������ 0��j�({�=/F���2��a�st\�U�z�gD��Ǉ�W�e2�C���yj3�f:\t�n�G�D���.L�>J3�K�5���e�XFǤ];��
ZR�|aY�f_w4��7��s-8W�3M�k+;3����7�
��Y�1��
���lܼ����������L�������V&��̉(���� ��W����W�Up�6��0{M>�M��2�LS��UhS �N�D1m.zp �0�����v
5�c1$�i��	�؜d�G���߁��.Z}�7v+m�U�N����aV�p��؟��|�A*�������|(@�;K���ޢtp�)n)��N$��ecv]b&P?e�=�$d�3��jL�����.��,H�˶�W ���tM�LD����Y M��e֚���2Y[j0�̎)W�X�(������P�}�]���%���X��x�p��)Ibh�� 0Ǻ����Z��S���m�-�Q`L0�� 7�*1��(tK����T�������	%��*3�+?n}Z�?U^�YY~_Q�;<u%�OA�"�I������m}#��:�S�z����`�?}���F���uI"�Y�77t'�C���MJ5�h�gY���I���:���s��M�Q�C�k�L���:l[�)8�v��=j�W<k���*sC�)9��6;՝5�!�O�JP~�B_S�Z
�ap�(.��w��_�~,LOUT>,~l'E�ZeM�u��Ω���+��aA8ܴI{;��1�e��	���`Y���m��A�t  �S�����gyS�Ȼ�?�/X�q���i�i�V�b��:(+J\�-?�*�lh=$�hu�ݥdH�aI�ڦt�_��NYQ����i?�='Z�2�x<�����%��y\Vr�r�.�B��=�lKI+�>
�(�O<���ۂԖU��y0�V.!�︛[�U�`F�!Tu?��Um�3�F��c�	`#0X7&�ƔCVP68}K�w�wE������GDh�;����H��tq��2`g��jyt�4�)�2h�RW��\"��d������� r�C;J���4n/Y7N���4M�`s�>�2�Fҗ�R̆´.�:6.HHk]ro'뱉�����5%76��F�e��l5�G�g*�����Nw�繠	;�/B�D=�ܵ�e��h+1?w�����̜ƥg������Ac?j�Ʈk#15�BW`���������XT�������ou cݷ�yq�&�m��-!!��9��Ӛ�4�j���8�i �َ'���R�g�E�%]碍k�QI�F!�h���{2�$�ݦj3,��2W|�	��߭J��`�ٰ'�8����J~�8��*�kėd"J�ӁKZ�W�������#fi�d����m.M(}�A�	����Cl0v]D�7&<�>��f���5<{�PqǪ���n�������F{�n�uM�������{�Im\��ٖ��y̌*����q?Ǒ����k�N#�k��2��6���/}ج�C\:�2����Maf�����	l�K�	i֒Uֱ�PU�����.�b�f>�;*�X�#�!���D�J	x����4�,j��
��愔�j	0y��WN\�[ʡ���N���C���+tqV�I��@$qbMH��p0;yi�b�D��GV}��5��T�J+F~^:�J���sK�՝�DR]�<$&8�1+l�n��� h�Tk�Zk?���,�<�؃yϺ�n}���U    �+���P�I��:}c5>`�"��0^�@|2@�/��� /~Kxϟ�*���:p
V��&,���S��K����i@�]Ԧy��n��������<F�̀.�W�9�!��p�a�3X�ӹ]ۧ`.�}�5-��5p>����a�Mbp&8d,�>��eA�3�l�X��$J�Ϲ��s��C��`
���Y ��Qh[SÚh��V��'sL�`"J����YL"g�1�;�|o�j`e^�NK��o&���[����3�Z���|��!q��u�&���-����cõ#��␹U�:�r�������1u�tP]�W��Tݷ[�
�����W�f;����ê<̇�F�E�,��B���CҸNT습Ʈ��2��Ys��	*��X�ɤGV(;>�gnebm���b�%SV"��o4��������Z��A�x,'Ɖ`a �Y�"�h����p��8���_ ���q�(�(�����h��uuϓCUh��Om��ǯ=L�xI�N�{\�|�9W�?x��ʣq���빚����B/�S�easV�֣KO��|�5���ް��78Un�Qb�h��tRJ�Hjm����]j�)�5d�0�K�6U3!m����j��%�AN˨ ��0P޿&X�"��ɯ�T�h�:�k�{��>�{Zx	&�^<�O�UH�f��-]�_�b��O�j��!�I�=ޯF�WI��F]���rC��^��6��w�H�����42?f��.u�1iƔ&5�8�Ԍf{sJ���l/�E�i�
�t���]�% ��$.=˴���V���q�?{�~�%f٦X���
��#�ii����zؗf���/j�Xu	�c�v5D����ڞ#+�8TQи�Y{\��f���Kl��P��~�`má��&� � �b��s���\�- ���|�n6xvm���x��m٘�_L��g���t��n���I�������(@�ˀQ��2�G�:H`o�i��I%�.ny�0��qR�r����c2��47�Z�%V��ѭ�W��w;��Jư3�ޫʱ����|��ʁ�`�b��8Y�� ̼�gy�_Աwiԕ�z-��ٗ>;l���܉"yoef�� ,��a{E��m��D���CTTxZ�!��g�]�h�U�c8��L�<m��/�b��m��elq/H������F�4�ZdxL,��U�ܠO����'�%!,������2l�_0�`��y�녫a��=ts��vV:m�N�F,�:���4;�v| X�m�O��D���Pn.�=�&&\�D�SI��1�vY~WE�|x�ˈ��°	�(�yZ�	c�&v]��;��Qx��[Ϝ���E!�Ɓ�7���@y�*�ai�}/��ȸ�9S>��!�4��r� ��s,d��&���۷�8��-U�/��q�th{3��x�_���,Y�Z��9W<i�C�ZЍ�u,:&i���9'� 4c�|%.GT�.y�����m�4�s	���WT>����1��o�@�Y�h$}M&/s�$� �
M��I�#���Z�R^a�Z��qsn�9R�������iʴ�e�X��6c Y71=r�^���\+<�$U[�I2(\� iz�|)�V���G̪�Xt~�p��L�>�8��$E<���,����T�Sg�s����ڲ��]�#]XW�U�ee�:93b�N���̙��GO�"���M�p��������ҊF{�2�ԉ��� ��<�R�ǍSY*����\Zk��*����o�f%��މ�g�W=��]�����4>n-=�q�[`ͥ��1�[`������0�}�y��a��p3���QԬ���l�
���c�EX��ɧϰ����<0�z�u�l V�i\�7���5&���{�C�}�byZ�������P%i�9\�q6���
+��)j��^LQ�����X�v���%A`����� �"�S�A�厕�
�
�uZ�҇���Y�u��Z��3����8��`(;_�4Źt��0��=?Bl�MRrŢ:���\@Y����8����+�{�#1xɦ�Q��c kQ�v�Ua�����`�>03�,|:o����L#�wB��ǣ��ܡ��_��$�4!H���~��ۧa����a�2�f⧪*�`��!5���k������b]*FH�v���˦���iӲ4ъ3\FJ�3�aI.�F�~}nvY����ī M�K6D����f���`3@]%n4��(m ;�P�)e��{.|�gE;,�1��$9l@⯏I��qQ�\�4Q������mV�C�XN@{��XS\��]Ԉ[�J^�1��t��Ĳ�8v�����Ŧ�K�B8��s1�0�E��0�=���zN���6v��S�EV؅�]�tPŌ���%�)���1�+�ĺ������Ǡ�f�-Ex2�`_=� ���1�����b�s6����5q���7�pp�!v��dSh����(-) ����;���a'`����R�i����9]PFc�Va`�>f���)y�'>����!�/���-so���əF�t`6��	~_�~��^A)��#�̝V�+��]��̃ԣ�,�T]�}K��Xy���d���(�N�&�\�a���y!U�ِ����`W�7t�����N1}a���qN���g��k���TW�i�H��A�g�B�#F�yх֪���m�LT~�%I��B<����t@�
#!oĲ�� �^\P-e���2���iA��c�bh@iq�=,��(��g'gE��%�]%�C֣��V�'3����5W>6����U�qT��e��{w�����F��>X媫��4m�/-c���J�Vǋ�{��'v3�^�FVcƟ�8+�6ϩ�frN��*�XE߱��i�.a(�t���L3�]MZ��}�,��,j���Ѐ ���[�a��zk�S��:�D���<tfWz i"��$�� 3��)j�@X�ت��-KZ�0��Q~��A����%1�����w8���_��k����zpn���G� 1Pw��&�5jsFti�4�/��	�e�$HnM�@	@�'�ƃ����o������0M|Rbq�a/2P0��a���� ?Z�u/��?Ɠ;�oY���k�A�p�񂌛>�2�rc�B]a�q�$���E}��J#<>��v�4:$i|y�*cU���5~�p󄮽&l?����Iv�ֳF������ҙb_N��\5����8Px�( A�:E��
�O1��Q�E�Ƒ���_��]>��X�="���U>T0/ꬶ��M/d=�ӷ�
WA:Tۀs��k�æ\��zZӉz�S�V;�0@�v^��Č�2�߾�p����W���i'�w��m
,���0 ��7W�.u�z��x%���D����b"o�>'i��|0���G��Rb��[�*������hi�A��3��Vc�t�����u��!�9�B��qJ��a��/G(�s�Fy������8����b��o���!�̼�d�����O��-ѣ�S:o�.�#q�Òw��c^FC�%��z1
0ZeT	��w��g��$I��QE������)w�^�i$!m@�|�$f�d�)#g�.�`i��s��݄!���G�ޜ����q�`��=#5p�/#ᘙ�O���=�+�U&sJn�;��1�n��IӶ0䊖.m�g�=֜7)iShN���ߚ]9}l�hm�>9�Ù�S�b�俥yfx�aY��/dI?��TQ{b�k^'~�`�m����~ju�VB-a��$����
͗h{._�N�r7�m��8���z��g�T���*��l=���{J<���僴�.�uK�K�@ �� q���ht`�u��s�㼮+s$V�.���fPo1N�����#��&M4.���M�w��pj�O炬��B��=0+����m��?�j��9l��~CU�:$���ķ{�R���3�>���[QWAy�(�|6��n��zد��DM��L
���   )㌥;�û��[�M�����U�����I�AC~Q(oL;�MlA���e&���̓�P�^lff^� rfƧ��/&�P��,Nu)~�23���pG��[C �Ʃ|Ԗ�w ���rE��(ON��}N�?��*7t����:M�!rҰBB<O�euf�}4f�p�a�@|�yj&!6a!�����PaW�H���	3'�b�X>�GG��|������CC�~�	����ϥ��aڒ�~0kD�q���/�UL�^�i`+e�Qo7m4eA���W~���lʊ��L��./T��ۧC���N�έg`�<4k`�zB���6�v��o�tm[�~9��	�<(,��%� �u�9� |�?b���KR�	�q��,�Ȳ��=�g pIL=h\�۹�6���E�6�Ք�3��6�/�����\.UN ��F�o�YF+�_���J,�M��j����D?�ZQ�ڱot�o�����ˢ�ZÃ��Y��A1��EZ�E��]��G.�['�F��ťSI�\��Q\���Nה#�Q�Z�M�����آ!tQ��m�r-���2S'���\ g��mUF@�qX��>Q��S�YI��뎏�B>����i�D��7��J�����kYn�g���T�1ǭ�ʞ��؋ �o!��W-�NR{�������y�Z}o���]BTN=�D{�>^h��������i��rB���6��V���Әg�@�j�U�g��y�n�Cb}�y�֞ڟ�2��9df���j������t��[�p��!�Y��Z�>���ہf����ʨ�`�o�n\;v�����a��d洨��߯�|�9�ډ;f}�I�E�a%o�����A�w����B_��H[�S�@�O+�7��^.Y��h�!i⩁Q�{\����Ǔf��Y���6�8%��&��B�e�&�$�����)Qs�4�I���u�/&&?9i��̔���VY���-��QƸ��g	\qs��P�j.jJ➧d�^8[ꄷ�&�<]冃�����l��<�����te��M�x�-V��tr蛰�=}�mAS}��0\��?�p��JKڰ̚Q�X|�p�2�}q>;Cr^�M���bX��@a�䕖���P�9X��N(�$�x��%��mH��iA:�p�[Rj*{TFӐ�p3@��/�ΧWo�Pioܴe�%LVv��5(�^���sw�EY,�,�Y��h�!M�ԯ��z ����V�����YݳzPqUH��gx�0�2={&Ry����B�%/+Q�P������#�Ü      �      x�E�[�6����������p&z&���ik$(T@޶�l�X�=��ݱg?����������������_�o�ٞ��笸�<���ՇO�<��v���#��m��ǽ���_̯�9���E����h�i}eϱw{�����6��{���z��-�E{nc���w��z�:K��s���{��{�7�~�^��Oߘ_�ݞ1��<���߯�/�<��1���6��'�?��-zߗ����o�o���w�{�Fu�x>��>W�w��m^?�xH6��vf쯹t"������}��h͵��s4���md�k���oγ�����F��{x�/��}Ivb�g��9��xY*q�X�~:Y<-��/��.K6������a����٤���c�����FLn��-^��]{=�8F����$��s_ϊ�Ƹ��6�	 .i�\��|��~�]�ޝ�mRGw�b��l��ق吆���Ex�8��|���g�=o���n��,�Y\n�O���2b>��;�O��'g;��y/I��a�e+�q��}񳱝�P��a�\�ứ�6��d˗|A�I�=n���J������v�m�k��8Q�<=v'wc��}L$y;�\�z��/������w�IA���ek�_�2OT��v��S@�$��H\�^���a]�5�%HH��-y>����@l����]�,����9���/!������Q'�nw���{@�=|��o-vY�b��r�gvBE�� �԰@+�����E��˶�NB'��	��m���YP��q�|��͟�sg��Ui�o" 9 ��>=�qL� ��j �{_�`� ̟����	րܠ�i.���y@!�V/��B|�J�F
X�4ŔX���wn�Ck$�P	�D-����!V��"����Yw�K|S����ٟ3��@�c�ٲϖ�n����c)���@�y(n>���5�}� �?
3��݊��V�C@S����,)���P!`]�U/Hb� / 6ڻ�*��ߙ���w�� A��n�ٷ/!�!o	��mP>�z`̓=��Xr4���[�@kř�����M�1g���b���y��'|=aw��؎T�y0?`x>IT�R���'h����dP��i�t;�0��9cj�A6�y�9*�- ������1�=�F�\��[�@i/`#:�3�N^���0��,t�F�lt�ׁ*R<KP@ �R�/��@'Ҥ���� ��i`�o�h�|�a��'?������QiŦ�6�.��?F�{P�%�$��k�'@�a|��FiA��� 
�l�(��^B�!��y!z��t~�4�ALЇAN��k� 奦Q��`�� b�Ա8u�zl��6���n)�FT?E��{y .���N�-@@����*�KЮa��v�4��E	_`�<M�aW�� ^�d����i�+�J����tJ��<��DBҼ����{����@�ы!�욕\��n8��J���ݜ(ʌ42A��^(�<�������{Us�.�4�
�h�������x�Q�%�0Δ�R
r,�P�u���
���'�~G�%��� �#�n���`%]���4àgc��0���5�C�DG�+O<򰄉��?�<��؋�%��a	�_%
c��a����:X���iG�[� ��"$���i��A���o\>� ��6�C@ t?l�WR�Gz`ƣE��خ�]s��
��ގ��a�!����
��p,J������ԅ�L��#�T�Km?�@P�SH���9�*p3)f�8J���VjD`m �ж �6�'����J䈗P=�i�	��hBk��.s;�Gr9�\z��D���� �
��H�4����Y�y ȬD�J���t�(�
�?�K�����i��f�R��bc�'УT@���;ٙ��ɕx��7qJ`���;r5�l^�ԭ�vP���>-��mOª�R<�56*��z�7 �ޘ����}��v��!C��g�ǟ��zq��	blO���a�1�%;�^�
:�:V�reuV�B�A��YY��Y>�a��>��P�iU�T_$�v��e����l�Ĥ��Ӆ7�@���4SɇY夗*�|�wlK=�����;��-!0��@k�+&pۻb@I��pU8	k��Ou�%��(9��J����V��&%��o>�E2�sY+D`�:]�ȵ(�E#�+��$?�Vȳ��3�&�K�ِ<Wr�=��D�N�xW;�S�~�Ȗ%j�dj�^�L0I�k�*=x\^�b`{V�;;~��5�w
<2���ZoL$(��úGYV�W�jRayj��%�A]yZ����A����ݶ%��,��Ј<ڞ�-���<ŋ�(ta찡�x�_)HP��/Y�E�p�$f�Ln���UZ,K�ZPpbWW�E.g�L�&� OK缄<��������&�%���T)������I�k�e(��uJ�F6,�WcC���ʼM*/џ�
�)�'�ż)����i���^�7;��^&�D��$H�dZ�����(�9����zPo{F���)-�!�ɦ��!3�D��>��� ���?gS� �a�	�H4�X ��Y��߂��?�d���7@\�"�5K��G\H�o҅�7I��}ւ��c���!T[�I��
����o-�c�ND��@�xH%�'�lB5�9S�U���;�8��;�N	�={)ly�N ����+��a9ɱ�e�X��F{��n[T �M����!������m��}�Pn[Rw�����`w�b�ݗ�����,� ^d�;����rٸ���I�{I��E3,�q���l����'��ƶ�C C
BB��X��;?a�q�rXG�T8�b%-��Ɠ��=�l����g�y�oLB� ͨAI�o��`ˉ��}��>^���o���(��*I9S*��`�������s��A�_M륮�҅ׄ�k���B�,�������(�v�xM	o�f`�;��:��.qC�X�]�R@ ;j"B��u��0�~D��b�638u8��0��g)��1�͸f$�Gl<�	��ۊc���<�X�q��Q���A��֡Oy�9��/�٢f�c��j,-?OY��'�R�q~��Tg�Ò��fy����0j]:��-q6���.Z헔�O��t$��ވ���b�����=6�EP�}਩sw��)�v꼕h/�o<C���bJ,�bٔ��Z"|3�� )dC@z�o�A�x+|r��NG����V�;3%e��a1?G=��r�<kJ�$�^��m>���& �N{H�Y�mٟ�B���tr��p��)���Q��a��l��u#o�.o����<��ibz� �NH4�$�����W�AA�*���kY���E�1���A�m',�v+ �;��W���A�_Ӯn��������8�A���Q����(+�|pk�y��Ï�]x�>@,&�F^Alw��r�e2q��R�`%t���y]�&�V��@��єka�H��
��2z���Ӫ�{��H��:bc���4����r��ݹ@��zSR�Q���Wy��Pٞ6�xi�A�}�����t6�Ս:Χ�xjf/X���X�~V߰�+L�>q��4PF�h��78���5�P��`���P]��]S}|�z�a����փF��
����XX,ۦ�r"ROc�:uI]#����T���A����8�ݝb�ɦ�cY3�.m���\��ɨ`�#'���36&I���E{:P�H�h�̔�l�����ˣ0J�xǭ�.��|ԡ��XgJ<��vb�1�t�:���o��^[#;O�F����Uɪ4T��S��/ۤ�TnO>Z�\!�UiV �9�Y���o:a�(��I��լ ���u��ǡ��� ���h�PW�P�'mA�y�yO�h>�!�͔m��t|LU�s{%u� !�E�5B@HL=��Pt��v�E��m���,�����7�d���L]/������a�QV�SC���DC��   �R��h�ғ�k@Ѡ�4�|U�����*ի;��홎���5�7-w�H���zj���:���)�#%�:�^����|U�Z�����χC�K;�9��8S����}�o9�95����u4�Ui���k����^瀅�d,��{l�0� ���V���o�M�  �J���n���0�m]1[��1�3L���_�j�g��f�e��:��:�LTJZv|b�K�K?}���o$���g�5�Y/A<���s��
��bx7�+ٳN'x�F�!@�ҡ XGw`�S���S= ,wO�������|�Q'M�w�G�`�(l�4!��5l�X�X3=�';�1=�;�R�&�;`vx9�aQ�͞��;E� �*�k���Q��ƴ6{u ���
�h�y\���/�?N���f�%�I�M$cI��g��|�^�˲[֌×x�ۃ��M��4�݃3���՘V���<�Z����C�SP����}���}q��h���Is9m��$��r{��������>���_�^���Wx�ք�Ǭ�x;i�ȴ��h���h�}�i(�ɚ�����2�(1�[�<*���pB!C\�r��z���V�yl_�\5���d8��p�KG�6�ַ�T�hְ���V%A}X;�C�����9Sr����[�u���Ǎk�$��ʲUL;~"T��Yg�Jگ5�����u�3�IL���9y��}���C��}I�?qm������ZLK�$�c�u��<�ôX����8���㘤g���#��cM{��5����NΖ���;�)%Q�-����!���{9��y��d!��u��N��V�e�>�E��P;���߁�Y��Fi��M���s��T�QJ��\NO� ��������#^6��;hl�[wDz����W��A�>�	�q���nj:J�p*tP��|⁗W^�<z��0�^�����5�ݼ��۳Qz*<jE�D�|�D��+��C ��Z~-���V�=� ���;7_u� ='�uo���u�Q�Ѳ'd,�V��V��3��K��9R�U�jMo�f�C�F���I��9�,k)9:x亅'��|Zl�#wC}�6�����}�E���C�%��pR�q�Cd`���wT@Kb���U�qr�Q�0���Pg[q��>�C02�n٣�j���O�@�,KD���N磩�ܦ�:�=z@��:?Y#���_u̦�]5趥]�2�7av�ؖ�u� �Y�0g�nc�Vޯ:�'G$桥�v�HOR�#Wu�/�vG�|��}<RY8\`�͉�?='�߄5�,�S��R`����J8DG�GS��z3�I��j��D��m�3q�?*Ђ-籸	��5"�2��&R}Iވ�o�D�8Y�鞿c��s��}6���l���]5Mz�n�29դg]�@�Peʱ��?�9�'���L����	#٠��Sp2�x�'^TU쭵�٨n�rm��'{l��~M*�s{���=z�#�=o�^�#ֿw[H�����mIC�ULE���H�K�,�B��\�[�/�Y݌ǹ�X��X'�Y�葉��iV��.o/�9��8�;)�#�{,@)s�lm أ��{u�=�l[+K3ݻ���,?�w��?�,]��S��E)����]���������u�J��4�����w�.Q��1��܇6�r�u�8p��hZk��<�p�Ұ[�#��n��5�ZPJޕ;��@�uE�����Aa^(�vB�R�RӼ��8�
�����¡�
�ZA��9�-;�Bt�D�pj�eX��>��8vZ��sa�;�.�y�o����a5����I��y���Q�UGs�u�+�l�o���+�6�X �jL�o�i6�����iǘ�*��~ݱU�|k�7 ��+N<Y|<����l�XhC�'�T�ڼ�BX5S��jZ��^Ӗ�Ƀ���T9%G4�hk�o�29�A�r���������F0ܳ�	/��F�T��κ�;�M�7�<��f����A��ITV�N����]�ꌺ;�X�K�o^�$P���#}�v�0Ѻ��P��SZ�^u�E�������t�      �   �  x�uW�n�6}��B`�����NиI�F}�wi[�V\��$��j���ːfșs��e�Ԍ�X�)g�qBME���Oq����+Rݸ����o�$����������.�/�����n�n�at�n	����M�%5'B��h�Sk�ƻ���j�֏C�����h$�h�������B��oO!ݜn�J�Ä!R�|�EM��n?m�o�޽��ql����J�1�q)�7o�7��CϿt}��c�k�mv�k�o}�� W]n��L.oj�ؚ�wC�����m�����V�8&�����9�� ��i<�n�F�[�1��Ge	!���9�a#��&t��L�T���� ���ѷ����=~�]���C�l���%�J�V�H?#l�6!���5m���q���u�K!1\ �fY�������9��t�%���4KN�7����B���"hlf�h,�ی�Т��tX2��x�K�Q�(MO��@x�ѣg� 7��<)x)�h5�T˕|Y��?�׀�۝U����>�g�U��KU�@I4�L��<��6��z�<6�)����UW�d�.�*%�"�r���5ͻi���ƥ�[HZr��$��� �~k��@��\�{�w~�n|߆15�������Hd]Q�*���iWy���NmG#L�5�-���Z�����E��E� ��j��p`?��'^r�qȏ㴍�D6��1Ţ���GU��L�3�ֻp�.�qL�G)���X��I<7&o����a�j"
���P��h�Wm�_L����;?T�OnH�F�R(��%(]�>+�k�=GW�웾��l�L���X�U�Bn�ӡ��]7�hd7Vu��%��T�~hb
���-F�G���j_����	"���h%G0�v��I�ǌ�|jN�g ���6�L.2}��3��.t���)|U3Yւڵ�ʩ�m��.�`�JV�~��I��D'�=t�`�"�aۺd2�H�8^Y��Qҙ���>J�C���;x��2���m����Ϲ����֦�2�܄�Z��Խoۡ��a�`�MhW_ MliD�HM�Ld��n��E�@y�C�<:7n�t{,��I�9>�q��`p��%c�`dr����{S]X��~8�����%W��"�47_Zn��!����ؤ{Q]`c³��'q�~���}����ΝK�CC@�"rX���4���筫/�K�������ȕ,&���ԇ��P>�n쁥?[�rf8^cSQ�����6�)�������} �*���g�J+���Z�9�Za	$��&�Ldj9o����s=�^`���8�,��0� ��ooMQD�[�0�V��B^G��S'���E��.�Zt����&'���ܲ� �4��E2Np-���* �qep]SZ���E!�\�7�~v��Y����YX�0Cs��^��
�ڀ#�H�v~]�T!Y)�Va!�]�A������@/���󭇃m������?��e����      �   ?  x��X�r��}� l�~ɛ,[�&��+*��T^ �P W��>�Arf`y�*U��hjnݧ�9ݎ���Rj�3�/�(�,����]<��Xeq]wm}��J�3gr�U�])�w�o\)y\}5�u7��q��u�a2�scY�E)�:�d)X\����]5�8��i�z��p=Qr�)�diM���Og%g��ݫ]�a���>ܜ��eR��R�RI/�ki���j{�������V���45�-ޛ�k�)\(6g����QC??w��f�������e��/�-5�*<���ח��U�?��dN��b��;��~�O� Vw�鬸�q���l�q�wH"g'���$���O���]�w�\gZ�ZS�K�,onJ�d�]��[�]�c���O�.���6���:O����)My������5�->l6�ծ;�@�d�q���@�4<܆���'�u���S@#7z��=~�q��Xȁ$A���[�I�t]�Z��e��Wrxks�e�U���I�WS��# �L' [�$����5�cF��q����p�+��[��MCU|Ί�!���L�\[U<_r�[��ׇ�����ͦ�o�Eqݴ��rC�̲\Q�	2�A�����'��j:Ɓ�f��B����6!iiڿ61�M��\Tw���Sq]m?��pN/�P�,gǝ@)�~����[�ʦ��?!�@Li9�!���$ x7���EC� ����� /=����)"��z����Bh�:lq8��z:���)j��cZo�]�n?M��x��t�t�;���o�u|>��i@R!sܞ1bSk�	(��Jp54u����j������ �+�d,�&U������j�]�� ��s�� _:mt�]J&�]q;T��"��T���k�=�\�-m!t,���?c�M�pr�]$BК,��U��b�4'��Bb.���3{�DB-�Ȥ�!1������6�:�`��^�*�d.� =�v�Q?�M��XR�3	-�}�b���������)��}[���dz	:6A\H�Q�*�=���#Ԩ��i���<�K�ʐ�z�\����~��uW��X|�TU �Mӷ�ns+�5��1�̽���~[u�u�]�
A�M�k<�Xq�~� n�LU�|�I�s�J����7)���yn����z�M�|C%4�S�+���S�� �{��Ԅ*f&3pL� %=�G��%�����R�Uu��Y4 �R�`�@pva3n��P���׺C��k��R	���5>}��\>V�4 ��Y���8�Sj�zX��mS�=�������JI�!�Ė`=k�5����L���,�76�2��s gj^�a~�L���c��i�[��!`�
����5��x����!�ɼΥ����0>rZ꤆�ZSz���y��&E�!K�8��E���>VP�&��쑒�~��<��A=�z	 Kp��ͬ׼b���5�\ed�7,䚩7��FP#C��c��%�����Ie��O��b1�Ѿ뻺��`��"�,)�b^n$3!'i(�P��`$�
��S�X6cI}}٣���L=S�������Mk�QȰ��1�j����y]=��c���2�r�g��������&*vVHŋ�6:D�9�[�)$3�:�(v����C�/�mq~����M6����Inc�&.�~O���m� ���$f�.b}��Y��8A��Ӻj,�[���I��� ΀Q}�K�C�s�B�a���l���|Kf�:-O�X��T<в�mڶ��&��/��p�7��]3-h���I�@H���o�S�C�%��+#`@D�B�O~}��V��X��K�"���j���6߹ԙ�-G۪�1�9��-g\�{����g*�:F��7Q�ȴy��|;�Qd������b"�K}s
꺇�o�����:q~	y��N�D��|?�'�+n���J�X|��m3��->�	Df0�^R�-"�6�4��,$=uTS]hƶ�l��hh4�PC?J�z[�b�2��wɅ%��3��ct�$0�`ю�H��<��
��>r��-��i��<_5��L��������5#�އ�
[�����yf	����xj`��9
�п9��a]��>��I�)���}���ӽ�!�l)I���#<bsV��IA%D��?3��(�:�p�A��:�ͣb���x��yL;$���
�^��T�gX��K9���&��i���ꚇ~�B����ἉW�>P�(��"ڼԤAzw�ð��*.̓	�P`�^�G+��V��I����_���!y8F�n�Jsje��8�qގ��~��`�-�{����8z��3�ymA
4��0��Б�S�h_�A�Llb:j��9:���}�ʔ�[AT�T�8/�c� K��
�cA���p�թE��9@��yH�y��J��GQzqt�4�g�o��~{���.��CG�-T����˾�i��_��yjK\��
��J�[o�=�?n>������J���W0�{9:<��/þ;!TRX=C�i+�qؔ���n�_��-}8�g�d#�Pp0�֡���	m�`?����$bg��xR!D"���<X��|[���,�55���-%_
Wpݔ��}}j�-�m�b�o[L�w�@�hg�}��˼�5�Wͣ_��j��qnЏ�qT��h2�
� �X1o�J\�]�!7G�3�V��K��)?LAIS]2�lz�t[wk�M�h�%� ;2I�r��sK�q�N�ݍ.�$���Ԓ���8�G�U] ��������h��K�S�M]��D�0w.�,7(Gf��xG�FwN��l�y2��a9�9Ҵ���S���T �B      �      x�%zY{ܺv�s�W��$���,ɒ�G��,k�rb& �  ����^�{N�'`���:_������|��fg�����σ��׿o~�Ʒv�����u��J7��p�m�v��'�5_�f�;�͏�Cm�pF����|՛�z�o8�n~�o�f�'����`�����|u��u��o����O<a­�ǈ�m���[6�q��[��y�k��͏=\W6uE��٭���ͯ�ߛ�����������s�gs���|��cͷ���?�o��o|�_��?w�o��988h���fg�G��߶����7��8��],���������pkӐ.�	�7ećk}$�����l~bun�s�v��;���Z�����(�N�7:�[�u�~�������bw�����0ܨ��Ns��mG�y�z�������;��(�櫻ǲ~><��E�Ո'��g����a��o�}��x�J�C�(Z��C/��ꞎ._>O���0�����5�}w{�����Yw�֓~|�8m����gν�'�|��s�����1?�Gǧg�U���䨴�����vu�%���hzs���郞�9|||??���i�g��Y*��$�ݨ��1��4�N� N��x���B>MǷ����2Nܟ-h��mT�����8��?�9]�������%nv���lv�ǻ㏱}}�s��ˎ�z1?_���}~خ���F����ʵ�)Gm�6;?�6UR�D����N'π008t���'�X~w~�]���Ϧ���g����.�O�y?{<�L���������x1�G�E��]��p{�� ��f�k�wswa�x�O��B�G�~���G�"��s�����)�����o^�?/�������߿��+������>\���<<�ov1c�^���`�Gs27���x��F���#y�7?0��a�k/����/P���h6��{�S�;�<�oc���(����=_^��E��×7��w������q�����ܴQδ��F����?\���������M�	|��׼����q��}�	�7#��}z�0�?���pxB/>O��>��l�ϣO�z�zv�2��������W��������-����|A ������Wq����N?�^>f�x~���ŗ-'���_�:����o_ޞ.>o+wyȆg�Ϯ�p:]��?~�>�6�|/=��1�?g���O�������\��7���ׯ�W���l��c�����泇�Sw9�}~F�����)��Y�ڇ��5^,�r������<h.o���t��r3_��9Y�gT�wSl�����4����U낛��џ�<���ӷ�~ҟ���̎�����atS�=���ի��k��hq~]�{+�gQ�����hۻ�����<���߳����Z_v�sN�c?6��3|���������դ�������?��C�rAW��n��������ٻ�?��������g�����Fs�,y>�y�����~˯��<�B/��;�pY���d��o.���m�lK���y��@�~6��y���ru��gn�N��rϧT�*<�q�tt��t�sv$u�%`����t3�+������?F��I�W?\�j;��N�������h�>��nb���%��da2��H{��~�.û|b��Y�'��~C�N/��z|��v@����7���cL�z��']D�[rU���|�ف`=�g~�O����o�<l� ��5�¾\��ۛ�.�})�bH�w�xl힒�v����Kf���������}����;{{�ro>_�ON�����o��b�'��>����A^>���s>����#�Ӽ�|�����#y~�x"���*N;�&젡���}x�wg���y�߻���?�����7����{z��'��]���}���×|'ޱ���Nч��3��	�=`.���?�Mߞ�r����m����������x���f���*w�qy�C�7R*7嘊g8�q"�q�)�blh]�QW���q�k��<֣e�e((� P�1S����a5�g���3�%k�_��4�.USL.c7x1q{��^y^-w��e9]y��b�`JZ&ݱXg�Ql�t�=�u�U��P93��7s	��F�6�Q6%�&K���@x
j��h\�K�F˼�6���L�fKځ����)V���7و"�ࡆ:)kb�	l�L�H�z���\�L�P��Dq������i|o��|R��:�DR�<���@�t*�^-�cb��d���,� K�����me]p>;jK���L�j���ϊR�x��h���F���V��䗞��1.�������kAxR���hkT���
f�Q��1R��z޷�wi�Cm'��9s����H�8P3����Aqst JӕЗlƲ��q�K��0�I�Bc%ᬘRր1o|��u�s]u�VS�̪kO�^򾟆h�ztv��+v���%6�e�N�ݔ���yY��ٸ���m5r�7����Vy��k8�^4���ib�ҩ��܀.�s�gl`��6ρ�q�5w��8��ҩ�IC�y�f1L�NCmd�斑zДV�,���6����nU�o������~�5N�1P� ��0��W�A���J�w ��k�, Go~�\��H6h1�X*Ba� L[��x��g����6�@c?�eK( =F1�T��ZQ[����?A���c�ߛ`��������|�����k8h�|C�7q���в8��%#q�G9h�H)G/
��G�t	VJ@��6����z�`o��������z��������׬k�Lf�b�5�������$��:W8�qa���]{ڣ�$hC�%�2���`�
�/ga?�$��o`y|��N��7��^�F_(Z�P-��5�_�&�!��_@[ �/n�����|�סk(�0w�5���2n���� ��ǔ���~@��&��K�Z�/3�a�.�P]�T�.+��S
V�SH�]�<�]������8�����9��׭���m�����5h�x�Zk��������q�Y\.ů�,���S�+�:��mp�M6p�{gI�r2���k�: ܸ�3�y�up�O��@����5z*�	v;�m���g���K����%��+\=�j�	����Yͣ�|����yhsnM���U.�<Q[V邍��Tʾ՘R�q��J��SZ�'��e	d�>{�V�iM�ﺖ�*$q��_1�]�~a��q{��d�*�#�L�J�e��jqĜS?��u��F�X�YXUά���ѻn�Ƚ��</�-H$�Th�H@V�L��J/mU�D�NӲ82�i�V�l�lƪ`|���%�<�`�Sˌ�]Y��`�h��Ģ�؏�Gv&K7�{�z�K�v�=(��j)}�v��a-]0<+��t�_R_��r�4�Zw�p��-V�~[Oh f����tg��A3�ۀW:�wZ5��j����)�B��I���e�+��L�@���PFD��]-㴮���E.I�133N�2��S1k�e�*�L}˗VS�T��z24��3��8KX,�CE���E�ι[�#6BD*c�X�@G�Ŭ��k�Ŵ��h�o�I8?u~n�J��qNVcA� C��:��.�Y=��|Ђ��׸��Ðc����I��E�gI{!K2uU)��K*���rE�������P�0�"XE�J�Rv���k�%���E�j9ڶt�w"��(�S~��P��
,�<����X����lmЄ�Qe�z[�.g+|EeaJ�����p�Ƶ�Xà�:P��S6H���zmRJ�#�Rn�ܘEi๝�s�>-a>��DHHo�~��Yr2��w;�,N�
��@DI�D(Q�$ԉ���s�r |k�1� SuZb��:�A��]�xѶ��0Uq`�� o�l�v�9�a��]y�7­���Ou���O#z����-T��� &o�
^[K��{���l���
�g�YV���1,���..�Q�Tt�k���`��b��ԏ����B��q� ��UX�n�gćٚ�{!#ү	� d��/�ot ��mo��n`���D�V�aD�̉a*���.8�8I��ѾB(ieV����Yxv��n���IQ� z  �(W����XHu�ƶ����W��L�� ��+J�m�
�*����`'q��
Ie�la6�?_���HxR�����yE��A�DIc]��:^���`��4���qi9Y�<W�W#�7��X�:�س�V�����	��8Ј��,�eE�N�Fa������ݴ�Z�� n�1�.�f�[3��X�6�vm��K����ldl�-��Y�3u���l�d�.[1^�)�9�~���
8�v7
7H4����+�}�����E6�
tC���W�Pb��y�"�㨐A��2��L<�߃�y.'?���1s��Ya�*O%�:#9�-��um9R8R�>�$�@�d���V����r��
��*��OS�VT�S�:�(S���Z����q�t����KT��gG��!Lz��¬�ZH�L���ٲQ�q�S墰�ɫ���l�"Se�c���ʩs$r^s��I��0P���Cf�@%�I�s٢)&�:�8F�L�a���A�=ފ��W&7�Q�H�C����G��tܹ��:�Nf�h}��ӽ��y^�6���<�%m�͒Y��H�[�Ia"�̋@�F0Dj�4����j	$�������4ڡւZ�-Y�a��c|�BF�|PǠcaz�lPU:5g��j	p�Xq���*:�����%_�S�@��l����ܸ��Ǿ�o&\Xx����O�U�����d��4f��l�eV�hڊ�V�#��Vcr�KBj� N����Lc�
���]2(N�t���(�r�!2+��	l �i	�U�a� �liϷ1~�l��S��F��tEd�3�$�r���E�k��ƨ�PGó��:W��;/�HK&�V��[M\�����f��0}͔M�w���2"��@nd�J9ߏ����b��`Փ��Z�JaL�Z)�L�������h]��`q���Q�b�bD��� |,�OHm�2�����Ф�
��d�ҭ@���E2�V���d|f����ca���F^�u!���^bޘzQ9ę��Vӕ.j+�$�=�����#�<�%B��.X(��N���Z�	�VX�Vڭ�N��+���f���P���M� &��y1���*��6���݀0����1��3ת�ZO�؞�VWb��j��<���59�Pr!}�q�Z�0�Stۗ0�qXy0#���u�L�C}O��PF#|}� ?�EL�#�t�ԋ��e�0	0�޼��f�S$�������n��w)!��uMC�����VBs���H����܈� [�UH���`��dJm}K��d�a���RD`�V��Ș�����%!�g��A�i�\j2f�9v�,*�8��n���� ���d��PÒ�a^d{ˑ�]TI�~]����K������󚄒�>�c43ȿa�bm����"��-$�%���3��8�����7*b*I3Y�k��J��Y���bB�sk�+l<��$��7��T�[ODA�n�B�g�k�)]XL^�{?x?:>�v�؋�6de��	�4>�+]��;�Mt��9�]i'�U�<�DhI�Tŝ�v=�Q��R!����6$w�Ȧ'^�mV� ���������c�
�hb����Pә\��-�����M��~kJk��P�$ݳlkA�P��ЊR#Q
9�t�J�¥��t0 6�t"�Fnj�y��u�*Ws���;f����&l+��j�l��n�`R��v���ʬ��	$)�p���8h���4SeX����9(�B֩ڰv�r����V�u�K��;���Ik�R\uG���I�EU6�C�yd�U�Ө�]pC3Ux�C�|�O
k���<!š�<�a�"�5m��t����D�c+F�j��PLeY暈8�u��r7�|��d�Z���~敯���5���8�: `pR�5	mU�$�Z�
ɀ�s����~��b��-��J:f�E���CVs��}����<�VMYEj��&���6��c�2��[�0�}�_@��Q>�XfSӖϚ�JJg�kT(C�i����F�b��k���2��	����c����.
=|sJ��z����e���Ԃ���&���Y�� ��k��c�F��w8�N��2�Q )���x�0��oIV� �1�5�葒��JI2L1$c,�l��-� ��U�~�H��%h�}�RyK� ���E�:�L��3��k&b�t\T+s%�ZQ ��j��D���5������X'�w	E��٥�ʱ֢�p�K�'cה-v�}�[!H�FBL:����/�O`��r5oW��U�E�Q����|��89�hBlA-	��r���N����jPn�"�a�7��W��h�[/�dn��U���ZBE���FX�XıS�e��:S�Y@U�P(=��Q굽�:V̨�з�0O�j��B0�m'u�n�TZV&�-���fcy��YT,��@5)�x�b9:C �pύ`7 �a�֑YgIв&�0���o3;���w ��Z'5�V�j�H�=&��u�� �U�H�Xw+�"������l2�29�Ou�J�j	�{�4��DL�S(�V�VT�R��֩c�.Nt�K��w��$A���O�O�)Q���&������Uc��{o�E�ت,�2��Z�vpl`�j��2���q���F��d��/Mv�Y�ʊ��资	��Ԭ����n���d�8_��W-\�ʱj��0�./��ٙ��~B��Rϼ̮_`��Fi>�!6tm�A�����۾�dG�H���R�J��Sh<�>z�e�)�.�tQ8����4Ӹ�6V�[{���C���^��B�Z^�?��Z��۷��*�����$��S_5�ˤ�J9�LI9����pl'��Ew=/V���V�����:���5�,r������L���0�u(`
��e���N����ۭ� �Sl�{�yVy����S���i����(�      �   �  x���[��:D��Q�	�!�����G�Kd\ �9�Vl>j�� �I]T�Ã��#����C�=�O�C��s���3�����C�yf�G�4��P3�������O|O�韼�Kw�����i{>������q�M�vqė��';�:�?��'7�Y!O���μ����{\�Ѵ~�]��y��9:^��EJ�@28O�{>?��Uρ��#�l���v�uތ�D=#��3����;�@�'����0�~δO0���d�K��v�gW�O��h��I��V�x;�?�á�L�!:RD>�Ӗ�M�fЃ؇m4BsyB>o�=����I�87��+B���Is���R�Ox4)1�}ö~ͽ�у�'r��ߐ����ՌM�QN��(©���<KK{�NvW�K��w�>U�~���v)��hp#h��i�����x>b8���(�@�#�+�g��Ei�^*�t������#~��R��-O�|U�Wy�o<��U��c�n���K���pEo�����cg|3��"�����~��/{c��u���>�ۆ���'$����8�+���y�R�|�_+��{(4el�p��5��\���gx��5����a5�������fmZ���Lh���G�Ƽ��v��f%;��љ]T��{�9m�(gv����|�y�K��5�k��H�OF9�lM$J���o�>�+�ى+��>o1��{A�K`����b�^b
r_��3���򩎧�-�}>�o��cx���^(�	g���և_w��lo���q�w�E;�P- �h�.=�k9������-=����ŰMP$$r�2_�eB��i2~�_��ۗ/=���4�zb��JX��B�ċ���o���tCA`�"?l�mQt�k9��~8 �9 %��l/ cYOЅ�N�� OG�.$���5�d��u�˻e��w���w~�[�?�r۝��V�cv��t�C?�0a^����}�Ύ�!f�}mq��m�7�+!���C�W����-�(�����/g~���O1�+�7~r���p��r/���#U'��{x՝_�l�i����3�����/��k��̏��E������8�sǷ�3p�<����~��[ի��w<������\�y�ۜ<���	3�#�w�����Ln�bX�5��m���󷼶#�o=��c�B�V��xm�G57z�4ăˠ��=��F/�7��*��>���^���d�a�/ֹn
P\�ľ�Cgz��^�i�Lǋu��6W�9$�,���%'�	7������.�0\W!^Fx��s�*���-���n���,$h	��;�#��
�1����4V���na�%�ī[{wwv'6]ͅ���ձ�ko֪@:^�a�{�ެ'�z(�)�=��o��-_Q�y][~���8gm��v��{0��\\-q�G�J�/[~ݻ)�P����<��
	�O��R����wk����0Y�z�q�0H'j���^�\n��Ok���k      �   �  x��WK�c7\�O�(I������&�L��n`0��>E�=�6D7`�M��ò��AET�W�R{��S��\?_~{�����ۿ��|\�hex�6�(���z-��X�v�B�ԼXJ��,gg-lI����K���ε��Xۈ�79�����_�~�����o���q�1
����l\�����?��?.�V:
Id��ƾ��miT�3ʳi��0�6\7xS��t�q:v���RO;G�B��cV2�k}"�=� 7@�ۂ��kI�V�����0�}�#�x������z+���N|��f��Z��������ܨ�7MՎ�Rj2 �
��T��v�6+��>�ViS��b��sU�{�I-�����8�Z����'�ZC���|>&mI_P^Tj���ݰ�`W�9l*C\=jYW�ݪT�4l��-��C~��۪�˿G�RF�R}QuK)W����dOa��Ȝ��n�f�n�܏�!�L�[F�m"Ş���xW�^�ivP��c�Օ���(��Ě,��n��f���%ş�jwfܡ>�^y���%�W<n�Ԡ=��hj=t��>@2�nCq��[]3k�D� ��;����#�����3��r�.�U�� ���zq�;�jm��5����|�ܘ��4x�J&5#ة0\�<�i���U�y;��	�0XXo�H�f�b��֍���������Z�F��A�O2�E�td�'<���Ab�݈1#�uB�y�f0����#N$¼�s�����֣v��dcy@G��g�.o�gLY��J�US�Fo�'�k&��␪.A$؆}�X�����Q�Ā��羶��-�O;���#�޴`Gи���Q$���s��wu\P�i���z��-�,�j�� �[.�'��dA/�ԗ}%��H�P�����Gȸ�}�y,�F��>�h���E��bbf͂؁4��l��E4�ɫx�N���C@X������`�X2.Ăc��gБ}����q�i��K��=o��^Ⱥp�Ic��ߏ��-ȏ��4��j+(lc�|x�����}������/$�s/�4BR�0��*�k�ߩ3-Kd��e�F�)#y�M��:l�<�,��OG��}V���h��S�@��]'
)�uܒ��$.z�_��Du]Oˮ��?_.���_��      �   U  x�UV�r�6}�B?��m%N�صki��H�-D��H_��=K)i:c�&v��^Z$��J6���춬K��`x�\������X�Z�vF����Ė�=�v����ViϮ�Ml�r8����r]s��b�+���6��S���\Y�0\*��t�^R��2<o�C_�]eC��VH�>��ұy7P�;^�Dj��}}ͻeJ�󧶥�<_�}~zڧu����+�zdw]j�5�m��T��x�}`����e�ϫ��s�j��6\h'������� y.���{h׉}�cp(�jæ�=�-�Ji����Hͭ��	ͮ�챔�T*MD8�3�yI��_�>U�6ܡ����]N�[�֧Ɍp\�p Z:�p�}]�H|��������2��e-�j���kνc*-Ї���q����aI@H����͆�)w�����RhB�i��Yp�.�Gx�=& i�ۘ��O�k鶇���S;��U�)d��cm���V��p{tnq_��:h�]^����}.m�����AY��#����B��̓ɿfv�_��	�� Ǡ�O�HC������-��v��G܁�0r��fAJ�\^�X�nT����9MM^E�j�~�ő%��ݣ��IM��x°���`������@MY
G�{!����LOf���.�(FY�%F����������%��!�H�p֞0�A�]W��L�B����7
:ʏ��6��f>���LW�@z]#fqٍq�L`��0�.��=`�ylKY7�\J�4��tb�C\>VZR<�M춓kv���f_r�W��pQ�a.(d�������m����I85q
rr��b��	�۔�<�J�)���L�>MD�q�lҲ�K�N`��y�i{2��mX[�%�}<���[��*� n<�k�j�Җ���~S��&�&�#�`�r?4� "���W�ϑ	Ja��C7؇�r�F�]$��O����1VI�	���n�J@�f�^�oy��7����;gɼCϱ򮦓���)��e�����@Sb�芏�j��ܵ"��<DDH7"���	���]����F%Bsi�e7�J�u�5֒� ����Ji��p���RK���Cn�+P��ڎ~��@}ۏ����bq�0(�c��k�=j�Y����tB�W#TP?��������xrj��SΒr>ut�S� ������P�Q�����f7�
}�� <�B�pr��\��,-��$���yR� �
��o�Œ��pv��2����4l�C����Z;�9�v+9���9"���]�V�Sr��y�!� ��r�]����Ջ�0L�n����sͣ�""���)�$��ư� " qʝǅ��2�o*��P�-�A����S��C@b��Äo o<7�����U
+�,餅R)��T��#���P��m��̀�<IG#v����� i����6xd2~^��@��+9��@�2b`!3�9�.K����d�Z�����
y s{�>��<�Թ;N#!1�Pƃ�$�[<
���QH���}I{�6L8��4��C�O�� �'�#ްv�)���kk������4��     