/*
===========================================================
PROJETO: Análise de Comportamento e Valor dos Clientes
Ferramenta: MySQL

Objetivo:
Utilizar SQL para responder perguntas de negócio relacionadas
ao comportamento dos clientes, identificando padrões de compra,
clientes de maior valor, oportunidades de fidelização e
informações que possam apoiar a tomada de decisão da empresa.

Autor: Jamille Silva
===========================================================
*/


-- =========================================================
-- ANÁLISE 1 - Valor gasto por cliente
-- =========================================================

/*
Pergunta de negócio:
Quem são os clientes que mais geram receita para o negócio?
*/

SELECT
    t.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(t.Quantity * p.UnitPrice) AS valor_total
FROM transacoes t
JOIN produtos p
    ON t.ProductID = p.ProductID
JOIN clientes c
    ON t.CustomerID = c.CustomerID
GROUP BY
    t.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY valor_total DESC;

/*
Insight:

A análise permite identificar os clientes que mais contribuem para o faturamento da empresa.

Esses clientes podem ser priorizados em estratégias de fidelização,
programas de benefícios e ações de relacionamento,
uma vez que possuem maior impacto na receita do negócio.
*/

-- =========================================================
-- ANÁLISE 2 - Frequência de compras
-- =========================================================

/*
Pergunta de negócio:
Quais clientes realizam compras com maior frequência?
*/


SELECT
    CustomerID,
    COUNT(TransactionID) AS frequencia
FROM transacoes
GROUP BY CustomerID
ORDER BY frequencia DESC;

/*
Insight:

A frequência de compra demonstra o nível de relacionamento do cliente com a empresa.

Clientes que compram frequentemente nem sempre são os que geram maior receita,
indicando diferentes perfis de consumo e oportunidades de segmentação.
*/

-- =========================================================
-- ANÁLISE 3 - Última compra
-- =========================================================

/*
Pergunta de negócio:
Quais clientes estão ativos e quais apresentam risco de abandono?
*/


SELECT
    CustomerID,
    MAX(Date) AS ultima_compra
FROM transacoes
GROUP BY CustomerID
ORDER BY ultima_compra DESC;

/*
Insight:

A data da última compra permite identificar clientes inativos ou com baixa recorrência.

Essas informações podem apoiar campanhas de reativação e ações para reduzir a perda de clientes.
*/

-- =========================================================
-- ANÁLISE 4 - Visão completa do cliente 
-- =========================================================

/*
Pergunta de negócio:
Como podemos avaliar o valor dos clientes considerando receita, frequência e atividade recente?
*/ 

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,

    COUNT(t.TransactionID) AS frequencia,

    SUM(t.Quantity * p.UnitPrice) AS valor_total,

    MAX(t.Date) AS ultima_compra

FROM clientes c

JOIN transacoes t
    ON c.CustomerID = t.CustomerID

JOIN produtos p
    ON t.ProductID = p.ProductID

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName

ORDER BY valor_total DESC;

/*
Insight:

A combinação entre valor gasto, frequência de compra e última compra oferece uma visão mais completa do comportamento dos clientes.

Essa análise possibilita identificar clientes estratégicos e criar segmentações para ações comerciais mais eficientes.
*/

-- =========================================================
-- ANÁLISE 5 - Receita por cidade
-- =========================================================

/*
Pergunta de negócio:
Quais cidades apresentam maior potencial de receita?
*/

SELECT

    c.City,

    SUM(t.Quantity * p.UnitPrice) AS receita_total,

    COUNT(DISTINCT c.CustomerID) AS clientes,

    COUNT(t.TransactionID) AS compras

FROM clientes c

JOIN transacoes t
    ON c.CustomerID = t.CustomerID

JOIN produtos p
    ON t.ProductID = p.ProductID

GROUP BY c.City

ORDER BY receita_total DESC;

/*
Insight:

Comparar a receita entre as cidades permite identificar os mercados mais relevantes para o negócio.

Essas informações podem orientar estratégias de expansão,
investimentos em marketing regional e alocação de recursos.
*/

-- =========================================================
-- ANÁLISE 6 -  Receita por gênero
-- =========================================================

