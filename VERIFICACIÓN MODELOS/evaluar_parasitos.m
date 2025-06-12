function tabla_resultados=evaluar_parasitos(total_parasitos_detectados, total_candidatos, total_parasitos_reales,metodo,nombre_tabla)
    TP=total_parasitos_detectados;
    fprintf('TP: %d\n', TP);
    FP=total_candidatos-total_parasitos_detectados;
    fprintf('FP: %d\n', FP);
    FN=total_parasitos_reales-total_parasitos_detectados;
    fprintf('FN: %d\n', FN);

    metodo = string(metodo);
    
    Sensibilidad=(TP/(TP+FN))*100;
    fprintf('Sensibilidad de %s para parasitos: %.2f%%\n',metodo, Sensibilidad);
    Precision=(TP/(TP+FP))*100;
    fprintf('Precisión de %s para parasitos: %.2f%%\n',metodo, Precision);

    % Crear tabla con resultados
    tabla_resultados = table(metodo, TP, FP, FN, Precision,Sensibilidad);

    % Guardar la tabla como archivo CSV
    writetable(tabla_resultados, nombre_tabla);

end