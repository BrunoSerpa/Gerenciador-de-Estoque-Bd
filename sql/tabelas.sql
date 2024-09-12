CREATE TABLE Cadastro (
    id serial NOT NULL,
    data_cadastro timestamp NOT NULL,
    frete money NULL,
    titulo varchar(180) NULL,
    custo_itens money NOT NULL,
    CONSTRAINT Cadastro_pk PRIMARY KEY (id)
);

CREATE TABLE Item (
    id serial NOT NULL,
    id_cadastro int NOT NULL,
    id_produto int NOT NULL,
    data_compra date NOT NULL,
    preco money NOT NULL,
    CONSTRAINT Item_pk PRIMARY KEY (id)
);

CREATE TABLE Marca (
    id serial NOT NULL,
    nome varchar(180) NOT NULL,
    CONSTRAINT Marca_pk PRIMARY KEY (id)
);

CREATE TABLE Nome (
    id serial NOT NULL,
    id_produto int NOT NULL,
    nome varchar(200) NOT NULL,
    CONSTRAINT Nome_pk PRIMARY KEY (id)
);

CREATE TABLE Produto (
    id serial NOT NULL,
    id_marca int NULL,
    garantia int NOT NULL,
    validade int NULL,
    preco money NOT NULL,
    quantidade int NOT NULL,
    CONSTRAINT Produto_pk PRIMARY KEY (id)
);