/*
Pergunta de negócio:
Existe diferença de comportamento entre homens e mulheres?
*/

SELECT

    c.Gender,

    SUM(t.Quantity * p.UnitPrice) AS receita_total,

    COUNT(DISTINCT c.CustomerID) AS clientes,

    COUNT(t.TransactionID) AS compras

FROM clientes c

JOIN transacoes t
    ON c.CustomerID = t.CustomerID

JOIN produtos p
    ON t.ProductID = p.ProductID

GROUP BY c.Gender

ORDER BY receita_total DESC;

/*
Insight:

A análise por gênero permite identificar possíveis diferenças no comportamento dos consumidores.

Esses resultados podem auxiliar na definição de campanhas mais direcionadas,
desde que interpretados em conjunto com outras características dos clientes.
*/

-- =========================================================
-- ANÁLISE 7 - Clientes inativos
-- =========================================================

/*
Pergunta de negócio:
Quais clientes estão há mais tempo sem realizar compras?
*/ 

SELECT

    CustomerID,

    MAX(Date) AS ultima_compra

FROM transacoes

GROUP BY CustomerID

ORDER BY ultima_compra ASC;

/*
Insight:

Clientes com maior tempo sem compras podem apresentar risco de abandono.

Identificá-los permite desenvolver ações de retenção,
campanhas de reativação e ofertas personalizadas para estimular novas compras.
*/

-- =========================================================
-- ANÁLISE 8 - Frequência x Valor gasto
-- =========================================================

/*
Pergunta de negócio:
Os clientes que compram com maior frequência são os que mais geram receita?
*/

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,

    COUNT(t.TransactionID) AS frequencia,

    SUM(t.Quantity * p.UnitPrice) AS valor_total,

    ROUND(
        SUM(t.Quantity * p.UnitPrice) / COUNT(t.TransactionID),
        2
    ) AS ticket_medio

FROM clientes c

JOIN transacoes t
    ON c.CustomerID = t.CustomerID

JOIN produtos p
    ON t.ProductID = p.ProductID

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName

ORDER BY
    frequencia DESC,
    valor_total DESC;

/*
Insight:

A análise permite comparar a frequência de compras com o valor total gasto por cada cliente.

Os resultados demonstram que clientes com maior frequência de compra nem sempre
são aqueles que geram maior receita, indicando diferentes perfis de consumo.

Essa informação pode apoiar estratégias de segmentação, permitindo identificar
clientes recorrentes e clientes de alto valor para ações comerciais específicas.
*/

-- =========================================================
-- ANÁLISE 9 - Quem são os 10 clientes prioritários para ações de fidelização?
-- =========================================================

/*
Pergunta de negócio:
Quem são os clientes mais valiosos para o negócio?
*/

SELECT

    c.CustomerID,
    c.FirstName,
    c.LastName,

    SUM(t.Quantity * p.UnitPrice) AS valor_total

FROM clientes c

JOIN transacoes t
    ON c.CustomerID = t.CustomerID

JOIN produtos p
    ON t.ProductID = p.ProductID

GROUP BY

    c.CustomerID,
    c.FirstName,
    c.LastName

ORDER BY valor_total DESC

LIMIT 10;

/*
Insight:

O ranking dos clientes de maior receita permite identificar consumidores estratégicos.

Esses clientes podem ser priorizados em programas de fidelidade,
atendimento personalizado e ações voltadas ao aumento do valor do relacionamento.
*/


/*
===========================================================
CONCLUSÃO GERAL
===========================================================

A análise permitiu identificar diferentes perfis de clientes,
considerando valor gasto, frequência de compras e recência.

Os resultados mostram que:

• Clientes de maior receita nem sempre apresentam maior frequência de compra.
• A análise da última compra possibilita identificar clientes com risco de abandono.
• A distribuição da receita entre cidades revela mercados com maior potencial.
• A combinação de múltiplos indicadores oferece uma visão mais completa do comportamento dos clientes.

Esses insights podem apoiar estratégias de fidelização,
segmentação de clientes e tomada de decisão baseada em dados.
*/