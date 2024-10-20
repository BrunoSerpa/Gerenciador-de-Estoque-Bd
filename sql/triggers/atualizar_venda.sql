CREATE OR REPLACE FUNCTION atualizarCustoVenda()
RETURNS TRIGGER AS $$ 
BEGIN
    IF OLD.id_venda IS NULL AND NEW.id_venda IS NOT NULL THEN
        UPDATE Venda
            SET custo_itens = custo_itens + NEW.preco_venda
            WHERE id = NEW.id_venda;
    
    ELSIF NEW.id_venda IS NOT NULL THEN
        UPDATE Venda
            SET custo_itens = custo_itens - OLD.preco_venda
            WHERE id = OLD.id_venda;

        UPDATE Venda
            SET custo_itens = custo_itens + NEW.preco_venda
            WHERE id = NEW.id_venda;
    
    ELSE
        UPDATE Venda
            SET custo_itens = custo_itens - OLD.preco_venda
            WHERE id = OLD.id_venda;

        UPDATE Item
            SET preco_venda = NULL
            WHERE id = NEW.id AND preco_venda IS NOT NULL;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizarTotalCustoVenda
    AFTER UPDATE
    OF id_venda, preco_venda ON Item
    FOR EACH ROW
    EXECUTE FUNCTION atualizarCustoVenda();