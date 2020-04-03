SELECT ENGINE Motor, TABLE_NAME Tabla,Round( DATA_LENGTH/1024/1024) AS 'Tamaño Tabla (MB)' , ROUND(INDEX_LENGTH/1024/1024) AS 'Tamaño Índices (MB)', ROUND(DATA_FREE/ 1024/1024) AS 'Espacio Libre (MB)',
100 * (data_free/(index_length+data_length)) AS 'Fragmentación %)'
FROM information_schema.TABLES
WHERE DATA_FREE > 0 AND TABLE_SCHEMA = 'poner_aqui_su_bd'
ORDER BY `Fragmentación (%)` DESC;
