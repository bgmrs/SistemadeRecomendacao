-- Passo 1: Encontrar outros usuários que avaliaram bem os mesmos filmes que o usuário alvo

WITH usuariosSimilares AS (
    SELECT 
        DISTINCT r2.userId
    FROM 
        ratings r1
        JOIN ratings r2 
        ON r1.movieId = r2.movieId
    WHERE 
        r1.userId = 1
        AND r1.rating >= 4
        AND r2.userId <> 1
        AND r2.rating >= 4
),

-- Passo 2: Identificar filmes bem avaliados, em média, pelos usuários semelhantes, mas que não foram avaliados pelo usuário alvo

recomendados AS (
    SELECT
        r.movieId, 
        AVG(r.rating) AS avgRating
    FROM
        ratings r
        JOIN usuariosSimilares su 
        ON r.userId = su.userId
        LEFT JOIN ratings ur 
        ON r.movieId = ur.movieId AND ur.userId = 1
    WHERE ur.movieId IS NULL
    GROUP BY r.movieId
),

-- Passo 3: Top 5 filmes recomendados para o usuário alvo

SELECT 
    m.title, 
    r.avgRating
FROM 
    recomendados r
    JOIN movies m 
    ON r.movieId = m.movieId
ORDER BY r.avgRating DESC
LIMIT 5;
